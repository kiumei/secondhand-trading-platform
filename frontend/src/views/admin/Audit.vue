<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { listGoods, updateGoodsStatus } from '@/api/goods'
import { getUser } from '@/api/user'
import type { Goods, User } from '@/types'

const goods = ref<Goods[]>([])
const sellers = ref<Record<number, string>>({})
const loading = ref(false)

const statusText: Record<string, string> = {
  on: '在售',
  sold: '已售出',
  off: '已下架',
  pending: '待审核',
  rejected: '已驳回',
}
const statusType: Record<string, 'success' | 'info' | 'warning' | 'danger'> = {
  on: 'success',
  sold: 'info',
  off: 'info',
  pending: 'warning',
  rejected: 'danger',
}

async function load() {
  loading.value = true
  goods.value = await listGoods()
  for (const g of goods.value) {
    const u = await getUser(g.sellerId)
    if (u) sellers.value[g.sellerId] = u.nickname
  }
  loading.value = false
}

async function approve(g: Goods) {
  await updateGoodsStatus(g.id, 'on')
  ElMessage.success('已通过')
  load()
}

async function reject(g: Goods) {
  const { value } = await ElMessageBox.prompt('驳回原因', '驳回', {
    confirmButtonText: '驳回',
    cancelButtonText: '取消',
  })
  await updateGoodsStatus(g.id, 'rejected', value)
  ElMessage.success('已驳回')
  load()
}

async function off(g: Goods) {
  await updateGoodsStatus(g.id, 'off')
  ElMessage.success('已下架')
  load()
}

onMounted(load)
</script>

<template>
  <div class="audit">
    <el-table v-loading="loading" :data="goods" style="width: 100%">
      <el-table-column label="图片" width="80">
        <template #default="{ row }">
          <el-image :src="row.images[0]" style="width: 50px; height: 50px" fit="cover" />
        </template>
      </el-table-column>
      <el-table-column prop="title" label="标题" min-width="200" show-overflow-tooltip />
      <el-table-column label="价格" width="100">
        <template #default="{ row }">
          <span class="price">{{ row.price }}</span>
        </template>
      </el-table-column>
      <el-table-column label="卖家" width="110">
        <template #default="{ row }">{{ sellers[row.sellerId] }}</template>
      </el-table-column>
      <el-table-column label="类型" width="80">
        <template #default="{ row }">{{ row.type === 'sell' ? '售卖' : '求购' }}</template>
      </el-table-column>
      <el-table-column label="状态" width="100">
        <template #default="{ row }">
          <el-tag :type="statusType[row.status]">{{ statusText[row.status] }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="200" fixed="right">
        <template #default="{ row }">
          <el-button v-if="row.status === 'pending'" type="success" size="small" @click="approve(row)">通过</el-button>
          <el-button v-if="row.status === 'pending'" type="danger" size="small" @click="reject(row)">驳回</el-button>
          <el-button v-if="row.status === 'on'" type="warning" size="small" @click="off(row)">下架</el-button>
          <el-tooltip v-if="row.status === 'rejected' && row.rejectReason" :content="row.rejectReason">
            <el-button size="small" disabled>原因</el-button>
          </el-tooltip>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>
