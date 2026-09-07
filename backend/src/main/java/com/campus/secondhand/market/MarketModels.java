package com.campus.secondhand.market;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.validation.constraints.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/** API 和 SQL 的显式字段模型，均不含密码；金额按十进制字符串返回。 */
public final class MarketModels {
    private MarketModels() { }
    public record Goods(String goodsId, String publishUserId, String categoryId, String title,
            @JsonFormat(shape = JsonFormat.Shape.STRING) BigDecimal sellPrice,
            @JsonFormat(shape = JsonFormat.Shape.STRING) BigDecimal originalPrice,
            int tradeType, String goodsDesc, Integer qualityLevel, String rejectReason,
            LocalDateTime publishTime, int goodsStatus, String sellerName, String cateName, boolean purchasable) { }
    public record GoodsInput(@NotBlank @Size(max = 32) String categoryId,
            @NotBlank @Size(max = 100) String title,
            @NotNull @DecimalMin("0.00") @Digits(integer = 8, fraction = 2) BigDecimal sellPrice,
            @DecimalMin("0.00") @Digits(integer = 8, fraction = 2) BigDecimal originalPrice,
            @NotNull @Min(1) @Max(3) Integer tradeType,
            @NotBlank @Size(max = 500) String goodsDesc, @Min(1) @Max(5) Integer qualityLevel) { }
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
            @NotBlank @Size(max = 50) String reportType, @NotBlank @Size(max = 500) String reportContent,
            @Size(max = 255) String proofImg) { }
    public record HandleInput(@NotBlank @Size(max = 500) String handleResult) { }
    public record CategoryInput(@NotBlank @Size(max = 50) String cateName, @Size(max = 255) String cateDesc) { }
    public record ReviewInput(@NotNull @Pattern(regexp = "PASS|REJECT") String decision,
            @Size(max = 255) String rejectReason) { }
}
