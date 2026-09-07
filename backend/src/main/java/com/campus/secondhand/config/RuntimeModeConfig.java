package com.campus.secondhand.config;

import java.util.Arrays;
import org.springframework.beans.factory.config.BeanFactoryPostProcessor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;
import org.springframework.util.StringUtils;

/** 在数据库 Bean 初始化前发现配置错误，错误信息不包含连接密码。 */
@Configuration(proxyBeanMethods = false)
public class RuntimeModeConfig {
    @Bean
    static BeanFactoryPostProcessor validateRuntimeMode(Environment environment) {
        return beanFactory -> {
            var profiles = Arrays.asList(environment.getActiveProfiles());
            boolean local = profiles.contains("local");
            boolean mysql = profiles.contains("mysql");
            if (local == mysql) {
                throw new IllegalStateException("请且仅启用 local 或 mysql 中的一种运行模式");
            }
            if (mysql) {
                for (String key : new String[]{"DB_URL", "DB_USERNAME", "DB_PASSWORD"}) {
                    if (!StringUtils.hasText(environment.getProperty(key))) {
                        throw new IllegalStateException("mysql 模式缺少配置：" + key);
                    }
                }
                if (!environment.getRequiredProperty("DB_URL").startsWith("jdbc:mysql://")) {
                    throw new IllegalStateException("DB_URL 必须是 jdbc:mysql:// 开头的连接地址");
                }
            }
        };
    }
}
