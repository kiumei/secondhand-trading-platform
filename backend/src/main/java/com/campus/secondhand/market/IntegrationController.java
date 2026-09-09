package com.campus.secondhand.market;

import com.campus.secondhand.common.*;
import com.campus.secondhand.user.*;
import jakarta.validation.Valid;
import org.springframework.context.annotation.Profile;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import static com.campus.secondhand.market.MarketModels.*;
import static com.campus.secondhand.market.MarketRules.found;

@RestController
@Profile("mysql")
public class IntegrationController {
    private final MarketMapper market;
    private final UserMapper users;
    public IntegrationController(MarketMapper market, UserMapper users) { this.market = market; this.users = users; }

    @GetMapping("/api/public/users/{id}")
    public ApiResponse<PublicUserView> profile(@PathVariable String id) {
        return ApiResponse.success(found(users.publicProfile(id)));
    }
    @GetMapping("/api/users/me/messages")
    public ApiResponse<PageResult<Message>> messages(Authentication auth, @Valid @ModelAttribute PageQuery page) {
        String id = CurrentUser.id(auth);
        return ApiResponse.success(new PageResult<>(market.inbox(id, page.getOffset(), page.getPageSize()),
                market.inboxCount(id), page.getPage(), page.getPageSize()));
    }
}
