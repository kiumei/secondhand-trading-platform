# 后端与前端交接建议

这份文档供前端同学安排页面、请求封装和联调使用。2026-09-08 已按实际数据库适配；最新对接差异与图片方案见 [协作对接](../backend/integration-notes.md)。商品举报已按当前表保存商品关联，可提交、查询和处理。下列账号、资料、分类、商品、订单、评价、私信和举报接口已编写并完成后端测试，真实 MySQL 和前后端联调尚待完成。服务状态、CSRF 和退出接口已实现，运行方式见 [后端说明](../backend/README.md)。业务范围优先沿用现有系统设计文档，接口细节在对应模块联调时逐项确定。

## 建议的联调顺序

| 批次 | 后端拟提供 | 前端可同步准备 |
| --- | --- | --- |
| 第一批 | 注册登录、当前用户、分类查询 | 登录注册页、登录状态、分类选择器 |
| 第二批 | 商品发布、我的商品、审核、列表和详情 | 发布表单、商品页、管理员审核页 |
| 第三批 | 下单、订单查询、交易动作、评价 | 买入/卖出订单页、操作按钮、评价表单 |
| 第四批 | 私信、举报和处理 | 消息页、举报表单、管理端处理页 |

建议先做校内自提的完整演示，支付仅作为模拟操作。功能删留按 DBA 确认文档和当前分工执行。商品图片已通过 goods_image 保存关联，最多4张，第一张作为封面。

## 请求与响应建议

- 统一使用 `/api` 前缀，JSON 字段采用 camelCase。
- 开发环境建议前端端口 5173、后端端口 8080；Vite 将 `/api` 原样代理到后端，不删除前缀。
- ID 在前端按字符串处理；金额建议按字符串传输，例如 `"12.34"`，由后端作精确金额计算。
- 时间建议采用带时区偏移的 ISO 8601 格式，例如 `2026-09-07T09:00:00+08:00`。
- 分页从第 1 页开始，默认每页 10 条，建议上限 50 条。

成功响应示例：

```json
{
  "code": "OK",
  "message": "成功",
  "data": {
    "items": [],
    "total": 0,
    "page": 1,
    "pageSize": 10
  }
}
```

失败示例（HTTP 409）：

```json
{
  "code": "STATE_CONFLICT",
  "message": "该商品当前不可购买",
  "data": null
}
```

建议请求封装统一处理 HTTP 400 参数错误、401 未登录、403 无权限、404 不存在、409 业务状态冲突、500 服务错误。遇到 401 清理本地用户状态并引导登录；403 不应直接当成登录失效。登录时密码正确但账号被封禁，返回 HTTP 403、ACCOUNT_BANNED。已有会话检测到账户封禁或密码、角色变更时失效，返回 HTTP 401、UNAUTHENTICATED。

## 登录与权限建议

建议采用 Cookie Session，前端不需要自行保存 JWT。登录后调用 `GET /api/users/me` 获取当前用户；刷新页面时也通过该接口恢复状态。角色沿用设计文档：0 学生、1 管理员。页面隐藏无权限操作用于改善体验，最终权限由后端校验。

已提供 `GET /api/auth/csrf`，返回 `data.token` 与 `data.headerName`。前端在注册、登录以及其他写请求前获取 token，按返回的 headerName 添加请求头；登录成功、退出后重新获取，避免使用已失效的 token。通过同源 Vite 代理请求时携带 Cookie。当前 CSRF 接口使用上述字段；登录成功会刷新会话并使旧 token 失效，退出会使会话失效。注册成功不自动登录。账号接口需要 mysql 模式，local 模式仅提供基础接口。

用户 role 表示身份（0学生、1管理员），status 表示账号状态（0正常、1封禁），两者不可混用。

举报 reportType 当前按数字传 1～5：1假冒伪劣、2欺诈行为、3辱骂骚扰、4违规违禁品、5其他；handleStatus 返回数字0待处理、1已处理。提交成功返回举报记录及 reportId、goodsId；处理举报不自动下架商品。

注册、下单、发布等操作无需传当前用户角色或当前登录用户 ID。订单售价和卖家身份由后端读取商品确定。

## 当前接口

下表路径均需要添加 `/api` 前缀。

