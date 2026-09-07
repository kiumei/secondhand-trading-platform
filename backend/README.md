# 后端基础工程

采用 Spring Boot 3.5.11、原生 MyBatis Starter 3.0.5、MySQL 驱动和 Spring Security，Java 编译目标为 17。版本固定用于可复现构建，不代表最新版本。

## 当前范围

已实现基础响应与安全配置、注册登录退出、当前用户与资料修改、分类管理、商品发布编辑审核下架与检索、订单创建与模拟支付/交付/完成/取消、评价、私信和举报处理。业务在 mysql 模式装配，SQL 使用原生 MyBatis XML；真实数据库读写尚待联调。未实现图片上传、真实支付和售后；不提供默认登录账号。

当前不会创建业务表、修改原 SQL、插入演示数据或创建触发器。按用户安排，等 DBA 完成数据库后根据其实际触发器定义调整代码；若没有定义，不自行新增触发器。当前关联更新由后端事务负责。

## 启动与测试

在 backend 目录执行，需 JDK 17 或更高版本和 Maven。首次构建需要获取 Maven 依赖。

```powershell
mvn test
mvn spring-boot:run "-Dspring-boot.run.profiles=local"
```

local 模式明确关闭数据库和 MyBatis 自动配置，供基础 HTTP 与安全组件开发。正常业务运行不应使用该模式；它不代表 MySQL 已连接。

- `GET http://localhost:8080/api/health` 返回统一包装的 `data.status=UP`，仅表示应用 HTTP 服务存活。
- `GET http://localhost:8080/api/auth/csrf` 返回 `data.token` 和 `data.headerName`，需要保留服务端 Session Cookie。
- `POST /api/auth/logout` 要求有效 CSRF token，返回成功 JSON 并使会话失效。`GET` 不执行退出。
- 其他受保护请求：未登录读取返回 JSON 401；写请求缺少有效 CSRF token 返回 JSON 403。

CSRF token 和会话绑定，不能跨会话使用。local 模式不装配业务接口，也不提供模拟账号；这些接口在 mysql 模式装配。获取 CSRF token 本身不会赋予业务访问权限。

后续获得数据库连接信息后使用 mysql 模式：

```powershell
$env:DB_URL = 'jdbc:mysql://localhost:3306/实际数据库名?connectionTimeZone=Asia/Shanghai'
$env:DB_USERNAME = '实际应用账号'
$env:DB_PASSWORD = '实际密码'
mvn spring-boot:run "-Dspring-boot.run.profiles=mysql"
```

以上为变量填写示例，不创建数据库或账号。启动时检查必须且仅启用 local 或 mysql；mysql 模式还检查连接变量完整性。SQL 初始化始终关闭，数据库连接与业务 SQL 尚待真实 MySQL 验证。

## 目录与后续接入

- `common/`：响应、业务异常、MVC 异常处理和分页。
- `config/`：安全策略及密码编码器。
- `system/`：基础服务接口。
- `auth/`、`user/`、`category/`：账号业务、受控用户响应和分类查询。
- `market/`：商品与分类管理、订单与评价、私信与举报的 Controller、Service 和显式数据模型。
- `src/main/resources/mapper/`：UserMapper.xml、CategoryMapper.xml、MarketMapper.xml，参数使用 `#{...}`。
- `src/test/`：无数据库基础集成测试，不替代 MySQL 事务、触发器和并发验收。

接口约定见 [前后端交接建议](../docs/backend-frontend-handoff.md)，数据库边界见 [后端与 DBA 交接](../docs/backend-dba-handoff.md)，内部推进依据见 [后端计划](backend-plan.md)。

## 验证记录

联调请求集合和手动执行顺序见 [requests/README.md](requests/README.md)。原始设计的覆盖与缺口见 [design-coverage.md](design-coverage.md)，主要业务已有代码不等于原始构想全部实现。

2026-09-07 执行 `mvn verify -B -ntp`：BUILD SUCCESS，50 项测试通过，0 失败、0 错误、0 跳过，并生成可执行 JAR。基础测试包含真实随机 HTTP 端口、会话与 CSRF 生命周期。账号与业务 API、业务规则测试使用仅存在于测试代码的 Mapper 替身；mysql 装配测试使用 DataSource 替身，验证 Mapper 加载和事务代理但不连接数据库。

已按 Java 17 目标编译，在本机 JDK 25 运行；尚未在 JDK 17 运行时单独验证。

