package com.campus.secondhand.market;

import com.campus.secondhand.common.PageQuery;
import com.campus.secondhand.common.PageResult;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import static com.campus.secondhand.market.MarketModels.*;
import static com.campus.secondhand.market.MarketRules.*;

@Service
@Profile("mysql")
public class OrderService {
    private final MarketMapper db;
    public OrderService(MarketMapper db) { this.db = db; }

    @Transactional
    public Order create(String buyer, String goodsId) {
        var item = found(db.lockGoods(goodsId));
        allow(!item.publishUserId().equals(buyer));
        state(item.goodsStatus() == 1 && db.activeOrders(goodsId).isEmpty(), "商品当前不可购买");
        var order = new Order(id(), buyer, item.publishUserId(), goodsId, item.sellPrice(), 0, now());
        changed(db.insertOrder(order));
        return order;
    }

    public Order detail(String id, String user) {
        var order = found(db.order(id));
        allow(order.buyerId().equals(user) || order.sellerId().equals(user));
        return order;
    }

    public PageResult<Order> list(String user, String side, PageQuery page) {
        require("buy".equals(side) || "sell".equals(side), "side 必须是 buy 或 sell");
        return new PageResult<>(db.orders(user, side, page.getOffset(), page.getPageSize()),
                db.orderCount(user, side), page.getPage(), page.getPageSize());
    }

    @Transactional
    public Order action(String id, String user, String action) {
        var snapshot = detail(id, user);
        var item = found(db.lockGoods(snapshot.goodsId()));
        var order = found(db.lockOrder(id));
        int from;
        int to;
        switch (action) {
            case "mock-pay" -> { allow(order.buyerId().equals(user)); from = 0; to = 1; }
            case "deliver" -> { allow(order.sellerId().equals(user)); from = 1; to = 2; }
            case "complete" -> { allow(order.buyerId().equals(user)); from = 2; to = 3; }
            case "cancel" -> { allow(order.buyerId().equals(user)); from = 0; to = 4; }
            default -> throw new IllegalArgumentException("未知订单动作");
        }
        state(order.orderStatus() == from, "订单当前状态不允许此操作");
        state(item.goodsStatus() == 1, "商品状态与订单不一致");
        changed(db.orderStatus(id, from, to));
        // 商品已售出状态由 trg_order_complete_update_goods 在同一事务内更新。
        return new Order(order.orderId(), order.buyerId(), order.sellerId(), order.goodsId(),
                order.orderPrice(), to, order.createTime());
    }

    @Transactional
    public Evaluation evaluate(String id, String user, EvaluationInput input) {
        var snapshot = detail(id, user);
        found(db.lockGoods(snapshot.goodsId()));
        var order = found(db.lockOrder(id));
        allow(order.buyerId().equals(user));
        state(order.orderStatus() == 3, "订单完成后才能评价");
        state(db.evaluationIds(id).isEmpty(), "该订单已经评价");
        var evaluation = new Evaluation(null, id, order.goodsId(), user, input.score(), input.content(), now());
        var key = new com.campus.secondhand.common.GeneratedId();
        changed(db.insertEvaluation(evaluation, key));
        return new Evaluation(key.getId(), id, order.goodsId(), user, input.score(), input.content(), evaluation.evaluateTime());
    }

    public PageResult<Evaluation> evaluations(String goodsId, PageQuery page) {
        var item = found(db.goods(goodsId));
        allow(item.goodsStatus() == 1 || item.goodsStatus() == 3);
        return new PageResult<>(db.evaluations(goodsId, page.getOffset(), page.getPageSize()),
                db.evaluationCount(goodsId), page.getPage(), page.getPageSize());
    }

    public PageResult<Evaluation> userEvaluations(String userId, PageQuery page) {
        return new PageResult<>(db.userEvaluations(userId, page.getOffset(), page.getPageSize()),
                db.userEvaluationCount(userId), page.getPage(), page.getPageSize());
    }
}
