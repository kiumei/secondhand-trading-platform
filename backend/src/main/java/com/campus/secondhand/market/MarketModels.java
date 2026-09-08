package com.campus.secondhand.market;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.validation.constraints.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * API 和 SQL 的显式字段模型，均不含密码；金额按十进制字符串返回。
 * API JSON 字段名沿用《前端确认文档（DBA 测试员答复版）》第二节口径，
 * 数据库列名严格遵循 db/secondhand_full.sql（例如 JSON tradeType ↔ 列 trade_method，
 * JSON goodsDesc ↔ 列 description，JSON qualityLevel ↔ 列 quality，JSON evaluateContent ↔ 列 content）。
 */
public final class MarketModels {
    private MarketModels() { }

    /** 商品列表项；多图以 cover_url 呈现封面，全部图片仅在详情返回。 */
    public record Goods(String goodsId, String publishUserId, String cateId, String title,
            @JsonFormat(shape = JsonFormat.Shape.STRING) BigDecimal sellPrice,
            @JsonFormat(shape = JsonFormat.Shape.STRING) BigDecimal originalPrice,
            int tradeType, String goodsDesc, Integer qualityLevel, String rejectReason,
            LocalDateTime publishTime, int goodsStatus, String sellerName, String cateName,
            String coverUrl, boolean purchasable) { }

    /** 商品详情：附带 goods_image 表中的全部图片（按 sort_order 升序）。 */
    public record GoodsDetail(String goodsId, String publishUserId, String cateId, String title,
            @JsonFormat(shape = JsonFormat.Shape.STRING) BigDecimal sellPrice,
            @JsonFormat(shape = JsonFormat.Shape.STRING) BigDecimal originalPrice,
            int tradeType, String goodsDesc, Integer qualityLevel, String rejectReason,
            LocalDateTime publishTime, int goodsStatus, String sellerName, String cateName,
            String coverUrl, List<String> images, boolean purchasable) { }

    /** images 为图片地址列表，最多 4 张，第一张为封面（goods_image.sort_order=1）。 */
    public record GoodsInput(@NotBlank @Size(max = 32) String cateId,
            @NotBlank @Size(max = 100) String title,
            @NotNull @DecimalMin("0.00") @Digits(integer = 8, fraction = 2) BigDecimal sellPrice,
            @DecimalMin("0.00") @Digits(integer = 8, fraction = 2) BigDecimal originalPrice,
            @NotNull @Min(1) @Max(3) Integer tradeType,
            @NotBlank @Size(max = 2000) String goodsDesc, @Min(1) @Max(5) Integer qualityLevel,
            @Size(max = 4) List<@Size(max = 500) String> images) { }

    public record GoodsFilter(String keyword, String cateId, BigDecimal minPrice, BigDecimal maxPrice,
            String ownerId, Integer status, String sort, long offset, int pageSize) { }

    public record Order(String orderId, String buyerId, String sellerId, String goodsId,
            @JsonFormat(shape = JsonFormat.Shape.STRING) BigDecimal orderPrice,
            int payStatus, int orderStatus,
            LocalDateTime payTime, LocalDateTime finishTime, LocalDateTime createTime) { }

    public record OrderInput(@NotBlank @Size(max = 32) String goodsId) { }

    /** 评价仅绑定真实订单（evaluate.order_id 唯一外键）；商品与评价人由后端按订单推导。 */
    public record Evaluation(String evaluateId, String orderId, String goodsId, String evaluateUserId,
            int score, String evaluateContent, LocalDateTime evaluateTime) { }

    public record EvaluationInput(@NotNull @Min(1) @Max(5) Integer score, @Size(max = 500) String content) { }

    public record Message(String msgId, String sendUserId, String receiveUserId, String content,
            int isRead, LocalDateTime sendTime) { }

    public record MessageInput(@NotBlank @Size(max = 32) String receiveUserId,
            @NotBlank @Size(max = 500) String content) { }

    /** report 表无商品外键，举报仅记录举报人、类型、内容、证据与处理结果。 */
    public record Report(String reportId, String reportUserId, int reportType, String reportContent,
            String proofImg, int handleStatus, String handleResult, LocalDateTime reportTime) { }

    public record ReportInput(@NotNull @Min(1) @Max(5) Integer reportType,
            @NotBlank @Size(max = 500) String reportContent,
            @Size(max = 255) String proofImg) { }

    public record HandleInput(@NotBlank @Size(max = 200) String handleResult) { }

    public record CategoryInput(@NotBlank @Size(max = 50) String cateName,
            @NotNull @Min(0) Integer parentId, Integer sort) { }

    public record ReviewInput(@NotNull @Pattern(regexp = "PASS|REJECT") String decision,
            @Size(max = 200) String rejectReason) { }

    public record FavoriteInput(@NotBlank @Size(max = 32) String goodsId) { }

    /** 管理员仪表盘（B1）：销售额按已完成订单（order_status=3）合计。 */
    public record Dashboard(long userCount, long goodsCount, long orderCount,
            @JsonFormat(shape = JsonFormat.Shape.STRING) BigDecimal salesAmount,
            long pendingGoodsCount) { }
}
