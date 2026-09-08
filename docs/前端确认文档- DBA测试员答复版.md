# 前端确认文档

> 目的：梳理前端当前已实现功能、与后端接口的差异，供组内确认「哪些功能保留、哪些删除、字段/状态如何对齐」，作为后续前端对齐后端（设计文档）的依据。
>
> 生成时间：2026-09-08

---

## 一、前端已有功能（mock 阶段）

当前前端为纯前端 mock：数据存 localStorage，接口签名按可替换真实后端设计。技术栈 Vue 3.5 + Vite + Pinia 4 + Element Plus + wangEditor 5 + TypeScript。

### 1. 用户体系
- 注册 / 登录（登录态存 localStorage，有效期 1 天；登录名用 `username`）
- 角色区分：学生 / 管理员，路由守卫控制权限
- 封禁 / 解封用户（被封禁用户无法登录）
- 管理员重置用户密码
- 个人资料编辑、修改密码
- 用户个人主页：头像、简介、统计（在售 / 评价 / 评分）、联系方式、在售商品、收到的评价

### 2. 商品分类
- 两级分类：4 个实物父类 × 2 子类
  - 学习考试（教材文具 / 书籍资料）
  - 数码装备（手机电脑 / 数码配件）
  - 宿舍生活（宿舍用品 / 日常个护）
  - 穿搭休闲（运动服饰 / 零食美妆）
- 校园服务独立入口：技能服务 / 回收（Dock 栏进入）

### 3. 商品
- 发布：圆形主图预览、多图上传（最多 4 张）、名称字数计数、两级级联分类、成色标签组、价格/原价、富文本详情、所在地级联选择
- 字段：名称、售价、原价、描述（富文本）、成色等级、驳回原因、发布时间、商品状态（5 态）
- 额外字段：多图、所在地、浏览量、想要数、包邮、卖家名
- 浏览 / 搜索 / 排序（综合 / 最新 / 价格 / 最想要）

### 4. 订单
- 完整订单流：下单 → 待支付 → 已支付 → 已发货 → 已完成（另有已取消态）
- 订单详情弹窗（买卖双方电话 / 地址）
- 状态变更自动通知对方（发货通知买家、确认收货通知卖家）

### 5. 评价
- 评分（1-5 星）+ 文字评价
- 商品详情页、用户主页展示评价

### 6. 私信
- 会话列表 + 聊天窗口
- 发送文字 + 图片
- 在线状态提示（头像绿点 / 灰点）
- 新建会话入口

### 7. 举报
- 商品详情页举报（填原因）
- 管理员举报处理

### 8. 管理员功能
- 仪表盘（商品数 / 用户数 / 订单数 / 销售额统计）
- 商品审核（通过 / 驳回 + 原因 / 下架）
- 分类管理、用户管理、举报处理、公告管理、评价管理、订单管理、系统设置

### 9. 其他
- 首页三栏布局、分类推荐卡片、Banner、精选好物
- 收藏
- 主题切换（浅色 / 深色 / 跟随系统）
- 初始化向导（外观 / 站点信息 / 管理员账号 / 首页配置 / SMTP）
- 校园地点数据（南昌大学全校区建筑 + 快递站点）

---

## 二、与后端不同的功能（差异对照）

### 1. 认证方式

| 项 | 前端现状 | 后端 |
|----|---------|------|
| 登录态 | localStorage 存 user 对象 | Cookie Session + CSRF token |
| 登录标识 | `username` | `phone`（手机号） |
| 注册字段 | username / password / nickname / phone | phone / password / userName |

### 2. 字段命名差异（前端 → 后端/设计文档）

