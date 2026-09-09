package com.campus.secondhand.system;

import com.campus.secondhand.common.ApiResponse;
import com.campus.secondhand.market.MarketModels.Dashboard;
import org.springframework.context.annotation.Profile;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Profile("mysql")
public class DashboardController {
    private final DashboardService dashboard;
    public DashboardController(DashboardService dashboard) { this.dashboard = dashboard; }

    @GetMapping("/api/admin/dashboard")
    public ApiResponse<Dashboard> snapshot() {
        return ApiResponse.success(dashboard.snapshot());
    }
}
