package com.campus.secondhand.config;

import com.campus.secondhand.auth.AccountService;
import com.campus.secondhand.category.CategoryMapper;
import com.campus.secondhand.user.UserMapper;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration(proxyBeanMethods = false)
@Profile("mysql")
@MapperScan(basePackageClasses = {UserMapper.class, CategoryMapper.class, com.campus.secondhand.market.MarketMapper.class})
public class AccountModuleConfig {
    @Bean AccountService accountService(UserMapper users, PasswordEncoder encoder) {
        return new AccountService(users, encoder);
    }
}
