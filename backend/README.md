# 后端基础工程

采用 Spring Boot 3.5.11、原生 MyBatis Starter 3.0.5、MySQL 驱动和 Spring Security，Java 编译目标为 17。版本固定用于可复现构建，不代表最新版本。

## 当前范围

已实现基础响应与安全配置、注册登录退出、当前用户与资料修改、两级分类管理、商品发布编辑审核下架与检索（含最多 4 张商品图片）、收藏、订单创建与模拟支付/交付/完成/取消、评价（强制绑定真实订单）、私信、举报处理，以及管理员侧仪表盘、用户管理（封禁/解封/重置密码）、订单管理、评价管理。业务在 mysql 模式装配，SQL 使用原生 MyBatis XML；真实数据库读写尚待联调。未实现图片文件上传（图片仅保存地址）、真实支付和售后操作；不提供默认登录账号。

按《前端确认文档（DBA 测试员答复版）》完成的对齐：

- 列名以 DBA 重新对齐的 `db/secondhand_full.sql` 为准（goods.user_id/trade_method/description/quality、category.cate_id/parent_id/sort、orders.buyer_id/seller_id/pay_status/pay_time/finish_time、evaluate.eva_id/order_id/score/content/eva_time、report.user_id/result/report_time、sys_user.role/status）。除 orders.order_id 为 varchar(32) 手工流水号（UUID 去连字符）外，其余表主键均为 int 自增，插入后通过同事务连接的 `SELECT LAST_INSERT_ID()` 取回。
- 状态码：商品 goods_status 0待审核、1上架、2下架、3已售出、4驳回（DBA 特别修订口径）；订单 order_status 0待付款、1待发货、2待收货、3完成、4取消、5售后；pay_status 0未支付、1已支付；用户 status 0正常、1封禁。
- API JSON 字段名沿用确认文档口径（goodsId/sellPrice/tradeType/goodsDesc/qualityLevel/goodsStatus/cateId/evaluateContent 等），并在 XML 中完成到数据库列名的映射。
- 登录标识为手机号（char(11) 唯一），注册/登录统一校验 11 位数字；被封禁用户（status=1）登录返回 403 ACCOUNT_BANNED。
- 评价必须绑定真实已完成订单（D2）：订单号来自请求路径，商品与评价人由订单推导，禁止传 0；evaluate.order_id 唯一约束兜底重复提交。
- 举报通过 goods_id 绑定商品，记录举报人、类型、内容、证据与处理结果（result）。

当前不会创建业务表、修改原 SQL、插入演示数据或创建触发器。按用户安排，等 DBA 完成数据库后根据其实际触发器定义调整代码；若没有定义，不自行新增触发器。当前完成订单的商品售出更新由完整 SQL 中的触发器负责，后端不重复更新。

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

2026-09-08 按 DBA 答复版完成对齐后执行 `mvn test -B -ntp`：BUILD SUCCESS，64 项测试通过，0 失败、0 错误、0 跳过（本机以临时下载的 JDK 17.0.2 与 Maven 3.9.16 执行，Java 17 目标）。测试包含真实随机 HTTP 端口、会话与 CSRF 生命周期。账号与业务 API、业务规则测试使用仅存在于测试代码的 Mapper 替身；mysql 装配测试使用 DataSource 替身，验证 Mapper 加载和事务代理但不连接数据库。同日执行 `mvn package -DskipTests` 并以 local 模式启动打包 JAR， health、CSRF、401/403、退出与旧 token 失效检查全部 PASS。

已按 Java 17 目标编译，在本机 JDK 25 运行；尚未在 JDK 17 运行时单独验证。

