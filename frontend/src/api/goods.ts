import { getDB, persist, nextId, delay } from './mock/db'
import type { Goods, GoodsStatus, TradeType, QualityLevel } from '@/types'

export interface GoodsQuery {
  keyword?: string
  categoryId?: number
  minPrice?: number
  maxPrice?: number
  status?: GoodsStatus
  sellerId?: number
}

function isPurchasable(goodsId: number): boolean {
  const db = getDB()
  const g = db.goods.find((x) => x.goodsId === goodsId)
  if (!g || g.goodsStatus !== 1) return false
  return !db.orders.some((o) => o.goodsId === goodsId && o.orderStatus !== 4)
}

export function listGoods(query: GoodsQuery = {}): Promise<Goods[]> {
  let list = getDB().goods.slice()
  if (query.keyword) {
    const kw = query.keyword.toLowerCase()
    list = list.filter(
      (g) => g.title.toLowerCase().includes(kw) || g.goodsDesc.toLowerCase().includes(kw),
    )
  }
  if (query.categoryId) list = list.filter((g) => g.cateId === query.categoryId)
  if (query.minPrice != null) list = list.filter((g) => g.sellPrice >= query.minPrice!)
  if (query.maxPrice != null) list = list.filter((g) => g.sellPrice <= query.maxPrice!)
  if (query.status != null) list = list.filter((g) => g.goodsStatus === query.status)
  if (query.sellerId != null) list = list.filter((g) => g.publishUserId === query.sellerId)
  list.sort((a, b) => b.publishTime.localeCompare(a.publishTime))
  return delay(list.map((g) => ({ ...g, purchasable: isPurchasable(g.goodsId) })))
}

export function getGoods(id: number): Promise<Goods | undefined> {
  const g = getDB().goods.find((x) => x.goodsId === id)
  if (g) {
    g.views += 1
    persist()
    return delay({ ...g, purchasable: isPurchasable(id) })
  }
  return delay(undefined)
}

export interface GoodsInput {
  title: string
  goodsDesc: string
  sellPrice: number
  originalPrice?: number
  cateId: number
  tradeType: TradeType
  qualityLevel?: QualityLevel
  images: string[]
  publishUserId: number
}

export function createGoods(input: GoodsInput): Promise<Goods> {
  const db = getDB()
  const seller = db.users.find((u) => u.userId === input.publishUserId)
  const goods: Goods = {
    goodsId: nextId('goods'),
    ...input,
    sellerName: seller?.userName ?? '匿名用户',
    cateName: db.categories.find((c) => c.categoryId === input.cateId)?.cateName,
    goodsStatus: 0, // 待审核
    publishTime: new Date().toLocaleString('zh-CN'),
    views: 0,
    purchasable: false,
  }
  db.goods.unshift(goods)
  persist()
  return delay(goods)
}

export function updateGoods(
  id: number,
  input: Omit<GoodsInput, 'images' | 'publishUserId'>,
): Promise<Goods | undefined> {
  const db = getDB()
  const g = db.goods.find((x) => x.goodsId === id)
  if (g) {
    Object.assign(g, input)
    g.cateName = db.categories.find((c) => c.categoryId === input.cateId)?.cateName
    g.goodsStatus = 0 // 修改后重新进入待审核
    g.rejectReason = undefined
    g.purchasable = false
    persist()
  }
  return delay(g)
}

export function updateGoodsStatus(
  id: number,
  status: GoodsStatus,
  rejectReason?: string,
): Promise<void> {
  const db = getDB()
  const g = db.goods.find((x) => x.goodsId === id)
  if (g) {
    g.goodsStatus = status
    g.rejectReason = rejectReason
    g.purchasable = status === 1
    persist()
  }
  return delay(undefined)
}

export function deleteGoods(id: number): Promise<void> {
  const db = getDB()
  db.goods = db.goods.filter((x) => x.goodsId !== id)
  persist()
  return delay(undefined)
}
