<script setup lang="ts">
import { ref, onMounted, reactive, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { listCategories, createCategory, updateCategory, deleteCategory } from '@/api/admin'
import type { Category } from '@/types'

const categories = ref<Category[]>([])
const loading = ref(false)

const dialogVisible = ref(false)
const isEdit = ref(false)
const form = reactive({ cateId: '', cateName: '', parentId: 0 })

const parentCategories = computed(() => categories.value.filter((c) => c.parentId === 0))

async function load() {
  loading.value = true
  categories.value = await listCategories()
  loading.value = false
}

function parentName(id: number): string {
  return parentCategories.value.find((c) => c.cateId === String(id))?.cateName ?? '—'
}

function openAdd() {
  isEdit.value = false
  form.cateId = ''
  form.cateName = ''
  form.parentId = 0
  dialogVisible.value = true
}

function openEdit(c: Category) {
  isEdit.value = true
  form.cateId = c.cateId
  form.cateName = c.cateName
  form.parentId = c.parentId
  dialogVisible.value = true
}

async function save() {
  if (!form.cateName.trim()) {
    ElMessage.warning('请输入分类名称')
    return
  }
  if (isEdit.value) {
    await updateCategory(form.cateId, form.cateName.trim())
  } else {
    await createCategory(form.cateName.trim(), form.parentId)
  }
  ElMessage.success('已保存')
  dialogVisible.value = false
  load()
}

async function remove(c: Category) {
  await ElMessageBox.confirm(`确定删除分类「${c.cateName}」？`, '提示', { type: 'warning' })
  await deleteCategory(c.cateId)
  ElMessage.success('已删除')
  load()
}

onMounted(load)
</script>

<template>
  <div class="categories">
    <div class="toolbar">
      <el-button type="primary" @click="openAdd">新增分类</el-button>
    </div>
    <el-table v-loading="loading" :data="categories" style="width: 100%">
      <el-table-column prop="cateId" label="ID" width="80" />
      <el-table-column label="层级" width="90">
        <template #default="{ row }">
          <el-tag :type="row.parentId === 0 ? 'primary' : 'info'" size="small">
            {{ row.parentId === 0 ? '父类' : '子类' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="cateName" label="分类名称" min-width="160" />
      <el-table-column label="所属父类" width="140">
        <template #default="{ row }">{{ row.parentId === 0 ? '—' : parentName(row.parentId) }}</template>
      </el-table-column>
      <el-table-column label="操作" width="160">
        <template #default="{ row }">
          <el-button size="small" @click="openEdit(row)">编辑</el-button>
          <el-button type="danger" size="small" @click="remove(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog v-model="dialogVisible" :title="isEdit ? '编辑分类' : '新增分类'" width="420px">
      <el-form label-width="80px">
        <el-form-item label="分类名称">
          <el-input v-model="form.cateName" maxlength="50" placeholder="请输入分类名称" />
        </el-form-item>
        <el-form-item label="所属父类">
          <el-select v-model="form.parentId" :disabled="isEdit && form.parentId !== 0" style="width: 100%">
            <el-option :value="0" label="无（作为一级分类）" />
            <el-option
              v-for="p in parentCategories"
              :key="p.cateId"
              :value="p.cateId"
              :label="p.cateName"
            />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="save">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped>
.toolbar {
  margin-bottom: 16px;
}
</style>
