package com.campus.secondhand.market;

import com.campus.secondhand.category.CategoryMapper.Category;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import org.apache.ibatis.annotations.Param;
import static com.campus.secondhand.market.MarketModels.*;

public interface MarketMapper {
    java.util.List<Message> inbox(@Param("userId") String userId,@Param("offset") long offset,@Param("size") int size);
    long inboxCount(@Param("userId") String userId);
    Category category(@Param("id") String id);
    int insertCategory(@Param("body") CategoryInput body);
    int updateCategory(@Param("id") String id, @Param("body") CategoryInput body);
    int deleteCategory(@Param("id") String id);
    long categoryGoods(@Param("id") String id);
    long categoryChildren(@Param("id") String id);

    Goods goods(@Param("id") String id);
    Goods lockGoods(@Param("id") String id);
    List<Goods> goodsList(GoodsFilter filter);
    long goodsCount(GoodsFilter filter);
    int insertGoods(@Param("owner") String owner, @Param("body") GoodsInput body);
    int updateGoods(@Param("id") String id, @Param("body") GoodsInput body);
    int goodsStatus(@Param("id") String id, @Param("oldStatus") int oldStatus,
            @Param("status") int status, @Param("reason") String reason);

    List<String> images(@Param("goodsId") String goodsId);
    int insertImages(@Param("goodsId") String goodsId, @Param("images") List<String> images);
    int deleteImages(@Param("goodsId") String goodsId);

    List<String> activeOrderIds(@Param("goodsId") String goodsId);
    int insertOrder(Order order);
    Order order(@Param("id") String id);
    Order lockOrder(@Param("id") String id);
    List<Order> orders(@Param("userId") String userId, @Param("side") String side,
            @Param("offset") long offset, @Param("size") int size);
    long orderCount(@Param("userId") String userId, @Param("side") String side);
    int orderPay(@Param("id") String id, @Param("oldStatus") int oldStatus,
            @Param("payTime") LocalDateTime payTime);
    int orderStatus(@Param("id") String id, @Param("oldStatus") int oldStatus,
            @Param("status") int status, @Param("finishTime") LocalDateTime finishTime);
    List<Order> adminOrders(@Param("status") Integer status,
            @Param("offset") long offset, @Param("size") int size);
    long adminOrderCount(@Param("status") Integer status);

    List<String> evaluationOfOrder(@Param("orderId") String orderId);
    int insertEvaluation(@Param("orderId") String orderId, @Param("score") int score,
            @Param("content") String content, @Param("time") LocalDateTime time);
    /** 同一事务连接内读取自增主键（eva_id 等 int 自增主键）。 */
    long lastInsertId();
    Evaluation evaluation(@Param("id") String id);
    int deleteEvaluation(@Param("id") String id);
    List<Evaluation> evaluations(@Param("goodsId") String goodsId,
            @Param("offset") long offset, @Param("size") int size);
    long evaluationCount(@Param("goodsId") String goodsId);
    List<Evaluation> userEvaluations(@Param("userId") String userId,
            @Param("offset") long offset, @Param("size") int size);
    long userEvaluationCount(@Param("userId") String userId);
    List<Evaluation> sellerEvaluations(@Param("sellerId") String sellerId,
            @Param("offset") long offset, @Param("size") int size);
    long sellerEvaluationCount(@Param("sellerId") String sellerId);
    List<Evaluation> allEvaluations(@Param("offset") long offset, @Param("size") int size);
    long allEvaluationCount();

    int insertMessage(Message message);
    Message message(@Param("id") String id);
    int readMessage(@Param("id") String id, @Param("userId") String userId);
    List<Message> messages(@Param("userId") String userId, @Param("peerId") String peerId,
            @Param("offset") long offset, @Param("size") int size);
    long messageCount(@Param("userId") String userId, @Param("peerId") String peerId);

    int insertReport(Report report);
    Report report(@Param("id") String id);
    int handleReport(@Param("id") String id, @Param("result") String result);
    List<Report> reports(@Param("userId") String userId, @Param("status") Integer status,
            @Param("offset") long offset, @Param("size") int size);
    long reportCount(@Param("userId") String userId, @Param("status") Integer status);

    boolean favoriteExists(@Param("userId") String userId, @Param("goodsId") String goodsId);
    int insertFavorite(@Param("userId") String userId, @Param("goodsId") String goodsId);
    int deleteFavorite(@Param("userId") String userId, @Param("goodsId") String goodsId);
    List<Goods> favoriteGoods(@Param("userId") String userId,
            @Param("offset") long offset, @Param("size") int size);
    long favoriteCount(@Param("userId") String userId);

    long countGoods();
    long countGoodsByStatus(@Param("status") int status);
    long countOrders();
    BigDecimal salesAmount();
}