| 功能 | 方法与路径 | 建议请求或用途 |
| --- | --- | --- |
| 注册 | `POST /auth/register` | phone、password、userName |
| 登录/退出 | `POST /auth/login`、`POST /auth/logout` | 登录提交 phone、password；退出无需业务参数 |
| 当前用户 | `GET /users/me`、`PATCH /users/me` | 读取和修改 userName、avatar、intro、address；手机号变更暂不开放 |
| 分类 | `GET /categories` | 返回 categoryId、cateName、cateDesc（当前为 null）；不保存描述 |
| 商品列表 | `GET /goods` | keyword、categoryId、minPrice、maxPrice、sellerId、page、pageSize |
| 商品详情 | `GET /goods/{id}` | 商品信息、卖家基础信息、是否可购买 |
| 发布/修改 | `POST /goods`、`PUT /goods/{id}` | 发布者修改后重新进入待审核，见下方请求示例 |
| 我的商品 | `GET /users/me/goods` | 分页，可按 status 筛选 |
| 下架 | `POST /goods/{id}/off-shelf` | 由后端校验所有权和交易占用 |
| 待审核列表 | `GET /admin/goods?status=3` | 管理员分页查询 |
| 审核 | `POST /admin/goods/{id}/review` | decision 建议 PASS/REJECT；驳回附 rejectReason |
| 审核前修改商品 | `PUT /admin/goods/{id}` | 管理员仅可修改待审核商品，修改后再执行审核 |
| 分类维护 | `POST /admin/categories`、`PUT /admin/categories/{id}`、`DELETE /admin/categories/{id}` | 分类有商品时删除可能被拒绝 |
| 创建订单 | `POST /orders` | 仅 goodsId |
| 订单列表/详情 | `GET /orders?side=buy`、`GET /orders?side=sell`、`GET /orders/{id}` | 列表分页；仅本人参与的订单 |
| 模拟支付 | `POST /orders/{id}/mock-pay` | 买家操作，页面标明模拟支付 |
| 交付/完成/取消 | `POST /orders/{id}/deliver`、`POST /orders/{id}/complete`、`POST /orders/{id}/cancel` | 建议分别由卖家交付、买家确认、买家取消未支付订单 |
| 评价 | `POST /orders/{id}/evaluation` | score、content |
| 商品评价列表 | `GET /goods/{id}/evaluations` | 分页 |
| 我的评价 | `GET /users/me/evaluations` | 分页，只返回当前用户提交的评价 |
| 私信 | `POST /messages`、`GET /messages?peerId={id}` | 发送 receiveUserId、content；查询分页 |
| 已读 | `PATCH /messages/{id}/read` | 接收方操作 |
| 举报 | `POST /reports`、`GET /users/me/reports` | POST 提交 goodsId、reportType、reportContent，可选 proofImg；GET 查询本人举报 |
| 举报处理 | `GET /admin/reports`、`POST /admin/reports/{id}/handle` | 提交 handleResult |

商品发布建议请求（tradeType=2 暂按现有模型的自提含义，接口接入时再落实）：

```json
{
  "categoryId": "分类ID",
  "title": "数据库教材",
  "sellPrice": "12.34",
  "originalPrice": "45.00",
  "tradeType": 2,
  "goodsDesc": "无缺页，可校内自提",
  "qualityLevel": 4
}
```

商品响应建议包含 goodsId、上述商品信息、publishTime、goodsStatus、purchasable；详情附卖家公开昵称和头像，个人手机号不默认公开。发布时 categoryId、title、sellPrice、tradeType、goodsDesc 必填，originalPrice 和 qualityLevel 可选。金额最多两位小数；tradeType 沿用 1邮寄、2自提、3两者，当前不提供物流追踪。

已提供 POST /api/uploads/images（multipart 字段 file，JPEG/PNG、5 MB），返回 data.url/width/height；GET /api/media/{filename} 公开访问。此地址适用于公开商品图和头像，不用于私密凭证。商品发布和编辑支持 images 地址数组，最多4张；响应返回 images 和 coverUrl。编辑时省略或 null 保留图片，空数组清空图片，第一张为封面。

## 状态展示建议

商品状态按现有 Word 文档：0 未售出、1 已售出、2 下架、3 待审核、4 驳回。建议前端统一维护字典，详情是否显示购买按钮还应结合 purchasable，不能只判断商品状态。

订单沿用系统设计 PDM 的状态：0待付款、1待发货、2待收货、3完成、4取消、5售后。第一版流程为“待付款→待发货→待收货→完成”，未付款可取消，售后暂不开放操作。建议统一维护状态字典。当前订单返回 orderStatus，尚未返回 statusText 或 allowedActions；前端可按上述字典显示，后端会检查每次操作的权限和旧状态。

重复点击建议临时禁用提交按钮；收到状态冲突后重新加载详情。私信第一版建议按需刷新或简单轮询，无需 WebSocket。

资料 PATCH 中省略或 null 表示保留原值，空字符串可清空头像 URL、简介和收货地址。address 最长255字符，仅用于当前用户资料；公开卖家资料不返回收货地址，订单暂未保存地址快照。商品列表、订单列表、评价和消息采用时间与 ID 倒序分页；举报当前按 ID 排序。业务状态冲突返回 STATE_CONFLICT（409），数据库约束冲突返回 DATA_CONFLICT（409），锁冲突返回 RETRY_REQUIRED（409）。
