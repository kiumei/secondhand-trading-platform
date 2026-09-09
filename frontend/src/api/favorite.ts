import { getDB, persist, nextId, delay } from './mock/db'
import type { Favorite } from '@/types'

export function listFavorites(userId: string): Promise<Favorite[]> {
  const list = getDB().favorites
    .filter((f) => f.userId === userId)
    .sort((a, b) => b.createTime.localeCompare(a.createTime))
  return delay(list)
}

export function isFavorite(userId: string, goodsId: string): Promise<boolean> {
  return delay(getDB().favorites.some((f) => f.userId === userId && f.goodsId === goodsId))
}

export function addFavorite(userId: string, goodsId: string): Promise<void> {
  const db = getDB()
  if (!db.favorites.some((f) => f.userId === userId && f.goodsId === goodsId)) {
    db.favorites.push({
      favoriteId: nextId('favorite'),
      userId,
      goodsId,
      createTime: new Date().toLocaleString('zh-CN'),
    })
    persist()
  }
  return delay(undefined)
}

export function removeFavorite(userId: string, goodsId: string): Promise<void> {
  const db = getDB()
  db.favorites = db.favorites.filter((f) => !(f.userId === userId && f.goodsId === goodsId))
  persist()
  return delay(undefined)
}
