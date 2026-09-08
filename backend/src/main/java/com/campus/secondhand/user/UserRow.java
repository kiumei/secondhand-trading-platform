package com.campus.secondhand.user;

import java.time.LocalDateTime;

/**
 * 仅用于持久层与账号服务，不可直接作为 API 响应。
 * 列名以 db/secondhand_full.sql 为准：sys_user(user_id, user_name, phone, password, avatar, intro, role, status, register_time)。
 * status：0 正常、1 封禁（管理员封禁/解封使用）。
 */
public record UserRow(String userId, String userName, String password, String phone,
        String avatar, String intro, int role, int status, LocalDateTime registerTime) { }
