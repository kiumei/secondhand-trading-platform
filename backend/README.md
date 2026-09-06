# 后端基础工程

采用 Spring Boot 3.5.11、原生 MyBatis Starter 3.0.5、MySQL 驱动和 Spring Security，Java 编译目标为 17。版本固定用于可复现构建，不代表最新版本。

## 当前范围

已编写统一响应、全局异常处理、分页参数及校验、BCrypt 密码组件、安全过滤链、服务状态和 CSRF 接口。尚未实现用户登录、注册、商品、订单及数据库 Mapper；不提供默认登录账号。

当前不会创建业务表、修改原 SQL、插入演示数据或创建触发器。触发器是课程明确要求，收到 DBA 的定义与行为说明后接入相关业务事务。

## 启动与测试

在 backend 目录执行，需 JDK 17 或更高版本和 Maven。首次构建需要获取 Maven 依赖。

```powershell
mvn test
mvn spring-boot:run "-Dspring-boot.run.profiles=local"
```

local 模式明确关闭数据库和 MyBatis 自动配置，供基础 HTTP 与安全组件开发。正常业务运行不应使用该模式；它不代表 MySQL 已连接。

- `GET http://localhost:8080/api/health` 返回统一包装的 `data.status=UP`，仅表示应用 HTTP 服务存活。
- `GET http://localhost:8080/api/auth/csrf` 返回 `data.token` 和 `data.headerName`，需要保留服务端 Session Cookie。
- 其他请求受保护：未登录读取返回 JSON 401；写请求缺少有效 CSRF token 返回 JSON 403。

CSRF token 和会话绑定，不能跨会话使用。登录尚未实现，因此获取 CSRF token 不会赋予业务访问权限。

后续获得数据库连接信息后使用 mysql 模式：

```powershell
$env:DB_URL = 'jdbc:mysql://localhost:3306/实际数据库名?connectionTimeZone=Asia/Shanghai'
$env:DB_USERNAME = '实际应用账号'
$env:DB_PASSWORD = '实际密码'
mvn spring-boot:run "-Dspring-boot.run.profiles=mysql"
```

以上为变量填写示例，不创建数据库或账号。不要同时启用 local 与 mysql。不指定模式时不会自动降级为无数据库模式。SQL 初始化始终关闭，数据库连接与业务 SQL 尚待真实 MySQL 验证。

## 目录与后续接入

- `common/`：响应、业务异常、MVC 异常处理和分页。
- `config/`：安全策略及密码编码器。
- `system/`：基础服务接口。
- `src/main/resources/mapper/`：后续手写 MyBatis XML；当前没有占位业务 SQL。
- `src/test/`：无数据库基础集成测试，不替代 MySQL 事务、触发器和并发验收。

接口约定见 [前后端交接建议](../docs/backend-frontend-handoff.md)，数据库边界见 [后端与 DBA 交接](../docs/backend-dba-handoff.md)，内部推进依据见 [后端计划](backend-plan.md)。

## 验证记录

2026-09-07 执行 `mvn test -B -ntp`：BUILD SUCCESS，7 项测试通过，0 失败、0 错误、0 跳过。验证包含完整 Spring 测试上下文与 MockMvc 安全过滤链，尚未单独进行真实 HTTP 端口启动验证。当前本机 JDK 为 25，编译使用 release 17；尚未在 JDK 17 运行时单独验证。

版本依据：[Spring Boot 3.5.11 发布说明](https://spring.io/blog/2026/02/19/spring-boot-3-5-11-available-now)、[MyBatis Starter 官方发布记录](https://github.com/mybatis/spring-boot-starter/releases)。
