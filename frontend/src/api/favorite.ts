import { getDB, persist, nextId, delay } from './mock/db'
import type { Favorite } from '@/types'

export function listFavorites(userId: number): Promise<Favorite[]> {
  const list = getDB().favorites
    .filter((f) => f.userId === userId)
    .sort((a, b) => b.createdAt.localeCompare(a.createdAt))
  return delay(list)
}

export function isFavorite(userId: number, goodsId: number): Promise<boolean> {
  return delay(getDB().favorites.some((f) => f.userId === userId && f.goodsId === goodsId))
}

export function addFavorite(userId: number, goodsId: number): Promise<void> {
  const db = getDB()
  if (!db.favorites.some((f) => f.userId === userId && f.goodsId === goodsId)) {
    db.favorites.push({ id: nextId('favorite'), userId, goodsId, createdAt: new Date().toLocaleString('zh-CN') })
    persist()
  }
  return delay(undefined)
}

export function removeFavorite(userId: number, goodsId: number): Promise<void> {
  const db = getDB()
  db.favorites = db.favorites.filter((f) => !(f.userId === userId && f.goodsId === goodsId))
  persist()
  return delay(undefined)
}
