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
    @GetMapping("/api/admin/users")
    public ApiResponse<PageResult<UserView>> users(@Valid @ModelAttribute PageQuery page) {
        return ApiResponse.success(new PageResult<>(users.list(page.getOffset(), page.getPageSize()).stream()
                .map(UserView::from).toList(), users.count(), page.getPage(), page.getPageSize()));
    }
    @GetMapping("/api/admin/orders")
    public ApiResponse<PageResult<Order>> orders(@Valid @ModelAttribute PageQuery page) {
        return ApiResponse.success(new PageResult<>(market.adminOrders(page.getOffset(), page.getPageSize()),
                market.adminOrderCount(), page.getPage(), page.getPageSize()));
    }
    @GetMapping("/api/admin/dashboard")
    public ApiResponse<Dashboard> dashboard() { return ApiResponse.success(market.dashboard()); }
    @DeleteMapping("/api/admin/evaluations/{id}")
    public ApiResponse<Void> deleteEvaluation(@PathVariable String id) {
        com.campus.secondhand.market.MarketRules.changed(market.deleteEvaluation(id));
        return ApiResponse.success(null);
    }
    @GetMapping("/api/admin/evaluations")
    public ApiResponse<PageResult<Evaluation>> evaluations(@Valid @ModelAttribute PageQuery page) {
        return ApiResponse.success(new PageResult<>(market.adminEvaluations(page.getOffset(), page.getPageSize()),
                market.adminEvaluationCount(), page.getPage(), page.getPageSize()));
    }
    @GetMapping("/api/users/me/messages")
    public ApiResponse<PageResult<Message>> messages(Authentication auth, @Valid @ModelAttribute PageQuery page) {
        String id = CurrentUser.id(auth);
        return ApiResponse.success(new PageResult<>(market.inbox(id, page.getOffset(), page.getPageSize()),
                market.inboxCount(id), page.getPage(), page.getPageSize()));
    }
}
