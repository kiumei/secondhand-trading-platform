# 校园二手交易平台（secondhand-trading-platform）

面向校园场景的二手交易平台，前后端分离 + MySQL。用户（学生/管理员）通过手机号注册登录，可发布、浏览、搜索二手商品，收藏商品，下单支付（模拟），交易完成后互相评价，并通过私信沟通、向管理员举报违规内容；管理员负责商品审核、分类管理、用户管理（封禁/解封/重置密码）、订单与评价管理及数据统计。

> 后端已按《[前端确认文档- DBA测试员答复版](docs/前端确认文档-%20DBA测试员答复版.md)》对齐最新数据库基线；前端目前仍为浏览器 mock 数据，尚未接入真实后端。

## 技术栈

| 端 | 技术 |
| --- | --- |
| 后端 | Java 17、Spring Boot 3.5、Spring Security（Cookie Session + CSRF）、MyBatis（XML）、MySQL 连接器 |
| 前端 | Vue 3.5、Vite、Pinia、Vue Router、Element Plus、wangEditor、TypeScript（当前为纯前端 mock） |
| 数据库 | MySQL 8.0、InnoDB、utf8mb4 |

## 目录结构

```
secondhand-trading-platform/
├── backend/                 # 后端（Spring Boot）
│   ├── src/main/java/com/campus/secondhand/
│   │   ├── auth/            # 注册/登录/退出/当前用户
│   │   ├── user/            # 用户持久层 + 管理员用户管理
│   │   ├── category/        # 两级分类
│   │   ├── market/          # 商品/收藏/订单/评价/私信/举报
│   │   ├── system/          # 健康检查、CSRF、管理员仪表盘
│   │   ├── common/          # 统一响应、异常、分页、状态码常量
│   │   └── config/          # 安全策略、运行模式校验、时间序列化
│   ├── src/main/resources/mapper/   # MyBatis XML（全部业务 SQL）
│   ├── src/test/            # 无数据库单元/集成测试（64 项）
│   ├── requests/            # Postman 请求集合
│   └── pom.xml
├── frontend/                # 前端（Vue 3，当前 mock）
│   └── src/api/             # 接口层（现为 localStorage 模拟，待接真实后端）
├── db/
│   └── secondhand_full.sql  # 最新数据库结构 + 数据（以此为准）
├── docs/                    # 需求、确认文档、前后端/DBA 交接文档
└── README.md
```

## 环境要求

- JDK 17+、Maven 3.9+
- Node.js 18+、npm
- MySQL 8.0（库名建议 `secondhand`，字符集 `utf8mb4`）

## 快速开始

### 1. 初始化数据库

用 MySQL 客户端（Navicat / 命令行）执行 [`db/secondhand_full.sql`](db/secondhand_full.sql)，包含全部表结构、约束和演示数据。**不要**让后端自动建表或改库（应用启动不会修改数据库）。

### 2. 启动后端（8080）

```powershell
cd backend
mvn test                 # 运行 64 项测试

# 方式一：local 模式（无数据库，仅基础 HTTP/安全功能，用于开发验证）
mvn spring-boot:run "-Dspring-boot.run.profiles=local"

# 方式二：mysql 模式（真实业务）
$env:DB_URL = 'jdbc:mysql://localhost:3306/secondhand?connectionTimeZone=Asia/Shanghai'
$env:DB_USERNAME = '你的账号'
$env:DB_PASSWORD = '你的密码'
mvn spring-boot:run "-Dspring-boot.run.profiles=mysql"
```

启动后检查：`GET http://localhost:8080/api/health` 返回 `data.status=UP`。

### 3. 启动前端（5173）

```powershell
cd frontend
npm install
npm run dev
```

开发服务器将 `/api` 代理到后端 8080。**注意：前端当前读写 localStorage 模拟数据，接真实后端需按 [前后端交接文档](docs/backend-frontend-handoff.md) 改造 `src/api/*`。**

## 功能清单

### 后端已实现（mysql 模式）

