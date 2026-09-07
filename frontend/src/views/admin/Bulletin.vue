<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { listBulletins, createBulletin, deleteBulletin } from '@/api/admin'
import type { Bulletin as BulletinType } from '@/types'

const bulletins = ref<BulletinType[]>([])
const loading = ref(false)
const dialogVisible = ref(false)
const form = ref({ title: '', content: '' })

async function load() {
  loading.value = true
  bulletins.value = await listBulletins()
  loading.value = false
}

async function submit() {
  if (!form.value.title || !form.value.content) {
    ElMessage.warning('请填写标题和内容')
    return
  }
  await createBulletin(form.value.title, form.value.content)
  ElMessage.success('已发布')
  dialogVisible.value = false
  form.value = { title: '', content: '' }
  load()
}

async function remove(b: BulletinType) {
  await ElMessageBox.confirm(`确定删除公告「${b.title}」？`, '提示', { type: 'warning' })
  await deleteBulletin(b.id)
  ElMessage.success('已删除')
  load()
}

onMounted(load)
</script>

<template>
  <div class="bulletin">
    <div class="toolbar">
      <el-button type="primary" @click="dialogVisible = true">发布公告</el-button>
    </div>
    <el-table v-loading="loading" :data="bulletins" style="width: 100%">
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="title" label="标题" min-width="180" show-overflow-tooltip />
      <el-table-column prop="content" label="内容" min-width="280" show-overflow-tooltip />
      <el-table-column prop="createdAt" label="发布时间" width="140" />
      <el-table-column label="操作" width="100">
        <template #default="{ row }">
          <el-button type="danger" size="small" @click="remove(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog v-model="dialogVisible" title="发布公告" width="480px">
      <el-form label-width="60px">
        <el-form-item label="标题">
          <el-input v-model="form.title" />
        </el-form-item>
        <el-form-item label="内容">
          <el-input v-model="form.content" type="textarea" :rows="4" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submit">发布</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped>
.toolbar {
  margin-bottom: 16px;
}
</style>
