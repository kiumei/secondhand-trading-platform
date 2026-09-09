package com.campus.secondhand;

import com.campus.secondhand.auth.AccountController;
import com.campus.secondhand.auth.AccountService;
import com.campus.secondhand.category.CategoryController;
import javax.sql.DataSource;
import org.apache.ibatis.session.SqlSessionFactory;
import org.junit.jupiter.api.Test;
import org.springframework.aop.support.AopUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Import;
import org.springframework.test.context.ActiveProfiles;
import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.never;

/** 检查真实 mysql 配置与 Mapper/事务装配，DataSource 替身不连接数据库。 */
@SpringBootTest(properties = {
        "DB_URL=jdbc:mysql://localhost/test-only",
        "DB_USERNAME=test-only", "DB_PASSWORD=test-only"
})
@ActiveProfiles("mysql")
@Import(MySqlModuleWiringTest.Wiring.class)
class MySqlModuleWiringTest {
    @Autowired ApplicationContext context;
    @Autowired SqlSessionFactory sessions;
    @Autowired DataSource dataSource;

    @Test void mysqlWiresControllersMappersAndTransactionProxyWithoutQuerying() throws Exception {
        assertThat(context.getBeansOfType(AccountController.class)).hasSize(1);
        assertThat(context.getBeansOfType(CategoryController.class)).hasSize(1);
        assertThat(AopUtils.isAopProxy(context.getBean(AccountService.class))).isTrue();
        assertThat(AopUtils.isAopProxy(context.getBean(com.campus.secondhand.market.GoodsService.class))).isTrue();
        assertThat(AopUtils.isAopProxy(context.getBean(com.campus.secondhand.market.OrderService.class))).isTrue();
        assertThat(AopUtils.isAopProxy(context.getBean(com.campus.secondhand.market.CommunicationService.class))).isTrue();
        assertThat(AopUtils.isAopProxy(context.getBean(com.campus.secondhand.market.FavoriteService.class))).isTrue();
        assertThat(AopUtils.isAopProxy(context.getBean(com.campus.secondhand.user.AdminUserService.class))).isTrue();
        assertThat(context.getBeansOfType(com.campus.secondhand.system.DashboardService.class)).hasSize(1);
        assertThat(context.getBeansOfType(com.campus.secondhand.system.DashboardController.class)).hasSize(1);
        assertThat(sessions.getConfiguration().hasStatement("com.campus.secondhand.user.UserMapper.insert")).isTrue();
        assertThat(sessions.getConfiguration().hasStatement("com.campus.secondhand.category.CategoryMapper.findAll")).isTrue();
        verify(dataSource, never()).getConnection();
    }

    @TestConfiguration
    static class Wiring {
        @Bean DataSource dataSource() { return mock(DataSource.class); }
    }
}
