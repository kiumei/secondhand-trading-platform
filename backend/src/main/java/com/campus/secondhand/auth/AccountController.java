package com.campus.secondhand.auth;

import com.campus.secondhand.common.ApiResponse;
import com.campus.secondhand.common.BusinessException;
import com.campus.secondhand.user.UserView;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.context.annotation.Profile;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.session.ChangeSessionIdAuthenticationStrategy;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.security.web.csrf.CsrfAuthenticationStrategy;
import org.springframework.security.web.csrf.HttpSessionCsrfTokenRepository;
import org.springframework.web.bind.annotation.*;

@RestController
@Profile("mysql")
public class AccountController {
    private final AccountService accounts;
    private final HttpSessionSecurityContextRepository contexts = new HttpSessionSecurityContextRepository();

    public AccountController(AccountService accounts) { this.accounts = accounts; }

    @PostMapping("/api/auth/register")
    public ApiResponse<UserView> register(@Valid @RequestBody RegisterRequest request) {
        return ApiResponse.success(accounts.register(request.phone(), request.password(), request.userName()));
    }

    @PostMapping("/api/auth/login")
    public ApiResponse<UserView> login(@Valid @RequestBody LoginRequest input,
            HttpServletRequest request, HttpServletResponse response) {
        var user = accounts.authenticate(input.phone(), input.password());
        var authentication = UsernamePasswordAuthenticationToken.authenticated(
                new AccountService.Principal(user.userId()), null,
                List.of(new SimpleGrantedAuthority(user.role() == 1 ? "ROLE_ADMIN" : "ROLE_STUDENT")));
        new ChangeSessionIdAuthenticationStrategy().onAuthentication(authentication, request, response);
        new CsrfAuthenticationStrategy(new HttpSessionCsrfTokenRepository())
                .onAuthentication(authentication, request, response);
        var context = SecurityContextHolder.createEmptyContext();
        context.setAuthentication(authentication);
        SecurityContextHolder.setContext(context);
        contexts.saveContext(context, request, response);
        return ApiResponse.success(UserView.from(user));
    }

    @GetMapping("/api/users/me")
    public ApiResponse<UserView> current(Authentication authentication) {
        if (authentication == null || !(authentication.getPrincipal() instanceof AccountService.Principal principal)) {
            throw new BusinessException(HttpStatus.UNAUTHORIZED, "UNAUTHENTICATED", "请先登录");
        }
        return ApiResponse.success(accounts.current(principal.userId()));
    }

    /** sys_user.phone 为 char(11) 且唯一，登录与注册统一按 11 位数字校验。 */
    public record RegisterRequest(@NotBlank @Pattern(regexp = "\\d{11}", message = "手机号必须是 11 位数字") String phone,
            @NotBlank @Size(max = 72) String password, @NotBlank @Size(max = 20) String userName) { }
    public record LoginRequest(@NotBlank @Pattern(regexp = "\\d{11}", message = "手机号必须是 11 位数字") String phone,
            @NotBlank @Size(max = 72) String password) { }

    @PatchMapping("/api/users/me")
    public ApiResponse<UserView> update(Authentication auth, @Valid @RequestBody ProfileRequest body) {
        return ApiResponse.success(accounts.updateProfile(com.campus.secondhand.common.CurrentUser.id(auth),
                body.userName(), body.avatar(), body.intro()));
    }

    public record ProfileRequest(@Size(max = 20) String userName,
            @Size(max = 255) String avatar, @Size(max = 200) String intro) { }
}
