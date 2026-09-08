package com.campus.secondhand.common;

/**
 * 状态码以 DBA 重新对齐的 db/secondhand_full.sql 为准（2026-09-08 转储）：
 * 商品 goods_status：0待审核、1上架、2下架、3已售出、4驳回；
 * 订单 order_status：0待付款、1待发货、2待收货、3完成、4取消、5售后；
 * 订单 pay_status：0未支付、1已支付；私信 is_read：0未读、1已读；
 * 举报 handle_status：0待处理、1已处理；用户 status：0正常、1封禁。
 */
public final class StatusCodes {
    private StatusCodes() { }

    public static final int GOODS_PENDING = 0;
    public static final int GOODS_LISTED = 1;
    public static final int GOODS_OFF_SHELF = 2;
    public static final int GOODS_SOLD = 3;
    public static final int GOODS_REJECTED = 4;

    public static final int ORDER_UNPAID = 0;
    public static final int ORDER_UNSHIPPED = 1;
    public static final int ORDER_UNRECEIVED = 2;
    public static final int ORDER_FINISHED = 3;
    public static final int ORDER_CANCELLED = 4;
    public static final int ORDER_AFTER_SALE = 5;

    public static final int USER_NORMAL = 0;
    public static final int USER_BANNED = 1;
}
