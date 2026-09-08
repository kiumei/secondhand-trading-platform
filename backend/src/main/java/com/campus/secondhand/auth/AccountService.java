package com.campus.secondhand.auth;

import com.campus.secondhand.common.BusinessException;
import com.campus.secondhand.user.UserMapper;
import com.campus.secondhand.user.UserRow;
import com.campus.secondhand.user.UserView;
import java.io.Serializable;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.UUID;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.transaction.annotation.Transactional;

public class AccountService {
    private final UserMapper users;
    private final PasswordEncoder encoder;
    private final String dummyHash;

    public AccountService(UserMapper users, PasswordEncoder encoder) {
        this.users = users;
        this.encoder = encoder;
        this.dummyHash = encoder.encode(UUID.randomUUID().toString());
    }

    @Transactional
    public UserView register(String phone, String password, String name) {
        checkPasswordLength(password);
        if (users.findByPhone(phone) != null) { throw duplicatePhone(); }
        var row = new UserRow(null, name,
                encoder.encode(password), phone, null, null, 0,
                LocalDateTime.now(ZoneId.of("Asia/Shanghai")));
        var key = new com.campus.secondhand.common.GeneratedId();
        try {
            if (users.insert(row, key) != 1) { throw new IllegalStateException("用户插入影响行数异常"); }
        } catch (DuplicateKeyException ex) {
            // 唯一约束兜底：并发注册不能只依赖事前查询。
            throw duplicatePhone();
        }
        return UserView.from(new UserRow(key.getId(), row.userName(), row.password(), row.phone(),
                row.avatar(), row.intro(), row.userRole(), row.registerTime()));
    }

    public UserRow authenticate(String phone, String password) {
        checkPasswordLength(password);
        UserRow row = users.findByPhone(phone);
        boolean matches = encoder.matches(password, row == null ? dummyHash : row.password());
        if (row == null || !matches || (row.userRole() != 0 && row.userRole() != 1)) {
            throw new BusinessException(HttpStatus.UNAUTHORIZED, "BAD_CREDENTIALS", "手机号或密码不正确");
        }
        return row;
    }

    public UserView current(String id) {
        UserRow row = users.findById(id);
        if (row == null) {
            throw new BusinessException(HttpStatus.UNAUTHORIZED, "UNAUTHENTICATED", "账号不存在，请重新登录");
        }
        return UserView.from(row);
    }

    @Transactional
    public UserView updateProfile(String id, String name, String avatar, String intro) {
        current(id);
        if (name != null && name.isBlank()) {
            throw new BusinessException(HttpStatus.BAD_REQUEST, "INVALID_REQUEST", "昵称不能为空");
        }
        if (name != null || avatar != null || intro != null) {
            users.updateProfile(id, name, avatar, intro);
        }
        return current(id);
    }

    @Transactional
    public void changePassword(String id, String oldPassword, String newPassword) {
        checkPasswordLength(oldPassword); checkPasswordLength(newPassword);
        UserRow row = users.findById(id);
        if (row == null || !encoder.matches(oldPassword, row.password())) {
            throw new BusinessException(HttpStatus.BAD_REQUEST, "BAD_PASSWORD", "原密码不正确");
        }
        if (users.updatePassword(id, row.password(), encoder.encode(newPassword)) != 1) {
            throw new BusinessException(HttpStatus.CONFLICT, "CONFLICT", "密码已变更，请重新登录");
        }
    }
    @Transactional
    public void resetPassword(String id, String newPassword) {
        checkPasswordLength(newPassword);
        UserRow row = users.findById(id);
        if (row == null) { throw new BusinessException(HttpStatus.NOT_FOUND, "NOT_FOUND", "账号不存在"); }
        if (users.updatePassword(row.userId(), row.password(), encoder.encode(newPassword)) != 1) {
            throw new BusinessException(HttpStatus.CONFLICT, "CONFLICT", "账号密码已变更，请刷新后重试");
        }
    }

    /** Session stores an opaque credential version, never a password or database password hash. */
    public static String credentialVersion(UserRow row) {
        try {
            var digest = java.security.MessageDigest.getInstance("SHA-256");
            return java.util.HexFormat.of().formatHex(digest.digest(
                    (row.userId() + ":" + row.password() + ":" + row.userRole()).getBytes(StandardCharsets.UTF_8)));
        } catch (java.security.NoSuchAlgorithmException ex) { throw new IllegalStateException(ex); }
    }

    private void checkPasswordLength(String password) {
        if (password.getBytes(StandardCharsets.UTF_8).length > 72) {
            throw new BusinessException(HttpStatus.BAD_REQUEST, "INVALID_REQUEST", "密码 UTF-8 长度不能超过 72 字节");
        }
    }

    private BusinessException duplicatePhone() {
        return new BusinessException(HttpStatus.CONFLICT, "PHONE_EXISTS", "手机号已注册");
    }

    public record Principal(String userId, String credentialVersion) implements Serializable {
        public Principal(String userId) { this(userId, null); }
    }
}