版本依据：[Spring Boot 3.5.11 发布说明](https://spring.io/blog/2026/02/19/spring-boot-3-5-11-available-now)、[MyBatis Starter 官方发布记录](https://github.com/mybatis/spring-boot-starter/releases)。

## 账号与分类接入说明

mysql 模式提供：

| 接口 | 请求 | 结果 |
| --- | --- | --- |
| POST /api/auth/register | phone、password、userName | 创建学生账号，返回公开字段，不自动登录 |
| POST /api/auth/login | phone、password | 更新会话 ID，保存认证状态，返回用户信息 |
| GET /api/users/me | 会话 Cookie | 读取当前用户资料，不含密码哈希 |
| GET /api/categories | 无 | 分类数组，字段 categoryId、cateName、cateDesc |

注册、登录前取得 CSRF token；登录成功后重新取得 token，旧 token 失效。退出也需要当前 token，退出后旧会话失效。角色由服务端读取，管理路径只允许管理员角色。

当前账号字段使用 Word 数据字典：sys_user(user_id, user_name, password, phone, avatar, intro, user_role, register_time)；分类使用 category(category_id, cate_name, cate_desc)。主键生成 32 位字符串，注册角色固定为 0，时间按 Asia/Shanghai 生成。手机号唯一约束是并发注册的数据库前提。

当前只实现已有字段长度与非空校验：手机号最长 20 字符、昵称最长 50 字符，密码非空且 UTF-8 不超过 BCrypt 的 72 字节限制。密码复杂度、手机号额外格式限制未自行制定。密码哈希保存为不带算法前缀的 BCrypt 格式。

错误码：PHONE_EXISTS（409），BAD_CREDENTIALS（401），INVALID_REQUEST（400）。非法注册 role/userId 字段不会改变后端生成的身份信息。

注册事务依赖真实数据库验证；MyBatis XML 解析通过不等于 SQL 已在 MySQL 执行通过。原始设计 SQL 未修改，业务映射按用户指示采用修正后的设计口径。订单状态已按用户确认沿用 PDM 的 0待付款、1待发货、2待收货、3完成、4取消、5售后。交易模块已实现，触发器关联更新按 DBA 最终定义再调整。

会话退出遵循 [Spring Security 官方处理流程](https://docs.spring.io/spring-security/reference/6.5/servlet/authentication/logout.html)，返回项目统一 JSON 响应。

## 本轮业务实现与验证边界

接口路径见前后端交接文档。新增实现覆盖该文档所列的资料修改、分类增改删、商品、订单、评价、私信与举报接口，尚未接入真实 MySQL。

- PATCH 资料：省略或 null 保留原值；空字符串可清空简介或头像地址，昵称不能留空。不能修改手机号、角色和用户 ID。
- 商品：发布状态为待审核；修改后重新审核。公开列表只列可售商品，已售详情可查看，待审核/驳回/下架详情限所有者和管理员。列表固定按发布时间和 ID 倒序，支持关键词、分类、价格、分页；暂不提供价格排序。售价和原价按十进制字符串返回，时间带 +08:00 时区。
- 订单：同一事务先锁商品再检查有效订单；金额取数据库售价。完成订单与标记已售在同一事务中执行。有效订单包括 0/1/2/3/5，取消订单不阻止再次购买；仅未支付订单允许取消。重复状态操作返回 409，不重复成交。没有自动超时取消。
- 评价：只允许已完成订单的买家评价一次，商品和评价人从订单取值；锁后使用当前读检查已存在评价。
- 私信：只查询当前用户与指定对方的会话；只有接收人可标记已读。消息按发送时间和 ID 倒序分页。
- 举报：绑定当前用户与商品；管理员填写处理结果，下架通过独立商品操作完成。Word 中举报没有时间字段，因此暂按 ID 稳定排序，不声称按举报时间排序。

订单仅使用 Word 的现有列加已确认的 PDM 状态编码，不自行增加 pay_status、pay_time、finish_time。评价保留 Word 中的商品与评价人外键。原设计没有商品封面字段，本轮没有添加 cover_url 或上传接口；头像和举报证据暂只保存已有的地址字段。

本轮测试覆盖参数校验、访问权限、状态流转、重复操作、金额来源、私信收发范围、SQL 参数绑定、Mapper 装配和事务代理。真实 MySQL 的 SQL 执行、外键与唯一约束、同时下单的互斥和事务回滚，以及前后端完整联调仍待完成。尚未为演示数据作安排，也未提交或推送代码。

## 打包与启动验证

在 backend 目录执行：

```powershell
mvn package -DskipTests -B -ntp
java -jar target/secondhand-backend-0.0.1-SNAPSHOT.jar --spring.profiles.active=local
```

有实际数据库时，先按上文配置 DB_URL、DB_USERNAME、DB_PASSWORD，再将启动参数改为 `--spring.profiles.active=mysql`。日常发布验证可使用 `mvn verify` 同时运行测试与打包；本次已按该命令完成全量验证。

自动检查打包后的基础服务（PowerShell 7）：

```powershell
./scripts/verify-packaged.ps1
```

该脚本在随机本地端口启动 JAR，检查 health、CSRF、401、403、退出及旧 token 失效，完成后关闭自己启动的 Java 进程。日志位于 target/packaged-verification，不包含账号密码或 token。

2026-09-07：`mvn verify -B -ntp` 返回 BUILD SUCCESS，50 项测试全部通过；打包 JAR 的 local 模式启动和基础检查返回 PASS，验证脚本能够自行关闭 Java 进程。请求集合共 42 项，已检查 JSON、变量引用和脚本语法；未在 Postman 与真实数据库中运行完整业务流程。打包输出与日志位于已忽略的 target 目录，未提交或推送。
