package com.campus.secondhand.market;

import com.campus.secondhand.common.*;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import static com.campus.secondhand.market.MarketModels.*;
import static com.campus.secondhand.market.MarketRules.*;

@Service
@Profile("mysql")
public class FavoriteService {
    private final MarketMapper db;
    public FavoriteService(MarketMapper db) { this.db = db; }
    public PageResult<Favorite> list(String user, PageQuery page) {
        return new PageResult<>(db.favorites(user, page.getOffset(), page.getPageSize()),
                db.favoriteCount(user), page.getPage(), page.getPageSize());
    }
    public boolean contains(String user, String goods) { return db.isFavorite(user, goods); }
    @Transactional
    public void add(String user, String goods) {
        var item = found(db.lockGoods(goods));
        allow(item.goodsStatus() == 1 || item.goodsStatus() == 3 || item.publishUserId().equals(user));
        // All add operations for a good share its row lock; the unique key remains the final guard.
        if (!db.isFavorite(user, item.goodsId())) { changed(db.addFavorite(user, item.goodsId())); }
    }
    @Transactional
    public void remove(String user, String goods) {
        // Lock the same row as add so concurrent add/remove calls have a defined order.
        found(db.lockGoods(goods));
        db.removeFavorite(user, goods);
    }
}
