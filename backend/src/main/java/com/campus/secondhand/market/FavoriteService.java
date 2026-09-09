package com.campus.secondhand.market;

import com.campus.secondhand.common.BusinessException;
import com.campus.secondhand.common.PageQuery;
import com.campus.secondhand.common.PageResult;
import com.campus.secondhand.common.StatusCodes;
import org.springframework.context.annotation.Profile;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import static com.campus.secondhand.market.MarketModels.*;
import static com.campus.secondhand.market.MarketRules.*;

/** 收藏（A1）：favorite(user_id, goods_id) 唯一，按收藏时间倒序分页返回商品。 */
@Service
@Profile("mysql")
public class FavoriteService {
    private final MarketMapper db;
    public FavoriteService(MarketMapper db) { this.db = db; }

    public PageResult<Goods> list(String user, PageQuery page) {
        return new PageResult<>(db.favoriteGoods(user, page.getOffset(), page.getPageSize()),
                db.favoriteCount(user), page.getPage(), page.getPageSize());
    }

    public boolean exists(String user, String goodsId) {
        require(goodsId != null && !goodsId.isBlank() && goodsId.length() <= 32, "商品编号不正确");
        return db.favoriteExists(user, goodsId);
    }

    @Transactional
    public void add(String user, String goodsId) {
        var item = found(db.goods(goodsId));
        state(item.goodsStatus() == StatusCodes.GOODS_LISTED || item.goodsStatus() == StatusCodes.GOODS_SOLD,
                "商品当前不可收藏");
        state(!db.favoriteExists(user, goodsId), "已收藏该商品");
        changed(db.insertFavorite(user, goodsId));
    }

    @Transactional
    public void remove(String user, String goodsId) {
        if (db.deleteFavorite(user, goodsId) != 1) {
            throw new BusinessException(HttpStatus.NOT_FOUND, "NOT_FOUND", "未收藏该商品");
        }
    }
}
