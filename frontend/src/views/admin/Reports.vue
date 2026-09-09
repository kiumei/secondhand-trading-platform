<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { listReports, handleReport } from '@/api/report'
import { listGoods } from '@/api/goods'
import type { Report, Goods } from '@/types'

const reports = ref<Report[]>([])
const goodsMap = ref<Record<string, Goods>>({})
const loading = ref(false)

async function load() {
  loading.value = true
  reports.value = await listReports()
  const all = await listGoods()
  goodsMap.value = Object.fromEntries(all.map((g) => [g.goodsId, g]))
  loading.value = false
}

async function handle(r: Report) {
  const { value } = await ElMessageBox.prompt('请填写处理结果', '处理举报', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
  })
  await handleReport(r.reportId, value)
  ElMessage.success('已处理')
  load()
}

onMounted(load)
</script>

<template>
  <div class="reports">
    <el-table v-loading="loading" :data="reports" style="width: 100%">
      <el-table-column prop="reportId" label="ID" width="80" />
      <el-table-column label="商品" min-width="180">
        <template #default="{ row }">{{ goodsMap[row.goodsId]?.title ?? `#${row.goodsId}` }}</template>
      </el-table-column>
      <el-table-column prop="reportType" label="举报类型" width="140" />
      <el-table-column prop="reportContent" label="举报原因" min-width="200" show-overflow-tooltip />
      <el-table-column label="状态" width="100">
        <template #default="{ row }">
          <el-tag :type="row.handleStatus === 0 ? 'warning' : 'success'">
            {{ row.handleStatus === 0 ? '待处理' : '已处理' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="handleResult" label="处理结果" min-width="160" show-overflow-tooltip />
      <el-table-column label="操作" width="120">
        <template #default="{ row }">
          <el-button v-if="row.handleStatus === 0" type="primary" size="small" @click="handle(row)">处理</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>
