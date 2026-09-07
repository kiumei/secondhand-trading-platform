<script setup lang="ts">
import { useRouter, useRoute } from 'vue-router'
import { useUserStore } from '@/stores/user'

const router = useRouter()
const route = useRoute()
const userStore = useUserStore()

const menus = [
  { path: '/admin', icon: 'Odometer', label: '仪表盘' },
  { path: '/admin/audit', icon: 'Checked', label: '商品审核' },
  { path: '/admin/categories', icon: 'Menu', label: '分类管理' },
  { path: '/admin/users', icon: 'User', label: '用户管理' },
  { path: '/admin/reports', icon: 'Warning', label: '举报处理' },
  { path: '/admin/bulletin', icon: 'Bell', label: '公告管理' },
  { path: '/admin/evaluates', icon: 'Star', label: '评价管理' },
  { path: '/admin/orders', icon: 'List', label: '订单管理' },
  { path: '/admin/settings', icon: 'Setting', label: '系统设置' },
]

function go(path: string) {
  router.push(path)
}

function backHome() {
  router.push({ name: 'home' })
}
</script>

<template>
  <div class="admin-layout">
    <aside class="sidebar">
      <div class="sidebar-logo" @click="backHome">
        <span class="logo-icon">闲</span>
        <span class="logo-text">管理后台</span>
      </div>
      <el-menu
        :default-active="route.path"
        class="sidebar-menu"
        @select="go"
      >
        <el-menu-item v-for="m in menus" :key="m.path" :index="m.path">
          <el-icon><component :is="m.icon" /></el-icon>
          <span>{{ m.label }}</span>
        </el-menu-item>
      </el-menu>
    </aside>
    <div class="admin-main">
      <header class="admin-header">
        <div class="crumb">{{ menus.find((m) => m.path === route.path)?.label || '后台' }}</div>
        <div class="admin-user">
          <span>{{ userStore.currentUser?.nickname }}</span>
          <el-button link @click="backHome">返回前台</el-button>
        </div>
      </header>
      <main class="admin-content">
        <RouterView />
      </main>
    </div>
  </div>
</template>

<style scoped>
.admin-layout {
  display: flex;
  min-height: 100vh;
  background: var(--page-bg);
}
.sidebar {
  width: 220px;
  background: var(--card-bg);
  border-right: 1px solid var(--border-color);
  display: flex;
  flex-direction: column;
  position: sticky;
  top: 0;
  height: 100vh;
}
.sidebar-logo {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 18px 20px;
  cursor: pointer;
}
.logo-icon {
  width: 30px;
  height: 30px;
  background: var(--xianyu-yellow);
  color: #fff;
  border-radius: 8px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
}
.logo-text {
  font-size: 16px;
  font-weight: 700;
}
.sidebar-menu {
  border-right: none;
  flex: 1;
}
.admin-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-width: 0;
}
.admin-header {
  height: 60px;
  background: var(--card-bg);
  border-bottom: 1px solid var(--border-color);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 24px;
}
.crumb {
  font-size: 16px;
  font-weight: 600;
}
.admin-user {
  display: flex;
  align-items: center;
  gap: 12px;
}
.admin-content {
  flex: 1;
  padding: 24px;
}
</style>
