package com.campus.secondhand;

import com.campus.secondhand.auth.AccountService;
import com.campus.secondhand.category.CategoryMapper.Category;
import com.campus.secondhand.common.StatusCodes;
import com.campus.secondhand.market.*;
import com.campus.secondhand.user.UserMapper;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.math.BigDecimal;
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
            {"cateId":"c","title":"教材","sellPrice":"12.34","tradeType":2,"goodsDesc":"描述",
             "images":["http://img/a","http://img/b"]}
            """;

    @BeforeEach void setup() {
        reset(db, users);
        when(db.category("c")).thenReturn(new Category("c", "教材", 0, 1));
        when(db.goods(anyString())).thenReturn(MarketServiceTest.item(StatusCodes.GOODS_LISTED));
        when(db.lockGoods("g")).thenReturn(MarketServiceTest.item(StatusCodes.GOODS_LISTED));
        when(db.activeOrderIds("g")).thenReturn(List.of());
        when(db.images(anyString())).thenReturn(List.of("http://img/a", "http://img/b"));
        when(db.deleteImages(anyString())).thenReturn(1);
        when(db.insertImages(anyString(), anyList()))
                .thenAnswer(inv -> ((java.util.List<?>) inv.getArgument(1)).size());
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
        when(db.goodsList(any())).thenReturn(List.of(MarketServiceTest.item(StatusCodes.GOODS_LISTED)));
        when(db.goodsCount(any())).thenReturn(1L);
        mvc.perform(get("/api/goods")).andExpect(status().isOk())
                .andExpect(jsonPath("$.data.items[0].sellPrice").value("12.34"))
                .andExpect(jsonPath("$.data.items[0].publishTime").value("2026-09-07T09:00:00+08:00"))
                .andExpect(jsonPath("$.data.items[0].coverUrl").value("http://img/1"));
        mvc.perform(write(post("/api/goods"), new MockHttpSession(), GOODS)).andExpect(status().isUnauthorized());
    }
    @Test void publishingValidatesMoneyAndUsesCurrentOwner() throws Exception {
        var session = session("seller", "STUDENT");
        mvc.perform(write(post("/api/goods"), session, GOODS.replace("12.34", "12.345"))).andExpect(status().isBadRequest());
        verify(db, never()).insertGoods(any(), any());
        when(db.insertGoods(eq("seller"), any())).thenReturn(1);
        when(db.lastInsertId()).thenReturn(7L);
        when(db.goods("7")).thenReturn(MarketServiceTest.item(StatusCodes.GOODS_PENDING));
        mvc.perform(write(post("/api/goods"), session, GOODS)).andExpect(status().isOk())
                .andExpect(jsonPath("$.data.goodsStatus").value(0))
                .andExpect(jsonPath("$.data.images.length()").value(2));
        verify(db).insertGoods(eq("seller"), any());
        verify(db).insertImages(eq("7"), any());
    }
    @Test void favoriteEndpointsStayScopedToCurrentSession() throws Exception {
        var session = session("buyer", "STUDENT");
        when(db.insertFavorite("buyer", "g")).thenReturn(1);
        mvc.perform(write(post("/api/favorites"), session, "{\"goodsId\":\"g\"}")).andExpect(status().isOk());
        verify(db).insertFavorite("buyer", "g");
        mvc.perform(get("/api/favorites/g").session(session)).andExpect(status().isOk());
        verify(db, atLeastOnce()).favoriteExists("buyer", "g");
        mvc.perform(get("/api/favorites")).andExpect(status().isUnauthorized());
    }
    @Test void adminEndpointsRejectStudentsBeforeDatabaseWork() throws Exception {
        mvc.perform(write(post("/api/admin/categories"), session("student", "STUDENT"), "{\"cateName\":\"教材\",\"parentId\":0}"))
                .andExpect(status().isForbidden());
        verify(db, never()).insertCategory(any());
        when(db.insertCategory(any())).thenReturn(1);
        when(db.lastInsertId()).thenReturn(9L);
        when(db.category("9")).thenReturn(new Category("9", "教材", 0, 1));
        mvc.perform(write(post("/api/admin/categories"), session("admin", "ADMIN"), "{\"cateName\":\"教材\",\"parentId\":0}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.cateId").value("9"))
                .andExpect(jsonPath("$.data.parentId").value(0));
    }
    @Test void adminCanEditPendingGoodsAndDashboardAggregates() throws Exception {
        when(db.lockGoods("g")).thenReturn(MarketServiceTest.item(StatusCodes.GOODS_PENDING));
        when(db.updateGoods(eq("g"), any())).thenReturn(1);
        mvc.perform(write(put("/api/admin/goods/g"), session("admin", "ADMIN"), GOODS))
                .andExpect(status().isOk());
        verify(db).updateGoods(eq("g"), any());

        when(db.countGoods()).thenReturn(12L);
        when(db.countOrders()).thenReturn(34L);
        when(db.salesAmount()).thenReturn(new BigDecimal("567.89"));
        when(db.countGoodsByStatus(StatusCodes.GOODS_PENDING)).thenReturn(3L);
        when(users.countUsers()).thenReturn(56L);
        mvc.perform(get("/api/admin/dashboard").session(session("admin", "ADMIN")))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.goodsCount").value(12))
                .andExpect(jsonPath("$.data.salesAmount").value("567.89"))
                .andExpect(jsonPath("$.data.pendingGoodsCount").value(3));
        mvc.perform(get("/api/admin/dashboard")).andExpect(status().isUnauthorized());
    }
    @Test void adminOrdersAndEvaluationsAreAdminOnly() throws Exception {
        when(db.adminOrders(isNull(), anyLong(), anyInt())).thenReturn(List.of(MarketServiceTest.order(0)));
        when(db.adminOrderCount(isNull())).thenReturn(1L);
        mvc.perform(get("/api/admin/orders").session(session("admin", "ADMIN")))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.total").value(1));
        when(db.allEvaluations(anyLong(), anyInt())).thenReturn(List.of(
                new Evaluation("9", "o", "g", "buyer", 5, "很好", MarketServiceTest.TIME)));
        when(db.allEvaluationCount()).thenReturn(1L);
        mvc.perform(get("/api/admin/evaluations").session(session("admin", "ADMIN")))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.items[0].evaluateUserId").value("buyer"));
        mvc.perform(delete("/api/admin/evaluations/9").session(session("admin", "ADMIN"))
                        .header("X-CSRF-TOKEN", "invalid")).andExpect(status().isForbidden());
        when(db.evaluation("9")).thenReturn(new Evaluation("9", "o", "g", "buyer", 5, "很好", MarketServiceTest.TIME));
        when(db.deleteEvaluation("9")).thenReturn(1);
        mvc.perform(write(delete("/api/admin/evaluations/9"), session("admin", "ADMIN"), ""))
                .andExpect(status().isOk());
    }
    @Test void myGoodsCannotBeRedirectedToAnotherOwner() throws Exception {
        mvc.perform(get("/api/users/me/goods").session(session("seller", "STUDENT")).param("ownerId", "victim"))
                .andExpect(status().isOk());
        verify(db).goodsList(argThat(f -> "seller".equals(f.ownerId())));
    }
    @Test void receivedEvaluationsArePublicAndScopedToSeller() throws Exception {
        when(db.sellerEvaluations(eq("seller"), anyLong(), anyInt())).thenReturn(List.of(
                new Evaluation("9", "o", "g", "buyer", 4, "不错", MarketServiceTest.TIME)));
        when(db.sellerEvaluationCount("seller")).thenReturn(1L);
        mvc.perform(get("/api/users/seller/evaluations")).andExpect(status().isOk())
                .andExpect(jsonPath("$.data.items[0].evaluateContent").value("不错"));
        verify(db, never()).userEvaluations(any(), anyLong(), anyInt());
    }
    @Test void orderIgnoresForgedBuyerAndPrice() throws Exception {
        when(db.insertOrder(any())).thenReturn(1);
        mvc.perform(write(post("/api/orders"), session("buyer", "STUDENT"),
                "{\"goodsId\":\"g\",\"buyerId\":\"victim\",\"orderPrice\":\"0.01\"}"))
                .andExpect(status().isOk()).andExpect(jsonPath("$.data.buyerId").value("buyer"))
                .andExpect(jsonPath("$.data.orderPrice").value("12.34"))
                .andExpect(jsonPath("$.data.payStatus").value(0));
    }
    @Test void orderActionRouteAndInvalidEvaluationAreChecked() throws Exception {
        when(db.order("o")).thenReturn(MarketServiceTest.order(0));
        when(db.lockOrder("o")).thenReturn(MarketServiceTest.order(0));
        when(db.orderPay(eq("o"), eq(0), any())).thenReturn(1);
        var session = session("buyer", "STUDENT");
        mvc.perform(write(post("/api/orders/o/mock-pay"), session, "{}"))
                .andExpect(status().isOk()).andExpect(jsonPath("$.data.orderStatus").value(1))
                .andExpect(jsonPath("$.data.payStatus").value(1));
        mvc.perform(write(post("/api/orders/o/evaluation"), session, "{\"score\":0}"))
                .andExpect(status().isBadRequest());
        verify(db, never()).insertEvaluation(any(), anyInt(), any(), any());
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
    @Test void orderAddressIsAcceptedButCannotExposeAnotherBuyersOrder() throws Exception {
        var session = session("buyer", "STUDENT");
        when(db.insertOrder(any())).thenReturn(1);
        mvc.perform(write(post("/api/orders"), session, "{\"goodsId\":\"g\",\"shippingAddress\":\"校区1栋\"}"))
                .andExpect(status().isOk()).andExpect(jsonPath("$.data.shippingAddress").value("校区1栋"));
        mvc.perform(write(post("/api/orders"), session, json.writeValueAsString(java.util.Map.of("goodsId", "g", "shippingAddress", "x".repeat(256)))))
                .andExpect(status().isBadRequest());
        when(db.order("o")).thenReturn(MarketServiceTest.order(0));
        mvc.perform(get("/api/orders/o").session(session("stranger", "STUDENT"))).andExpect(status().isForbidden());
        mvc.perform(get("/api/users/me/evaluations")).andExpect(status().isUnauthorized());
    }

    @TestConfiguration
    static class Wiring {
        @Bean MarketMapper marketMapper() { return mock(MarketMapper.class); }
        @Bean UserMapper userMapper() { return mock(UserMapper.class); }
        @Bean GoodsService goodsService(MarketMapper db) { return new GoodsService(db); }
        @Bean OrderService orderService(MarketMapper db) { return new OrderService(db); }
        @Bean CommunicationService communicationService(MarketMapper db, UserMapper users) { return new CommunicationService(db, users); }
        @Bean FavoriteService favoriteService(MarketMapper db) { return new FavoriteService(db); }
        @Bean com.campus.secondhand.system.DashboardService dashboardService(MarketMapper db, UserMapper users) {
            return new com.campus.secondhand.system.DashboardService(db, users);
        }
        @Bean GoodsController goodsController(GoodsService service) { return new GoodsController(service); }
        @Bean OrderController orderController(OrderService service) { return new OrderController(service); }
        @Bean CommunicationController communicationController(CommunicationService service) { return new CommunicationController(service); }
        @Bean FavoriteController favoriteController(FavoriteService service) { return new FavoriteController(service); }
        @Bean com.campus.secondhand.system.DashboardController dashboardController(com.campus.secondhand.system.DashboardService service) {
            return new com.campus.secondhand.system.DashboardController(service);
        }
    }
}
