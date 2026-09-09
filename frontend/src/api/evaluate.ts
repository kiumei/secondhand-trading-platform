import { getDB, persist, nextId, delay } from './mock/db'
import type { Evaluate } from '@/types'

export function listEvaluates(goodsId?: string): Promise<Evaluate[]> {
  let list = getDB().evaluates.slice()
  if (goodsId != null) list = list.filter((e) => e.goodsId === goodsId)
  list.sort((a, b) => b.evaluateTime.localeCompare(a.evaluateTime))
  return delay(list)
}

export function createEvaluate(input: {
  orderId: string
  goodsId: string
  evaluateUserId: string
  score: 1 | 2 | 3 | 4 | 5
  evaluateContent: string
}): Promise<Evaluate | null> {
  const db = getDB()
  // 同一订单只能评价一次（对应数据库 UNIQUE(order_id) 约束）
  if (db.evaluates.some((e) => e.orderId === input.orderId)) return delay(null)
  const ev: Evaluate = {
    evaluateId: nextId('evaluate'),
    ...input,
    evaluateTime: new Date().toLocaleString('zh-CN'),
  }
  db.evaluates.unshift(ev)
  persist()
  return delay(ev)
}

export function deleteEvaluate(id: string): Promise<void> {
  const db = getDB()
  db.evaluates = db.evaluates.filter((e) => e.evaluateId !== id)
  persist()
  return delay(undefined)
}
