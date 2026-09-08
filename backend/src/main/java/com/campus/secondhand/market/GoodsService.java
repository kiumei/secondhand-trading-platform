package com.campus.secondhand.market;

import com.campus.secondhand.category.CategoryMapper.Category;
import com.campus.secondhand.common.BusinessException;
import com.campus.secondhand.common.PageQuery;
import com.campus.secondhand.common.PageResult;
import com.campus.secondhand.common.StatusCodes;
import java.math.BigDecimal;
import java.util.List;
import org.springframework.context.annotation.Profile;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import static com.campus.secondhand.market.MarketModels.*;
import static com.campus.secondhand.market.MarketRules.*;

@Service
@Profile("mysql")
public class GoodsService {
    private final MarketMapper db;
    public GoodsService(MarketMapper db) { this.db = db; }

    public GoodsDetail detail(String id, String viewer, boolean admin) {
        var item = found(db.goods(id));
        // 上架、已售出记录可由链接查看；待审核、下架、驳回仅所有者与管理员可见。
        allow(item.goodsStatus() == StatusCodes.GOODS_LISTED
                || item.goodsStatus() == StatusCodes.GOODS_SOLD
                || admin || item.publishUserId().equals(viewer));
        return toDetail(item, db.images(id));
    }

    public PageResult<Goods> list(PageQuery page, String keyword, String cateId,
            BigDecimal min, BigDecimal max, String owner, Integer status, boolean privateList, String sort) {
        require(keyword == null || keyword.length() <= 100, "搜索词过长");
        require(cateId == null || cateId.length() <= 32, "分类编号过长");
        require(min == null || min.signum() >= 0, "最低价格不能为负数");
        require(max == null || max.signum() >= 0, "最高价格不能为负数");
        require(min == null || max == null || min.compareTo(max) <= 0, "价格范围不正确");
        require(status == null || (status >= 0 && status <= 4), "商品状态不正确");
        require(sort == null || sort.isBlank() || List.of("latest", "priceAsc", "priceDesc").contains(sort),
                "排序方式不正确");
        // 公开列表固定只展示上架商品；我的商品/管理员列表可按状态筛选。
        var filter = new GoodsFilter(keyword, cateId, min, max, owner,
                privateList ? status : Integer.valueOf(StatusCodes.GOODS_LISTED),
                sort, page.getOffset(), page.getPageSize());
        return new PageResult<>(db.goodsList(filter), db.goodsCount(filter), page.getPage(), page.getPageSize());
    }

    @Transactional
    public GoodsDetail publish(String owner, GoodsInput body) {
        found(db.category(body.cateId()));
        validateImages(body);
        changed(db.insertGoods(owner, body));
        String goodsId = String.valueOf(db.lastInsertId());
        insertImages(goodsId, body.images());
        return detail(goodsId, owner, false);
    }

    @Transactional
    public GoodsDetail edit(String id, String owner, GoodsInput body) {
        var item = found(db.lockGoods(id));
        allow(item.publishUserId().equals(owner));
        editable(item);
        found(db.category(body.cateId()));
        validateImages(body);
        changed(db.updateGoods(id, body));
        saveImages(id, body.images());
        return detail(id, owner, false);
    }

    @Transactional
    public GoodsDetail editForReview(String id, GoodsInput body) {
        var item = found(db.lockGoods(id));
        state(item.goodsStatus() == StatusCodes.GOODS_PENDING, "管理员只能修改待审核商品");
        state(db.activeOrderIds(id).isEmpty(), "商品存在有效订单，不能修改");
        found(db.category(body.cateId()));
        validateImages(body);
        changed(db.updateGoods(id, body));
        saveImages(id, body.images());
        return detail(id, null, true);
    }

