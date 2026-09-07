import { ref, watch } from 'vue'
import { defineStore } from 'pinia'

export type ThemeMode = 'light' | 'dark' | 'system'
export type Locale = 'zh-CN' | 'en-US'

const THEME_KEY = 'xianyu-theme'
const LOCALE_KEY = 'xianyu-locale'

export const useThemeStore = defineStore('theme', () => {
  const theme = ref<ThemeMode>((localStorage.getItem(THEME_KEY) as ThemeMode) || 'light')
  const locale = ref<Locale>((localStorage.getItem(LOCALE_KEY) as Locale) || 'zh-CN')

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

  function setLocale(l: Locale) {
    locale.value = l
    localStorage.setItem(LOCALE_KEY, l)
  }

  // 跟随系统时监听变化
  if (typeof window !== 'undefined') {
    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', () => {
      if (theme.value === 'system') applyTheme()
    })
  }

  watch(theme, applyTheme, { immediate: true })

  return { theme, locale, setTheme, setLocale, applyTheme }
})
