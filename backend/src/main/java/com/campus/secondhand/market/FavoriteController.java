package com.campus.secondhand.market;

import com.campus.secondhand.common.*;
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
    @GetMapping("/api/users/me/favorites")
    public ApiResponse<PageResult<Favorite>> list(Authentication auth, @Valid @ModelAttribute PageQuery page) {
        return ApiResponse.success(favorites.list(CurrentUser.id(auth), page));
    }
    @GetMapping("/api/goods/{id}/favorite")
    public ApiResponse<Boolean> contains(Authentication auth, @PathVariable String id) {
        return ApiResponse.success(favorites.contains(CurrentUser.id(auth), id));
    }
    @PutMapping("/api/goods/{id}/favorite")
    public ApiResponse<Void> add(Authentication auth, @PathVariable String id) {
        favorites.add(CurrentUser.id(auth), id); return ApiResponse.success(null);
    }
    @DeleteMapping("/api/goods/{id}/favorite")
    public ApiResponse<Void> remove(Authentication auth, @PathVariable String id) {
        favorites.remove(CurrentUser.id(auth), id); return ApiResponse.success(null);
    }
}
