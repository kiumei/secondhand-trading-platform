<script setup lang="ts">
import { ref, watch, computed, onMounted, onBeforeUnmount } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { useFavoriteStore } from '@/stores/favorite'
import { listMessages } from '@/api/message'
import { listOrders } from '@/api/order'

const router = useRouter()
const route = useRoute()
const userStore = useUserStore()
const favoriteStore = useFavoriteStore()

// 当前高亮的 dock 项（route.name 与 item.key 一致）
const activeKey = computed(() => String(route.name ?? ''))

const msgCount = ref(0)
const orderCount = ref(0)

async function loadBadges() {
  if (!userStore.isLoggedIn) {
    msgCount.value = 0
    orderCount.value = 0
    return
  }
  const uid = userStore.currentUser!.userId
  const [msgs, buys, sells] = await Promise.all([
    listMessages(uid),
    listOrders({ buyerId: uid }),
    listOrders({ sellerId: uid }),
  ])
  msgCount.value = msgs.filter((m) => m.receiveUserId === uid && m.isRead === 0).length
  orderCount.value = [...buys, ...sells].filter(
    (o) => o.orderStatus !== 3 && o.orderStatus !== 4,
  ).length
  favoriteStore.refresh()
}

watch(() => userStore.isLoggedIn, (v) => {
  if (v) loadBadges()
}, { immediate: true })

// 路由变化时刷新角标（读完消息 / 处理完订单返回后，红点随之更新）
watch(() => route.fullPath, () => loadBadges())

// 消息页内已读某会话后即时刷新红点（无需切换路由）
onMounted(() => window.addEventListener('messages-read', loadBadges))
onBeforeUnmount(() => window.removeEventListener('messages-read', loadBadges))

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

const items = [
  { key: 'publish', icon: 'Plus', label: '发布', accent: true, fn: goPublish },
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
      :class="{ accent: it.accent, active: activeKey === it.key }"
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
  user-select: none;
  color: var(--text-main);
  transition:
    color 0.2s,
    background 0.2s,
    transform 0.2s cubic-bezier(0.34, 1.56, 0.64, 1);
}
.dock-item:hover {
  color: var(--color-primary);
  background: var(--color-surface);
  transform: scale(1.08);
}
.dock-item:active {
  transform: scale(0.9);
}
.dock-item.active {
  color: var(--color-primary);
  background: var(--el-color-primary-light-9);
}
.dock-item.active .dock-label {
  font-weight: 600;
}
.dock-item.active .el-icon {
  animation: dock-bounce 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
}
.dock-item.accent {
  background: var(--color-primary);
  color: #fff;
}
.dock-item.accent:hover {
  background: var(--color-primary-active);
  color: #fff;
}
@keyframes dock-bounce {
  0% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.25);
  }
  100% {
    transform: scale(1);
  }
}
.dock-label {
  font-size: var(--text-xs);
}
</style>
