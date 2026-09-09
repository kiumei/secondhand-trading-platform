package com.campus.secondhand;

import com.campus.secondhand.common.StatusCodes;
import com.campus.secondhand.market.*;
import com.campus.secondhand.common.BusinessException;
import com.campus.secondhand.common.PageQuery;
import com.campus.secondhand.user.UserMapper;
import com.campus.secondhand.user.UserRow;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import static com.campus.secondhand.market.MarketModels.*;
import static org.assertj.core.api.Assertions.*;
import static org.mockito.Mockito.*;

/**
 * 业务规则测试；并发互斥、外键和真实回滚仍需 MySQL 验收。
 * 商品状态：0待审核 1上架 2下架 3已售出 4驳回；订单状态：0待付款 1待发货 2待收货 3完成 4取消 5售后。
 */
class MarketServiceTest {
    MarketMapper db;
    UserMapper users;
    GoodsService goods;
    OrderService orders;
    CommunicationService communication;
    FavoriteService favorites;
    static final LocalDateTime TIME = LocalDateTime.of(2026, 9, 7, 9, 0);

    static Goods item(int status) {
        return new Goods("g", "seller", "c", "教材", new BigDecimal("12.34"), null,
                2, "描述", 4, null, TIME, status, "卖家", "教材", "http://img/1", status == StatusCodes.GOODS_LISTED);
    }
    static Order order(int status) {
        return new Order("o", "buyer", "seller", "g", new BigDecimal("12.34"), 0, status, null, null, TIME);
    }
    static GoodsInput input() { return new GoodsInput("c", "新标题", new BigDecimal("19.99"), null, 2, "描述", 4, null); }
    static com.campus.secondhand.category.CategoryMapper.Category category() {
        return new com.campus.secondhand.category.CategoryMapper.Category("c", "教材", 0, 1);
    }

    @BeforeEach void setup() {
        db = mock(MarketMapper.class); users = mock(UserMapper.class);
        goods = new GoodsService(db); orders = new OrderService(db);
        communication = new CommunicationService(db, users); favorites = new FavoriteService(db);
        when(db.lockGoods("g")).thenReturn(item(StatusCodes.GOODS_LISTED));
        when(db.goods("g")).thenReturn(item(StatusCodes.GOODS_LISTED));
        when(db.activeOrderIds("g")).thenReturn(List.of());
        when(db.order("o")).thenReturn(order(0)); when(db.lockOrder("o")).thenReturn(order(0));
    }

