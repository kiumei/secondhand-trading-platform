package com.campus.secondhand.market;

import com.campus.secondhand.category.CategoryMapper.Category;
import java.util.List;
import com.campus.secondhand.common.GeneratedId;
import org.apache.ibatis.annotations.Param;
import static com.campus.secondhand.market.MarketModels.*;

public interface MarketMapper {
    List<Favorite> favorites(@Param("id") String id, @Param("offset") long offset, @Param("size") int size);
    long favoriteCount(@Param("id") String id);
    boolean isFavorite(@Param("user") String user, @Param("goods") String goods);
    int addFavorite(@Param("user") String user, @Param("goods") String goods);
    int removeFavorite(@Param("user") String user, @Param("goods") String goods);
    Dashboard dashboard();
    int deleteEvaluation(@Param("id") String id);
    List<Order> adminOrders(@Param("offset") long offset, @Param("size") int size);
    long adminOrderCount();
    List<Evaluation> adminEvaluations(@Param("offset") long offset, @Param("size") int size);
    long adminEvaluationCount();
    List<Message> inbox(@Param("id") String id, @Param("offset") long offset, @Param("size") int size);
    long inboxCount(@Param("id") String id);
    Category category(@Param("id") String id);
    List<Category> lockCategories();
    List<String> goodsImages(@Param("id") String id);
    int deleteGoodsImages(@Param("id") String id);
    int insertGoodsImage(@Param("id") String id, @Param("url") String url, @Param("sort") int sort);
    int insertCategory(@Param("key") GeneratedId key, @Param("body") CategoryInput body);
    int updateCategory(@Param("id") String id, @Param("body") CategoryInput body);
    int deleteCategory(@Param("id") String id);
    long categoryGoods(@Param("id") String id);
    Goods goods(@Param("id") String id);
    Goods lockGoods(@Param("id") String id);
    List<Goods> goodsList(GoodsFilter filter);
    long goodsCount(GoodsFilter filter);
    int insertGoods(@Param("key") GeneratedId key, @Param("owner") String owner, @Param("body") GoodsInput body);
    int updateGoods(@Param("id") String id, @Param("body") GoodsInput body);
    int goodsStatus(@Param("id") String id, @Param("oldStatus") int oldStatus,
            @Param("status") int status, @Param("reason") String reason);
    List<Order> activeOrders(@Param("goodsId") String goodsId);
    int insertOrder(Order order);
    Order order(@Param("id") String id);
    Order lockOrder(@Param("id") String id);
    List<Order> orders(@Param("userId") String userId, @Param("side") String side,
            @Param("offset") long offset, @Param("size") int size);
    long orderCount(@Param("userId") String userId, @Param("side") String side);
    int orderStatus(@Param("id") String id, @Param("oldStatus") int oldStatus, @Param("status") int status);
    List<String> evaluationIds(@Param("id") String id);
    int insertEvaluation(@Param("row") Evaluation evaluation, @Param("key") GeneratedId key);
    List<Evaluation> evaluations(@Param("id") String id, @Param("offset") long offset, @Param("size") int size);
    long evaluationCount(@Param("id") String id);
    List<Evaluation> userEvaluations(@Param("userId") String userId,
            @Param("offset") long offset, @Param("size") int size);
    long userEvaluationCount(@Param("userId") String userId);
    int insertMessage(@Param("row") Message message, @Param("key") GeneratedId key);
    Message message(@Param("id") String id);
    int readMessage(@Param("id") String id, @Param("userId") String userId);
    List<Message> messages(@Param("userId") String userId, @Param("peerId") String peerId,
            @Param("offset") long offset, @Param("size") int size);
    long messageCount(@Param("userId") String userId, @Param("peerId") String peerId);
    int insertReport(@Param("row") Report report, @Param("key") GeneratedId key);
    Report report(@Param("id") String id);
    int handleReport(@Param("id") String id, @Param("result") String result);
    List<Report> reports(@Param("userId") String userId, @Param("status") Integer status,
            @Param("offset") long offset, @Param("size") int size);
    long reportCount(@Param("userId") String userId, @Param("status") Integer status);
}
