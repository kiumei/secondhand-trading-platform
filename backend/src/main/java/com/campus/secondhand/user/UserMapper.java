package com.campus.secondhand.user;

import org.apache.ibatis.annotations.Param;

public interface UserMapper {
    UserRow findByPhone(@Param("phone") String phone);
    UserRow findById(@Param("userId") String userId);
    int insert(UserRow user);
    int updateProfile(@Param("userId") String userId, @Param("userName") String userName,
            @Param("avatar") String avatar, @Param("intro") String intro);
}
