package com.campus.secondhand.user;

import java.time.OffsetDateTime;
import java.time.ZoneId;

public record UserView(String userId, String userName, String phone, String avatar,
        String intro, int role, int status, OffsetDateTime registerTime, String address) {
    public static UserView from(UserRow row) {
        return new UserView(row.userId(), row.userName(), row.phone(), row.avatar(), row.intro(),
                row.role(), row.status(), row.registerTime() == null ? null
                        : row.registerTime().atZone(ZoneId.of("Asia/Shanghai")).toOffsetDateTime(), row.address());
    }
}
