import { ref, computed } from 'vue'
import { defineStore } from 'pinia'
import type { User } from '@/types'
import * as userApi from '@/api/user'

const TOKEN_KEY = 'xianyu-user'
// 登录态有效期：1 天
const SESSION_TTL = 24 * 60 * 60 * 1000

export const useUserStore = defineStore('user', () => {
  const currentUser = ref<User | null>(null)

  const isLoggedIn = computed(() => currentUser.value != null)
  const isAdmin = computed(() => currentUser.value?.role === 'admin')

  // 同步恢复登录态，避免刷新后因异步加载被路由守卫误判为未登录
  function loadFromStorage() {
    try {
      const raw = localStorage.getItem(TOKEN_KEY)
      if (!raw) return
      const data = JSON.parse(raw) as { user: User; expiresAt: number }
      // 过期则清除
      if (data?.user && data.expiresAt > Date.now()) {
        currentUser.value = data.user
      } else {
        localStorage.removeItem(TOKEN_KEY)
      }
    } catch {
      localStorage.removeItem(TOKEN_KEY)
    }
  }

  function persist() {
    if (currentUser.value) {
      localStorage.setItem(
        TOKEN_KEY,
        JSON.stringify({ user: currentUser.value, expiresAt: Date.now() + SESSION_TTL }),
      )
    } else {
      localStorage.removeItem(TOKEN_KEY)
    }
  }

  async function login(username: string, password: string) {
    const u = await userApi.login(username, password)
    if (u) {
      currentUser.value = u
      persist()
    }
    return u != null
  }

  async function register(input: {
    username: string
    password: string
    nickname: string
    phone: string
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

  async function updateProfile(patch: Partial<Pick<User, 'nickname' | 'phone' | 'address' | 'avatar'>>) {
    if (!currentUser.value) return
    await userApi.updateProfile(currentUser.value.id, patch)
    Object.assign(currentUser.value, patch)
    persist()
  }

  async function updatePassword(oldPassword: string, newPassword: string) {
    if (!currentUser.value) return false
    return userApi.updatePassword(currentUser.value.id, oldPassword, newPassword)
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
  }
})
