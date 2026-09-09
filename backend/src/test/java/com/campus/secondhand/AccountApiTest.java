package com.campus.secondhand;

import com.campus.secondhand.auth.AccountController;
import com.campus.secondhand.auth.AccountService;
import com.campus.secondhand.category.CategoryController;
import com.campus.secondhand.category.CategoryMapper;
import com.campus.secondhand.user.AdminUserController;
import com.campus.secondhand.user.AdminUserService;
import com.campus.secondhand.user.UserMapper;
import com.campus.secondhand.user.UserRow;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.time.LocalDateTime;
import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Import;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/** Mapper 替身仅存在于测试，验证 API 与会话；不声称验证真实 SQL 或事务。 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("local")
@Import(AccountApiTest.Wiring.class)
class AccountApiTest {
    @Autowired MockMvc mvc;
    @Autowired ObjectMapper json;
    @Autowired UserMapper users;
    @Autowired CategoryMapper categories;
    @Autowired PasswordEncoder encoder;
    private UserRow student;
    private UserRow admin;

    @BeforeEach void setup() {
        reset(users, categories);
        student = new UserRow("student-id", "学生", encoder.encode("test-password"),
                "13800000000", null, null, 0, 0, LocalDateTime.of(2026, 9, 7, 9, 0));
        admin = new UserRow("admin-id", "管理员", encoder.encode("admin-password"),
                "13900000001", null, null, 1, 0, LocalDateTime.of(2026, 9, 7, 9, 0));
        when(users.findByPhone(student.phone())).thenReturn(student);
        when(users.findById(student.userId())).thenReturn(student);
        when(users.findByPhone(admin.phone())).thenReturn(admin);
        when(users.findById(admin.userId())).thenReturn(admin);
        when(users.insert(any())).thenReturn(1);
        when(users.lastInsertId()).thenReturn(421L);
    }

    private MockHttpServletRequestBuilder write(String path, String body) throws Exception {
        var result = mvc.perform(get("/api/auth/csrf")).andExpect(status().isOk()).andReturn();
        var token = json.readTree(result.getResponse().getContentAsString()).get("data");
        return post(path).session((MockHttpSession) result.getRequest().getSession(false))
                .header(token.get("headerName").asText(), token.get("token").asText())
                .contentType("application/json").content(body);
    }

    private MockHttpSession login(String phone, String password) throws Exception {
        var login = mvc.perform(write("/api/auth/login",
                "{\"phone\":\"" + phone + "\",\"password\":\"" + password + "\"}"))
                .andExpect(status().isOk()).andReturn();
        return (MockHttpSession) login.getRequest().getSession(false);
    }

    @Test void registerHashesPasswordAndIgnoresInjectedRole() throws Exception {
        mvc.perform(write("/api/auth/register", """
                {"phone":"13900000000","password":"new-password","userName":"新用户","role":1,"userId":"attacker"}
                """))
                .andExpect(status().isOk()).andExpect(jsonPath("$.data.role").value(0))
                .andExpect(jsonPath("$.data.status").value(0))
                .andExpect(jsonPath("$.data.userId").value("421"))
                .andExpect(jsonPath("$.data.password").doesNotExist());
        var capture = ArgumentCaptor.forClass(UserRow.class);
        verify(users).insert(capture.capture());
        assertThat(capture.getValue().userId()).isNull();
        assertThat(capture.getValue().role()).isZero();
        assertThat(capture.getValue().status()).isZero();
        assertThat(encoder.matches("new-password", capture.getValue().password())).isTrue();
    }

    @Test void registerRequiresElevenDigitPhone() throws Exception {
        mvc.perform(write("/api/auth/register", """
                {"phone":"139abc00000","password":"new-password","userName":"新用户"}
                """))
                .andExpect(status().isBadRequest());
        verify(users, never()).insert(any());
    }

    @Test void duplicatePhoneIncludesConcurrentConstraintViolation() throws Exception {
        mvc.perform(write("/api/auth/register", """
                {"phone":"13800000000","password":"test-password","userName":"重复"}
                """))
                .andExpect(status().isConflict()).andExpect(jsonPath("$.code").value("PHONE_EXISTS"));
        verify(users, never()).insert(any());
        when(users.insert(any())).thenThrow(new DuplicateKeyException("test-only"));
        mvc.perform(write("/api/auth/register", """
                {"phone":"13900000000","password":"test-password","userName":"并发"}
                """))
                .andExpect(status().isConflict()).andExpect(jsonPath("$.code").value("PHONE_EXISTS"));
    }

    @Test void loginRotatesSessionAndCsrfThenLogoutRemovesAuthentication() throws Exception {
        var builder = write("/api/auth/login", """
                {"phone":"13800000000","password":"test-password"}
                """);
        // 将登录前的会话和 token 保存，验证登录后失效。
        var request = builder.buildRequest(mvc.getDispatcherServlet().getServletContext());
        var session = (MockHttpSession) request.getSession(false);
        String oldId = session.getId();
        String oldToken = request.getHeader("X-CSRF-TOKEN");
        mvc.perform(builder).andExpect(status().isOk())
                .andExpect(jsonPath("$.data.password").doesNotExist());
        assertThat(session.getId()).isNotEqualTo(oldId);
        mvc.perform(get("/api/users/me").session(session))
                .andExpect(status().isOk()).andExpect(jsonPath("$.data.userId").value("student-id"))
                .andExpect(jsonPath("$.data.registerTime").value("2026-09-07T09:00:00+08:00"));
        mvc.perform(get("/api/admin/not-implemented").session(session)).andExpect(status().isForbidden());
        mvc.perform(post("/api/auth/logout").session(session).header("X-CSRF-TOKEN", oldToken))
                .andExpect(status().isForbidden());
        var refreshed = mvc.perform(get("/api/auth/csrf").session(session)).andReturn();
        String newToken = json.readTree(refreshed.getResponse().getContentAsString()).at("/data/token").asText();
        mvc.perform(post("/api/auth/logout").session(session).header("X-CSRF-TOKEN", newToken))
                .andExpect(status().isOk());
        assertThat(session.isInvalid()).isTrue();
        mvc.perform(get("/api/users/me")).andExpect(status().isUnauthorized());
    }

    @Test void bannedUserCannotLoginEvenWithCorrectPassword() throws Exception {
        when(users.findByPhone("13800000000")).thenReturn(new UserRow("student-id", "学生",
                student.password(), "13800000000", null, null, 0, 1, LocalDateTime.of(2026, 9, 7, 9, 0)));
        mvc.perform(write("/api/auth/login", """
                {"phone":"13800000000","password":"test-password"}
                """))
                .andExpect(status().isForbidden()).andExpect(jsonPath("$.code").value("ACCOUNT_BANNED"));
    }

    @Test void wrongPasswordAndUnknownPhoneHaveSamePublicError() throws Exception {
        for (String phone : List.of("13800000000", "13900000002")) {
            mvc.perform(write("/api/auth/login", "{\"phone\":\"" + phone + "\",\"password\":\"wrong\"}"))
                    .andExpect(status().isUnauthorized()).andExpect(jsonPath("$.code").value("BAD_CREDENTIALS"));
        }
    }

    @Test void invalidInputAndOversizedUtf8PasswordAreRejected() throws Exception {
        mvc.perform(write("/api/auth/register", "{\"phone\":\"\",\"password\":\"x\",\"userName\":\"x\"}"))
                .andExpect(status().isBadRequest());
        mvc.perform(write("/api/auth/register", "{\"phone\":\"13900000000\",\"password\":\"" + "密".repeat(25) + "\",\"userName\":\"x\"}"))
                .andExpect(status().isBadRequest());
        verify(users, never()).insert(any());
    }

    @Test void categoryQueryIsPublicAndUsesDatabaseFields() throws Exception {
        when(categories.findAll()).thenReturn(List.of(new CategoryMapper.Category("category-id", "教材", 0, 1),
                new CategoryMapper.Category("child-id", "课程教材", 1, 2)));
        mvc.perform(get("/api/categories")).andExpect(status().isOk())
                .andExpect(jsonPath("$.data[0].cateId").value("category-id"))
                .andExpect(jsonPath("$.data[0].parentId").value(0))
                .andExpect(jsonPath("$.data[1].parentId").value(1));
    }

    @Test void profilePatchOnlyUpdatesCurrentUsersAllowedFields() throws Exception {
        var session = login("13800000000", "test-password");
        var csrf = mvc.perform(get("/api/auth/csrf").session(session)).andReturn();
        String token = json.readTree(csrf.getResponse().getContentAsString()).at("/data/token").asText();
        when(users.updateProfile("student-id", "新昵称", null, "", null)).thenReturn(1);
        mvc.perform(patch("/api/users/me").session(session).header("X-CSRF-TOKEN", token)
                .contentType("application/json").content("""
                    {"userName":"新昵称","intro":"","userId":"victim","role":1,"phone":"changed"}
                    """))
                .andExpect(status().isOk()).andExpect(jsonPath("$.data.role").value(0));
        verify(users).updateProfile("student-id", "新昵称", null, "", null);
        mvc.perform(patch("/api/users/me").session(session).header("X-CSRF-TOKEN", token)
                .contentType("application/json").content("{\"userName\":\" \"}"))
                .andExpect(status().isBadRequest());
        verify(users, times(1)).updateProfile(any(), any(), any(), any(), any());
    }

    @Test void adminCanBanStudentButNotAdminAccounts() throws Exception {
        var session = login("13900000001", "admin-password");
        var csrf = mvc.perform(get("/api/auth/csrf").session(session)).andReturn();
        String token = json.readTree(csrf.getResponse().getContentAsString()).at("/data/token").asText();
        when(users.updateStatus("student-id", 1)).thenReturn(1);
        mvc.perform(post("/api/admin/users/student-id/ban").session(session).header("X-CSRF-TOKEN", token))
                .andExpect(status().isOk());
        verify(users).updateStatus("student-id", 1);
        // 管理员账号不能被封禁。
        mvc.perform(post("/api/admin/users/admin-id/ban").session(session).header("X-CSRF-TOKEN", token))
                .andExpect(status().isConflict());
        verify(users, never()).updateStatus(eq("admin-id"), anyInt());
        // 重置密码返回一次性新密码。
        when(users.updatePassword(eq("student-id"), anyString())).thenReturn(1);
        var result = mvc.perform(post("/api/admin/users/student-id/reset-password").session(session)
                        .header("X-CSRF-TOKEN", token).contentType("application/json").content("{}"))
                .andExpect(status().isOk());
        var body = json.readTree(result.andReturn().getResponse().getContentAsString()).at("/data/newPassword").asText();
        assertThat(body).hasSize(8);
        verify(users).updatePassword(eq("student-id"), anyString());
    }

    @TestConfiguration
    static class Wiring {
        @Bean UserMapper users() { return mock(UserMapper.class); }
        @Bean CategoryMapper categories() { return mock(CategoryMapper.class); }
        @Bean AccountService accounts(UserMapper users, PasswordEncoder encoder) { return new AccountService(users, encoder); }
        @Bean AccountController accountController(AccountService accounts) { return new AccountController(accounts); }
        @Bean CategoryController categoryController(CategoryMapper categories) { return new CategoryController(categories); }
        @Bean AdminUserService adminUserService(UserMapper users, PasswordEncoder encoder) { return new AdminUserService(users, encoder); }
        @Bean AdminUserController adminUserController(AdminUserService users) { return new AdminUserController(users); }
    }
}
