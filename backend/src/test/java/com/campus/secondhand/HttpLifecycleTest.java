package com.campus.secondhand;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.CookieManager;
import java.net.CookiePolicy;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Import;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@ActiveProfiles("local")
@Import(HttpLifecycleTest.TestEndpoints.class)
class HttpLifecycleTest {
    @LocalServerPort int port;
    @Autowired ObjectMapper mapper;

    private HttpClient client() {
        return HttpClient.newBuilder()
                .cookieHandler(new CookieManager(null, CookiePolicy.ACCEPT_ALL))
                .connectTimeout(Duration.ofSeconds(5)).build();
    }

    private HttpResponse<String> get(HttpClient client, String path) throws Exception {
        return client.send(HttpRequest.newBuilder(URI.create("http://localhost:" + port + path))
                .timeout(Duration.ofSeconds(5)).GET().build(), HttpResponse.BodyHandlers.ofString());
    }

    private HttpResponse<String> logout(HttpClient client, JsonNode csrf) throws Exception {
        var request = HttpRequest.newBuilder(URI.create("http://localhost:" + port + "/api/auth/logout"))
                .timeout(Duration.ofSeconds(5)).POST(HttpRequest.BodyPublishers.noBody());
        if (csrf != null) {
            request.header(csrf.get("headerName").asText(), csrf.get("token").asText());
        }
        return client.send(request.build(), HttpResponse.BodyHandlers.ofString());
    }

    @Test void realHttpServiceStartsAndReturnsJson() throws Exception {
        var response = get(client(), "/api/health");
        assertThat(response.statusCode()).isEqualTo(200);
        assertThat(mapper.readTree(response.body()).at("/data/status").asText()).isEqualTo("UP");
    }

    @Test void logoutInvalidatesCookieSessionAndOldCsrfToken() throws Exception {
        var client = client();
        var tokenResponse = get(client, "/api/auth/csrf");
        JsonNode oldToken = mapper.readTree(tokenResponse.body()).get("data");
        assertThat(tokenResponse.headers().allValues("set-cookie").toString()).contains("HttpOnly");
        assertThat(logout(client, null).statusCode()).isEqualTo(403);
        // GET 不能退出，也不能将 POST 的 token 消耗掉。
        assertThat(get(client, "/api/auth/logout").statusCode()).isEqualTo(401);
        var response = logout(client, oldToken);
        assertThat(response.statusCode()).isEqualTo(200);
        assertThat(mapper.readTree(response.body()).get("code").asText()).isEqualTo("OK");
        assertThat(response.headers().allValues("set-cookie").toString()).contains("Max-Age=0");
        assertThat(logout(client, oldToken).statusCode()).isEqualTo(403);
        var newToken = mapper.readTree(get(client, "/api/auth/csrf").body()).get("data");
        assertThat(newToken.get("token").asText()).isNotEqualTo(oldToken.get("token").asText());
        assertThat(logout(client, newToken).statusCode()).isEqualTo(200);
        assertThat(get(client, "/api/users/me").statusCode()).isEqualTo(401);
    }

    @Test void servletErrorDispatchUsesSafeJsonEnvelope() throws Exception {
        var response = get(client(), "/api/health?containerError=true");
        assertThat(response.statusCode()).isEqualTo(404);
        assertThat(mapper.readTree(response.body()).get("code").asText()).isEqualTo("NOT_FOUND");
        assertThat(response.body()).doesNotContain("private-container-detail", "timestamp", "trace");
    }

    @TestConfiguration
    static class TestEndpoints {
        @Bean ErrorProbe errorProbe() { return new ErrorProbe(); }
    }

    @RestController
    static class ErrorProbe {
        @GetMapping(value = "/api/health", params = "containerError")
        void containerError(HttpServletResponse response) throws IOException {
            response.sendError(404, "private-container-detail");
        }
    }
}
