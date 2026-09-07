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
        var filter = new com.campus.secondhand.market.MarketModels.GoodsFilter("' OR 1=1 --", "c", null, null, null, 0, 0, 10);
        var listing = configuration.getMappedStatement("com.campus.secondhand.market.MarketMapper.goodsList").getBoundSql(filter);
        assertThat(listing.getSql()).contains("JOIN sys_user", "JOIN category", "LIMIT ? OFFSET ?").doesNotContain("OR 1=1 --");
        for (String statement : new String[]{"lockGoods", "lockOrder", "activeOrders", "evaluationIds"}) {
            var sql = configuration.getMappedStatement("com.campus.secondhand.market.MarketMapper." + statement)
                    .getBoundSql(Map.of("id", "x", "goodsId", "g")).getSql();
            assertThat(sql).contains("FOR UPDATE");
        }
    }
}
