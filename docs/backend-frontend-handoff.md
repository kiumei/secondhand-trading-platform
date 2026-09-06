# 后端与前端交接建议

这份文档供前端同学安排页面、请求封装和联调使用。目前业务接口尚未实现，以下是后端建议采用的约定，可以先据此准备页面和 Mock 数据。基础工程已编写服务状态和 CSRF 接口，运行验证情况见 backend/README.md。业务范围优先沿用现有系统设计文档，接口细节在对应模块联调时逐项确定。

## 建议的联调顺序

| 批次 | 后端拟提供 | 前端可同步准备 |
| --- | --- | --- |
| 第一批 | 注册登录、当前用户、分类查询 | 登录注册页、登录状态、分类选择器 |
| 第二批 | 商品发布、我的商品、审核、列表和详情 | 发布表单、商品页、管理员审核页 |
| 第三批 | 下单、订单查询、交易动作、评价 | 买入/卖出订单页、操作按钮、评价表单 |
| 第四批 | 私信、举报和处理 | 消息页、举报表单、管理端处理页 |

建议先做校内自提的完整演示，支付仅作为模拟操作。收藏、求购、找回密码邮件、搜索联想和站点设置暂放后续。封面上传属于建议扩展，未接入前可以使用占位图，不影响先联调商品文字信息。

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
  "code": "GOODS_UNAVAILABLE",
  "message": "该商品当前不可购买",
  "data": null
}
```

建议请求封装统一处理 HTTP 400 参数错误、401 未登录、403 无权限、404 不存在、409 业务状态冲突、500 服务错误。遇到 401 清理本地用户状态并引导登录；403 不应直接当成登录失效。业务 code 是拟定值，正式提供接口时后端一并给出。

## 登录与权限建议

建议采用 Cookie Session，前端不需要自行保存 JWT。登录后调用 `GET /api/users/me` 获取当前用户；刷新页面时也通过该接口恢复状态。角色沿用设计文档：0 学生、1 管理员。页面隐藏无权限操作用于改善体验，最终权限由后端校验。

建议提供 `GET /api/auth/csrf`，返回 `data.token` 与 `data.headerName`。前端在注册、登录以及其他写请求前获取 token，按返回的 headerName 添加请求头；登录成功、退出后重新获取，避免使用已失效的 token。通过同源 Vite 代理请求时携带 Cookie。当前 CSRF 接口使用上述字段；注册、登录、退出仍待实现，会话刷新将在账号模块联调时验证。

注册、下单、发布等操作无需传当前用户角色或当前登录用户 ID。订单售价和卖家身份由后端读取商品确定。

## 接口草案

下表路径均需要添加 `/api` 前缀。

| 功能 | 方法与路径 | 建议请求或用途 |
| --- | --- | --- |
| 注册 | `POST /auth/register` | phone、password、userName |
| 登录/退出 | `POST /auth/login`、`POST /auth/logout` | 登录提交 phone、password；退出无需业务参数 |
| 当前用户 | `GET /users/me`、`PATCH /users/me` | 修改 userName、avatar、intro；手机号变更暂不开放 |
| 分类 | `GET /categories` | 返回 categoryId、cateName、cateDesc |
| 商品列表 | `GET /goods` | keyword、categoryId、minPrice、maxPrice、page、pageSize |
| 商品详情 | `GET /goods/{id}` | 商品信息、卖家基础信息、是否可购买 |
| 发布/修改 | `POST /goods`、`PUT /goods/{id}` | 见下方发布示例 |
| 我的商品 | `GET /users/me/goods` | 分页，可按 status 筛选 |
| 下架 | `POST /goods/{id}/off-shelf` | 由后端校验所有权和交易占用 |
| 待审核列表 | `GET /admin/goods?status=3` | 管理员分页查询 |
| 审核 | `POST /admin/goods/{id}/review` | decision 建议 PASS/REJECT；驳回附 rejectReason |
| 分类维护 | `POST /admin/categories`、`PUT /admin/categories/{id}`、`DELETE /admin/categories/{id}` | 分类有商品时删除可能被拒绝 |
| 创建订单 | `POST /orders` | 仅 goodsId |
| 订单列表/详情 | `GET /orders?side=buy`、`GET /orders?side=sell`、`GET /orders/{id}` | 列表分页；仅本人参与的订单 |
| 模拟支付 | `POST /orders/{id}/mock-pay` | 买家操作，页面标明模拟支付 |
| 交付/完成/取消 | `POST /orders/{id}/deliver`、`POST /orders/{id}/complete`、`POST /orders/{id}/cancel` | 建议分别由卖家交付、买家确认、买家取消未支付订单 |
| 评价 | `POST /orders/{id}/evaluation` | score、content |
| 商品评价列表 | `GET /goods/{id}/evaluations` | 分页 |
| 私信 | `POST /messages`、`GET /messages?peerId={id}` | 发送 receiveUserId、content；查询分页 |
| 已读 | `PATCH /messages/{id}/read` | 接收方操作 |
| 举报 | `POST /reports`、`GET /users/me/reports` | 提交 goodsId、reportType、reportContent、可选 proofImg |
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

商品响应建议包含 goodsId、上述商品信息、publishTime、goodsStatus、purchasable；详情附卖家公开昵称和头像，个人手机号不默认公开。原价和成色等可选项以已有数据字典为基础，最终必填规则随接口提供。

封面若接入，建议 `POST /uploads/images` 使用 multipart/form-data，字段名 file，返回 `data.url`，发布时增加可选 coverUrl。暂建议仅 JPG/PNG、最大 8 MB；这是扩展建议，尚未视为数据库既有字段。

## 状态展示建议

商品状态按现有 Word 文档：0 未售出、1 已售出、2 下架、3 待审核、4 驳回。建议前端统一维护字典，详情是否显示购买按钮还应结合 purchasable，不能只判断商品状态。

订单先按“待付款→待交付→待确认→完成”和“未付款可取消”的流程准备页面。具体数字编码在交易模块交付时提供，前端先不要散落硬编码。建议后端返回 statusText 和 allowedActions（当前用户可执行动作列表），帮助前端控制按钮；后端仍会重新检查每次操作是否合法。

重复点击建议临时禁用提交按钮；收到状态冲突后重新加载详情。私信第一版建议按需刷新或简单轮询，无需 WebSocket。
