package com.campus.secondhand.user;

import com.campus.secondhand.common.BusinessException;
import com.campus.secondhand.common.PageQuery;
import com.campus.secondhand.common.PageResult;
import com.campus.secondhand.common.StatusCodes;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import org.springframework.context.annotation.Profile;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 管理员用户管理（B2）：封禁/解封使用 sys_user.status（0 正常、1 封禁），重置密码写入 BCrypt 哈希。
 * 管理员账号不可被封禁，也不能封禁当前登录管理员自己。
 */
@Service
@Profile("mysql")
public class AdminUserService {
    private final UserMapper users;
    private final PasswordEncoder encoder;

    public AdminUserService(UserMapper users, PasswordEncoder encoder) { this.users = users; this.encoder = encoder; }

    private UserRow found(UserRow row) {
        if (row == null) { throw new BusinessException(HttpStatus.NOT_FOUND, "NOT_FOUND", "用户不存在"); }
        return row;
    }

    public PageResult<UserView> list(String keyword, PageQuery page) {
        if (keyword != null && keyword.length() > 50) {
            throw new BusinessException(HttpStatus.BAD_REQUEST, "INVALID_REQUEST", "搜索词过长");
        }
        return new PageResult<>(users.adminList(keyword, page.getOffset(), page.getPageSize())
                        .stream().map(UserView::from).toList(),
                users.adminCount(keyword), page.getPage(), page.getPageSize());
    }

    @Transactional
    public UserView setBanned(String operator, String userId, boolean banned) {
        var row = found(users.findById(userId));
        if (banned) {
            if (row.role() == 1) {
                throw new BusinessException(HttpStatus.CONFLICT, "STATE_CONFLICT", "管理员账号不能被封禁");
            }
            if (row.userId().equals(operator)) {
                throw new BusinessException(HttpStatus.CONFLICT, "STATE_CONFLICT", "不能封禁当前登录账号");
            }
        }
        int target = banned ? StatusCodes.USER_BANNED : StatusCodes.USER_NORMAL;
        if (row.status() != target) {
            if (users.updateStatus(userId, target) != 1) {
                throw new BusinessException(HttpStatus.CONFLICT, "STATE_CONFLICT", "用户状态已改变，请刷新后重试");
            }
        }
        return UserView.from(found(users.findById(userId)));
    }

    /** password 缺省时生成 8 位随机密码；仅生成的密码会在响应中返回一次。 */
    @Transactional
    public ResetResult resetPassword(String userId, String password) {
        var row = found(users.findById(userId));
        boolean generated = password == null || password.isBlank();
        String plain = generated ? randomPassword() : password;
        if (plain.length() < 6 || plain.getBytes(StandardCharsets.UTF_8).length > 72) {
            throw new BusinessException(HttpStatus.BAD_REQUEST, "INVALID_REQUEST", "密码长度必须在 6 到 72 字节之间");
        }
        if (users.updatePassword(userId, encoder.encode(plain)) != 1) {
            throw new BusinessException(HttpStatus.CONFLICT, "STATE_CONFLICT", "用户状态已改变，请刷新后重试");
        }
        return new ResetResult(row.userId(), generated ? plain : null);
    }

    public record ResetResult(String userId, String newPassword) { }

    private String randomPassword() {
        var alphabet = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz23456789";
        var random = new SecureRandom();
        var builder = new StringBuilder(8);
        for (int i = 0; i < 8; i++) { builder.append(alphabet.charAt(random.nextInt(alphabet.length()))); }
        return builder.toString();
    }
}
