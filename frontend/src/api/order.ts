import { getDB, persist, nextId, delay } from './mock/db'
import type { Order, OrderStatus } from '@/types'

export function listOrders(query: { buyerId?: string; sellerId?: string } = {}): Promise<Order[]> {
  let list = getDB().orders.slice()
  if (query.buyerId != null) list = list.filter((o) => o.buyerId === query.buyerId)
  if (query.sellerId != null) list = list.filter((o) => o.sellerId === query.sellerId)
  list.sort((a, b) => b.createTime.localeCompare(a.createTime))
  return delay(list)
}

export function createOrder(input: {
  goodsId: string
  buyerId: string
  sellerId: string
  orderPrice: number
  shippingAddress?: string
}): Promise<Order | null> {
  const db = getDB()
  const goods = db.goods.find((g) => g.goodsId === input.goodsId)
  if (!goods || goods.goodsStatus !== 1) return delay(null)
  const activeOrder = db.orders.some((o) => o.goodsId === input.goodsId && o.orderStatus !== 4)
  if (activeOrder) return delay(null)
  const order: Order = {
    orderId: nextId('order'),
    ...input,
    payStatus: 0,
    orderStatus: 0, // 待付款
    createTime: new Date().toLocaleString('zh-CN'),
  }
  db.orders.unshift(order)
  goods.purchasable = false
  persist()
  return delay(order)
}

export function updateOrderShippingAddress(id: string, address: string): Promise<void> {
  const db = getDB()
  const o = db.orders.find((x) => x.orderId === id)
  if (o) {
    o.shippingAddress = address
    persist()
  }
  return delay(undefined)
}

export function updateOrderStatus(id: string, status: OrderStatus): Promise<void> {
  const db = getDB()
  const o = db.orders.find((x) => x.orderId === id)
  if (o) {
    o.orderStatus = status
    if (status === 1) {
      // 模拟支付
      o.payStatus = 1
      o.payTime = new Date().toLocaleString('zh-CN')
    } else if (status === 3) {
      // 订单完成 → 商品已售（对应触发器）
      o.finishTime = new Date().toLocaleString('zh-CN')
      const goods = db.goods.find((g) => g.goodsId === o.goodsId)
      if (goods) {
        goods.goodsStatus = 3
        goods.purchasable = false
      }
    } else if (status === 4) {
      // 取消 → 商品恢复可购买
      const goods = db.goods.find((g) => g.goodsId === o.goodsId)
      if (goods) {
        goods.purchasable = goods.goodsStatus === 1
      }
    }
    persist()
  }
  return delay(undefined)
}
