import { getDB, persist, nextId, delay } from './mock/db'
import type { User } from '@/types'

export function login(username: string, password: string): Promise<User | null> {
  const u = getDB().users.find(
    (x) => x.username === username && x.password === password,
  )
  // 封禁用户不能登录
  if (u?.banned) return delay(null)
  return delay(u ?? null)
}

export function register(input: {
  username: string
  password: string
  nickname: string
  phone: string
}): Promise<User | null> {
  const db = getDB()
  if (db.users.some((x) => x.username === input.username)) return delay(null)
  const user: User = {
    id: nextId('user'),
    ...input,
    address: '',
    role: 'student',
    avatar: `https://picsum.photos/seed/avatar${input.username}/200/200`,
  }
  db.users.push(user)
  persist()
  return delay(user)
}

export function updateProfile(
  id: number,
  patch: Partial<Pick<User, 'nickname' | 'phone' | 'address' | 'avatar'>>,
): Promise<void> {
  const db = getDB()
  const u = db.users.find((x) => x.id === id)
  if (u) {
    Object.assign(u, patch)
    persist()
  }
  return delay(undefined)
}

export function updatePassword(
  id: number,
  oldPassword: string,
  newPassword: string,
): Promise<boolean> {
  const db = getDB()
  const u = db.users.find((x) => x.id === id)
  if (!u || u.password !== oldPassword) return delay(false)
  u.password = newPassword
  persist()
  return delay(true)
}

export function getUser(id: number): Promise<User | undefined> {
  return delay(getDB().users.find((x) => x.id === id))
}

export function listUsers(): Promise<User[]> {
  return delay(getDB().users.slice())
}

export function deleteUser(id: number): Promise<void> {
  const db = getDB()
  db.users = db.users.filter((x) => x.id !== id)
  persist()
  return delay(undefined)
}

export function setBanned(id: number, banned: boolean): Promise<void> {
  const db = getDB()
  const u = db.users.find((x) => x.id === id)
  if (u) {
    u.banned = banned
    persist()
  }
  return delay(undefined)
}

export function resetPassword(id: number, newPassword: string): Promise<void> {
  const db = getDB()
  const u = db.users.find((x) => x.id === id)
  if (u) {
    u.password = newPassword
    persist()
  }
  return delay(undefined)
}

export function setOnline(id: number, online: boolean): Promise<void> {
  const db = getDB()
  const u = db.users.find((x) => x.id === id)
  if (u) {
    u.online = online
    persist()
  }
  return delay(undefined)
}
