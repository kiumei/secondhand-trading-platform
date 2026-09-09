import http, { getAllPages } from './http'
import { toGoods } from './goods'
import type { Goods } from '@/types'

// 收藏列表返回的是商品列表（Goods）
export async function listFavorites(): Promise<Goods[]> {
  const items = await getAllPages<unknown>('/favorites')
  return items.map((g) => toGoods(g as never))
}

export async function isFavorite(goodsId: string): Promise<boolean> {
  return (await http.get(`/favorites/${goodsId}`)) as boolean
}

export async function addFavorite(goodsId: string): Promise<void> {
  await http.post('/favorites', { goodsId })
}

export async function removeFavorite(goodsId: string): Promise<void> {
  await http.delete(`/favorites/${goodsId}`)
}