    @Transactional
    public void offShelf(String id, String owner, boolean admin) {
        var item = found(db.lockGoods(id));
        allow(admin || item.publishUserId().equals(owner));
        state(item.goodsStatus() == StatusCodes.GOODS_LISTED, "只有上架商品可以下架");
        changed(db.goodsStatus(id, StatusCodes.GOODS_LISTED, StatusCodes.GOODS_OFF_SHELF, null));
    }

    @Transactional
    public GoodsDetail review(String id, ReviewInput body) {
        var item = found(db.lockGoods(id));
        state(item.goodsStatus() == StatusCodes.GOODS_PENDING, "只有待审核商品可以审核");
        state(db.activeOrderIds(id).isEmpty(), "商品存在有效订单");
        boolean pass = "PASS".equals(body.decision());
        require(pass || (body.rejectReason() != null && !body.rejectReason().isBlank()), "驳回时必须填写原因");
        changed(db.goodsStatus(id, StatusCodes.GOODS_PENDING,
                pass ? StatusCodes.GOODS_LISTED : StatusCodes.GOODS_REJECTED,
                pass ? null : body.rejectReason()));
        return detail(id, null, true);
    }

    @Transactional
    public Category saveCategory(CategoryInput body, String id) {
        validateCategory(body, id);
        if (id == null) {
            changed(db.insertCategory(body));
            id = String.valueOf(db.lastInsertId());
        } else {
            found(db.category(id));
            changed(db.updateCategory(id, body));
        }
        return found(db.category(id));
    }

    @Transactional
    public void deleteCategory(String id) {
        found(db.category(id));
        state(db.categoryGoods(id) == 0, "分类仍有关联商品，不能删除");
        state(db.categoryChildren(id) == 0, "分类仍有子分类，不能删除");
        changed(db.deleteCategory(id));
    }

    private void editable(Goods item) {
        state(item.goodsStatus() != StatusCodes.GOODS_SOLD, "已售出商品不能修改");
        state(db.activeOrderIds(item.goodsId()).isEmpty(), "商品存在有效订单，不能修改或下架");
    }

    /** 编辑时图片整体替换：images=null 保留原图，空列表清空；新发布直接写入。 */
    private void saveImages(String goodsId, List<String> images) {
        if (images == null) { return; }
        changed(db.deleteImages(goodsId));
        insertImages(goodsId, images);
    }

    private void insertImages(String goodsId, List<String> images) {
        if (images == null || images.isEmpty()) { return; }
        if (db.insertImages(goodsId, images) != images.size()) {
            throw new BusinessException(HttpStatus.CONFLICT, "STATE_CONFLICT", "图片保存失败，请重试");
        }
    }

    private void validateImages(GoodsInput body) {
        require(body.images() == null || body.images().size() <= 4, "商品图片最多 4 张");
        if (body.images() != null) {
            for (String url : body.images()) {
                require(url != null && !url.isBlank() && url.length() <= 500, "图片地址不能为空且长度不超过 500");
            }
        }
    }

    /** 两级分类：parentId=0 为一级分类；二级分类的父分类必须存在且为一级。 */
    private void validateCategory(CategoryInput body, String selfId) {
        if (body.parentId() == 0) { return; }
        if (selfId != null && String.valueOf(body.parentId()).equals(selfId)) {
            throw new BusinessException(HttpStatus.CONFLICT, "STATE_CONFLICT", "父分类不能是分类自身");
        }
        var parent = found(db.category(String.valueOf(body.parentId())));
        state(parent.parentId() == null || parent.parentId() == 0, "分类最多两级，父分类必须是一级分类");
    }

    private GoodsDetail toDetail(Goods item, List<String> images) {
        return new GoodsDetail(item.goodsId(), item.publishUserId(), item.cateId(), item.title(),
                item.sellPrice(), item.originalPrice(), item.tradeType(), item.goodsDesc(),
                item.qualityLevel(), item.rejectReason(), item.publishTime(), item.goodsStatus(),
                item.sellerName(), item.cateName(), item.coverUrl(), images, item.purchasable());
    }
}
