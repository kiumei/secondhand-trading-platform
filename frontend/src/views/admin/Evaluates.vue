<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { listEvaluates, deleteEvaluate } from '@/api/evaluate'
import { listGoods } from '@/api/goods'
import { getUser } from '@/api/user'
import type { Evaluate, Goods } from '@/types'

const evaluates = ref<Evaluate[]>([])
const goodsMap = ref<Record<number, Goods>>({})
const userNames = ref<Record<number, string>>({})
const loading = ref(false)

async function load() {
  loading.value = true
  evaluates.value = await listEvaluates()
  const all = await listGoods()
  goodsMap.value = Object.fromEntries(all.map((g) => [g.goodsId, g]))
  for (const e of evaluates.value) {
    const u = await getUser(e.evaluateUserId)
    if (u) userNames.value[e.evaluateUserId] = u.userName
  }
  loading.value = false
}

async function remove(e: Evaluate) {
  await ElMessageBox.confirm('确定删除该评价？', '提示', { type: 'warning' })
  await deleteEvaluate(e.evaluateId)
  ElMessage.success('已删除')
  load()
}

onMounted(load)
</script>

<template>
  <div class="evaluates">
    <el-table v-loading="loading" :data="evaluates" style="width: 100%">
      <el-table-column prop="evaluateId" label="ID" width="80" />
      <el-table-column label="商品" min-width="180">
        <template #default="{ row }">{{ goodsMap[row.goodsId]?.title ?? `#${row.goodsId}` }}</template>
      </el-table-column>
      <el-table-column label="用户" width="120">
        <template #default="{ row }">{{ userNames[row.evaluateUserId] }}</template>
      </el-table-column>
      <el-table-column label="评分" width="150">
        <template #default="{ row }">
          <el-rate :model-value="row.score" disabled />
        </template>
      </el-table-column>
      <el-table-column prop="evaluateContent" label="内容" min-width="240" show-overflow-tooltip />
      <el-table-column prop="evaluateTime" label="时间" width="180" />
      <el-table-column label="操作" width="100">
        <template #default="{ row }">
          <el-button type="danger" size="small" @click="remove(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>
