import { getDB, persist, nextId, delay } from './mock/db'
import type { Order, OrderStatus } from '@/types'

export function listOrders(query: { buyerId?: number; sellerId?: number } = {}): Promise<Order[]> {
  let list = getDB().orders.slice()
  if (query.buyerId != null) list = list.filter((o) => o.buyerId === query.buyerId)
  if (query.sellerId != null) list = list.filter((o) => o.sellerId === query.sellerId)
  list.sort((a, b) => b.createdAt.localeCompare(a.createdAt))
  return delay(list)
}

export function createOrder(input: {
  goodsId: number
  buyerId: number
  sellerId: number
  price: number
}): Promise<Order> {
  const db = getDB()
  const order: Order = {
    id: nextId('order'),
    ...input,
    status: 'unpaid',
    createdAt: new Date().toLocaleString('zh-CN'),
  }
  db.orders.unshift(order)
  persist()
  return delay(order)
}

export function updateOrderStatus(id: number, status: OrderStatus, logistics?: string): Promise<void> {
  const db = getDB()
  const o = db.orders.find((x) => x.id === id)
  if (o) {
    o.status = status
    if (logistics) o.logistics = logistics
    persist()
  }
  return delay(undefined)
}
