package com.campus.secondhand.market;

import com.campus.secondhand.common.PageQuery;
import com.campus.secondhand.common.PageResult;
import com.campus.secondhand.common.StatusCodes;
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
    public Order create(String buyer, String goodsId) { return create(buyer, goodsId, null); }

    @Transactional
    public Order create(String buyer, String goodsId, String shippingAddress) {
        require(shippingAddress == null || shippingAddress.length() <= 255, "收货地址不能超过255字符");
        String address = shippingAddress == null || shippingAddress.isBlank() ? null : shippingAddress.strip();
        var item = found(db.lockGoods(goodsId));
        allow(!item.publishUserId().equals(buyer));
        // 仅上架商品可下单；有效订单（0/1/2/3/5）存在即视为已被占用。
        state(item.goodsStatus() == StatusCodes.GOODS_LISTED && db.activeOrderIds(goodsId).isEmpty(),
                "商品当前不可购买");
        var order = new Order(id(), buyer, item.publishUserId(), goodsId, item.sellPrice(),
                0, StatusCodes.ORDER_UNPAID, null, null, now(), address);
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

    /** 管理员订单管理（B4）：可按状态筛选并查看任意订单。 */
    public PageResult<Order> adminList(Integer status, PageQuery page) {
        require(status == null || (status >= 0 && status <= 5), "订单状态不正确");
        return new PageResult<>(db.adminOrders(status, page.getOffset(), page.getPageSize()),
                db.adminOrderCount(status), page.getPage(), page.getPageSize());
    }

    public Order adminDetail(String id) {
        return found(db.order(id));
    }

    @Transactional
    public Order action(String id, String user, String action) {
        var snapshot = detail(id, user);
        var item = found(db.lockGoods(snapshot.goodsId()));
        var order = found(db.lockOrder(id));
        int from;
        int to;
        boolean paid = false;
        var payTime = (java.time.LocalDateTime) null;
        var finishTime = (java.time.LocalDateTime) null;
        switch (action) {
            case "mock-pay" -> {
                allow(order.buyerId().equals(user));
                from = StatusCodes.ORDER_UNPAID;
                to = StatusCodes.ORDER_UNSHIPPED;
                paid = true;
                payTime = now();
            }
            case "deliver" -> {
                allow(order.sellerId().equals(user));
                from = StatusCodes.ORDER_UNSHIPPED;
                to = StatusCodes.ORDER_UNRECEIVED;
            }
            case "complete" -> {
                allow(order.buyerId().equals(user));
                from = StatusCodes.ORDER_UNRECEIVED;
                to = StatusCodes.ORDER_FINISHED;
                finishTime = now();
            }
            case "cancel" -> {
                allow(order.buyerId().equals(user));
                from = StatusCodes.ORDER_UNPAID;
                to = StatusCodes.ORDER_CANCELLED;
            }
            default -> throw new IllegalArgumentException("未知订单动作");
        }
        state(order.orderStatus() == from, "订单当前状态不允许此操作");
        state(to == StatusCodes.ORDER_CANCELLED || item.goodsStatus() == StatusCodes.GOODS_LISTED, "商品状态与订单不一致");
        changed(paid ? db.orderPay(id, from, payTime) : db.orderStatus(id, from, to, finishTime));
        // 商品已售出状态由数据库触发器在同一事务内更新。
        return new Order(order.orderId(), order.buyerId(), order.sellerId(), order.goodsId(),
                order.orderPrice(), paid ? 1 : order.payStatus(), to,
                paid ? payTime : order.payTime(), finishTime != null ? finishTime : order.finishTime(),
                order.createTime(), order.shippingAddress());
    }

    /** 评价必须绑定真实已完成订单（D2）：订单号来自路径，商品与评价人由订单推导，禁止传 0。 */
    @Transactional
    public Evaluation evaluate(String id, String user, EvaluationInput input) {
        var snapshot = detail(id, user);
        found(db.lockGoods(snapshot.goodsId()));
        var order = found(db.lockOrder(id));
        allow(order.buyerId().equals(user));
        state(order.orderStatus() == StatusCodes.ORDER_FINISHED, "订单完成后才能评价");
        state(db.evaluationOfOrder(id).isEmpty(), "该订单已经评价");
        changed(db.insertEvaluation(id, input.score(), input.content(), now()));
        var saved = found(db.evaluation(String.valueOf(db.lastInsertId())));
        return saved;
    }

    public PageResult<Evaluation> evaluations(String goodsId, PageQuery page) {
        var item = found(db.goods(goodsId));
        allow(item.goodsStatus() == StatusCodes.GOODS_LISTED || item.goodsStatus() == StatusCodes.GOODS_SOLD);
        return new PageResult<>(db.evaluations(goodsId, page.getOffset(), page.getPageSize()),
                db.evaluationCount(goodsId), page.getPage(), page.getPageSize());
    }

    /** 我提交的评价：评价人是订单买家。 */
    public PageResult<Evaluation> userEvaluations(String userId, PageQuery page) {
        return new PageResult<>(db.userEvaluations(userId, page.getOffset(), page.getPageSize()),
                db.userEvaluationCount(userId), page.getPage(), page.getPageSize());
    }

    /** 用户收到的评价（个人主页展示）：评价对象是订单卖家。 */
    public PageResult<Evaluation> sellerEvaluations(String sellerId, PageQuery page) {
        return new PageResult<>(db.sellerEvaluations(sellerId, page.getOffset(), page.getPageSize()),
                db.sellerEvaluationCount(sellerId), page.getPage(), page.getPageSize());
    }

    /** 管理员评价管理（B3）。 */
    public PageResult<Evaluation> adminEvaluations(PageQuery page) {
        return new PageResult<>(db.allEvaluations(page.getOffset(), page.getPageSize()),
                db.allEvaluationCount(), page.getPage(), page.getPageSize());
    }

    @Transactional
    public void deleteEvaluation(String id) {
        found(db.evaluation(id));
        changed(db.deleteEvaluation(id));
    }
}
