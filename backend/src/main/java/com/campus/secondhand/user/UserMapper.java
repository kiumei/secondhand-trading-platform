package com.campus.secondhand.user;

import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface UserMapper {
    PublicUserView publicProfile(@Param("id") String id);
    int changePassword(@Param("id") String id,@Param("oldHash") String oldHash,@Param("newHash") String newHash);
    UserRow findByPhone(@Param("phone") String phone);
    UserRow findById(@Param("userId") String userId);
    int insert(UserRow user);
    /** 同一事务连接内读取自增主键；所有表主键为 int 自增（orders 除外）。 */
    long lastInsertId();
    int updateProfile(@Param("userId") String userId, @Param("userName") String userName,
            @Param("avatar") String avatar, @Param("intro") String intro, @Param("address") String address);
    int updateStatus(@Param("userId") String userId, @Param("status") int status);
    int updatePassword(@Param("userId") String userId, @Param("password") String password);
    List<UserRow> adminList(@Param("keyword") String keyword,
            @Param("offset") long offset, @Param("size") int size);
    long adminCount(@Param("keyword") String keyword);
    long countUsers();
}
