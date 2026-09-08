package com.campus.secondhand;

import com.campus.secondhand.auth.AccountService;
import com.campus.secondhand.category.CategoryMapper.Category;
import com.campus.secondhand.market.*;
import com.campus.secondhand.user.UserMapper;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Import;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import static com.campus.secondhand.market.MarketModels.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("local")
@Import(MarketApiTest.Wiring.class)
class MarketApiTest {
    @Autowired MockMvc mvc;
    @Autowired ObjectMapper json;
    @Autowired MarketMapper db;
    @Autowired UserMapper users;
    static final String GOODS = """
            {"categoryId":"c","title":"教材","sellPrice":"12.34","tradeType":2,"goodsDesc":"描述"}
            """;

    @BeforeEach void setup() {
        reset(db, users);
        when(db.category("c")).thenReturn(new Category("c", "教材", null));
        when(db.goods(anyString())).thenReturn(MarketServiceTest.item(1));
        when(db.lockGoods("g")).thenReturn(MarketServiceTest.item(1));
        when(db.activeOrders("g")).thenReturn(List.of());
    }
    private MockHttpSession session(String id, String role) {
        var session = new MockHttpSession();
        var context = SecurityContextHolder.createEmptyContext();
        context.setAuthentication(UsernamePasswordAuthenticationToken.authenticated(new AccountService.Principal(id), null,
                List.of(new SimpleGrantedAuthority("ROLE_" + role))));
        session.setAttribute(HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY, context);
        return session;
    }
    private MockHttpServletRequestBuilder write(MockHttpServletRequestBuilder builder, MockHttpSession session, String body) throws Exception {
        var result = mvc.perform(get("/api/auth/csrf").session(session)).andReturn();
        var token = json.readTree(result.getResponse().getContentAsString()).get("data");
        return builder.session(session).header(token.get("headerName").asText(), token.get("token").asText())
                .contentType("application/json").content(body);
    }
    @Test void anonymousCanBrowseButCannotPublish() throws Exception {
        when(db.goodsList(any())).thenReturn(List.of(MarketServiceTest.item(1))); when(db.goodsCount(any())).thenReturn(1L);
        mvc.perform(get("/api/goods")).andExpect(status().isOk())
                .andExpect(jsonPath("$.data.items[0].sellPrice").value("12.34"))
                .andExpect(jsonPath("$.data.items[0].publishTime").value("2026-09-07T09:00:00+08:00"));
        mvc.perform(write(post("/api/goods"), new MockHttpSession(), GOODS)).andExpect(status().isUnauthorized());
    }
    @Test void publishingValidatesMoneyAndUsesCurrentOwner() throws Exception {
        var session = session("seller", "STUDENT");
        mvc.perform(write(post("/api/goods"), session, GOODS.replace("12.34", "12.345"))).andExpect(status().isBadRequest());
        verify(db, never()).insertGoods(any(), any(), any());
        when(db.insertGoods(any(), eq("seller"), any())).thenAnswer(call -> { ((com.campus.secondhand.common.GeneratedId)call.getArgument(0)).setId("201"); return 1; });
        mvc.perform(write(post("/api/goods"), session, GOODS)).andExpect(status().isOk());
        verify(db).insertGoods(any(), eq("seller"), any());
    }
    @Test void adminEndpointsRejectStudentsBeforeDatabaseWork() throws Exception {
        mvc.perform(write(post("/api/admin/categories"), session("student", "STUDENT"), "{\"cateName\":\"教材\"}"))
                .andExpect(status().isForbidden());
        verify(db, never()).insertCategory(any(), any());
        when(db.insertCategory(any(), any())).thenAnswer(call -> { ((com.campus.secondhand.common.GeneratedId)call.getArgument(0)).setId("7"); return 1; });
        when(db.category(anyString())).thenReturn(new Category("c", "教材", null));
        mvc.perform(write(post("/api/admin/categories"), session("admin", "ADMIN"), "{\"cateName\":\"教材\"}"))
                .andExpect(status().isOk());
    }
    @Test void adminCanEditPendingGoodsAndUserCanListOwnEvaluations() throws Exception {
        when(db.lockGoods("g")).thenReturn(MarketServiceTest.item(0));
        when(db.updateGoods(eq("g"), any())).thenReturn(1);
        mvc.perform(write(put("/api/admin/goods/g"), session("admin", "ADMIN"), GOODS))
                .andExpect(status().isOk());
        verify(db).updateGoods(eq("g"), any());

        mvc.perform(get("/api/users/me/evaluations").session(session("buyer", "STUDENT"))
                        .param("userId", "victim").param("page", "1").param("pageSize", "10"))
                .andExpect(status().isOk());
        verify(db).userEvaluations("buyer", 0, 10);
        verify(db).userEvaluationCount("buyer");
    }
    @Test void myGoodsCannotBeRedirectedToAnotherOwner() throws Exception {
        mvc.perform(get("/api/users/me/goods").session(session("seller", "STUDENT")).param("ownerId", "victim"))
                .andExpect(status().isOk());
        verify(db).goodsList(argThat(f -> "seller".equals(f.ownerId())));
    }
    @Test void orderIgnoresForgedBuyerAndPrice() throws Exception {
        when(db.insertOrder(any())).thenReturn(1);
        mvc.perform(write(post("/api/orders"), session("buyer", "STUDENT"),
                "{\"goodsId\":\"g\",\"buyerId\":\"victim\",\"orderPrice\":\"0.01\"}"))
                .andExpect(status().isOk()).andExpect(jsonPath("$.data.buyerId").value("buyer"))
                .andExpect(jsonPath("$.data.orderPrice").value("12.34"));
    }
    @Test void orderActionRouteAndInvalidEvaluationAreChecked() throws Exception {
        when(db.order("o")).thenReturn(MarketServiceTest.order(0));
        when(db.lockOrder("o")).thenReturn(MarketServiceTest.order(0));
        when(db.orderStatus("o", 0, 1)).thenReturn(1);
        var session = session("buyer", "STUDENT");
        mvc.perform(write(post("/api/orders/o/mock-pay"), session, "{}"))
                .andExpect(status().isOk()).andExpect(jsonPath("$.data.orderStatus").value(1));
        mvc.perform(write(post("/api/orders/o/evaluation"), session, "{\"score\":0}"))
                .andExpect(status().isBadRequest());
        verify(db, never()).insertEvaluation(any(), any());
    }
    @Test void unrelatedUserCannotReadMessageOrHandleReport() throws Exception {
        when(db.message("m")).thenReturn(new Message("m", "a", "b", "私信", 0, MarketServiceTest.TIME));
        var session = session("c", "STUDENT");
        mvc.perform(write(patch("/api/messages/m/read"), session, "{}"))
                .andExpect(status().isForbidden());
        mvc.perform(write(post("/api/admin/reports/r/handle"), session, "{\"handleResult\":\"处理\"}"))
                .andExpect(status().isForbidden());
        verify(db, never()).readMessage(any(), any()); verify(db, never()).handleReport(any(), any());
    }
    @Test void integrationListsRespectRoleAndCurrentIdentity() throws Exception {
        mvc.perform(get("/api/admin/orders").session(session("buyer", "STUDENT"))).andExpect(status().isForbidden());
        verify(db, never()).adminOrders(anyLong(), anyInt());
        mvc.perform(get("/api/admin/orders").session(session("admin", "ADMIN"))).andExpect(status().isOk());
        verify(db).adminOrders(0, 10);
        mvc.perform(get("/api/users/me/messages").param("userId", "victim").session(session("buyer", "STUDENT")))
                .andExpect(status().isOk());
        verify(db).inbox("buyer", 0, 10);
        verify(db).inboxCount("buyer");
    }
    @Test void publicProfileNeverIncludesPrivateAccountFields() throws Exception {
        when(users.publicProfile("101")).thenReturn(new com.campus.secondhand.user.PublicUserView("101", "同学", null, "你好"));
        mvc.perform(get("/api/public/users/101")).andExpect(status().isOk())
                .andExpect(jsonPath("$.data.userName").value("同学"))
                .andExpect(jsonPath("$.data.phone").doesNotExist())
                .andExpect(jsonPath("$.data.password").doesNotExist())
                .andExpect(jsonPath("$.data.role").doesNotExist());
    }
    @Test void favoriteRoutesUseCurrentUserAndAdminDeletionRejectsStudents() throws Exception {
        when(db.addFavorite("buyer", "g")).thenReturn(1);
        mvc.perform(write(put("/api/goods/g/favorite"), session("buyer", "STUDENT"), "{\"userId\":\"victim\"}"))
                .andExpect(status().isOk());
        verify(db).addFavorite("buyer", "g");
        mvc.perform(get("/api/users/me/favorites").param("userId", "victim").session(session("buyer", "STUDENT")))
                .andExpect(status().isOk());
        verify(db).favorites("buyer", 0, 10);
        mvc.perform(write(delete("/api/admin/evaluations/1"), session("buyer", "STUDENT"), "{}"))
                .andExpect(status().isForbidden());
        verify(db, never()).deleteEvaluation(any());
        when(db.deleteEvaluation("1")).thenReturn(1);
        mvc.perform(write(delete("/api/admin/evaluations/1"), session("admin", "ADMIN"), "{}"))
                .andExpect(status().isOk());
    }
    @TestConfiguration
    static class Wiring {
        @Bean MarketMapper marketMapper() { return mock(MarketMapper.class); }
        @Bean UserMapper userMapper() { return mock(UserMapper.class); }
        @Bean GoodsService goodsService(MarketMapper db) { return new GoodsService(db); }
        @Bean OrderService orderService(MarketMapper db) { return new OrderService(db); }
        @Bean CommunicationService communicationService(MarketMapper db, UserMapper users) { return new CommunicationService(db, users); }
        @Bean GoodsController goodsController(GoodsService service) { return new GoodsController(service); }
        @Bean OrderController orderController(OrderService service) { return new OrderController(service); }
        @Bean CommunicationController communicationController(CommunicationService service) { return new CommunicationController(service); }
        @Bean IntegrationController integrationController(MarketMapper db, UserMapper users) { return new IntegrationController(db, users); }
        @Bean FavoriteService favoriteService(MarketMapper db) { return new FavoriteService(db); }
        @Bean FavoriteController favoriteController(FavoriteService service) { return new FavoriteController(service); }
    }
}
