import http from './http'
import type { Order, OrderStatus } from '@/types'

interface ApiOrder {
  orderId: string
  buyerId: string
  sellerId: string
  goodsId: string
  orderPrice: string
  payStatus: number
  orderStatus: number
  payTime?: string | null
  finishTime?: string | null
  createTime: string
  shippingAddress?: string | null
}

function toOrder(api: ApiOrder): Order {
  return {
    orderId: api.orderId,
    buyerId: api.buyerId,
    sellerId: api.sellerId,
    goodsId: api.goodsId,
    orderPrice: parseFloat(api.orderPrice),
    payStatus: api.payStatus,
    orderStatus: api.orderStatus as OrderStatus,
    payTime: api.payTime ?? undefined,
    finishTime: api.finishTime ?? undefined,
    createTime: api.createTime,
    shippingAddress: api.shippingAddress ?? undefined,
  }
}

// 查询订单：buyerId 表示买到的，sellerId 表示卖出的
export async function listOrders(
  query: { buyerId?: string; sellerId?: string } = {},
): Promise<Order[]> {
  const side = query.sellerId != null ? 'sell' : 'buy'
  const data = (await http.get('/orders', { params: { side, page: 1, pageSize: 50 } })) as {
    items: ApiOrder[]
  }
  return (data.items ?? []).map(toOrder)
}

export async function createOrder(input: {
  goodsId: string
  buyerId: string
  sellerId: string
  orderPrice: number
  shippingAddress?: string
}): Promise<Order | null> {
  try {
    const api = (await http.post('/orders', {
      goodsId: input.goodsId,
      shippingAddress: input.shippingAddress,
    })) as ApiOrder
    return toOrder(api)
  } catch {
    return null
  }
}

// 状态动作：待发货→支付、待收货→发货、完成→确认、取消→取消
const actionByStatus: Record<number, string> = {
  1: 'mock-pay',
  2: 'deliver',
  3: 'complete',
  4: 'cancel',
}

export async function updateOrderStatus(id: string, status: OrderStatus): Promise<void> {
  const action = actionByStatus[status]
  if (action) {
    await http.post(`/orders/${id}/${action}`)
  }
}

// 后端不提供下单后修改地址的接口
export async function updateOrderShippingAddress(_id: string, _address: string): Promise<void> {
  // no-op
}

// 管理员订单列表
export async function listAdminOrders(status?: number): Promise<Order[]> {
  const params: Record<string, string | number> = { page: 1, pageSize: 50 }
  if (status != null) params.status = status
  const data = (await http.get('/admin/orders', { params })) as { items: ApiOrder[] }
  return (data.items ?? []).map(toOrder)
}
