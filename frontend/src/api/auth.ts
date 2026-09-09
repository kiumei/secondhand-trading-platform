import http, { refreshCsrf } from './http'
import type { User } from '@/types'

// 登录：先取 CSRF，登录成功后重新取（后端会刷新 token）
export async function login(phone: string, password: string): Promise<User> {
  await refreshCsrf()
  const user = (await http.post('/auth/login', { phone, password })) as User
  await refreshCsrf()
  return user
}

// 注册：注册成功不自动登录
export async function register(phone: string, password: string, userName: string): Promise<User> {
  await refreshCsrf()
  return (await http.post('/auth/register', { phone, password, userName })) as User
}

export async function logout(): Promise<void> {
  await refreshCsrf()
  await http.post('/auth/logout')
}

// 当前用户（刷新页面恢复会话也用它）
export async function getCurrentUser(): Promise<User> {
  return (await http.get('/users/me')) as User
}

export async function updateProfile(
  patch: Partial<Pick<User, 'userName' | 'avatar' | 'intro' | 'address'>>,
): Promise<User> {
  return (await http.patch('/users/me', patch)) as User
}

export async function updatePassword(oldPassword: string, newPassword: string): Promise<void> {
  await http.put('/users/me/password', { oldPassword, newPassword })
}
