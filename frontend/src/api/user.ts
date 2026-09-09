import http from './http'
import type { User } from '@/types'

interface ApiUser {
  userId: string
  userName: string
  phone?: string
  avatar?: string
  intro?: string
  address?: string
  role?: number
  status?: number
  registerTime?: string
}

function toUser(api: ApiUser): User {
  return {
    userId: api.userId,
    userName: api.userName,
    phone: api.phone ?? '',
    avatar: api.avatar ?? '',
    intro: api.intro ?? '',
    address: api.address,
    role: (api.role ?? 0) as 0 | 1,
    status: api.status ?? 0,
    registerTime: api.registerTime ?? '',
  }
}

// 公开用户资料（仅返回 userId/userName/avatar/intro，不含手机号/地址）
export async function getUser(id: string): Promise<User | undefined> {
  try {
    const api = (await http.get(`/public/users/${id}`)) as ApiUser
    return toUser(api)
  } catch {
    return undefined
  }
}

// 管理员用户列表
export async function listUsers(): Promise<User[]> {
  const data = (await http.get('/admin/users', { params: { page: 1, pageSize: 200 } })) as {
    items: ApiUser[]
  }
  return (data.items ?? []).map(toUser)
}

// 封禁 / 解封
export async function setUserStatus(id: string, status: 0 | 1): Promise<void> {
  if (status === 1) {
    await http.post(`/admin/users/${id}/ban`)
  } else {
    await http.post(`/admin/users/${id}/unban`)
  }
}

// 重置密码
export async function resetPassword(id: string, newPassword: string): Promise<void> {
  await http.post(`/admin/users/${id}/reset-password`, { password: newPassword })
}
