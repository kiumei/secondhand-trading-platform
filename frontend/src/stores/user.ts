import { ref, computed } from 'vue'
import { defineStore } from 'pinia'
import type { User } from '@/types'
import * as userApi from '@/api/user'

const USER_KEY = 'xianyu-user'
// 登录态有效期：1 天
const SESSION_TTL = 24 * 60 * 60 * 1000

export const useUserStore = defineStore('user', () => {
  const currentUser = ref<User | null>(null)

  const isLoggedIn = computed(() => currentUser.value != null)
  const isAdmin = computed(() => currentUser.value?.role === 1)

  // 同步恢复登录态，避免刷新后因异步加载被路由守卫误判为未登录
  function loadFromStorage() {
    try {
      const raw = localStorage.getItem(USER_KEY)
      if (!raw) return
      const data = JSON.parse(raw) as { user: User; expiresAt: number }
      // 过期则清除
      if (data?.user && data.expiresAt > Date.now()) {
        currentUser.value = data.user
      } else {
        localStorage.removeItem(USER_KEY)
      }
    } catch {
      localStorage.removeItem(USER_KEY)
    }
  }

  function persist() {
    if (currentUser.value) {
      localStorage.setItem(
        USER_KEY,
        JSON.stringify({ user: currentUser.value, expiresAt: Date.now() + SESSION_TTL }),
      )
    } else {
      localStorage.removeItem(USER_KEY)
    }
  }

  async function login(phone: string, password: string) {
    const u = await userApi.login(phone, password)
    if (u) {
      currentUser.value = u
      persist()
    }
    return u != null
  }

  async function register(input: {
    phone: string
    password: string
    userName: string
  }) {
    const u = await userApi.register(input)
    if (u) {
      currentUser.value = u
      persist()
    }
    return u != null
  }

  function logout() {
    currentUser.value = null
    persist()
  }

  async function updateProfile(patch: Partial<Pick<User, 'userName' | 'avatar' | 'intro' | 'address'>>) {
    if (!currentUser.value) return
    await userApi.updateProfile(currentUser.value.userId, patch)
    Object.assign(currentUser.value, patch)
    persist()
  }

  async function updatePassword(oldPassword: string, newPassword: string) {
    if (!currentUser.value) return false
    return userApi.updatePassword(currentUser.value.userId, oldPassword, newPassword)
  }

  // 同步当前用户状态（含封禁），被封禁则登出
  async function syncBanStatus() {
    if (!currentUser.value) return
    const u = await userApi.getUser(currentUser.value.userId)
    if (!u || u.status !== 0) {
      logout()
      return
    }
    currentUser.value = u
    persist()
  }

  return {
    currentUser,
    isLoggedIn,
    isAdmin,
    loadFromStorage,
    login,
    register,
    logout,
    updateProfile,
    updatePassword,
    syncBanStatus,
  }
})
