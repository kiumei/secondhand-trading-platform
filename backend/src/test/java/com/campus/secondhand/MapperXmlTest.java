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
        var report = new com.campus.secondhand.market.MarketModels.Report("1", "2", "3", 1, "reason", null, 0, null, null);
        var reportInsert = configuration.getMappedStatement("com.campus.secondhand.market.MarketMapper.insertReport").getBoundSql(report);
        assertThat(reportInsert.getSql()).contains("goods_id");
        assertThat(reportInsert.getParameterMappings()).extracting(org.apache.ibatis.mapping.ParameterMapping::getProperty).contains("goodsId");
        var inbox = configuration.getMappedStatement("com.campus.secondhand.market.MarketMapper.inbox")
                .getBoundSql(Map.of("userId", "2", "offset", 0, "size", 10));
        assertThat(inbox.getParameterMappings()).extracting(org.apache.ibatis.mapping.ParameterMapping::getProperty)
                .containsExactly("userId", "userId", "size", "offset");
        var orderRow = new com.campus.secondhand.market.MarketModels.Order("o", "b", "s", "g", java.math.BigDecimal.ONE,
                0, 0, null, null, null, "校区1栋");
        var orderInsert = configuration.getMappedStatement("com.campus.secondhand.market.MarketMapper.insertOrder").getBoundSql(orderRow);
        assertThat(orderInsert.getSql()).contains("shipping_address");
        assertThat(orderInsert.getParameterMappings()).extracting(org.apache.ibatis.mapping.ParameterMapping::getProperty).contains("shippingAddress");
        for (String name : new String[]{"order", "lockOrder", "orders", "adminOrders"}) {
            var params = new java.util.HashMap<String,Object>();
            params.put("id", "o"); params.put("userId", "b"); params.put("side", "buy"); params.put("status", null);
            params.put("offset", 0); params.put("size", 10);
            assertThat(configuration.getMappedStatement("com.campus.secondhand.market.MarketMapper." + name)
                    .getBoundSql(params).getSql()).contains("shipping_address");
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
