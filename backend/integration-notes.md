# 2026-09-08 协作对接

本轮以 `db/secondhand_full.sql` 为数据库基线，只修改后端代码。前端源码与数据库脚本保持原样；真实 MySQL 执行、数据检查和回滚验收由 DBA 负责。本地后端测试使用 Mapper/DataSource 替身，不代表已完成三端联调。

## 图片协作建议

建议采用“后端存文件，数据库存地址，前端展示地址”。后端已提供独立上传与访问接口，已接入现有 goods_image 表。

1. 前端以 `multipart/form-data` 调用 `POST /api/uploads/images`，字段名 `file`，带登录 Cookie 和 CSRF 请求头。不要手动指定 multipart 的 Content-Type 边界。
2. 后端校验并重新编码 JPEG/PNG，保存到 `UPLOAD_DIRECTORY` 指定的目录，返回 `data.url`、`data.width`、`data.height`。默认目录为启动工作目录下的 `uploads`，单文件最多 5 MB，最多 1600 万像素、单边不超过 8000 像素。
3. 前端将返回的 `/api/media/{文件名}` 作为图片地址展示。该 GET 地址可匿名读取，适用于公开商品图或头像；不要上传私密举报凭证。前端占位图片无需写入数据库。
4. 商品发布/编辑已接收 images 地址数组，通过现有 goods_image(img_id, goods_id, img_url, sort_order) 保存，最多4张。响应返回 images，第一张作为 coverUrl。编辑时省略或 null 保留原图，空数组清空关联。

上传目录需持久保存，部署迁移时同时迁移文件。上传成功仅表示文件保存，商品提交成功后才保存关联；未绑定上传暂不自动清理。

## 已完成的后端适配

- 用户、分类、商品、评价、私信采用数据库自增主键，由 MyBatis `useGeneratedKeys` 回填。API ID 继续使用字符串；订单仍按数据库 VARCHAR(32) 使用后端生成的订单号。
- 商品状态与当前 SQL 一致：0待审核、1上架、2下架、3已售、4驳回。公开列表只查上架商品，是否能下单另看 purchasable。
- 字段映射改为当前数据库列名：用户 role、商品 user_id/trade_method/description/quality、分类 cate_id；分类描述不存在，返回 null，非空描述写入明确拒绝。
- 评价只存订单关联，商品和评价买家通过 orders 联查。新增订单写 pay_status=0，模拟支付同步 pay_status/pay_time，完成同步 finish_time 和商品已售状态。
- 举报按 user_id/result 等现有列读取和处理。goods_id 已接入查询和提交；reportType 为数字1至5，handleStatus 为数字0待处理、1已处理。
- 新增公开用户资料、管理员用户/订单/评价列表、当前用户全部私信以及本人修改密码接口，供现有前端页面接入。
- 当前完整 SQL 已包含订单完成更新商品、封禁下架商品、禁止未完成订单评价三个触发器。后端已删除订单完成时的重复商品更新，保留权限和评价前置校验。
- 用户 status 为0正常、1封禁；封禁登录返回403 ACCOUNT_BANNED，已有会话下次请求失效并返回401 UNAUTHENTICATED。个人资料支持 address 读写（最长255字符），省略或 null 保留，空字符串清空。公开用户资料不暴露地址。

## 给前端同学的对接点

现有 `frontend/src/api/*` 仍使用浏览器模拟数据，应由前端同学改成请求后端。后端没有代改这些文件。

| 前端内容 | 后端约定 |
| --- | --- |
| 登录和刷新 | 手机号登录；GET /api/users/me 恢复真实会话，不把 localStorage 的角色作为登录依据 |
| 注册 | phone、password、userName；注册后需再调用登录；nickname 对应 userName，username 不是独立登录字段 |
| 分页 | data.items、total、page、pageSize；默认 10、最多 50，需要多页时由前端继续请求 |
| 商品 | price/desc/categoryId 对应 sellPrice/goodsDesc/categoryId；金额返回十进制字符串 |
| 商品状态 | pending/on/off/sold/rejected 分别映射 0/1/2/3/4；待审查询显式传 status=0 |
| 商品查询 | GET /api/goods 支持 sellerId、关键词、分类和价格；管理员 GET /api/admin/goods 不传 status 查全部 |
| 订单 | ID 是字符串，不要 Number(orderId)；卖家/买家/价格由后端确定 |
| 评价 | 必须提供本人已完成订单的实际 ID；前端当前 orderId: 0 是占位，需替换 |
| 订单商品展示 | 公开商品列表只返回上架商品，已售商品需按订单 goodsId 查详情 |
| 公开卖家资料 | GET /api/public/users/{id} 仅返回 userId/userName/avatar/intro，不返回手机号或密码 |
| 管理端列表 | GET /api/admin/users、/api/admin/orders、/api/admin/evaluations，均分页、限管理员 |
| 消息收录 | GET /api/users/me/messages 返回本人全部私信分页；GET /api/messages?peerId=... 查双方会话 |
| 修改密码 | PUT /api/users/me/password，oldPassword/newPassword；需登录和 CSRF |

收藏、商品多图及两级分类已有实现；功能扩展按同学分工处理。求购、公告和站点配置按确认文档不新增。现有订单不保存物流单号或收货地址快照。

## 验证与交付

后端执行 `mvn verify -B -ntp`。最新代码已通过67项测试并打包成功。本轮不追加独立 JAR 启动检查，实际启动与数据库连接在联调时验证。Postman 集合位于 requests，包含新增接口和图片上传请求。业务请求需 DBA 提供可用数据库后执行；本轮未导入、修改原始数据，也未进行真实数据库联调。
