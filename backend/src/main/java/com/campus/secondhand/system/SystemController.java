package com.campus.secondhand.system;

import com.campus.secondhand.common.ApiResponse;
import org.springframework.security.web.csrf.CsrfToken;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class SystemController {
    @GetMapping("/api/health")
    public ApiResponse<Health> health() {
        return ApiResponse.success(new Health("UP", "secondhand-backend"));
    }

    @GetMapping("/api/auth/csrf")
    public ApiResponse<CsrfData> csrf(CsrfToken token) {
        return ApiResponse.success(new CsrfData(token.getToken(), token.getHeaderName()));
    }

    public record Health(String status, String service) { }
    public record CsrfData(String token, String headerName) { }
}
