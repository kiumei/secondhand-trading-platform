package com.campus.secondhand.common;

import com.campus.secondhand.auth.AccountService;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;

public final class CurrentUser {
    private CurrentUser() { }
    public static String id(Authentication auth) {
        if (auth == null || !(auth.getPrincipal() instanceof AccountService.Principal principal)) {
            throw new BusinessException(HttpStatus.UNAUTHORIZED, "UNAUTHENTICATED", "请先登录");
        }
        return principal.userId();
    }
    public static boolean admin(Authentication auth) {
        return auth != null && auth.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
    }
}
