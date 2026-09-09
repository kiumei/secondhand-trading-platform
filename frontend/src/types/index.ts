// 数据模型对齐后端契约。
// 说明：ID 用 string（后端 varchar(32)）；金额前端内部用 number，HTTP 传输时转字符串。

// 用户角色：0 学生，1 管理员
export type Role = 0 | 1

export interface User {
  userId: string
  userName: string // 昵称
  phone: string // 手机号（登录标识）
  password?: string // 仅 mock 内部使用，后端不返回
  avatar: string
  intro: string
  address?: string // 收货地址
  role: Role
  status: number // 0 正常，1 封禁
  registerTime: string
}

// 商品状态：0待审核 1上架 2下架 3已售出 4驳回
export type GoodsStatus = 0 | 1 | 2 | 3 | 4
// 交易方式：1邮寄 2自提 3两者
export type TradeType = 1 | 2 | 3
// 成色等级：1-5（1 全新 → 5 较差）
export type QualityLevel = 1 | 2 | 3 | 4 | 5

export interface Goods {
  goodsId: string
  publishUserId: string
  cateId: string
  title: string
  sellPrice: number
  originalPrice?: number
  tradeType: TradeType
  goodsDesc: string
  qualityLevel?: QualityLevel
  rejectReason?: string
  publishTime: string
  goodsStatus: GoodsStatus
  sellerName?: string
  cateName?: string
  coverUrl?: string
  purchasable?: boolean
  // 前端私货（接后端后删除）
  images: string[]
  views: number
}

// 订单状态：0待付款 1待发货 2待收货 3完成 4取消 5售后
export type OrderStatus = 0 | 1 | 2 | 3 | 4 | 5

export interface Order {
  orderId: string
  buyerId: string
  sellerId: string
  goodsId: string
  orderPrice: number
  payStatus: number // 0 未支付，1 已支付
  orderStatus: OrderStatus
  payTime?: string
  finishTime?: string
  createTime: string
  shippingAddress?: string // 收货地址（下单快照）
}

export interface Evaluate {
  evaluateId: string
  orderId: string // 真实订单号（评价必须绑定订单）
  goodsId: string
  evaluateUserId: string
  score: 1 | 2 | 3 | 4 | 5
  evaluateContent: string
  evaluateTime: string
}

export interface Message {
  msgId: string
  sendUserId: string
  receiveUserId: string
  content: string
  image?: string
  isRead: 0 | 1
  sendTime: string
}

// 举报类型：1假冒伪劣 2欺诈行为 3辱骂骚扰 4违规违禁品 5其他
export type ReportType = 1 | 2 | 3 | 4 | 5

export interface Report {
  reportId: string
  reportUserId: string
  goodsId: string
  reportType: ReportType
  reportContent: string
  proofImg?: string
  handleStatus: number // 0 待处理，1 已处理
  handleResult?: string
  reportTime?: string
}

export interface Favorite {
  favoriteId: string
  userId: string
  goodsId: string
  createTime: string
}

export interface Category {
  cateId: string
  cateName: string
  parentId: number
  sort?: number
}