    @Test void publicListingForcesListedStatus() {
        goods.list(new PageQuery(), "教材", null, null, null, null, StatusCodes.GOODS_PENDING, false, null);
        var filter = ArgumentCaptor.forClass(GoodsFilter.class);
        verify(db).goodsList(filter.capture());
        assertThat(filter.getValue().status()).isEqualTo(StatusCodes.GOODS_LISTED);
        verify(db).goodsCount(filter.getValue());
    }
    @Test void publicListingRejectsUnknownSort() {
        assertThatThrownBy(() -> goods.list(new PageQuery(), null, null, null, null, null, null, false, "wantCount"))
                .isInstanceOf(BusinessException.class);
        verify(db, never()).goodsList(any());
    }
    @Test void hiddenGoodsOnlyVisibleToOwnerOrAdmin() {
        when(db.goods("g")).thenReturn(item(StatusCodes.GOODS_PENDING));
        when(db.images("g")).thenReturn(List.of("http://img/1"));
        assertThatThrownBy(() -> goods.detail("g", null, false)).isInstanceOf(BusinessException.class);
        assertThat(goods.detail("g", "seller", false).goodsStatus()).isEqualTo(StatusCodes.GOODS_PENDING);
        assertThat(goods.detail("g", "admin", true).goodsStatus()).isEqualTo(StatusCodes.GOODS_PENDING);
        assertThat(goods.detail("g", "admin", true).images()).containsExactly("http://img/1");
        // 上架、已售出对公众可见。
        when(db.goods("g")).thenReturn(item(StatusCodes.GOODS_SOLD));
        assertThat(goods.detail("g", null, false).goodsStatus()).isEqualTo(StatusCodes.GOODS_SOLD);
    }
    @Test void invalidPriceRangeIsRejectedBeforeQuery() {
        assertThatThrownBy(() -> goods.list(new PageQuery(), null, null, BigDecimal.TEN, BigDecimal.ONE, null, null, false, null))
                .isInstanceOf(BusinessException.class);
        verify(db, never()).goodsList(any());
    }
    @Test void ownershipAndActiveOrdersPreventEditing() {
        assertThatThrownBy(() -> goods.edit("g", "stranger", input())).isInstanceOf(BusinessException.class);
        when(db.activeOrderIds("g")).thenReturn(List.of("o"));
        assertThatThrownBy(() -> goods.edit("g", "seller", input())).isInstanceOf(BusinessException.class);
        assertThatThrownBy(() -> goods.offShelf("g", "seller", false)).isInstanceOf(BusinessException.class);
        verify(db, never()).updateGoods(any(), any());
    }
    @Test void moreThanFourImagesAreRejected() {
        var tooMany = new GoodsInput("c", "标题", new BigDecimal("9.99"), null, 2, "描述", 4,
                List.of("1", "2", "3", "4", "5"));
        assertThatThrownBy(() -> goods.publish("seller", tooMany)).isInstanceOf(BusinessException.class);
        verify(db, never()).insertGoods(any(), any());
    }
    @Test void publishCreatesPendingGoodsWithImages() {
        when(db.category("c")).thenReturn(category());
        when(db.insertGoods(any(), any())).thenReturn(1);
        when(db.insertImages(eq("7"), any())).thenReturn(2);
        when(db.lastInsertId()).thenReturn(7L);
        when(db.goods("7")).thenReturn(new Goods("7", "seller", "c", "教材", new BigDecimal("12.34"),
                null, 2, "描述", 4, null, TIME, StatusCodes.GOODS_PENDING, "卖家", "教材", null, false));
        when(db.images("7")).thenReturn(List.of("http://a", "http://b"));
        var body = new GoodsInput("c", "标题", new BigDecimal("9.99"), null, 2, "描述", 4,
                List.of("http://a", "http://b"));
        var created = goods.publish("seller", body);
        assertThat(created.goodsStatus()).isEqualTo(StatusCodes.GOODS_PENDING);
        assertThat(created.goodsId()).isEqualTo("7");
        assertThat(created.images()).containsExactly("http://a", "http://b");
        verify(db).insertImages("7", body.images());
    }
    @Test void reviewTransitionsPendingToListedOrRejected() {
        when(db.lockGoods("g")).thenReturn(item(StatusCodes.GOODS_PENDING));
        assertThatThrownBy(() -> goods.review("g", new ReviewInput("REJECT", " "))).isInstanceOf(BusinessException.class);
        when(db.goodsStatus("g", 0, 4, "信息不足")).thenReturn(1);
        goods.review("g", new ReviewInput("REJECT", "信息不足"));
        verify(db).goodsStatus("g", 0, 4, "信息不足");
        when(db.goodsStatus("g", 0, 1, null)).thenReturn(1);
        goods.review("g", new ReviewInput("PASS", null));
        verify(db).goodsStatus("g", 0, 1, null);
        // 已上架商品不能重复审核。
        when(db.lockGoods("g")).thenReturn(item(StatusCodes.GOODS_LISTED));
        assertThatThrownBy(() -> goods.review("g", new ReviewInput("PASS", null))).isInstanceOf(BusinessException.class);
    }
    @Test void offShelfOnlyAllowedFromListed() {
        when(db.lockGoods("g")).thenReturn(item(StatusCodes.GOODS_PENDING));
        assertThatThrownBy(() -> goods.offShelf("g", "seller", false)).isInstanceOf(BusinessException.class);
        when(db.lockGoods("g")).thenReturn(item(StatusCodes.GOODS_LISTED));
        when(db.goodsStatus("g", 1, 2, null)).thenReturn(1);
        goods.offShelf("g", "seller", false);
        verify(db).goodsStatus("g", 1, 2, null);
    }
    @Test void adminCanOnlyEditPendingGoodsBeforeReview() {
        when(db.lockGoods("g")).thenReturn(item(StatusCodes.GOODS_PENDING));
        when(db.category("c")).thenReturn(category());
        when(db.updateGoods("g", input())).thenReturn(1);
        when(db.goods("g")).thenReturn(item(StatusCodes.GOODS_PENDING));
        goods.editForReview("g", input());
        verify(db).updateGoods("g", input());
        when(db.lockGoods("g")).thenReturn(item(StatusCodes.GOODS_LISTED));
        assertThatThrownBy(() -> goods.editForReview("g", input())).isInstanceOf(BusinessException.class);
    }
    @Test void referencedCategoryOrChildrenCannotBeDeleted() {
        when(db.category("c")).thenReturn(category());
        when(db.categoryGoods("c")).thenReturn(1L);
        assertThatThrownBy(() -> goods.deleteCategory("c")).isInstanceOf(BusinessException.class);
        when(db.categoryGoods("c")).thenReturn(0L);
        when(db.categoryChildren("c")).thenReturn(2L);
        assertThatThrownBy(() -> goods.deleteCategory("c")).isInstanceOf(BusinessException.class);
        verify(db, never()).deleteCategory(any());
    }
    @Test void childCategoryMustHaveTopLevelParent() {
        when(db.insertCategory(any())).thenReturn(1);
        when(db.lastInsertId()).thenReturn(9L);
        when(db.category("9")).thenReturn(new com.campus.secondhand.category.CategoryMapper.Category("9", "子类", 1, 2));
        // 父分类不存在。
        assertThatThrownBy(() -> goods.saveCategory(new CategoryInput("子类", 99, 2), null))
                .isInstanceOf(BusinessException.class);
        // 父分类不是一级分类（最多两级）。
        when(db.category("99")).thenReturn(new com.campus.secondhand.category.CategoryMapper.Category("99", "子类", 1, 2));
        assertThatThrownBy(() -> goods.saveCategory(new CategoryInput("子类", 99, 2), null))
                .isInstanceOf(BusinessException.class);
        when(db.category("1")).thenReturn(new com.campus.secondhand.category.CategoryMapper.Category("1", "一级", 0, 1));
        assertThat(goods.saveCategory(new CategoryInput("子类", 1, 2), null).cateId()).isEqualTo("9");
    }
    @Test void orderUsesDatabasePriceAndLocksBeforeCheckingAvailability() {
        when(db.insertOrder(any())).thenReturn(1);
        var created = orders.create("buyer", "g");
        assertThat(created.orderPrice()).isEqualByComparingTo("12.34");
        assertThat(created.sellerId()).isEqualTo("seller");
        assertThat(created.orderStatus()).isZero();
        assertThat(created.payStatus()).isZero();
        var sequence = inOrder(db);
        sequence.verify(db).lockGoods("g"); sequence.verify(db).activeOrderIds("g"); sequence.verify(db).insertOrder(any());
    }
    @Test void selfPurchasePendingOrReservedGoodsAreRejected() {
        assertThatThrownBy(() -> orders.create("seller", "g")).isInstanceOf(BusinessException.class);
        when(db.activeOrderIds("g")).thenReturn(List.of("o"));
        assertThatThrownBy(() -> orders.create("another-buyer", "g")).isInstanceOf(BusinessException.class);
        when(db.activeOrderIds("g")).thenReturn(List.of());
        when(db.lockGoods("g")).thenReturn(item(StatusCodes.GOODS_PENDING));
        assertThatThrownBy(() -> orders.create("another-buyer", "g")).isInstanceOf(BusinessException.class);
        verify(db, never()).insertOrder(any());
    }
    @Test void onlyParticipantsCanReadOrders() {
        assertThatThrownBy(() -> orders.detail("o", "stranger")).isInstanceOf(BusinessException.class);
        assertThat(orders.detail("o", "buyer").orderId()).isEqualTo("o");
        assertThat(orders.detail("o", "seller").orderId()).isEqualTo("o");
    }
    @Test void completionLeavesGoodsUpdateToDatabaseTrigger() {
        when(db.order("o")).thenReturn(order(2)); when(db.lockOrder("o")).thenReturn(order(2));
        when(db.orderStatus(eq("o"), eq(2), eq(3), any())).thenReturn(1);
        var finished = orders.action("o", "buyer", "complete");
        assertThat(finished.orderStatus()).isEqualTo(3);
        assertThat(finished.finishTime()).isNotNull();
        var sequence = inOrder(db);
        sequence.verify(db).order("o"); sequence.verify(db).lockGoods("g"); sequence.verify(db).lockOrder("o");
        sequence.verify(db).orderStatus(eq("o"), eq(2), eq(3), any());
        verify(db, never()).goodsStatus(any(), anyInt(), anyInt(), any());
    }
    @Test void paymentSetsPayStatusPayTimeAndTime() {
        when(db.orderPay(any(), anyInt(), any())).thenReturn(1);
        var paid = orders.action("o", "buyer", "mock-pay");
        assertThat(paid.orderStatus()).isEqualTo(1);
        assertThat(paid.payStatus()).isEqualTo(1);
        assertThat(paid.payTime()).isNotNull();
        verify(db).orderPay(eq("o"), eq(0), any());
    }
    @Test void deliveryAndCancellationEnforceActorAndOldState() {
        assertThatThrownBy(() -> orders.action("o", "buyer", "deliver")).isInstanceOf(BusinessException.class);
        when(db.order("o")).thenReturn(order(1)); when(db.lockOrder("o")).thenReturn(order(1));
        when(db.orderStatus("o", 1, 2, null)).thenReturn(1);
        assertThat(orders.action("o", "seller", "deliver").orderStatus()).isEqualTo(2);
        // 已支付订单不能取消，只有待付款可以取消。
        assertThatThrownBy(() -> orders.action("o", "buyer", "cancel")).isInstanceOf(BusinessException.class);
        when(db.order("o")).thenReturn(order(0)); when(db.lockOrder("o")).thenReturn(order(0));
        when(db.orderStatus("o", 0, 4, null)).thenReturn(1);
        assertThat(orders.action("o", "buyer", "cancel").orderStatus()).isEqualTo(4);
        verify(db, never()).goodsStatus(any(), anyInt(), anyInt(), any());
    }
    @Test void repeatedPaymentFailsAfterCancellation() {
        when(db.lockOrder("o")).thenReturn(order(4));
        assertThatThrownBy(() -> orders.action("o", "buyer", "mock-pay")).isInstanceOf(BusinessException.class);
        verify(db, never()).orderPay(any(), anyInt(), any());
    }
    @Test void evaluationRequiresCompletedRealOrderOnce() {
        assertThatThrownBy(() -> orders.evaluate("o", "buyer", new EvaluationInput(5, "很好"))).isInstanceOf(BusinessException.class);
        when(db.order("o")).thenReturn(order(3)); when(db.lockOrder("o")).thenReturn(order(3));
        when(db.evaluationOfOrder("o")).thenReturn(List.of()); when(db.insertEvaluation(any(), anyInt(), any(), any())).thenReturn(1);
        when(db.evaluation("9")).thenReturn(new Evaluation("9", "o", "g", "buyer", 5, "很好", TIME));
        when(db.lastInsertId()).thenReturn(9L);
        var result = orders.evaluate("o", "buyer", new EvaluationInput(5, "很好"));
        assertThat(result.evaluateId()).isEqualTo("9");
        assertThat(result.goodsId()).isEqualTo("g");
        assertThat(result.evaluateUserId()).isEqualTo("buyer");
        verify(db).insertEvaluation(eq("o"), eq(5), eq("很好"), any());
        when(db.evaluationOfOrder("o")).thenReturn(List.of("9"));
        assertThatThrownBy(() -> orders.evaluate("o", "buyer", new EvaluationInput(5, "重复"))).isInstanceOf(BusinessException.class);
        assertThatThrownBy(() -> orders.evaluate("o", "seller", new EvaluationInput(5, "越权"))).isInstanceOf(BusinessException.class);
    }
    @Test void evaluationListsAreScopedByOrderRole() {
        orders.userEvaluations("buyer", new PageQuery());
        verify(db).userEvaluations("buyer", 0, 10);
        verify(db).userEvaluationCount("buyer");
        orders.sellerEvaluations("seller", new PageQuery());
        verify(db).sellerEvaluations("seller", 0, 10);
        verify(db).sellerEvaluationCount("seller");
    }
    @Test void adminEvaluationDeleteRequiresExistingRow() {
        when(db.evaluation("9")).thenReturn(new Evaluation("9", "o", "g", "buyer", 5, "很好", TIME));
        when(db.deleteEvaluation("9")).thenReturn(1);
        orders.deleteEvaluation("9");
        verify(db).deleteEvaluation("9");
        assertThatThrownBy(() -> orders.deleteEvaluation("missing")).isInstanceOf(BusinessException.class);
    }
    @Test void onlyMessageRecipientCanMarkRead() {
        when(db.message("m")).thenReturn(new Message("m", "sender", "receiver", "你好", 0, TIME));
        assertThatThrownBy(() -> communication.read("m", "sender")).isInstanceOf(BusinessException.class);
        communication.read("m", "receiver"); verify(db).readMessage("m", "receiver");
    }
    @Test void messageQueryAlwaysScopesBothParticipants() {
        when(users.findById("peer")).thenReturn(new UserRow("peer", "同学", "", "", null, null, 0, 0, TIME));
        communication.messages("me", "peer", new PageQuery());
        verify(db).messages("me", "peer", 0, 10); verify(db).messageCount("me", "peer");
    }
    @Test void favoritesRequireVisibleGoodsAndStayUnique() {
        when(db.insertFavorite("buyer", "g")).thenReturn(1);
        favorites.add("buyer", "g");
        verify(db).insertFavorite("buyer", "g");
        when(db.favoriteExists("buyer", "g")).thenReturn(true);
        assertThatThrownBy(() -> favorites.add("buyer", "g")).isInstanceOf(BusinessException.class);
        assertThat(favorites.exists("buyer", "g")).isTrue();
        // 已售出商品仍可收藏；待审核不可收藏。
        when(db.favoriteExists("buyer", "g")).thenReturn(false);
        when(db.goods("g")).thenReturn(item(StatusCodes.GOODS_PENDING));
        assertThatThrownBy(() -> favorites.add("buyer", "g")).isInstanceOf(BusinessException.class);
        when(db.goods("g")).thenReturn(item(StatusCodes.GOODS_SOLD));
        favorites.add("buyer", "g");
        // 删除不存在的收藏返回 404。
        when(db.deleteFavorite("buyer", "g")).thenReturn(0);
        assertThatThrownBy(() -> favorites.remove("buyer", "g")).isInstanceOf(BusinessException.class);
    }
    @Test void reportRecordsReporterTypeAndNeverTouchesGoods() {
        when(db.insertReport(any())).thenReturn(1);
        when(db.lastInsertId()).thenReturn(21L);
        var report = communication.report("buyer", new ReportInput("g", 3, "原因", null));
        assertThat(report.reportId()).isEqualTo("21");
        assertThat(report.reportUserId()).isEqualTo("buyer");
        assertThat(report.handleStatus()).isZero();
        assertThat(report.reportType()).isEqualTo(3);
        assertThat(report.reportTime()).isNotNull();
        assertThat(report.goodsId()).isEqualTo("g");
        verify(db).goods("g");
        when(db.report("21")).thenReturn(report); when(db.handleReport("21", "已处理")).thenReturn(1);
        communication.handle("21", "已处理");
        verify(db).handleReport("21", "已处理");
        when(db.report("21")).thenReturn(new Report("21", "buyer", "g", 3, "原因", null, 1, "已处理", report.reportTime()));
        var handled = communication.handle("21", "已处理");
        assertThat(handled.handleStatus()).isEqualTo(1);
        verify(db, never()).goodsStatus(any(), anyInt(), anyInt(), any());
    }
}
