package com.campus.secondhand.market;

import com.campus.secondhand.common.BusinessException;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.UUID;
import org.springframework.http.HttpStatus;

final class MarketRules {
    private MarketRules() { }
    static String id() { return UUID.randomUUID().toString().replace("-", ""); }
    static LocalDateTime now() { return LocalDateTime.now(ZoneId.of("Asia/Shanghai")); }
    static <T> T found(T value) {
        if (value == null) { throw new BusinessException(HttpStatus.NOT_FOUND, "NOT_FOUND", "记录不存在"); }
        return value;
    }
    static void allow(boolean permitted) {
        if (!permitted) { throw new BusinessException(HttpStatus.FORBIDDEN, "FORBIDDEN", "无权执行此操作"); }
    }
    static void require(boolean valid, String message) {
        if (!valid) { throw new BusinessException(HttpStatus.BAD_REQUEST, "INVALID_REQUEST", message); }
    }
    static void state(boolean valid, String message) {
        if (!valid) { throw new BusinessException(HttpStatus.CONFLICT, "STATE_CONFLICT", message); }
    }
    static void changed(int rows) { state(rows == 1, "记录状态已改变，请刷新后重试"); }
}
