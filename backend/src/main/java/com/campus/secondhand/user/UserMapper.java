package com.campus.secondhand.user;

import org.apache.ibatis.annotations.Param;

public interface UserMapper {
    PublicUserView publicProfile(@Param("id") String id);
    java.util.List<UserRow> list(@Param("offset") long offset, @Param("size") int size);
    long count();
    int updatePassword(@Param("id") String id, @Param("oldHash") String oldHash, @Param("newHash") String newHash);
    UserRow findByPhone(@Param("phone") String phone);
    UserRow findById(@Param("userId") String userId);
    int insert(@Param("row") UserRow user, @Param("key") com.campus.secondhand.common.GeneratedId key);
    int updateProfile(@Param("userId") String userId, @Param("userName") String userName,
            @Param("avatar") String avatar, @Param("intro") String intro);
}
