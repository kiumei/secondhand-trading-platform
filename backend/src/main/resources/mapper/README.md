# MyBatis XML

UserMapper.xml：账号、资料、封禁状态与密码。CategoryMapper.xml：两级分类查询。MarketMapper.xml：分类管理、商品与多图、收藏、订单、评价、私信与举报。全部业务 SQL 使用参数绑定。

列名严格对齐 DBA 重新对齐的 `db/secondhand_full.sql`（2026-09-08 转储）：goods.user_id/trade_method/description/quality、category.cate_id/parent_id/sort、orders.buyer_id/seller_id/pay_status/pay_time/finish_time、evaluate.eva_id/order_id/score/content/eva_time、report.user_id/result/report_time、sys_user.role/status 等。除 orders.order_id 为 varchar(32) 手工流水号外，各表主键均为 int 自增，插入后通过同事务连接的 `SELECT LAST_INSERT_ID()` 取回。商品状态 0待审核/1上架/2下架/3已售出/4驳回；订单状态 0待付款/1待发货/2待收货/3完成/4取消/5售后。

已验证解析、绑定与装配；实际 MySQL 执行、约束、并发与回滚仍待验证。没有修改或执行建表与触发器脚本。
