package com.campus.secondhand;

import java.util.Map;
import org.apache.ibatis.builder.xml.XMLMapperBuilder;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.Configuration;
import org.junit.jupiter.api.Test;
import static org.assertj.core.api.Assertions.assertThat;

class MapperXmlTest {
    @Test void xmlParsesAndUserInputRemainsBoundParameter() throws Exception {
        var configuration = new Configuration();
        for (String resource : new String[]{"mapper/UserMapper.xml", "mapper/CategoryMapper.xml", "mapper/MarketMapper.xml"}) {
            try (var input = Resources.getResourceAsStream(resource)) {
                new XMLMapperBuilder(input, configuration, resource, configuration.getSqlFragments()).parse();
            }
        }
        var bound = configuration.getMappedStatement("com.campus.secondhand.user.UserMapper.findByPhone")
                .getBoundSql(Map.of("phone", "' OR 1=1 --"));
        assertThat(bound.getSql()).contains("phone = ?").doesNotContain("OR 1=1");
        assertThat(bound.getParameterMappings()).hasSize(1);
        assertThat(configuration.hasStatement("com.campus.secondhand.category.CategoryMapper.findAll")).isTrue();
        for (var method : com.campus.secondhand.market.MarketMapper.class.getMethods()) {
            assertThat(configuration.hasStatement("com.campus.secondhand.market.MarketMapper." + method.getName())).isTrue();
        }
        // 列名对齐 db/secondhand_full.sql：trade_method、description、quality、user_id。
        var filter = new com.campus.secondhand.market.MarketModels.GoodsFilter(
                "' OR 1=1 --", "c", null, null, null, 1, "latest", 0, 10);
        var listing = configuration.getMappedStatement("com.campus.secondhand.market.MarketMapper.goodsList").getBoundSql(filter);
        assertThat(listing.getSql()).contains("JOIN sys_user", "JOIN category", "trade_method", "LIMIT ? OFFSET ?")
                .doesNotContain("OR 1=1 --");
        var locked = configuration.getMappedStatement("com.campus.secondhand.market.MarketMapper.goodsList")
                .getBoundSql(new com.campus.secondhand.market.MarketModels.GoodsFilter(
                        null, null, null, null, null, 1, "priceAsc", 0, 10));
        assertThat(locked.getSql()).contains("ORDER BY g.sell_price ASC");
        for (String statement : new String[]{"lockGoods", "lockOrder", "activeOrderIds", "evaluationOfOrder"}) {
            var sql = configuration.getMappedStatement("com.campus.secondhand.market.MarketMapper." + statement)
                    .getBoundSql(Map.of("id", "x", "goodsId", "g", "orderId", "o")).getSql();
            assertThat(sql).contains("FOR UPDATE");
        }
        var order = configuration.getMappedStatement("com.campus.secondhand.market.MarketMapper.insertOrder")
                .getBoundSql(Map.of("orderId", "o", "sellerId", "1", "goodsId", "g", "buyerId", "2",
                        "orderPrice", new java.math.BigDecimal("1.00"), "createTime", java.time.LocalDateTime.now()));
        assertThat(order.getSql()).contains("pay_status", "order_status");
    }
}