| 实体 | 前端字段 | 后端/文档字段 | 主要差异 |
|------|---------|--------------|---------|
| 用户 | id, username, password, nickname, phone, address, bio, role('student'/'admin'), avatar, banned, online | userId, userName, password, phone, avatar, intro, user_role(0/1), register_time | 前端无 register_time；role 字符串 vs 数字；前端多 address/banned/online |
| 分类 | id, name, parentId | categoryId, cateName, cateDesc | 前端两级(parentId) vs 后端单级；前端无 cateDesc |
| 商品 | id, title, desc, price, originalPrice, categoryId, images[], status(字符串), type('sell'/'want'), condition, location, freeShipping, sellerName, wantCount, views | goodsId, publishUserId, cateId, title, sellPrice, originalPrice, tradeType(1/2/3), goodsDesc, qualityLevel(1-5), rejectReason, publishTime, goodsStatus(0-4), sellerName, cateName, purchasable | 前端多 images/location/freeShipping/wantCount/views/type('want')；condition 字符串 vs qualityLevel 数字；status 字符串 vs goodsStatus 数字；前端无 tradeType |
| 订单 | id, goodsId, buyerId, sellerId, price, status(字符串), logistics | orderId, buyerId, sellerId, goodsId, orderPrice, orderStatus(0-5), createTime | 前端 5 态 vs 后端 6 态；前端多 logistics |
| 评价 | id, orderId, goodsId, userId, score, content | evaluateId, orderId, goodsId, evaluateUserId, score, evaluateContent, evaluateTime | 字段命名；前端写评价时 orderId 传 0（未真正绑定订单） |
| 私信 | id, from, to, content, image | msgId, sendUserId, receiveUserId, content, isRead, sendTime | 前端多 image；前端无 isRead |
| 举报 | id, goodsId, userId, reason, status('pending'/'done') | reportId, reportUserId, goodsId, reportType, reportContent, proofImg, handleStatus, handleResult | 前端无 reportType/proofImg/handleResult |

### 3. 状态码差异

| 项 | 前端 | 后端/设计文档 |
|----|------|--------------|
| 商品状态 | 'on'/'sold'/'off'/'pending'/'rejected'（字符串 5 态） | 0 未售出 / 1 已售出 / 2 下架 / 3 待审核 / 4 驳回（数字 5 态） |
| 订单状态 | 'unpaid'/'paid'/'shipped'/'done'/'cancelled'（5 态） | 0 待付款 / 1 待发货 / 2 待收货 / 3 完成 / 4 取消 / 5 售后（数字 6 态） |
| 交易方式 | type 'sell'/'want' | tradeType 1 邮寄 / 2 自提 / 3 两者 |

> 【DBA/测试员特别修改】：**商品状态码请以此为准：0待审核、1上架、2下架、3已售出、4驳回（旧文档“0未售出”已作废，数据库和后端以此为准）**。订单状态码为：0待付款、1待发货、2待收货、3完成、4取消、5售后。

### 4. 分类层级

- 前端：两级分类（父类 + 子类，含 parentId）
- 后端/设计文档：单层分类（category_id, cate_name, cate_desc）

> 【DBA/测试员修改】：数据库 `category` 表存在 `parent_id` 字段，**已支持两级分类**，前端和文档可以安心保留两级。

### 5. 前端有、后端未实现的功能

| 功能 | 说明 |
|------|------|
| 商品多图 | 设计文档 goods 无图片字段，后端无上传接口 |
| 收藏 | 后端无收藏接口 |
| 公告 | 后端无公告接口 |
| 站点设置 / 初始化向导（SMTP 等） | 后端无对应接口 |
| 两级分类 | 后端只返回扁平分类 |
| 想要数 / 浏览量 / 在线状态 / 包邮 / 所在地 | 设计文档无这些字段 |
| 求购（type='want'） | 后端 tradeType 是交易方式（邮寄/自提/两者），非求购 |
| 找回密码邮件、搜索联想 | 后端明确暂不做 |

> 【DBA/测试员修改】：商品多图已新增 `goods_image` 表支持；收藏已新增 `favorite` 表支持。其余（公告、系统设置、想要数等）数据库无表，确认删除。

### 6. 后端有、前端没有

| 功能 | 说明 |
|------|------|
| CSRF token 机制 | 前端需接入（获取 token 并随写请求携带） |
| 退出接口 | `POST /api/auth/logout` |
| 商品 `purchasable` 字段 | 后端按有效订单计算是否可购买 |
| 订单 6 态（含售后） | 前端为 5 态 |

---

## 三、需要确认的事项

> 请逐项确认「需要 / 不需要」，作为前端删改的依据。

