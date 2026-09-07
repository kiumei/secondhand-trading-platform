<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { listCategories, createCategory, deleteCategory } from '@/api/admin'
import type { Category } from '@/types'

const categories = ref<Category[]>([])
const loading = ref(false)

async function load() {
  loading.value = true
  categories.value = await listCategories()
  loading.value = false
}

async function add() {
  const { value } = await ElMessageBox.prompt('分类名称', '新增分类', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
  })
  await createCategory(value)
  ElMessage.success('已添加')
  load()
}

async function remove(c: Category) {
  await ElMessageBox.confirm(`确定删除分类「${c.name}」？`, '提示', { type: 'warning' })
  await deleteCategory(c.id)
  ElMessage.success('已删除')
  load()
}

onMounted(load)
</script>

<template>
  <div class="categories">
    <div class="toolbar">
      <el-button type="primary" @click="add">新增分类</el-button>
    </div>
    <el-table v-loading="loading" :data="categories" style="width: 100%">
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="name" label="分类名称" />
      <el-table-column label="操作" width="120">
        <template #default="{ row }">
          <el-button type="danger" size="small" @click="remove(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<style scoped>
.toolbar {
  margin-bottom: 16px;
}
</style>
