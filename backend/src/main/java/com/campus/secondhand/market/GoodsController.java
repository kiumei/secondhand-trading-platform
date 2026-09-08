package com.campus.secondhand.market;

import com.campus.secondhand.category.CategoryMapper.Category;
import com.campus.secondhand.common.*;
import jakarta.validation.Valid;
import java.math.BigDecimal;
import org.springframework.context.annotation.Profile;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import static com.campus.secondhand.market.MarketModels.*;

@RestController
@Profile("mysql")
public class GoodsController {
    private final GoodsService goods;
    public GoodsController(GoodsService goods) { this.goods = goods; }

    @GetMapping("/api/goods")
    public ApiResponse<PageResult<Goods>> list(@Valid @ModelAttribute PageQuery page,
            @RequestParam(required = false) String keyword, @RequestParam(required = false) String cateId,
            @RequestParam(required = false) BigDecimal minPrice, @RequestParam(required = false) BigDecimal maxPrice,
            @RequestParam(required = false) String sort) {
        return ApiResponse.success(goods.list(page, keyword, cateId, minPrice, maxPrice, null, null, false, sort));
    }
    @GetMapping("/api/goods/{id}")
    public ApiResponse<GoodsDetail> detail(@PathVariable String id, Authentication auth) {
        String viewer = auth != null && auth.getPrincipal() instanceof com.campus.secondhand.auth.AccountService.Principal
                ? CurrentUser.id(auth) : null;
        return ApiResponse.success(goods.detail(id, viewer, CurrentUser.admin(auth)));
    }
    @GetMapping("/api/users/me/goods")
    public ApiResponse<PageResult<Goods>> mine(Authentication auth, @Valid @ModelAttribute PageQuery page,
            @RequestParam(required = false) Integer status) {
        return ApiResponse.success(goods.list(page, null, null, null, null, CurrentUser.id(auth), status, true, null));
    }
    @PostMapping("/api/goods")
    public ApiResponse<GoodsDetail> publish(Authentication auth, @Valid @RequestBody GoodsInput body) {
        return ApiResponse.success(goods.publish(CurrentUser.id(auth), body));
    }
    @PutMapping("/api/goods/{id}")
    public ApiResponse<GoodsDetail> edit(@PathVariable String id, Authentication auth, @Valid @RequestBody GoodsInput body) {
        return ApiResponse.success(goods.edit(id, CurrentUser.id(auth), body));
    }
    @PostMapping("/api/goods/{id}/off-shelf")
    public ApiResponse<Void> offShelf(@PathVariable String id, Authentication auth) {
        goods.offShelf(id, CurrentUser.id(auth), CurrentUser.admin(auth));
        return ApiResponse.success(null);
    }
    @GetMapping("/api/admin/goods")
    public ApiResponse<PageResult<Goods>> pending(@Valid @ModelAttribute PageQuery page,
            @RequestParam(defaultValue = "0") Integer status) {
        return ApiResponse.success(goods.list(page, null, null, null, null, null, status, true, null));
    }
    @PostMapping("/api/admin/goods/{id}/review")
    public ApiResponse<GoodsDetail> review(@PathVariable String id, @Valid @RequestBody ReviewInput body) {
        return ApiResponse.success(goods.review(id, body));
    }
    @PutMapping("/api/admin/goods/{id}")
    public ApiResponse<GoodsDetail> editForReview(@PathVariable String id, @Valid @RequestBody GoodsInput body) {
        return ApiResponse.success(goods.editForReview(id, body));
    }
    @PostMapping("/api/admin/categories")
    public ApiResponse<Category> addCategory(@Valid @RequestBody CategoryInput body) {
        return ApiResponse.success(goods.saveCategory(body, null));
    }
    @PutMapping("/api/admin/categories/{id}")
    public ApiResponse<Category> editCategory(@PathVariable String id, @Valid @RequestBody CategoryInput body) {
        return ApiResponse.success(goods.saveCategory(body, id));
    }
    @DeleteMapping("/api/admin/categories/{id}")
    public ApiResponse<Void> deleteCategory(@PathVariable String id) {
        goods.deleteCategory(id); return ApiResponse.success(null);
    }
}
