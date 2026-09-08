<script setup lang="ts">
import { ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { useFavoriteStore } from '@/stores/favorite'
import { listMessages } from '@/api/message'
import { listOrders } from '@/api/order'

const router = useRouter()
const userStore = useUserStore()
const favoriteStore = useFavoriteStore()

const msgCount = ref(0)
const orderCount = ref(0)

async function loadBadges() {
  if (!userStore.isLoggedIn) {
    msgCount.value = 0
    orderCount.value = 0
    return
  }
  const uid = userStore.currentUser!.id
  const [msgs, buys, sells] = await Promise.all([
    listMessages(uid),
    listOrders({ buyerId: uid }),
    listOrders({ sellerId: uid }),
  ])
  msgCount.value = msgs.length
  orderCount.value = [...buys, ...sells].filter(
    (o) => !['done', 'cancelled'].includes(o.status),
  ).length
  favoriteStore.refresh()
}

watch(() => userStore.isLoggedIn, (v) => {
  if (v) loadBadges()
}, { immediate: true })

function go(name: string) {
  if (!userStore.isLoggedIn) {
    router.push({ name: 'login', query: { redirect: router.resolve({ name }).path } })
    return
  }
  router.push({ name })
}

function goPublish() {
  if (!userStore.isLoggedIn) {
    router.push({ name: 'login', query: { redirect: '/publish' } })
    return
  }
  router.push({ name: 'publish' })
}

function goService() {
  router.push({ name: 'search', query: { group: '5' } })
}

const items = [
  { key: 'publish', icon: 'Plus', label: '发布', accent: true, fn: goPublish },
  { key: 'service', icon: 'Service', label: '校园服务', fn: goService },
  { key: 'messages', icon: 'ChatDotRound', label: '消息', badge: () => msgCount.value },
  { key: 'orders', icon: 'Tickets', label: '订单', badge: () => orderCount.value },
  { key: 'favorites', icon: 'Star', label: '收藏', badge: () => favoriteStore.favorites.length },
  { key: 'profile', icon: 'User', label: '我的' },
]
</script>

<template>
  <div class="dock-bar">
    <div
      v-for="it in items"
      :key="it.key"
      class="dock-item"
      :class="{ accent: it.accent }"
      @click="it.fn ? it.fn() : go(it.key)"
    >
      <el-badge
        v-if="it.badge"
        :value="it.badge()"
        :hidden="it.badge() === 0"
        :max="99"
      >
        <el-icon :size="22"><component :is="it.icon" /></el-icon>
      </el-badge>
      <el-icon v-else :size="22"><component :is="it.icon" /></el-icon>
      <span class="dock-label">{{ it.label }}</span>
    </div>
  </div>
</template>

<style scoped>
.dock-bar {
  position: fixed;
  right: 16px;
  top: 50%;
  transform: translateY(-50%);
  z-index: 90;
  background: var(--card-bg);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-float);
  padding: var(--space-2);
  display: flex;
  flex-direction: column;
  gap: var(--space-1);
}
.dock-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 2px;
  padding: var(--space-2);
  border-radius: var(--radius-md);
  cursor: pointer;
  color: var(--text-main);
  transition: color 0.2s, background 0.2s;
}
.dock-item:hover {
  color: var(--color-primary);
  background: var(--color-surface);
}
.dock-item.accent {
  background: var(--color-primary);
  color: #fff;
}
.dock-item.accent:hover {
  background: var(--color-primary-active);
  color: #fff;
}
.dock-label {
  font-size: var(--text-xs);
}
</style>
