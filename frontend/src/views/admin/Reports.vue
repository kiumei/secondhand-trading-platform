<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { listReports, resolveReport } from '@/api/report'
import { listGoods } from '@/api/goods'
import type { Report, Goods } from '@/types'

const reports = ref<Report[]>([])
const goodsMap = ref<Record<number, Goods>>({})
const loading = ref(false)

async function load() {
  loading.value = true
  reports.value = await listReports()
  const all = await listGoods()
  goodsMap.value = Object.fromEntries(all.map((g) => [g.id, g]))
  loading.value = false
}

async function resolve(r: Report) {
  await resolveReport(r.id)
  ElMessage.success('已处理')
  load()
}

onMounted(load)
</script>

<template>
  <div class="reports">
    <el-table v-loading="loading" :data="reports" style="width: 100%">
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column label="商品" min-width="200">
        <template #default="{ row }">{{ goodsMap[row.goodsId]?.title ?? `#${row.goodsId}` }}</template>
      </el-table-column>
      <el-table-column prop="reason" label="举报原因" min-width="180" show-overflow-tooltip />
      <el-table-column prop="createdAt" label="举报时间" width="180" />
      <el-table-column label="状态" width="100">
        <template #default="{ row }">
          <el-tag :type="row.status === 'pending' ? 'warning' : 'success'">
            {{ row.status === 'pending' ? '待处理' : '已处理' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="120">
        <template #default="{ row }">
          <el-button v-if="row.status === 'pending'" type="primary" size="small" @click="resolve(row)">处理</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>
