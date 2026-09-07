package com.campus.secondhand.common;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/** Servlet 容器错误分派的兜底；MVC 异常仍由 GlobalExceptionHandler 处理。 */
@RestController
public class ApiErrorController implements ErrorController {
    @RequestMapping("${server.error.path:${error.path:/error}}")
    public ResponseEntity<ApiResponse<Void>> error(HttpServletRequest request) {
        Object attribute = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);
        int status = attribute instanceof Integer value && value >= 400 && value <= 599
                ? value : 500;
        String code = status == 500 ? "INTERNAL_ERROR" : "HTTP_" + status;
        String message = "请求无法处理";
        if (status == 400) { code = "INVALID_REQUEST"; message = "请求参数或格式不正确"; }
        if (status == 404) { code = "NOT_FOUND"; message = "资源不存在"; }
        if (status >= 500) { message = "服务暂时不可用"; }
        return ResponseEntity.status(status)
                .body(ApiResponse.error(code, message));
    }
}
