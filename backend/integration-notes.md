# 2026-09-08 协作对接

本轮以 `db/secondhand_full.sql` 为数据库基线，只修改后端代码。前端源码与数据库脚本保持原样；真实 MySQL 执行、数据检查和回滚验收由 DBA 负责。本地后端测试使用 Mapper/DataSource 替身，不代表已完成三端联调。

## 图片协作建议

建议采用“后端存文件，数据库存地址，前端展示地址”。后端已提供独立上传与访问接口，无需先新增商品图片表。

1. 前端以 `multipart/form-data` 调用 `POST /api/uploads/images`，字段名 `file`，带登录 Cookie 和 CSRF 请求头。不要手动指定 multipart 的 Content-Type 边界。
2. 后端校验并重新编码 JPEG/PNG，保存到 `UPLOAD_DIRECTORY` 指定的目录，返回 `data.url`、`data.width`、`data.height`。默认目录为启动工作目录下的 `uploads`，单文件最多 5 MB，最多 1600 万像素、单边不超过 8000 像素。
3. 前端将返回的 `/api/media/{文件名}` 作为图片地址展示。该 GET 地址可匿名读取，适用于公开商品图或头像；不要上传私密举报凭证。前端占位图片无需写入数据库。
4. 建议 DBA 新增 `goods_image` 表：`image_id INT AUTO_INCREMENT`、`goods_id INT`（关联 goods）、`image_url VARCHAR(255)`、`sort_order INT`。建议同一商品排序值唯一，按顺序第一张作为封面。该方案仅为建议，本轮没有修改数据库或执行 DDL。
5. DBA 确认字段后，后端再扩展商品发布/编辑请求的 `images` 数组，按提交顺序保存图片关联，并在详情返回数组。上传成功目前只代表文件已保存，不代表图片已绑定商品；当前商品接口还不接收 images。

上传目录应使用后端能写入的持久目录，重启后继续使用同一目录。文件不会自动上传到 GitHub；搬迁部署时需要同时迁移上传目录。未绑定的上传暂不自动清理，等图片关联表确定后再按实际关系制定清理规则。

可以转告同学：

> 商品图片文件由后端保存，不必把图片二进制放进 MySQL。建议数据库用 goods_image 表记录商品编号、图片地址和显示顺序，第一张作为封面。前端先调用上传接口拿到 URL；等 DBA 确认表结构，后端把 URL 数组接入商品发布和详情。各自先完成负责的部分，最终再联调关联保存。

## 已完成的后端适配

- 用户、分类、商品、评价、私信采用数据库自增主键，由 MyBatis `useGeneratedKeys` 回填。API ID 继续使用字符串；订单仍按数据库 VARCHAR(32) 使用后端生成的订单号。
- 商品状态与当前 SQL 一致：0待审核、1上架、2下架、3已售、4驳回。公开列表只查上架商品，是否能下单另看 purchasable。
- 字段映射改为当前数据库列名：用户 role、商品 user_id/trade_method/description/quality、分类 cate_id；分类描述不存在，返回 null，非空描述写入明确拒绝。
- 评价只存订单关联，商品和评价买家通过 orders 联查。新增订单写 pay_status=0，模拟支付同步 pay_status/pay_time，完成同步 finish_time 和商品已售状态。
- 举报按 user_id/result 等现有列读取和处理。缺少商品编号时返回 goodsId=null；商品举报提交返回 409、REPORT_GOODS_UNAVAILABLE，防止静默丢失关联。
- 新增公开用户资料、管理员用户/订单/评价列表、当前用户全部私信以及本人修改密码接口，供现有前端页面接入。
- 当前 SQL 无触发器定义，后端事务继续负责关联更新。若 DBA 后续新增触发器，再按实际定义调整。

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

收藏、求购、公告、地址、站点初始化及配置没有对应数据库表/列，本轮不新增这些存储或模拟成功。现有订单不保存物流单号，不应自行生成假运单号。商品图片关联等待 DBA；前端可先对接上传与预览。

## 验证与交付

后端执行 `mvn verify -B -ntp`。打包启动检查执行 `pwsh -File scripts/verify-packaged.ps1`。Postman 集合位于 requests，包含新增接口和图片上传请求。业务请求需 DBA 提供可用数据库后执行；本轮未导入、修改原始数据，也未进行真实数据库联调。