版本依据：[Spring Boot 3.5.11 发布说明](https://spring.io/blog/2026/02/19/spring-boot-3-5-11-available-now)、[MyBatis Starter 官方发布记录](https://github.com/mybatis/spring-boot-starter/releases)。

## 账号与分类接入说明

mysql 模式提供：

| 接口 | 请求 | 结果 |
| --- | --- | --- |
| POST /api/auth/register | phone（11 位数字）、password、userName | 创建学生账号，返回公开字段，不自动登录 |
| POST /api/auth/login | phone、password | 更新会话 ID，保存认证状态，返回用户信息；封禁账号返回 403 ACCOUNT_BANNED |
| GET /api/users/me | 会话 Cookie | 读取当前用户资料，不含密码哈希 |
| GET /api/categories | 无 | 两级分类数组，字段 cateId、cateName、parentId、sort（parent_id=0 为一级分类） |

注册、登录前取得 CSRF token；登录成功后重新取得 token，旧 token 失效。退出也需要当前 token，退出后旧会话失效。角色由服务端读取，管理路径只允许管理员角色。

当前账号字段使用数据库转储口径：sys_user(user_id, user_name, phone, password, avatar, intro, role, status, register_time)；分类使用 category(cate_id, cate_name, parent_id, sort)。除 orders.order_id 为 32 位手工流水号外，主键由数据库自增生成，注册角色固定 0、状态固定 0，时间按 Asia/Shanghai 生成。手机号 char(11) 唯一约束是并发注册的数据库前提。

当前只实现已有字段长度与非空校验：手机号 11 位数字、昵称最长 20 字符，密码非空且 UTF-8 不超过 BCrypt 的 72 字节限制。密码复杂度未自行制定。密码哈希保存为不带算法前缀的 BCrypt 格式。

错误码：PHONE_EXISTS（409），BAD_CREDENTIALS（401），ACCOUNT_BANNED（403），INVALID_REQUEST（400）。非法注册 role/userId 字段不会改变后端生成的身份信息。

注册事务依赖真实数据库验证；MyBatis XML 解析通过不等于 SQL 已在 MySQL 执行通过。原始建表 SQL 未修改，业务 SQL 列名严格对齐 DBA 重新对齐的 `db/secondhand_full.sql` 转储。商品状态采用 DBA 修订口径：0待审核、1上架、2下架、3已售出、4驳回；订单状态沿用 PDM 的 0待付款、1待发货、2待收货、3完成、4取消、5售后。交易模块已实现，触发器关联更新按 DBA 最终定义再调整。

会话退出遵循 [Spring Security 官方处理流程](https://docs.spring.io/spring-security/reference/6.5/servlet/authentication/logout.html)，返回项目统一 JSON 响应。

## 本轮业务实现与验证边界

接口路径见前后端交接文档，新增实现覆盖收藏、商品多图、两级分类与管理员端点，尚未接入真实 MySQL。

- PATCH 资料：省略或 null 保留原值；空字符串可清空简介或头像地址，昵称不能留空。不能修改手机号、角色和用户 ID。
- 商品：发布状态为待审核（0）；修改后重新审核。公开列表只列上架商品（1），已售出（3）详情可查看，待审核/下架/驳回（0/2/4）详情限所有者和管理员。列表默认按发布时间和 ID 倒序，支持关键词、分类（含子分类）、价格区间、`sort=latest|priceAsc|priceDesc` 与分页。售价和原价按十进制字符串返回，时间带 +08:00 时区。发布与编辑支持 `images` 地址列表（最多 4 张，第一张为封面，存 goods_image 表；编辑时整体替换，null 保留原图）；列表返回 coverUrl，详情返回 images。
- 订单：同一事务先锁商品再检查有效订单；金额取数据库售价；创建时 pay_status=0。模拟支付置 pay_status=1 并写 pay_time；确认完成写 finish_time 并在同一事务把商品置为已售出（3）。有效订单包括 0/1/2/3/5，取消订单不阻止再次购买；仅未支付订单允许取消。重复状态操作返回 409，不重复成交。没有自动超时取消。
- 评价：只允许已完成订单的买家评价一次，必须绑定路径中的真实订单 ID（禁止传 0）；商品与评价人由订单推导；锁后使用当前读检查已存在评价，evaluate.order_id 唯一约束兜底重复提交。`GET /api/users/{id}/evaluations` 公开返回指定用户作为卖家收到的评价；`GET /api/users/me/evaluations` 返回当前用户提交的评价。
- 私信：只查询当前用户与指定对方的会话；只有接收人可标记已读。消息按发送时间和 ID 倒序分页。数据库仅存文字内容，不支持图片消息。
- 举报：记录举报人、类型、内容与证据地址；report 表无商品外键，不再绑定商品。管理员填写处理结果（result 列），下架通过独立商品操作完成。列表按举报时间和 ID 倒序分页。
- 收藏：POST/DELETE `/api/favorites`；`GET /api/favorites` 按收藏时间倒序分页返回收藏的商品；`GET /api/favorites/{goodsId}` 查询是否已收藏。
- 管理员（B1–B4）：`GET /api/admin/dashboard` 返回用户数、商品数、订单数、销售额（已完成订单合计）与待审核商品数；`GET /api/admin/users` 关键词分页，`ban/unban` 切换 status（0 正常/1 封禁，管理员账号不可封禁），`reset-password` 未传密码时生成 8 位随机密码并仅在响应中返回一次；`GET /api/admin/orders` 与 `GET /api/admin/evaluations`（`DELETE` 删除违规评价）支持分页与状态筛选；两级分类管理校验父分类必须为一级，删除前检查商品与子分类。

数据库写入严格使用 db/secondhand_full.sql 的列（含 pay_status、pay_time、finish_time、report_time、result），不在 SQL 中使用转储之外的列名；API 字段名与列名的映射集中在 Mapper XML。

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

2026-09-08：`mvn test -B -ntp` 返回 BUILD SUCCESS，64 项测试全部通过；`mvn package -DskipTests` 生成打包 JAR，local 模式启动和基础检查（health、CSRF、401/403、退出、旧 token 失效）返回 PASS，验证进程自行关闭。请求集合共 42 项，已按新口径修正分类/商品/举报字段并检查 JSON、变量引用和脚本语法；收藏、仪表盘与管理员用户新增端点暂未加入集合；未在 Postman 与真实数据库中运行完整业务流程。打包输出与日志位于已忽略的 target 目录，未提交或推送。
