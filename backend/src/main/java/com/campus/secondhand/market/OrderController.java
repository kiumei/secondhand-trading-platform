package com.campus.secondhand.market;

import com.campus.secondhand.common.*;
import jakarta.validation.Valid;
import org.springframework.context.annotation.Profile;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import static com.campus.secondhand.market.MarketModels.*;

@RestController
@Profile("mysql")
public class OrderController {
    private final OrderService orders;
    public OrderController(OrderService orders) { this.orders = orders; }
    @PostMapping("/api/orders")
    public ApiResponse<Order> create(Authentication auth, @Valid @RequestBody OrderInput input) {
        return ApiResponse.success(orders.create(CurrentUser.id(auth), input.goodsId()));
    }
    @GetMapping("/api/orders")
    public ApiResponse<PageResult<Order>> list(Authentication auth, @RequestParam(defaultValue = "buy") String side,
            @Valid @ModelAttribute PageQuery page) {
        return ApiResponse.success(orders.list(CurrentUser.id(auth), side, page));
    }
    @GetMapping("/api/orders/{id}")
    public ApiResponse<Order> detail(Authentication auth, @PathVariable String id) {
        return ApiResponse.success(orders.detail(id, CurrentUser.id(auth)));
    }
    @PostMapping("/api/orders/{id}/{action:mock-pay|deliver|complete|cancel}")
    public ApiResponse<Order> action(Authentication auth, @PathVariable String id, @PathVariable String action) {
        return ApiResponse.success(orders.action(id, CurrentUser.id(auth), action));
    }
    @PostMapping("/api/orders/{id}/evaluation")
    public ApiResponse<Evaluation> evaluate(Authentication auth, @PathVariable String id,
            @Valid @RequestBody EvaluationInput input) {
        return ApiResponse.success(orders.evaluate(id, CurrentUser.id(auth), input));
    }
    @GetMapping("/api/goods/{id}/evaluations")
    public ApiResponse<PageResult<Evaluation>> evaluations(@PathVariable String id, @Valid @ModelAttribute PageQuery page) {
        return ApiResponse.success(orders.evaluations(id, page));
    }
    @GetMapping("/api/users/me/evaluations")
    public ApiResponse<PageResult<Evaluation>> myEvaluations(Authentication auth,
            @Valid @ModelAttribute PageQuery page) {
        return ApiResponse.success(orders.userEvaluations(CurrentUser.id(auth), page));
    }
}
