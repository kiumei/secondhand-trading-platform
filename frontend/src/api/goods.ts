import { getDB, persist, nextId, delay } from './mock/db'
import type { Goods, GoodsStatus, GoodsType, GoodsCondition } from '@/types'

export interface GoodsQuery {
  keyword?: string
  categoryId?: number
  categoryIds?: number[]
  minPrice?: number
  maxPrice?: number
  type?: GoodsType
  status?: GoodsStatus
  sellerId?: number
}

export function listGoods(query: GoodsQuery = {}): Promise<Goods[]> {
  let list = getDB().goods.slice()
  if (query.keyword) {
    const kw = query.keyword.toLowerCase()
    list = list.filter(
      (g) => g.title.toLowerCase().includes(kw) || g.desc.toLowerCase().includes(kw),
    )
  }
  if (query.categoryId) list = list.filter((g) => g.categoryId === query.categoryId)
  if (query.categoryIds?.length) list = list.filter((g) => query.categoryIds!.includes(g.categoryId))
  if (query.minPrice != null) list = list.filter((g) => g.price >= query.minPrice!)
  if (query.maxPrice != null) list = list.filter((g) => g.price <= query.maxPrice!)
  if (query.type) list = list.filter((g) => g.type === query.type)
  if (query.status) list = list.filter((g) => g.status === query.status)
  if (query.sellerId != null) list = list.filter((g) => g.sellerId === query.sellerId)
  list.sort((a, b) => b.createdAt.localeCompare(a.createdAt))
  return delay(list)
}

export function getGoods(id: number): Promise<Goods | undefined> {
  const g = getDB().goods.find((x) => x.id === id)
  if (g) {
    g.views += 1
    persist()
  }
  return delay(g)
}

export interface GoodsInput {
  title: string
  desc: string
  price: number
  originalPrice?: number
  categoryId: number
  images: string[]
  type: GoodsType
  condition?: GoodsCondition
  location?: string
  sellerId: number
}

export function createGoods(input: GoodsInput): Promise<Goods> {
  const db = getDB()
  const seller = db.users.find((u) => u.id === input.sellerId)
  const goods: Goods = {
    id: nextId('goods'),
    ...input,
    sellerName: seller?.nickname ?? '匿名用户',
    wantCount: 0,
    status: 'pending',
    createdAt: new Date().toLocaleString('zh-CN'),
    views: 0,
  }
  db.goods.unshift(goods)
  persist()
  return delay(goods)
}

export function updateGoodsStatus(
  id: number,
  status: GoodsStatus,
  rejectReason?: string,
): Promise<void> {
  const db = getDB()
  const g = db.goods.find((x) => x.id === id)
  if (g) {
    g.status = status
    g.rejectReason = rejectReason
    persist()
  }
  return delay(undefined)
}

export function deleteGoods(id: number): Promise<void> {
  const db = getDB()
  db.goods = db.goods.filter((x) => x.id !== id)
  persist()
  return delay(undefined)
}
