package com.campus.secondhand.auth;

import com.campus.secondhand.common.ApiResponse;
import com.campus.secondhand.user.UserMapper;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

/** Recheck the account for existing sessions so password resets revoke previous logins. */
public class AccountSessionFilter extends OncePerRequestFilter {
    private final UserMapper users;
    private final ObjectMapper json;
    public AccountSessionFilter(UserMapper users, ObjectMapper json) { this.users = users; this.json = json; }
    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {
        var auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.getPrincipal() instanceof AccountService.Principal principal
                && !"/api/auth/logout".equals(request.getServletPath())) {
            com.campus.secondhand.user.UserRow row;
            try { row = users.findById(principal.userId()); }
            catch (org.springframework.dao.DataAccessException ex) {
                response.setStatus(503); response.setContentType("application/json;charset=UTF-8");
                json.writeValue(response.getOutputStream(), ApiResponse.error("SERVICE_UNAVAILABLE", "服务暂时不可用"));
                return;
            }
            if (row == null || row.status() != 0 || !AccountService.credentialVersion(row).equals(principal.credentialVersion())) {
                SecurityContextHolder.clearContext();
                var session = request.getSession(false);
                if (session != null) { session.invalidate(); }
                response.setStatus(401); response.setContentType("application/json;charset=UTF-8");
                json.writeValue(response.getOutputStream(), ApiResponse.error("UNAUTHENTICATED", "账号状态已变更，请重新登录"));
                return;
            }
        }
        chain.doFilter(request, response);
    }
}
