package com.campus.secondhand.user;

import com.campus.secondhand.common.ApiResponse;
import com.campus.secondhand.common.CurrentUser;
import com.campus.secondhand.common.PageQuery;
import com.campus.secondhand.common.PageResult;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Size;
import org.springframework.context.annotation.Profile;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@Profile("mysql")
public class AdminUserController {
    private final AdminUserService users;
    public AdminUserController(AdminUserService users) { this.users = users; }

    @GetMapping("/api/admin/users")
    public ApiResponse<PageResult<UserView>> list(@RequestParam(required = false) String keyword,
            @Valid @ModelAttribute PageQuery page) {
        return ApiResponse.success(users.list(keyword, page));
    }

    @PostMapping("/api/admin/users/{id}/ban")
    public ApiResponse<UserView> ban(@PathVariable String id, Authentication auth) {
        return ApiResponse.success(users.setBanned(CurrentUser.id(auth), id, true));
    }

    @PostMapping("/api/admin/users/{id}/unban")
    public ApiResponse<UserView> unban(@PathVariable String id, Authentication auth) {
        return ApiResponse.success(users.setBanned(CurrentUser.id(auth), id, false));
    }

    @PostMapping("/api/admin/users/{id}/reset-password")
    public ApiResponse<AdminUserService.ResetResult> resetPassword(@PathVariable String id,
            @Valid @RequestBody(required = false) ResetRequest body) {
        return ApiResponse.success(users.resetPassword(id, body == null ? null : body.password()));
    }

    public record ResetRequest(@Size(max = 72) String password) { }
}
