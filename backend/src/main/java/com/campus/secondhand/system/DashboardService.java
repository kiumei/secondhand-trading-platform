package com.campus.secondhand.system;

import com.campus.secondhand.common.StatusCodes;
import com.campus.secondhand.market.MarketMapper;
import com.campus.secondhand.market.MarketModels.Dashboard;
import com.campus.secondhand.user.UserMapper;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Service;

/** 管理员仪表盘（B1）：数据库聚合查询；销售额按已完成订单（order_status=3）合计。 */
@Service
@Profile("mysql")
public class DashboardService {
    private final MarketMapper market;
    private final UserMapper users;
    public DashboardService(MarketMapper market, UserMapper users) { this.market = market; this.users = users; }

    public Dashboard snapshot() {
        return new Dashboard(users.countUsers(), market.countGoods(), market.countOrders(),
                market.salesAmount(), market.countGoodsByStatus(StatusCodes.GOODS_PENDING));
    }
}
