# MyBatis XML

UserMapper.xml：账号与资料修改。CategoryMapper.xml：分类查询。MarketMapper.xml：分类管理、商品、订单、评价、私信与举报。全部业务 SQL 使用参数绑定。

字段按 db/secondhand_full.sql 当前表结构映射，自增主键使用 useGeneratedKeys 回填；API ID 为字符串。评价的商品和买家由订单联查。商品状态为 0待审核、1上架、2下架、3已售、4驳回。举报缺少商品关联，提交暂拒绝，读取返回 goodsId=null。订单状态采用 PDM 的 0至5。已验证解析、绑定与装配；实际 MySQL 执行、约束、并发与回滚仍待验证。没有修改或执行建表与触发器脚本。
