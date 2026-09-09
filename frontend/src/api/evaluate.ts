import http from './http'
import type { Evaluate } from '@/types'

interface ApiEvaluation {
  evaluateId: string
  orderId: string
  goodsId: string
  evaluateUserId: string
  score: number
  evaluateContent: string
  evaluateTime: string
}

function toEvaluation(api: ApiEvaluation): Evaluate {
  return {
    evaluateId: api.evaluateId,
    orderId: api.orderId,
    goodsId: api.goodsId,
    evaluateUserId: api.evaluateUserId,
    score: api.score as 1 | 2 | 3 | 4 | 5,
    evaluateContent: api.evaluateContent,
    evaluateTime: api.evaluateTime,
  }
}

// 某件商品的评价列表（公开）
export async function listEvaluates(goodsId: string): Promise<Evaluate[]> {
  const data = (await http.get(`/goods/${goodsId}/evaluations`, {
    params: { page: 1, pageSize: 50 },
  })) as { items: ApiEvaluation[] }
  return (data.items ?? []).map(toEvaluation)
}

// 管理员评价列表
export async function listAdminEvaluations(): Promise<Evaluate[]> {
  const data = (await http.get('/admin/evaluations', {
    params: { page: 1, pageSize: 50 },
  })) as { items: ApiEvaluation[] }
  return (data.items ?? []).map(toEvaluation)
}

export async function createEvaluate(input: {
  orderId: string
  goodsId: string
  evaluateUserId: string
  score: 1 | 2 | 3 | 4 | 5
  evaluateContent: string
}): Promise<Evaluate | null> {
  try {
    const api = (await http.post(`/orders/${input.orderId}/evaluation`, {
      score: input.score,
      content: input.evaluateContent,
    })) as ApiEvaluation
    return toEvaluation(api)
  } catch {
    return null
  }
}

export async function deleteEvaluate(id: string): Promise<void> {
  await http.delete(`/admin/evaluations/${id}`)
}
