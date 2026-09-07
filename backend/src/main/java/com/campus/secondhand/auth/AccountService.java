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
        var row = new UserRow(UUID.randomUUID().toString().replace("-", ""), name,
                encoder.encode(password), phone, null, null, 0,
                LocalDateTime.now(ZoneId.of("Asia/Shanghai")));
        try {
            if (users.insert(row) != 1) { throw new IllegalStateException("用户插入影响行数异常"); }
        } catch (DuplicateKeyException ex) {
            // 唯一约束兜底：并发注册不能只依赖事前查询。
            throw duplicatePhone();
        }
        return UserView.from(row);
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

    private void checkPasswordLength(String password) {
        if (password.getBytes(StandardCharsets.UTF_8).length > 72) {
            throw new BusinessException(HttpStatus.BAD_REQUEST, "INVALID_REQUEST", "密码 UTF-8 长度不能超过 72 字节");
        }
    }

    private BusinessException duplicatePhone() {
        return new BusinessException(HttpStatus.CONFLICT, "PHONE_EXISTS", "手机号已注册");
    }

    /** Session 仅保存身份，不保存密码或完整用户行。 */
    public record Principal(String userId) implements Serializable { }
}
