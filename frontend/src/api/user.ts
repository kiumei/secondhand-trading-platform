import { getDB, persist, nextId, delay } from './mock/db'
import type { User } from '@/types'

export function login(phone: string, password: string): Promise<User | null> {
  const u = getDB().users.find((x) => x.phone === phone && x.password === password)
  // 封禁用户不能登录
  if (u?.status !== 0) return delay(null)
  return delay(u ?? null)
}

export function register(input: {
  phone: string
  password: string
  userName: string
}): Promise<User | null> {
  const db = getDB()
  if (db.users.some((x) => x.phone === input.phone)) return delay(null)
  const user: User = {
    userId: nextId('user'),
    ...input,
    avatar:
      'data:image/svg+xml;charset=utf-8,' +
      encodeURIComponent(
        '<svg xmlns="http://www.w3.org/2000/svg" width="200" height="200"><rect width="200" height="200" fill="#d0d0d0"/></svg>',
      ),
    intro: '',
    role: 0,
    status: 0,
    registerTime: new Date().toLocaleString('zh-CN'),
  }
  db.users.push(user)
  persist()
  return delay(user)
}

export function updateProfile(
  id: string,
  patch: Partial<Pick<User, 'userName' | 'avatar' | 'intro' | 'address'>>,
): Promise<void> {
  const db = getDB()
  const u = db.users.find((x) => x.userId === id)
  if (u) {
    Object.assign(u, patch)
    persist()
  }
  return delay(undefined)
}

export function updatePassword(
  id: string,
  oldPassword: string,
  newPassword: string,
): Promise<boolean> {
  const db = getDB()
  const u = db.users.find((x) => x.userId === id)
  if (!u || u.password !== oldPassword) return delay(false)
  u.password = newPassword
  persist()
  return delay(true)
}

export function getUser(id: string): Promise<User | undefined> {
  return delay(getDB().users.find((x) => x.userId === id))
}

export function listUsers(): Promise<User[]> {
  return delay(getDB().users.slice())
}

export function deleteUser(id: string): Promise<void> {
  const db = getDB()
  db.users = db.users.filter((x) => x.userId !== id)
  persist()
  return delay(undefined)
}

export function setUserStatus(id: string, status: 0 | 1): Promise<void> {
  const db = getDB()
  const u = db.users.find((x) => x.userId === id)
  if (u) {
    u.status = status
    if (status === 1) {
      // 封禁 → 名下 0/1 状态商品强制下架（对应触发器 trg_user_ban_off_goods）
      for (const g of db.goods) {
        if (g.publishUserId === id && (g.goodsStatus === 0 || g.goodsStatus === 1)) {
          g.goodsStatus = 2
          g.purchasable = false
        }
      }
    }
    persist()
  }
  return delay(undefined)
}

export function resetPassword(id: string, newPassword: string): Promise<void> {
  const db = getDB()
  const u = db.users.find((x) => x.userId === id)
  if (u) {
    u.password = newPassword
    persist()
  }
  return delay(undefined)
}
