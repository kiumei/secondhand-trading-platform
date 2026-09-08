import { ref, watch } from 'vue'
import { defineStore } from 'pinia'

export type ThemeMode = 'light' | 'dark' | 'system'

const THEME_KEY = 'xianyu-theme'

export const useThemeStore = defineStore('theme', () => {
  const theme = ref<ThemeMode>((localStorage.getItem(THEME_KEY) as ThemeMode) || 'light')

  function applyTheme() {
    const isDark =
      theme.value === 'dark' ||
      (theme.value === 'system' &&
        window.matchMedia('(prefers-color-scheme: dark)').matches)
    document.documentElement.classList.toggle('dark', isDark)
  }

  function setTheme(mode: ThemeMode) {
    theme.value = mode
    localStorage.setItem(THEME_KEY, mode)
    applyTheme()
  }

  // 跟随系统时监听变化
  if (typeof window !== 'undefined') {
    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', () => {
      if (theme.value === 'system') applyTheme()
    })
  }

  watch(theme, applyTheme, { immediate: true })

  return { theme, setTheme, applyTheme }
})
