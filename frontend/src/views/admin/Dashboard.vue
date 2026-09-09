<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { listAdminGoods } from '@/api/goods'
import { listAdminOrders } from '@/api/order'
import { listUsers, getUser } from '@/api/user'
import { listReports } from '@/api/report'
import type { Goods, GoodsStatus } from '@/types'

const router = useRouter()

const loading = ref(false)
const stats = ref({
  goods: 0,
  users: 0,
  orders: 0,
  reports: 0,
  sales: 0,
})
const pendingGoods = ref<Goods[]>([])
const sellerNames = ref<Record<string, string>>({})

onMounted(async () => {
  loading.value = true
  try {
    // 公开 listGoods 只返回上架商品；这里按状态拉管理员全量，统计与待审核列表才准确
    const allGoods: Goods[] = []
    const statuses: GoodsStatus[] = [0, 1, 2, 3, 4]
    for (const s of statuses) {
      allGoods.push(...(await listAdminGoods(s)))
    }
    const [orders, users, reports] = await Promise.all([
      listAdminOrders(),
      listUsers(),
      listReports(),
    ])
    stats.value = {
      goods: allGoods.length,
      users: users.length,
      orders: orders.length,
      reports: reports.filter((r) => r.handleStatus === 0).length,
      sales: orders
        .filter((o) => o.orderStatus === 2 || o.orderStatus === 3)
        .reduce((s, o) => s + o.orderPrice, 0),
    }
    pendingGoods.value = allGoods.filter((g) => g.goodsStatus === 0)
    for (const g of pendingGoods.value) {
      const u = await getUser(g.publishUserId)
      if (u) sellerNames.value[g.publishUserId] = u.userName
    }
  } finally {
    loading.value = false
  }
})

function goAudit() {
  router.push('/admin/audit')
}

const cards = [
  { key: 'goods', label: '商品总数', color: '#ff8200' },
  { key: 'users', label: '用户总数', color: '#409eff' },
  { key: 'orders', label: '订单总数', color: '#67c23a' },
  { key: 'reports', label: '待处理举报', color: '#f56c6c' },
]
</script>

<template>
  <div class="dashboard" v-loading="loading" element-loading-text="加载中…">
    <div class="stat-grid">
      <div v-for="c in cards" :key="c.key" class="stat-card">
        <div class="stat-value" :style="{ color: c.color }">{{ stats[c.key as keyof typeof stats] }}</div>
        <div class="stat-label">{{ c.label }}</div>
      </div>
    </div>
    <div class="sales-card">
      <div class="sales-title">累计销售额</div>
      <div class="sales-value price">¥{{ stats.sales }}</div>
    </div>

    <div class="pending-card">
      <div class="pending-head">
        <span class="pending-title">待审核商品（{{ pendingGoods.length }}）</span>
        <el-button size="small" type="primary" @click="goAudit">去审核</el-button>
      </div>
      <el-table v-if="pendingGoods.length" :data="pendingGoods" size="small">
        <el-table-column label="图片" width="70">
          <template #default="{ row }">
            <el-image :src="row.images[0]" style="width: 40px; height: 40px" fit="cover" />
          </template>
        </el-table-column>
        <el-table-column prop="title" label="标题" min-width="200" show-overflow-tooltip />
        <el-table-column label="卖家" width="120">
          <template #default="{ row }">{{ sellerNames[row.publishUserId] }}</template>
        </el-table-column>
        <el-table-column prop="publishTime" label="发布时间" width="180" />
        <el-table-column label="操作" width="90">
          <template #default>
            <el-button size="small" type="success" @click="goAudit">审核</el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-empty v-else description="暂无待审核商品" :image-size="60" />
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
  margin-bottom: 16px;
}
.sales-title {
  color: var(--text-sub);
  margin-bottom: 8px;
}
.sales-value {
  font-size: 36px;
}
.pending-card {
  background: var(--card-bg);
  border-radius: 8px;
  padding: 24px;
}
.pending-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;
}
.pending-title {
  font-size: 16px;
  font-weight: 600;
}
</style>
