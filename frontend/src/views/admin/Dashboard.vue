<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { listGoods } from '@/api/goods'
import { listOrders } from '@/api/order'
import { listUsers } from '@/api/user'
import { listReports } from '@/api/report'

const stats = ref({
  goods: 0,
  users: 0,
  orders: 0,
  reports: 0,
  sales: 0,
})

onMounted(async () => {
  const [goods, orders, users, reports] = await Promise.all([
    listGoods(),
    listOrders(),
    listUsers(),
    listReports(),
  ])
  stats.value = {
    goods: goods.length,
    users: users.length,
    orders: orders.length,
    reports: reports.filter((r) => r.status === 'pending').length,
    sales: orders.filter((o) => o.status === 'done' || o.status === 'shipped').reduce((s, o) => s + o.price, 0),
  }
})

const cards = [
  { key: 'goods', label: '商品总数', color: '#ff8200' },
  { key: 'users', label: '用户总数', color: '#409eff' },
  { key: 'orders', label: '订单总数', color: '#67c23a' },
  { key: 'reports', label: '待处理举报', color: '#f56c6c' },
]
</script>

<template>
  <div class="dashboard">
    <div class="stat-grid">
      <div v-for="c in cards" :key="c.key" class="stat-card">
        <div class="stat-value" :style="{ color: c.color }">{{ stats[c.key as keyof typeof stats] }}</div>
        <div class="stat-label">{{ c.label }}</div>
      </div>
    </div>
    <div class="sales-card">
      <div class="sales-title">累计销售额</div>
      <div class="sales-value price">{{ stats.sales }}</div>
    </div>
  </div>
</template>

<style scoped>
.stat-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 16px;
  margin-bottom: 16px;
}
.stat-card {
  background: var(--card-bg);
  border-radius: 8px;
  padding: 24px;
}
.stat-value {
  font-size: 32px;
  font-weight: 700;
}
.stat-label {
  color: var(--text-sub);
  margin-top: 4px;
}
.sales-card {
  background: var(--card-bg);
  border-radius: 8px;
  padding: 24px;
}
.sales-title {
  color: var(--text-sub);
  margin-bottom: 8px;
}
.sales-value {
  font-size: 36px;
}
</style>
