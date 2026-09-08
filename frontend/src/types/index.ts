// 数据模型对齐设计文档 / 后端口径。
// 说明：mock 阶段 ID 暂用 number，接后端时统一改为 string（后端为 varchar(32)）。

// 用户角色：0 学生，1 管理员
export type Role = 0 | 1

export interface User {
  userId: number
  userName: string // 昵称
  phone: string // 手机号（登录标识）
  password: string
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
  goodsId: number
  publishUserId: number
  cateId: number
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
  purchasable?: boolean
  // 前端私货（不进后端，仅本地 mock）
  images: string[]
  views: number
}

// 订单状态：0待付款 1待发货 2待收货 3完成 4取消 5售后
export type OrderStatus = 0 | 1 | 2 | 3 | 4 | 5

export interface Order {
  orderId: number
  buyerId: number
  sellerId: number
  goodsId: number
  orderPrice: number
  orderStatus: OrderStatus
  createTime: string
  shippingAddress?: string // 收货地址（下单快照）
}

export interface Evaluate {
  evaluateId: number
  orderId: number // 真实订单号（评价必须绑定订单）
  goodsId: number
  evaluateUserId: number
  score: 1 | 2 | 3 | 4 | 5
  evaluateContent: string
  evaluateTime: string
}

export interface Message {
  msgId: number
  sendUserId: number
  receiveUserId: number
  content: string
  image?: string
  isRead: 0 | 1
  sendTime: string
}

export interface Report {
  reportId: number
  reportUserId: number
  goodsId: number
  reportType: string
  reportContent: string
  proofImg?: string
  handleStatus: number // 0 待处理，1 已处理
  handleResult?: string
}

export interface Favorite {
  favoriteId: number
  userId: number
  goodsId: number
  createTime: string
}

export interface Category {
  categoryId: number
  cateName: string
  parentId: number // 0 表示一级分类
}