### A. 功能删留

| # | 功能 | 现状 | 设计文档是否有 | 建议（含DBA/测试员答复） |
|---|------|------|--------------|------|
| A1 | 收藏 | 前端有，后端无 | 无 | **确认保留**（已建 `favorite` 表） |
| A2 | 公告 | 前端有，后端无 | 无 | **确认删除** |
| A3 | 站点设置 / 初始化向导 | 前端有，后端无 | 无 | **确认删除** |
| A4 | 商品多图上传/展示 | 前端有，后端无 | 无 | **确认保留**（已建 `goods_image` 表，支持4张） |
| A5 | 两级分类 | 前端有 | 无（单层） | **确认保留**（数据库有 `parent_id`） |
| A6 | 校园服务入口（技能服务/回收） | 前端有 | 无 | **确认删除** |
| A7 | 想要数 | 前端有 | 无 | **确认删除** |
| A8 | 浏览量 | 前端有 | 无 | **确认删除** |
| A9 | 包邮 | 前端有 | 无 | **确认删除** |
| A10 | 所在地（级联选择） | 前端有 | 无 | **确认删除** |
| A11 | 在线状态 | 前端有 | 无 | **确认删除** |
| A12 | 求购（type='want'） | 前端有 | 无（tradeType 为交易方式） | **确认删除** |

### B. 管理员功能删留

设计文档 1.2.2 只明确「商品审核 / 商品分类管理 / 举报处理」三类管理员功能，以下为前端额外实现：

| # | 功能 | 文档是否明确 | 建议（含DBA/测试员答复） |
|---|------|------------|------|
| B1 | 仪表盘（商品/用户/订单/销售额统计） | 未明确 | **确认保留**（数据库支持聚合查询） |
| B2 | 用户管理（封禁/解封/重置密码） | 未明确 | **确认保留**（`sys_user` 表有 `status` 字段） |
| B3 | 评价管理 | 未明确 | **确认保留** |
| B4 | 订单管理 | 未明确 | **确认保留** |
| B5 | 公告管理 | 无 | **确认删除** |
| B6 | 系统设置 | 无 | **确认删除** |

### C. 字段与状态对齐

| # | 事项 | 建议（含DBA/测试员答复） |
|---|------|------|
| C1 | 字段名统一为后端/文档口径（goodsId/sellPrice/tradeType/goodsDesc/qualityLevel/goodsStatus 等） | **必须统一**，严格遵循最新SQL命名 |
| C2 | 状态码由字符串改为数字（商品 0-4、订单 0-5） | **必须修改**（商品：0待审核，1上架，2下架，3已售出，4驳回；订单：0待付款，1待发货，2待收货，3完成，4取消，5售后） |
| C3 | 登录标识由 username 改为 phone | **必须修改**（手机号唯一约束已建立） |
| C4 | 认证由 localStorage 存 user 对象改为 Cookie Session + CSRF | 按后端接口执行（DBA不涉及） |

### D. 其他

| # | 事项 | 建议（含DBA/测试员答复） |
|---|------|------|
| D1 | 主题切换（浅色/深色）——纯 UI、无数据模型 | **确认保留** |
| D2 | 评价绑定订单（前端当前 orderId 传 0） | **必须修改，禁止传0！** 必须有真实订单ID，否则外键约束报错，无法插入评价 |

---

## 四、附：后端接口现状（供参考）

后端 Spring Boot 已实现接口清单见 [backend-frontend-handoff.md](backend-frontend-handoff.md)，涵盖：注册登录退出、当前用户、分类、商品（发布/编辑/审核/下架/列表/详情）、订单（创建/支付/交付/完成/取消/评价）、私信、举报及处理。尚未接入真实 MySQL（后端 SQL 列名与当前数据库转储存在不一致，需后端/DBA 另行对齐）。

> 【DBA/测试员备注】：后端 SQL 列名与当前数据库转储已由本 DBA 重新对齐（字段已改为 `buyer_id`、`seller_id`、`send_user_id` 等），请后端拉取 GitHub `db` 目录下最新版 `secondhand_full.sql`（包含最新结构和数据）执行，以此为准！