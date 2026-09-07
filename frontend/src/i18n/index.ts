import { createI18n } from 'vue-i18n'

const messages = {
  'zh-CN': {
    app: {
      name: '校园二手集市',
      search: '搜索宝贝',
      publish: '发布',
      message: '消息',
      login: '登录',
      register: '注册',
      logout: '退出登录',
      profile: '我的',
      admin: '后台管理',
    },
  },
  'en-US': {
    app: {
      name: 'Campus Flea Market',
      search: 'Search',
      publish: 'Sell',
      message: 'Messages',
      login: 'Sign in',
      register: 'Sign up',
      logout: 'Sign out',
      profile: 'Profile',
      admin: 'Admin',
    },
  },
}

export const i18n = createI18n({
  legacy: false,
  locale: localStorage.getItem('xianyu-locale') || 'zh-CN',
  fallbackLocale: 'zh-CN',
  messages,
})

export default i18n
