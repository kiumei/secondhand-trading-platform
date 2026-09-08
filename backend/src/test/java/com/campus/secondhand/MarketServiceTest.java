package com.campus.secondhand;

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

/** 业务规则测试；并发互斥、外键和真实回滚仍需 MySQL 验收。 */
class MarketServiceTest {
    MarketMapper db;
    UserMapper users;
    GoodsService goods;
    OrderService orders;
    CommunicationService communication;
    static final LocalDateTime TIME = LocalDateTime.of(2026, 9, 7, 9, 0);

    static Goods item(int status) {
        return new Goods("g", "seller", "c", "教材", new BigDecimal("12.34"), null,
                2, "描述", 4, null, TIME, status, "卖家", "教材", status == 1);
    }
    static Order order(int status) { return new Order("o", "buyer", "seller", "g", new BigDecimal("12.34"), status, TIME); }
    static GoodsInput input() { return new GoodsInput("c", "新标题", new BigDecimal("19.99"), null, 2, "描述", 4); }

    @BeforeEach void setup() {
        db = mock(MarketMapper.class); users = mock(UserMapper.class);
        goods = new GoodsService(db); orders = new OrderService(db); communication = new CommunicationService(db, users);
        when(db.lockGoods("g")).thenReturn(item(1));
        when(db.goods("g")).thenReturn(item(1));
        when(db.activeOrders("g")).thenReturn(List.of());
        when(db.order("o")).thenReturn(order(0)); when(db.lockOrder("o")).thenReturn(order(0));
    }