| 模块 | 接口要点 |
| --- | --- |
| 账号 | 注册（11 位手机号唯一）、登录（封禁账号 403）、退出、当前用户、修改资料 |
| 分类 | 两级分类查询；管理员增/改/删（校验父级为一级，删除前检查商品与子分类） |
| 商品 | 发布/编辑（重新进入待审核）、审核通过与驳回、上下架、检索（关键词/分类含子类/价格区间/排序 latest、priceAsc、priceDesc）、多图（`images` 最多 4 张，存 `goods_image`，列表返回封面、详情返回全部） |
| 收藏 | 添加/取消/我的收藏分页/是否已收藏 |
| 订单 | 下单（锁商品防超卖，金额取库内售价）、模拟支付（写 pay_status/pay_time）、发货、确认完成（写 finish_time 并置商品已售出）、取消；管理员订单列表/详情 |
| 评价 | 仅已完成订单的买家可评、一单一次、强制绑定真实订单 ID；商品评价列表、我提交的、用户收到的；管理员评价列表/删除 |
| 私信 | 指定对方收发、会话分页、标记已读 |
| 举报 | 提交（类型/内容/证据地址）、我的举报、管理员处理 |
| 管理员 | 仪表盘（用户/商品/订单数、销售额、待审核数）、用户列表/封禁/解封/重置密码 |

### 前端现状

1. 开头说明：从「认证已接、其余 mock」改成「全部接真实后端」
2. 技术栈：加了 axios
3. 已实现功能：全部标注「均接真实后端」，并更新了分类（单级 6 分类）、商品（图片走上传）、订单（去掉修改地址）、私信图片（URL 存 content）等细节
4. 对齐情况：改成「无 mock 残留差异」，列了核心契约
5. 架构：改成 axios + HTTP + Vite 代理，注明 mock 数据层已不再使用
6. 剩余事项：改成收尾清单（删 mock、删 views 私货、公开资料不含手机号、图片数据问题、端到端联调）
7. 新增「测试账号」：管理员/学生各列了账号

## 状态码约定（以数据库为准，禁止字符串）

| 项 | 编码 |
| --- | --- |
| 商品 goods_status | 0 待审核、1 上架、2 下架、3 已售出、4 驳回 |
| 订单 order_status | 0 待付款、1 待发货、2 待收货、3 完成、4 取消、5 售后（本轮不开放） |
| 订单 pay_status | 0 未支付、1 已支付 |
| 用户 status | 0 正常、1 封禁 |
| 私信 is_read / 举报 handle_status | 0/1 |

## 接口约定

- 统一前缀 `/api`；响应包装 `{code, message, data}`；分页 `{items, total, page, pageSize}`。
- ID 与金额均为字符串；时间为带 `+08:00` 的 ISO 8601。
- 认证用 Cookie Session；所有写请求需先 `GET /api/auth/csrf` 取 token，并按返回的 `headerName` 携带请求头。
- 常见错误码：`UNAUTHENTICATED`(401)、`FORBIDDEN`(403)、`INVALID_REQUEST`(400)、`NOT_FOUND`(404)、`STATE_CONFLICT`/`PHONE_EXISTS`/`DATA_CONFLICT`(409)。

完整清单见 [backend/README.md](backend/README.md) 与 [docs/backend-frontend-handoff.md](docs/backend-frontend-handoff.md)，可直接导入 [backend/requests/secondhand.postman_collection.json](backend/requests/secondhand.postman_collection.json) 联调。

## 文档索引

| 文档 | 内容 |
| --- | --- |
| [docs/requirements.md](docs/requirements.md) | 原始需求 |
| [docs/前端确认文档- DBA测试员答复版.md](docs/前端确认文档-%20DBA测试员答复版.md) | 功能删留与字段/状态对齐基线（本次改造依据） |
| [docs/backend-frontend-handoff.md](docs/backend-frontend-handoff.md) | 前后端接口交接 |
| [docs/backend-dba-handoff.md](docs/backend-dba-handoff.md) | 数据库/事务/触发器协作边界 |
| [backend/README.md](backend/README.md) | 后端运行、接口与验证记录 |
| [backend/src/main/resources/mapper/README.md](backend/src/main/resources/mapper/README.md) | SQL 列名对齐说明 |

## 当前状态与分工

- ✅ 后端：已对齐最新 SQL 基线，`mvn test` 64 项通过；真实 MySQL 执行、并发与事务回滚待 DBA 环境验收。
- ✅  前端：mock → 真实接口接入
- ⏳ DBA：提供数据库环境与连接信息；如后续新增触发器，后端将按实际定义调整关联更新逻辑。

## 常见问题

- **401 UNAUTHENTICATED**：未登录或会话失效，先调用登录接口。
- **403 FORBIDDEN**：写请求缺少有效 CSRF token（登录/退出后需重新获取），或访问了无权限的管理接口。
- **409 STATE_CONFLICT**：状态已变化（如商品被他人下单、订单重复操作），刷新后重试。
- **启动报错“请且仅启用 local 或 mysql”**：必须且只能激活一种运行模式；mysql 模式需完整配置 `DB_URL`、`DB_USERNAME`、`DB_PASSWORD`。
