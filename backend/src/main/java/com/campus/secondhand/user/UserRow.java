package com.campus.secondhand.user;

import java.time.LocalDateTime;

/** 仅用于持久层与账号服务，不可直接作为 API 响应。 */
public record UserRow(String userId, String userName, String password, String phone,
        String avatar, String intro, int userRole, LocalDateTime registerTime, int status) {
    public UserRow(String userId, String userName, String password, String phone,
            String avatar, String intro, int userRole, LocalDateTime registerTime) {
        this(userId, userName, password, phone, avatar, intro, userRole, registerTime, 0);
    }
}
