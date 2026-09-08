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
        allow(item.goodsStatus() == 1 || item.goodsStatus() == 3 || admin || item.publishUserId().equals(viewer));
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
        var filter = new GoodsFilter(keyword, category, min, max, owner, privateList ? status : Integer.valueOf(1),
                page.getOffset(), page.getPageSize());
        return new PageResult<>(db.goodsList(filter), db.goodsCount(filter), page.getPage(), page.getPageSize());
    }

    @Transactional
    public Goods publish(String owner, GoodsInput body) {
        validateImages(body.images());
        found(db.category(body.categoryId()));
        var key = new com.campus.secondhand.common.GeneratedId();
        changed(db.insertGoods(key, owner, body));
        replaceImages(key.getId(), body.images());
        return found(db.goods(key.getId()));
    }

    @Transactional
    public Goods edit(String id, String owner, GoodsInput body) {
        var item = found(db.lockGoods(id));
        allow(item.publishUserId().equals(owner));
        editable(item);
        validateImages(body.images());
        found(db.category(body.categoryId()));
        changed(db.updateGoods(id, body));
        replaceImages(id, body.images());
        return found(db.goods(id));
    }

    @Transactional
    public Goods editForReview(String id, GoodsInput body) {
        var item = found(db.lockGoods(id));
        state(item.goodsStatus() == 0, "管理员只能修改待审核商品");
        state(db.activeOrders(id).isEmpty(), "商品存在有效订单，不能修改");
        validateImages(body.images());
        found(db.category(body.categoryId()));
        changed(db.updateGoods(id, body));
        replaceImages(id, body.images());
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
        state(item.goodsStatus() == 0, "只有待审核商品可以审核");
        state(db.activeOrders(id).isEmpty(), "商品存在有效订单");
        boolean pass = "PASS".equals(body.decision());
        require(pass || (body.rejectReason() != null && !body.rejectReason().isBlank()), "驳回时必须填写原因");
        changed(db.goodsStatus(id, 0, pass ? 1 : 4, pass ? null : body.rejectReason()));
        return found(db.goods(id));
    }

    private void editable(Goods item) {
        state(item.goodsStatus() != 3, "已售商品不能修改");
        state(db.activeOrders(item.goodsId()).isEmpty(), "商品存在有效订单，不能修改或下架");
    }

    @Transactional
    public Category saveCategory(String id, CategoryInput body) {
        require(body.cateDesc() == null || body.cateDesc().isBlank(), "当前分类表没有分类描述字段");
        // Serialize hierarchy mutations so concurrent moves cannot create a cycle.
        var categories = db.lockCategories();
        Category current = id == null ? null : found(db.category(id));
        if (current != null) { id = current.categoryId(); }
        String parent = body.parentId() != null ? body.parentId() : current == null ? "0" : current.parentId();
        parent = parent == null ? "0" : parent;
        Integer sort = body.sort() != null ? body.sort() : current == null ? 0 : current.sort();
        var byId = new java.util.HashMap<String, Category>();
        for (var category : categories) { byId.put(category.categoryId(), category); }
        var visited = new java.util.HashSet<String>();
        String ancestor = parent;
        int depth = 0;
        while (ancestor != null && !"0".equals(ancestor)) {
            require(!ancestor.equals(id) && visited.add(ancestor), "分类不能成为自身或子分类的下级");
            require(++depth <= 1, "仅支持两级分类，父分类必须是一级分类");
            Category category = byId.get(ancestor);
            require(category != null, "父分类不存在");
            ancestor = category.parentId();
        }
        if (!"0".equals(parent) && current != null) {
            String currentId = current.categoryId();
            require(categories.stream().noneMatch(c -> currentId.equals(c.parentId())), "有子分类的分类不能移动到二级");
        }
        var value = new CategoryInput(body.cateName(), null, parent, sort);
        if (id == null) {
            var key = new com.campus.secondhand.common.GeneratedId();
            changed(db.insertCategory(key, value)); id = key.getId();
        }
        else { changed(db.updateCategory(id, value)); }
        return found(db.category(id));
    }

    @Transactional
    public void deleteCategory(String id) {
        var categories = db.lockCategories();
        var current = found(db.category(id));
        state(categories.stream().noneMatch(c -> current.categoryId().equals(c.parentId())), "分类仍有子分类，不能删除");
        state(db.categoryGoods(id) == 0, "分类仍有关联商品，不能删除");
        changed(db.deleteCategory(id));
    }

    private void validateImages(java.util.List<String> images) {
        if (images == null) { return; }
        require(images.size() <= 4, "最多保存 4 张商品图片");
        for (String url : images) {
            require(url != null && !url.isBlank() && url.length() <= 500, "图片地址不能为空且不能超过 500 字符");
            boolean valid = url.matches("/api/media/[0-9a-f]{32}\\.(jpg|png)");
            try {
                var uri = java.net.URI.create(url);
                valid = valid || (("https".equalsIgnoreCase(uri.getScheme()) || "http".equalsIgnoreCase(uri.getScheme()))
                        && uri.getHost() != null && uri.getUserInfo() == null);
            } catch (IllegalArgumentException ex) { valid = false; }
            require(valid, "图片地址需为上传接口返回的路径或有效 HTTP/HTTPS 地址");
        }
    }

    private void replaceImages(String id, java.util.List<String> images) {
        // Omitted/null keeps images on edit. An explicit empty array clears associations only.
        if (images == null) { return; }
        db.deleteGoodsImages(id);
        for (int i = 0; i < images.size(); i++) { changed(db.insertGoodsImage(id, images.get(i), i + 1)); }
    }
}
