package com.campus.secondhand.market;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.validation.constraints.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/** API 和 SQL 的显式字段模型，均不含密码；金额按十进制字符串返回。 */
public final class MarketModels {
    private MarketModels() { }
    public record Goods(String goodsId, String publishUserId, String categoryId, String title,
            @JsonFormat(shape = JsonFormat.Shape.STRING) BigDecimal sellPrice,
            @JsonFormat(shape = JsonFormat.Shape.STRING) BigDecimal originalPrice,
            int tradeType, String goodsDesc, Integer qualityLevel, String rejectReason,
            LocalDateTime publishTime, int goodsStatus, String sellerName, String cateName, boolean purchasable,
            List<String> images) {
        public Goods { images = images == null ? List.of() : List.copyOf(images); }
        public Goods(String goodsId, String publishUserId, String categoryId, String title,
                BigDecimal sellPrice, BigDecimal originalPrice, int tradeType, String goodsDesc,
                Integer qualityLevel, String rejectReason, LocalDateTime publishTime, int goodsStatus,
                String sellerName, String cateName, boolean purchasable) {
            this(goodsId, publishUserId, categoryId, title, sellPrice, originalPrice, tradeType, goodsDesc,
                    qualityLevel, rejectReason, publishTime, goodsStatus, sellerName, cateName, purchasable, List.of());
        }
        @com.fasterxml.jackson.annotation.JsonProperty("coverImg")
        public String coverImg() { return images.isEmpty() ? null : images.get(0); }
    }
    public record GoodsInput(@NotBlank @Size(max = 32) String categoryId,
            @NotBlank @Size(max = 100) String title,
            @NotNull @DecimalMin("0.00") @Digits(integer = 8, fraction = 2) BigDecimal sellPrice,
            @DecimalMin("0.00") @Digits(integer = 8, fraction = 2) BigDecimal originalPrice,
            @NotNull @Min(1) @Max(3) Integer tradeType,
            @NotBlank @Size(max = 500) String goodsDesc, @Min(1) @Max(5) Integer qualityLevel,
            @Size(max = 4) List<@NotBlank @Size(max = 500) String> images) {
        public GoodsInput(String categoryId, String title, BigDecimal sellPrice, BigDecimal originalPrice,
                Integer tradeType, String goodsDesc, Integer qualityLevel) {
            this(categoryId, title, sellPrice, originalPrice, tradeType, goodsDesc, qualityLevel, null);
        }
    }
    public record GoodsFilter(String keyword, String categoryId, BigDecimal minPrice, BigDecimal maxPrice,
            String ownerId, Integer status, long offset, int pageSize) { }
    public record Order(String orderId, String buyerId, String sellerId, String goodsId,
            @JsonFormat(shape = JsonFormat.Shape.STRING) BigDecimal orderPrice,
            int orderStatus, LocalDateTime createTime) { }
    public record OrderInput(@NotBlank @Size(max = 32) String goodsId) { }
    public record Evaluation(String evaluateId, String orderId, String goodsId, String evaluateUserId,
            int score, String evaluateContent, LocalDateTime evaluateTime) { }
    public record EvaluationInput(@NotNull @Min(1) @Max(5) Integer score, @Size(max = 500) String content) { }
    public record Message(String msgId, String sendUserId, String receiveUserId, String content,
            int isRead, LocalDateTime sendTime) { }
    public record MessageInput(@NotBlank @Size(max = 32) String receiveUserId,
            @NotBlank @Size(max = 500) String content) { }
    public record Report(String reportId, String reportUserId, String goodsId, String reportType,
            String reportContent, String proofImg, int handleStatus, String handleResult) { }
    public record ReportInput(@NotBlank @Size(max = 32) String goodsId,
            @NotBlank @Pattern(regexp = "[1-5]") String reportType, @NotBlank @Size(max = 500) String reportContent,
            @Size(max = 255) String proofImg) { }
    public record HandleInput(@NotBlank @Size(max = 200) String handleResult) { }
    public record CategoryInput(@NotBlank @Size(max = 50) String cateName, @Size(max = 255) String cateDesc,
            @Pattern(regexp = "0|[1-9][0-9]{0,9}") String parentId, Integer sort) {
        public CategoryInput(String cateName, String cateDesc) { this(cateName, cateDesc, null, null); }
    }
    public record ReviewInput(@NotNull @Pattern(regexp = "PASS|REJECT") String decision,
            @Size(max = 200) String rejectReason) { }
    public record Favorite(String favoriteId, String userId, String goodsId, LocalDateTime createTime) { }
    public record Dashboard(long goodsCount, long userCount, long orderCount, long pendingReportCount,
            @JsonFormat(shape = JsonFormat.Shape.STRING) BigDecimal salesAmount) { }
}
