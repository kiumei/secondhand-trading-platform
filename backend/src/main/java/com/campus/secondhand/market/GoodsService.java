package com.campus.secondhand.market;

import com.campus.secondhand.category.CategoryMapper.Category;
import com.campus.secondhand.common.PageQuery;
import com.campus.secondhand.common.PageResult;
import java.math.BigDecimal;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import static com.campus.secondhand.market.MarketModels.*;
import static com.campus.secondhand.market.MarketRules.*;

@Service
@Profile("mysql")
public class GoodsService {
    private final MarketMapper db;
    public GoodsService(MarketMapper db) { this.db = db; }

    public Goods detail(String id, String viewer, boolean admin) {
        var item = found(db.goods(id));
        // 已售记录仍可由链接查看；待审核、驳回、下架仅所有者与管理员可见。
        allow(item.goodsStatus() == 0 || item.goodsStatus() == 1 || admin || item.publishUserId().equals(viewer));
        return item;
    }

    public PageResult<Goods> list(PageQuery page, String keyword, String category,
            BigDecimal min, BigDecimal max, String owner, Integer status, boolean privateList) {
        require(keyword == null || keyword.length() <= 100, "搜索词过长");
        require(category == null || category.length() <= 32, "分类编号过长");
        require(min == null || min.signum() >= 0, "最低价格不能为负数");
        require(max == null || max.signum() >= 0, "最高价格不能为负数");
        require(min == null || max == null || min.compareTo(max) <= 0, "价格范围不正确");
        require(status == null || (status >= 0 && status <= 4), "商品状态不正确");
        var filter = new GoodsFilter(keyword, category, min, max, owner, privateList ? status : Integer.valueOf(0),
                page.getOffset(), page.getPageSize());
        return new PageResult<>(db.goodsList(filter), db.goodsCount(filter), page.getPage(), page.getPageSize());
    }

    @Transactional
    public Goods publish(String owner, GoodsInput body) {
        found(db.category(body.categoryId()));
        String id = id();
        changed(db.insertGoods(id, owner, body));
        return found(db.goods(id));
    }

    @Transactional
    public Goods edit(String id, String owner, GoodsInput body) {
        var item = found(db.lockGoods(id));
        allow(item.publishUserId().equals(owner));
        editable(item);
        found(db.category(body.categoryId()));
        db.updateGoods(id, body);
        return found(db.goods(id));
    }

    @Transactional
    public Goods editForReview(String id, GoodsInput body) {
        var item = found(db.lockGoods(id));
        state(item.goodsStatus() == 3, "管理员只能修改待审核商品");
        state(db.activeOrders(id).isEmpty(), "商品存在有效订单，不能修改");
        found(db.category(body.categoryId()));
        changed(db.updateGoods(id, body));
        return found(db.goods(id));
    }

    @Transactional
    public void offShelf(String id, String owner, boolean admin) {
        var item = found(db.lockGoods(id));
        allow(admin || item.publishUserId().equals(owner));
        editable(item);
        if (item.goodsStatus() != 2) { changed(db.goodsStatus(id, item.goodsStatus(), 2, null)); }
    }

    @Transactional
    public Goods review(String id, ReviewInput body) {
        var item = found(db.lockGoods(id));
        state(item.goodsStatus() == 3, "只有待审核商品可以审核");
        state(db.activeOrders(id).isEmpty(), "商品存在有效订单");
        boolean pass = "PASS".equals(body.decision());
        require(pass || (body.rejectReason() != null && !body.rejectReason().isBlank()), "驳回时必须填写原因");
        changed(db.goodsStatus(id, 3, pass ? 0 : 4, pass ? null : body.rejectReason()));
        return found(db.goods(id));
    }

    private void editable(Goods item) {
        state(item.goodsStatus() != 1, "已售商品不能修改");
        state(db.activeOrders(item.goodsId()).isEmpty(), "商品存在有效订单，不能修改或下架");
    }

    @Transactional
    public Category saveCategory(String id, CategoryInput body) {
        if (id == null) { id = id(); changed(db.insertCategory(id, body)); }
        else { found(db.category(id)); changed(db.updateCategory(id, body)); }
        return found(db.category(id));
    }

    @Transactional
    public void deleteCategory(String id) {
        found(db.category(id));
        state(db.categoryGoods(id) == 0, "分类仍有关联商品，不能删除");
        changed(db.deleteCategory(id));
    }
}
