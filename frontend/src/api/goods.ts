import http, { getAllPages } from './http'
import type { Goods, GoodsStatus, TradeType, QualityLevel } from '@/types'

// 后端返回的金额是字符串，这里定义 API 原始类型
interface ApiGoods {
  goodsId: string
  publishUserId: string
  cateId: string
  title: string
  sellPrice: string
  originalPrice?: string | null
  tradeType: number
  goodsDesc: string
  qualityLevel?: number | null
  rejectReason?: string | null
  publishTime: string
  goodsStatus: number
  sellerName?: string
  cateName?: string
  coverUrl?: string | null
  purchasable: boolean
  images?: string[]
}

export function toGoods(api: ApiGoods): Goods {
  return {
    goodsId: api.goodsId,
    publishUserId: api.publishUserId,
    cateId: api.cateId,
    title: api.title,
    sellPrice: parseFloat(api.sellPrice),
    originalPrice: api.originalPrice != null ? parseFloat(api.originalPrice) : undefined,
    tradeType: api.tradeType as TradeType,
    goodsDesc: api.goodsDesc,
    qualityLevel: (api.qualityLevel ?? undefined) as QualityLevel | undefined,
    rejectReason: api.rejectReason ?? undefined,
    publishTime: api.publishTime,
    goodsStatus: api.goodsStatus as GoodsStatus,
    sellerName: api.sellerName,
    cateName: api.cateName,
    coverUrl: api.coverUrl ?? undefined,
    purchasable: api.purchasable,
    images: api.images && api.images.length ? api.images : api.coverUrl ? [api.coverUrl] : [],
    views: 0,
  }
}

export interface GoodsQuery {
  keyword?: string
  cateId?: string
  minPrice?: number
  maxPrice?: number
  status?: GoodsStatus
}

export async function listGoods(query: GoodsQuery = {}): Promise<Goods[]> {
  const params: Record<string, string | number> = { page: 1, pageSize: 50 }
  if (query.keyword) params.keyword = query.keyword
  if (query.cateId) params.cateId = query.cateId
  if (query.minPrice != null) params.minPrice = query.minPrice
  if (query.maxPrice != null) params.maxPrice = query.maxPrice
  if (query.status != null) params.status = query.status
  const data = (await http.get('/goods', { params })) as { items: ApiGoods[] }
  // 后端公开列表只返回「上架」商品。是否只保留可购买商品由购物场景调用方决定。
  return (data.items ?? []).map(toGoods)
}

export async function getGoods(id: string): Promise<Goods | undefined> {
  try {
    const api = (await http.get(`/goods/${id}`)) as ApiGoods
    return toGoods(api)
  } catch {
    return undefined
  }
}

export interface GoodsInput {
  title: string
  goodsDesc: string
  sellPrice: number
  originalPrice?: number
  cateId: string
  tradeType: TradeType
  qualityLevel?: QualityLevel
  images: string[]
  publishUserId: string
}

export async function createGoods(input: GoodsInput): Promise<Goods> {
  const body = {
    cateId: input.cateId,
    title: input.title,
    sellPrice: String(input.sellPrice),
    originalPrice: input.originalPrice != null ? String(input.originalPrice) : null,
    tradeType: input.tradeType,
    goodsDesc: input.goodsDesc,
    qualityLevel: input.qualityLevel ?? null,
    images: input.images,
  }
  const api = (await http.post('/goods', body)) as ApiGoods
  return toGoods(api)
}

export async function updateGoods(
  id: string,
  input: Omit<GoodsInput, 'images' | 'publishUserId'>,
): Promise<Goods | undefined> {
  const body = {
    cateId: input.cateId,
    title: input.title,
    sellPrice: String(input.sellPrice),
    originalPrice: input.originalPrice != null ? String(input.originalPrice) : null,
    tradeType: input.tradeType,
    goodsDesc: input.goodsDesc,
    qualityLevel: input.qualityLevel ?? null,
  }
  const api = (await http.put(`/admin/goods/${id}`, body)) as ApiGoods
  return toGoods(api)
}

// 状态变更：通过 → 审核 PASS；驳回 → 审核 REJECT；下架 → off-shelf
export async function updateGoodsStatus(
  id: string,
  status: GoodsStatus,
  rejectReason?: string,
): Promise<void> {
  if (status === 1) {
    await http.post(`/admin/goods/${id}/review`, { decision: 'PASS' })
  } else if (status === 4) {
    await http.post(`/admin/goods/${id}/review`, { decision: 'REJECT', rejectReason })
  } else if (status === 2) {
    await http.post(`/goods/${id}/off-shelf`)
  }
}

// 我的商品（当前用户）
export async function listMyGoods(status?: GoodsStatus): Promise<Goods[]> {
  const params: Record<string, string | number> = {}
  if (status != null) params.status = status
  const items = await getAllPages<ApiGoods>('/users/me/goods', params)
  return items.map(toGoods)
}

// 管理员商品列表（可按状态筛选，例如待审核 status=0）
export async function listAdminGoods(status?: GoodsStatus): Promise<Goods[]> {
  const params: Record<string, string | number> = {}
  if (status != null) params.status = status
  const items = await getAllPages<ApiGoods>('/admin/goods', params)
  return items.map(toGoods)
}
