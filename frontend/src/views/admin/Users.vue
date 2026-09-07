<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { listUsers, deleteUser } from '@/api/user'
import type { User } from '@/types'

const users = ref<User[]>([])
const loading = ref(false)

async function load() {
  loading.value = true
  users.value = await listUsers()
  loading.value = false
}

async function remove(u: User) {
  if (u.role === 'admin') {
    ElMessage.warning('不能删除管理员')
    return
  }
  await ElMessageBox.confirm(`确定删除用户「${u.nickname}」？`, '提示', { type: 'warning' })
  await deleteUser(u.id)
  ElMessage.success('已删除')
  load()
}

onMounted(load)
</script>

<template>
  <div class="users">
    <el-table v-loading="loading" :data="users" style="width: 100%">
      <el-table-column label="头像" width="70">
        <template #default="{ row }">
          <el-avatar :size="40" :src="row.avatar" />
        </template>
      </el-table-column>
      <el-table-column prop="username" label="用户名" width="140" />
      <el-table-column prop="nickname" label="昵称" width="140" />
      <el-table-column prop="phone" label="手机号" width="140" />
      <el-table-column prop="address" label="地址" min-width="160" show-overflow-tooltip />
      <el-table-column label="角色" width="100">
        <template #default="{ row }">
          <el-tag :type="row.role === 'admin' ? 'danger' : 'warning'">
            {{ row.role === 'admin' ? '管理员' : '学生' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="100">
        <template #default="{ row }">
          <el-button type="danger" size="small" :disabled="row.role === 'admin'" @click="remove(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>
