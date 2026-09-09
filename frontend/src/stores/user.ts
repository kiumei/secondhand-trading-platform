import { ref, computed } from 'vue'
import { defineStore } from 'pinia'
import type { User } from '@/types'
import * as authApi from '@/api/auth'

export const useUserStore = defineStore('user', () => {
  const currentUser = ref<User | null>(null)

  const isLoggedIn = computed(() => currentUser.value != null)
  const isAdmin = computed(() => currentUser.value?.role === 1)

  // 恢复会话：刷新页面后通过 Cookie Session 从后端取当前用户
  async function restoreSession() {
    try {
      currentUser.value = await authApi.getCurrentUser()
    } catch {
      currentUser.value = null
    }
  }

  async function login(phone: string, password: string) {
    try {
      currentUser.value = await authApi.login(phone, password)
      return true
    } catch {
      return false
    }
  }

  async function register(input: {
    phone: string
    password: string
    userName: string
  }) {
    try {
      await authApi.register(input.phone, input.password, input.userName)
      // 注册成功不自动登录，这里补一次登录
      currentUser.value = await authApi.login(input.phone, input.password)
      return true
    } catch {
      return false
    }
  }

  async function logout() {
    try {
      await authApi.logout()
    } catch {
      // ignore
    }
    currentUser.value = null
  }

  async function updateProfile(
    patch: Partial<Pick<User, 'userName' | 'avatar' | 'intro' | 'address'>>,
  ) {
    if (!currentUser.value) return
    currentUser.value = await authApi.updateProfile(patch)
  }

  async function updatePassword(oldPassword: string, newPassword: string) {
    try {
      await authApi.updatePassword(oldPassword, newPassword)
      return true
    } catch {
      return false
    }
  }

  // 同步当前用户状态（含封禁），被封禁则登出
  async function syncBanStatus() {
    if (!currentUser.value) return
    try {
      const u = await authApi.getCurrentUser()
      if (!u || u.status !== 0) {
        await logout()
        return
      }
      currentUser.value = u
    } catch {
      await logout()
    }
  }

  return {
    currentUser,
    isLoggedIn,
    isAdmin,
    restoreSession,
    login,
    register,
    logout,
    updateProfile,
    updatePassword,
    syncBanStatus,
  }
})
