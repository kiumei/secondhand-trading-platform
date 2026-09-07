/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     2026/9/7 15:31:49                            */
/*==============================================================*/


drop table if exists User;

drop table if exists category;

drop table if exists evaluate;

drop table if exists goods;

drop table if exists message;

drop table if exists "order";

drop table if exists report;

/*==============================================================*/
/* Table: User                                                  */
/*==============================================================*/
create table User
(
   user_id              int not null comment '自增主键',
   user_name            varchar(20) not null,
   phone                char(11) not null,
   password             varchar(64) not null comment '加密存储
            ',
   avatar               varchar(255),
   intro                varchar(200),
   role                 smallint not null comment '0表示普通用户
            1表示管理员
            ',
   status               smallint not null comment '0普通用户
            1管理员
            ',
   register_time        datetime,
   primary key (user_id)
);

alter table User comment '用户用于二手交易，可以是卖家也可以是买家';

/*==============================================================*/
/* Table: category                                              */
/*==============================================================*/
create table category
(
   cate_id              int not null comment '自增主键',
   cate_name            varchar(50) not null,
   parent_id            int comment '父类为0表示一级分类',
   sort                 int,
   primary key (cate_id)
);

alter table category comment '商品分类';

/*==============================================================*/
/* Table: evaluate                                              */
/*==============================================================*/
create table evaluate
(
   eva_id               int not null comment '自增',
   order_id             varchar(32) not null comment '手工生成流水号不自增',
   score                smallint not null comment '1-5星',
   evaluate_content     varchar(500),
   eva_time             datetime not null,
   primary key (eva_id)
);

alter table evaluate comment '评价';

/*==============================================================*/
/* Table: goods                                                 */
/*==============================================================*/
create table goods
(
   goods_id             int not null,
   user_id              int not null comment '自增主键',
   cate_id              int not null comment '自增主键',
   title                varchar(100) not null,
   sell_price           decimal(10,2) not null,
   original_price       decimal(10,2),
   trade_method         smallint not null comment '1邮寄
            2自提
            3两者',
   description          text not null comment '文本描述',
   quality              smallint comment '1-5表示新旧程度',
   reject_reason        varchar(200),
   publish_time         datetime,
   goods_satus          smallint not null comment '0未售出，1已售出，2下架，3待审核，4驳回',
   primary key (goods_id)
);

alter table goods comment '商品';

/*==============================================================*/
/* Table: message                                               */
/*==============================================================*/
create table message
(
   msg_id               int not null,
   user_id              int not null comment '自增主键',
   Use_user_id          int not null comment '自增主键',
   messge_content       varchar(500) not null,
   is_read              smallint not null comment '0未读
            1已读',
   sendtime             datetime not null,
   primary key (msg_id)
);

alter table message comment '私信';

/*==============================================================*/
/* Table: "order"                                               */
/*==============================================================*/
create table "order"
(
   order_id             varchar(32) not null comment '手工生成流水号不自增',
   user_id              int not null comment '自增主键',
   eva_id               int comment '自增',
   goods_id             int not null,
   Use_user_id          int not null comment '自增主键',
   order_price          decimal(10,2) not null,
   pay_status           smallint not null comment '0未支付
            1支付',
   order_status         smallint not null comment '0待付款
            1代发货
            2待收货
            3完成
            4取消
            5售后',
   pay_time             datetime,
   finish_time          datetime,
   create_time          datetime not null,
   primary key (order_id)
);

alter table "order" comment '订单';

/*==============================================================*/
/* Table: report                                                */
/*==============================================================*/
create table report
(
   report_id            int not null comment '自增',
   user_id              int not null comment '自增主键',
   goods_id             int not null,
   report_type          smallint not null,
   report_contentV      varchar(500) not null,
   proof_img            varchar(255),
   handle_status        smallint not null comment '0待处理
            1已处理',
   result               varchar(200),
   report_time          datetime not null,
   primary key (report_id)
);

alter table report comment '举报维权';

alter table evaluate add constraint FK_rel_goods_create_evaluate foreign key (order_id)
      references "order" (order_id) on delete restrict on update restrict;

alter table goods add constraint FK_rel_category_include_goods foreign key (cate_id)
      references category (cate_id) on delete restrict on update restrict;

alter table goods add constraint FK_rel_user_publish_goods foreign key (user_id)
      references User (user_id) on delete restrict on update restrict;

alter table message add constraint FK_rel_user_receive_msg foreign key (Use_user_id)
      references User (user_id) on delete restrict on update restrict;

alter table message add constraint FK_rel_user_send_msg foreign key (user_id)
      references User (user_id) on delete restrict on update restrict;

alter table "order" add constraint FK_rel_goods_create_evaluate foreign key (eva_id)
      references evaluate (eva_id) on delete restrict on update restrict;

alter table "order" add constraint FK_rel_goods_create_order foreign key (goods_id)
      references goods (goods_id) on delete restrict on update restrict;

alter table "order" add constraint FK_rel_user_buy_order foreign key (Use_user_id)
      references User (user_id) on delete restrict on update restrict;

alter table "order" add constraint FK_rel_user_sell_order foreign key (user_id)
      references User (user_id) on delete restrict on update restrict;

alter table report add constraint FK_rel_user_create_report foreign key (user_id)
      references User (user_id) on delete restrict on update restrict;

alter table report add constraint FK_举报 foreign key (goods_id)
      references goods (goods_id) on delete restrict on update restrict;

