import { getDB, persist, nextId, delay } from './mock/db'
import type { Evaluate } from '@/types'

export function listEvaluates(goodsId?: number): Promise<Evaluate[]> {
  let list = getDB().evaluates.slice()
  if (goodsId != null) list = list.filter((e) => e.goodsId === goodsId)
  list.sort((a, b) => b.createdAt.localeCompare(a.createdAt))
  return delay(list)
}

export function createEvaluate(input: {
  orderId: number
  goodsId: number
  userId: number
  score: 1 | 2 | 3 | 4 | 5
  content: string
}): Promise<Evaluate> {
  const db = getDB()
  const ev: Evaluate = {
    id: nextId('evaluate'),
    ...input,
    createdAt: new Date().toLocaleString('zh-CN'),
  }
  db.evaluates.unshift(ev)
  persist()
  return delay(ev)
}

export function deleteEvaluate(id: number): Promise<void> {
  const db = getDB()
  db.evaluates = db.evaluates.filter((e) => e.id !== id)
  persist()
  return delay(undefined)
}
