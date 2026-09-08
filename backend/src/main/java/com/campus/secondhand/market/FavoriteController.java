package com.campus.secondhand.market;

import com.campus.secondhand.common.ApiResponse;
import com.campus.secondhand.common.CurrentUser;
import com.campus.secondhand.common.PageQuery;
import com.campus.secondhand.common.PageResult;
import jakarta.validation.Valid;
import org.springframework.context.annotation.Profile;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import static com.campus.secondhand.market.MarketModels.*;

@RestController
@Profile("mysql")
public class FavoriteController {
    private final FavoriteService favorites;
    public FavoriteController(FavoriteService favorites) { this.favorites = favorites; }

    @GetMapping("/api/favorites")
    public ApiResponse<PageResult<Goods>> list(Authentication auth, @Valid @ModelAttribute PageQuery page) {
        return ApiResponse.success(favorites.list(CurrentUser.id(auth), page));
    }

    @GetMapping("/api/favorites/{goodsId}")
    public ApiResponse<Boolean> exists(Authentication auth, @PathVariable String goodsId) {
        return ApiResponse.success(favorites.exists(CurrentUser.id(auth), goodsId));
    }

    @PostMapping("/api/favorites")
    public ApiResponse<Void> add(Authentication auth, @Valid @RequestBody FavoriteInput input) {
        favorites.add(CurrentUser.id(auth), input.goodsId());
        return ApiResponse.success(null);
    }

    @DeleteMapping("/api/favorites/{goodsId}")
    public ApiResponse<Void> remove(Authentication auth, @PathVariable String goodsId) {
        favorites.remove(CurrentUser.id(auth), goodsId);
        return ApiResponse.success(null);
    }
}
