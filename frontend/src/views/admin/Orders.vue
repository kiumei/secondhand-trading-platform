<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { listOrders } from '@/api/order'
import { listGoods } from '@/api/goods'
import { getUser } from '@/api/user'
import type { Order, Goods } from '@/types'

const orders = ref<Order[]>([])
const goodsMap = ref<Record<number, Goods>>({})
const userNames = ref<Record<number, string>>({})
const loading = ref(false)

const statusText: Record<number, string> = {
  0: '待付款',
  1: '待发货',
  2: '待收货',
  3: '已完成',
  4: '已取消',
  5: '售后',
}

async function load() {
  loading.value = true
  orders.value = await listOrders()
  const all = await listGoods()
  goodsMap.value = Object.fromEntries(all.map((g) => [g.goodsId, g]))
  const ids = new Set<number>()
  orders.value.forEach((o) => {
    ids.add(o.buyerId)
    ids.add(o.sellerId)
  })
  for (const id of ids) {
    const u = await getUser(id)
    if (u) userNames.value[id] = u.userName
  }
  loading.value = false
}

onMounted(load)
</script>

<template>
  <div class="orders">
    <el-table v-loading="loading" :data="orders" style="width: 100%">
      <el-table-column prop="orderId" label="订单号" width="90">
        <template #default="{ row }">#{{ row.orderId }}</template>
      </el-table-column>
      <el-table-column label="商品" min-width="180">
        <template #default="{ row }">{{ goodsMap[row.goodsId]?.title ?? `#${row.goodsId}` }}</template>
      </el-table-column>
      <el-table-column label="买家" width="110">
        <template #default="{ row }">{{ userNames[row.buyerId] }}</template>
      </el-table-column>
      <el-table-column label="卖家" width="110">
        <template #default="{ row }">{{ userNames[row.sellerId] }}</template>
      </el-table-column>
      <el-table-column label="金额" width="100">
        <template #default="{ row }"><span class="price">¥{{ row.orderPrice }}</span></template>
      </el-table-column>
      <el-table-column label="状态" width="100">
        <template #default="{ row }">{{ statusText[row.orderStatus] }}</template>
      </el-table-column>
      <el-table-column prop="createTime" label="下单时间" width="180" />
    </el-table>
  </div>
</template>