    @Test void publicListingCannotRequestPrivateStatuses() {
        goods.list(new PageQuery(), "教材", null, null, null, null, 3, false);
        var filter = ArgumentCaptor.forClass(GoodsFilter.class);
        verify(db).goodsList(filter.capture());
        assertThat(filter.getValue().status()).isEqualTo(1);
        verify(db).goodsCount(filter.getValue());
    }
    @Test void hiddenGoodsOnlyVisibleToOwnerOrAdmin() {
        when(db.goods("g")).thenReturn(item(0));
        assertThatThrownBy(() -> goods.detail("g", null, false)).isInstanceOf(BusinessException.class);
        assertThat(goods.detail("g", "seller", false).goodsStatus()).isEqualTo(0);
        assertThat(goods.detail("g", "admin", true).goodsStatus()).isEqualTo(0);
    }
    @Test void invalidPriceRangeIsRejectedBeforeQuery() {
        assertThatThrownBy(() -> goods.list(new PageQuery(), null, null, BigDecimal.TEN, BigDecimal.ONE, null, 0, false))
                .isInstanceOf(BusinessException.class);
        verify(db, never()).goodsList(any());
    }
    @Test void ownershipAndActiveOrdersPreventEditing() {
        assertThatThrownBy(() -> goods.edit("g", "stranger", input())).isInstanceOf(BusinessException.class);
        when(db.activeOrders("g")).thenReturn(List.of(order(0)));
        assertThatThrownBy(() -> goods.edit("g", "seller", input())).isInstanceOf(BusinessException.class);
        assertThatThrownBy(() -> goods.offShelf("g", "seller", false)).isInstanceOf(BusinessException.class);
        verify(db, never()).updateGoods(any(), any());
    }
    @Test void reviewRequiresPendingStateAndRejectionReason() {
        when(db.lockGoods("g")).thenReturn(item(0));
        assertThatThrownBy(() -> goods.review("g", new ReviewInput("REJECT", " "))).isInstanceOf(BusinessException.class);
        when(db.goodsStatus("g", 0, 4, "信息不足")).thenReturn(1);
        goods.review("g", new ReviewInput("REJECT", "信息不足"));
        verify(db).goodsStatus("g", 0, 4, "信息不足");
        when(db.lockGoods("g")).thenReturn(item(1));
        assertThatThrownBy(() -> goods.review("g", new ReviewInput("PASS", null))).isInstanceOf(BusinessException.class);
    }
    @Test void adminCanOnlyEditPendingGoodsBeforeReview() {
        when(db.lockGoods("g")).thenReturn(item(0));
        when(db.category("c")).thenReturn(new com.campus.secondhand.category.CategoryMapper.Category("c", "教材", null));
        when(db.updateGoods("g", input())).thenReturn(1);
        when(db.goods("g")).thenReturn(item(0));
        goods.editForReview("g", input());
        verify(db).updateGoods("g", input());
        when(db.lockGoods("g")).thenReturn(item(1));
        assertThatThrownBy(() -> goods.editForReview("g", input())).isInstanceOf(BusinessException.class);
    }
    @Test void referencedCategoryCannotBeDeleted() {
        when(db.category("c")).thenReturn(new com.campus.secondhand.category.CategoryMapper.Category("c", "教材", null));
        when(db.categoryGoods("c")).thenReturn(1L);
        assertThatThrownBy(() -> goods.deleteCategory("c")).isInstanceOf(BusinessException.class);
        verify(db, never()).deleteCategory(any());
    }
    @Test void categoryHierarchyRejectsCyclesMissingParentsAndDeletingParents() {
        var root = new com.campus.secondhand.category.CategoryMapper.Category("1", "父类", null, "0", 1);
        var child = new com.campus.secondhand.category.CategoryMapper.Category("2", "子类", null, "1", 2);
        when(db.lockCategories()).thenReturn(List.of(root, child));
        when(db.category("1")).thenReturn(root);
        assertThatThrownBy(() -> goods.saveCategory("1", new CategoryInput("父类", null, "2", 0)))
                .isInstanceOf(BusinessException.class).hasMessageContaining("自身或子分类");
        assertThatThrownBy(() -> goods.saveCategory(null, new CategoryInput("新类", null, "99", 0)))
                .isInstanceOf(BusinessException.class).hasMessageContaining("父分类不存在");
        assertThatThrownBy(() -> goods.deleteCategory("1"))
                .isInstanceOf(BusinessException.class).hasMessageContaining("子分类");
        verify(db, never()).updateCategory(any(), any());
        verify(db, never()).deleteCategory(any());
    }
    @Test void categoryEditPreservesOmittedParentAndSort() {
        var parent = new com.campus.secondhand.category.CategoryMapper.Category("1", "父类", null, "0", 1);
        var child = new com.campus.secondhand.category.CategoryMapper.Category("2", "子类", null, "1", 7);
        when(db.lockCategories()).thenReturn(List.of(parent, child));
        when(db.category("2")).thenReturn(child);
        when(db.updateCategory(eq("2"), any())).thenReturn(1);
        goods.saveCategory("2", new CategoryInput("改名", null));
        verify(db).updateCategory("2", new CategoryInput("改名", null, "1", 7));
    }
    @Test void editingImagesPersistsOrderAndEmptyArrayClearsButOmissionPreserves() {
        when(db.category("c")).thenReturn(new com.campus.secondhand.category.CategoryMapper.Category("c", "类别", null));
        when(db.updateGoods(eq("g"), any())).thenReturn(1);
        when(db.insertGoodsImage(any(), any(), anyInt())).thenReturn(1);
        goods.edit("g", "seller", input());
        verify(db, never()).deleteGoodsImages(any());
        var first = "https://example.com/a.jpg";
        var second = "https://example.com/b.png";
        goods.edit("g", "seller", new GoodsInput("c", "教材", BigDecimal.TEN, null, 2, "描述", 4, List.of(first, second)));
        var writes = inOrder(db);
        writes.verify(db).deleteGoodsImages("g");
        writes.verify(db).insertGoodsImage("g", first, 1);
        writes.verify(db).insertGoodsImage("g", second, 2);
        goods.edit("g", "seller", new GoodsInput("c", "教材", BigDecimal.TEN, null, 2, "描述", 4, List.of()));
        verify(db, times(2)).deleteGoodsImages("g");
    }
    @Test void malformedImageUrlsDoNotReachDatabaseWrites() {
        var body = new GoodsInput("c", "教材", BigDecimal.TEN, null, 2, "描述", 4, List.of("javascript:alert(1)"));
        assertThatThrownBy(() -> goods.publish("seller", body)).isInstanceOf(BusinessException.class);
        verify(db, never()).insertGoods(any(), any(), any());
        verify(db, never()).deleteGoodsImages(any());
    }
    @Test void cannotCreateThirdCategoryLevelOrPublishFiveImages() {
        var root = new com.campus.secondhand.category.CategoryMapper.Category("1", "父类", null, "0", 0);
        var child = new com.campus.secondhand.category.CategoryMapper.Category("2", "子类", null, "1", 0);
        when(db.lockCategories()).thenReturn(List.of(root, child));
        assertThatThrownBy(() -> goods.saveCategory(null, new CategoryInput("第三层", null, "2", 0)))
                .isInstanceOf(BusinessException.class).hasMessageContaining("两级");
        var images = java.util.Collections.nCopies(5, "https://example.com/image.png");
        assertThatThrownBy(() -> goods.publish("seller", new GoodsInput("c", "教材", BigDecimal.TEN, null, 2, "描述", 4, images)))
                .isInstanceOf(BusinessException.class).hasMessageContaining("4 张");
        verify(db, never()).insertGoods(any(), any(), any());
    }
    @Test void orderUsesDatabasePriceAndLocksBeforeCheckingAvailability() {
        when(db.insertOrder(any())).thenReturn(1);
        var created = orders.create("buyer", "g");
        assertThat(created.orderPrice()).isEqualByComparingTo("12.34");
        assertThat(created.sellerId()).isEqualTo("seller");
        assertThat(created.orderStatus()).isZero();
        var sequence = inOrder(db);
        sequence.verify(db).lockGoods("g"); sequence.verify(db).activeOrders("g"); sequence.verify(db).insertOrder(any());
    }
    @Test void selfPurchaseAndAlreadyReservedGoodsAreRejected() {
        assertThatThrownBy(() -> orders.create("seller", "g")).isInstanceOf(BusinessException.class);
        when(db.activeOrders("g")).thenReturn(List.of(order(0)));
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
        when(db.orderStatus("o", 2, 3)).thenReturn(1);
        assertThat(orders.action("o", "buyer", "complete").orderStatus()).isEqualTo(3);
        var sequence = inOrder(db);
        sequence.verify(db).order("o"); sequence.verify(db).lockGoods("g"); sequence.verify(db).lockOrder("o");
        sequence.verify(db).orderStatus("o", 2, 3);
        verify(db, never()).goodsStatus(any(), anyInt(), anyInt(), any());
    }
    @Test void paymentDeliveryAndCancellationEnforceActorAndOldState() {
        assertThatThrownBy(() -> orders.action("o", "seller", "mock-pay")).isInstanceOf(BusinessException.class);
        when(db.orderStatus("o", 0, 1)).thenReturn(1);
        assertThat(orders.action("o", "buyer", "mock-pay").orderStatus()).isEqualTo(1);
        when(db.order("o")).thenReturn(order(1)); when(db.lockOrder("o")).thenReturn(order(1));
        assertThatThrownBy(() -> orders.action("o", "buyer", "cancel")).isInstanceOf(BusinessException.class);
        assertThatThrownBy(() -> orders.action("o", "buyer", "deliver")).isInstanceOf(BusinessException.class);
        when(db.orderStatus("o", 1, 2)).thenReturn(1);
        assertThat(orders.action("o", "seller", "deliver").orderStatus()).isEqualTo(2);
    }
    @Test void cancellationDoesNotMarkGoodsSoldAndRepeatedPaymentFails() {
        when(db.orderStatus("o", 0, 4)).thenReturn(1);
        assertThat(orders.action("o", "buyer", "cancel").orderStatus()).isEqualTo(4);
        verify(db, never()).goodsStatus(any(), anyInt(), anyInt(), any());
        when(db.lockOrder("o")).thenReturn(order(4));
        assertThatThrownBy(() -> orders.action("o", "buyer", "mock-pay")).isInstanceOf(BusinessException.class);
    }
    @Test void evaluationRequiresCompletionAndGetsIdentityFromOrder() {
        assertThatThrownBy(() -> orders.evaluate("o", "buyer", new EvaluationInput(5, "很好"))).isInstanceOf(BusinessException.class);
        when(db.order("o")).thenReturn(order(3)); when(db.lockOrder("o")).thenReturn(order(3));
        when(db.evaluationIds("o")).thenReturn(List.of()); when(db.insertEvaluation(any(), any())).thenReturn(1);
        var result = orders.evaluate("o", "buyer", new EvaluationInput(5, "很好"));
        assertThat(result.goodsId()).isEqualTo("g"); assertThat(result.evaluateUserId()).isEqualTo("buyer");
        when(db.evaluationIds("o")).thenReturn(List.of("e"));
        assertThatThrownBy(() -> orders.evaluate("o", "buyer", new EvaluationInput(5, "重复"))).isInstanceOf(BusinessException.class);
        assertThatThrownBy(() -> orders.evaluate("o", "seller", new EvaluationInput(5, "越权"))).isInstanceOf(BusinessException.class);
    }
    @Test void userEvaluationListCannotBeRedirectedToAnotherUser() {
        orders.userEvaluations("buyer", new PageQuery());
        verify(db).userEvaluations("buyer", 0, 10);
        verify(db).userEvaluationCount("buyer");
    }
    @Test void onlyMessageRecipientCanMarkRead() {
        when(db.message("m")).thenReturn(new Message("m", "sender", "receiver", "你好", 0, TIME));
        assertThatThrownBy(() -> communication.read("m", "sender")).isInstanceOf(BusinessException.class);
        communication.read("m", "receiver"); verify(db).readMessage("m", "receiver");
    }
    @Test void messageQueryAlwaysScopesBothParticipants() {
        when(users.findById("peer")).thenReturn(new UserRow("peer", "同学", "", "", null, null, 0, TIME));
        communication.messages("me", "peer", new PageQuery());
        verify(db).messages("me", "peer", 0, 10); verify(db).messageCount("me", "peer");
    }
    @Test void reportCannotSilentlyLoseGoodsAssociation() {
        when(db.insertReport(any(), any())).thenAnswer(call -> {
            ((com.campus.secondhand.common.GeneratedId) call.getArgument(1)).setId("12");
            return 1;
        });
        var report = communication.report("buyer", new ReportInput("g", "1", "原因", null));
        assertThat(report.goodsId()).isEqualTo("g");
        assertThat(report.reportId()).isEqualTo("12");
        verify(db).insertReport(argThat(row -> row.goodsId().equals("g") && row.reportUserId().equals("buyer")), any());
        assertThatThrownBy(() -> communication.report("buyer", new ReportInput("g", "0", "原因", null)))
                .isInstanceOf(BusinessException.class);
    }
}
