import { getDB, persist, nextId, delay } from './mock/db'
import type { Order, OrderStatus } from '@/types'

export function listOrders(query: { buyerId?: number; sellerId?: number } = {}): Promise<Order[]> {
  let list = getDB().orders.slice()
  if (query.buyerId != null) list = list.filter((o) => o.buyerId === query.buyerId)
  if (query.sellerId != null) list = list.filter((o) => o.sellerId === query.sellerId)
  list.sort((a, b) => b.createTime.localeCompare(a.createTime))
  return delay(list)
}

export function createOrder(input: {
  goodsId: number
  buyerId: number
  sellerId: number
  orderPrice: number
  shippingAddress?: string
}): Promise<Order | null> {
  const db = getDB()
  const goods = db.goods.find((g) => g.goodsId === input.goodsId)
  // 商品必须是「上架」且没有有效订单（除已取消外），否则不可购买
  if (!goods || goods.goodsStatus !== 1) return delay(null)
  const activeOrder = db.orders.some(
    (o) => o.goodsId === input.goodsId && o.orderStatus !== 4,
  )
  if (activeOrder) return delay(null)
  const order: Order = {
    orderId: nextId('order'),
    ...input,
    orderStatus: 0, // 待付款
    createTime: new Date().toLocaleString('zh-CN'),
  }
  db.orders.unshift(order)
  goods.purchasable = false
  persist()
  return delay(order)
}

export function updateOrderShippingAddress(id: number, address: string): Promise<void> {
  const db = getDB()
  const o = db.orders.find((x) => x.orderId === id)
  if (o) {
    o.shippingAddress = address
    persist()
  }
  return delay(undefined)
}

export function updateOrderStatus(id: number, status: OrderStatus): Promise<void> {
  const db = getDB()
  const o = db.orders.find((x) => x.orderId === id)
  if (o) {
    o.orderStatus = status
    const goods = db.goods.find((g) => g.goodsId === o.goodsId)
    if (goods) {
      if (status === 3) {
        // 订单完成 → 商品已售（对应触发器 trg_order_complete_update_goods）
        goods.goodsStatus = 3
        goods.purchasable = false
      } else if (status === 4) {
        // 取消 → 商品恢复可购买
        goods.purchasable = goods.goodsStatus === 1
      }
    }
    persist()
  }
  return delay(undefined)
}
