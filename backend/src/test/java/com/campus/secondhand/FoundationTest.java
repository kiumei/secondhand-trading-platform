package com.campus.secondhand;

import com.campus.secondhand.common.ApiResponse;
import com.campus.secondhand.common.BusinessException;
import com.campus.secondhand.common.PageQuery;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Import;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RestController;
import jakarta.validation.Valid;
import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("local")
@Import(FoundationTest.TestEndpoints.class)
class FoundationTest {
    @Autowired MockMvc mvc;
    @Autowired ObjectMapper mapper;
    @Autowired PasswordEncoder encoder;

    @Test void healthIsPublicAndWrapped() throws Exception {
        mvc.perform(get("/api/health"))
                .andExpect(status().isOk()).andExpect(jsonPath("$.code").value("OK"))
                .andExpect(jsonPath("$.data.status").value("UP"));
    }

    @Test void protectedRequestsReturnJsonInsteadOfLoginRedirect() throws Exception {
        mvc.perform(get("/api/users/me"))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.code").value("UNAUTHENTICATED"));
    }

    @Test void csrfTokenWorksOnlyWithItsSession() throws Exception {
        var result = mvc.perform(get("/api/auth/csrf")).andExpect(status().isOk()).andReturn();
        var data = mapper.readTree(result.getResponse().getContentAsString()).get("data");
        var session = (MockHttpSession) result.getRequest().getSession(false);
        assertThat(session).isNotNull();
        String header = data.get("headerName").asText();
        String token = data.get("token").asText();
        mvc.perform(post("/api/not-implemented").session(session))
                .andExpect(status().isForbidden()).andExpect(jsonPath("$.code").value("FORBIDDEN"));
        mvc.perform(post("/api/not-implemented").session(session).header(header, token))
                .andExpect(status().isUnauthorized());
        mvc.perform(post("/api/not-implemented").header(header, token))
                .andExpect(status().isForbidden());
    }

    @Test void queryValidationKeepsItsHttpStatus() throws Exception {
        mvc.perform(get("/api/health").param("pageCheck", "true").param("pageSize", "51"))
                .andExpect(status().isBadRequest()).andExpect(jsonPath("$.code").value("INVALID_REQUEST"));
        mvc.perform(get("/api/health").param("pageCheck", "true").param("page", "abc"))
                .andExpect(status().isBadRequest());
        mvc.perform(get("/api/health").param("pageCheck", "true"))
                .andExpect(status().isOk()).andExpect(jsonPath("$.data").value(0));
    }

    @Test void businessConflictKeepsItsCodeAndStatus() throws Exception {
        mvc.perform(get("/api/health").param("failureCheck", "conflict"))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.code").value("TEST_CONFLICT"));
    }

    @Test void unexpectedFailureDoesNotLeakInternalMessage() throws Exception {
        mvc.perform(get("/api/health").param("failureCheck", "unexpected"))
                .andExpect(status().isInternalServerError())
                .andExpect(jsonPath("$.code").value("INTERNAL_ERROR"))
                .andExpect(jsonPath("$.message").value("服务暂时不可用"));
    }

    @Test void passwordHashIsSaltedAndVerifiable() {
        String first = encoder.encode("course-test-password");
        assertThat(first).isNotEqualTo(encoder.encode("course-test-password"));
        assertThat(encoder.matches("course-test-password", first)).isTrue();
        assertThat(encoder.matches("wrong-password", first)).isFalse();
        assertThat(first.length()).isLessThanOrEqualTo(64);
    }

    @TestConfiguration
    static class TestEndpoints {
        @Bean QueryProbe queryProbe() { return new QueryProbe(); }
    }

    /** 只存在于测试上下文，验证真实 MVC 参数绑定与全局异常链路。 */
    @RestController
    static class QueryProbe {
        @GetMapping(value = "/api/health", params = "pageCheck")
        ApiResponse<Long> query(@Valid @ModelAttribute PageQuery query) {
            return ApiResponse.success(query.getOffset());
        }

        @GetMapping(value = "/api/health", params = "failureCheck=conflict")
        void conflict() {
            throw new BusinessException(HttpStatus.CONFLICT, "TEST_CONFLICT", "测试状态冲突");
        }

        @GetMapping(value = "/api/health", params = "failureCheck=unexpected")
        void unexpected() {
            throw new IllegalStateException("internal-detail-must-not-leak");
        }
    }
}
