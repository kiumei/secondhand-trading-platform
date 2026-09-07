export type Role = 'student' | 'admin'

export interface User {
  id: number
  username: string
  password: string
  nickname: string
  phone: string
  address: string
  bio?: string
  role: Role
  avatar: string
}

export type GoodsStatus = 'on' | 'sold' | 'off' | 'pending' | 'rejected'
export type GoodsType = 'sell' | 'want'
export type GoodsCondition = '全新' | '9成新' | '8成新' | '7成新' | '6成新及以下'

export interface Goods {
  id: number
  title: string
  desc: string
  price: number
  originalPrice?: number
  categoryId: number
  images: string[]
  status: GoodsStatus
  rejectReason?: string
  sellerId: number
  type: GoodsType
  condition?: GoodsCondition
  location?: string
  freeShipping?: boolean
  sellerName?: string
  wantCount?: number
  createdAt: string
  views: number
}

export type OrderStatus = 'unpaid' | 'paid' | 'shipped' | 'done' | 'cancelled'

export interface Order {
  id: number
  goodsId: number
  buyerId: number
  sellerId: number
  price: number
  status: OrderStatus
  logistics?: string
  createdAt: string
}

export interface Evaluate {
  id: number
  orderId: number
  goodsId: number
  userId: number
  score: 1 | 2 | 3 | 4 | 5
  content: string
  createdAt: string
}

export interface Message {
  id: number
  from: number
  to: number
  content: string
  image?: string
  createdAt: string
}

export interface Report {
  id: number
  goodsId: number
  userId: number
  reason: string
  status: 'pending' | 'done'
  createdAt: string
}

export interface Favorite {
  id: number
  userId: number
  goodsId: number
  createdAt: string
}

export interface Category {
  id: number
  name: string
}

export interface Bulletin {
  id: number
  title: string
  content: string
  createdAt: string
}

export interface SiteConfig {
  title: string
  footer: string
  heroTitle: string
  heroSubtitle: string
}
