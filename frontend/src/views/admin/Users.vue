<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { listUsers, deleteUser, setBanned, resetPassword } from '@/api/user'
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

async function toggleBan(u: User) {
  if (u.role === 'admin') {
    ElMessage.warning('不能封禁管理员')
    return
  }
  const action = u.banned ? '解封' : '封禁'
  await ElMessageBox.confirm(`确定${action}用户「${u.nickname}」？`, '提示', { type: 'warning' })
  await setBanned(u.id, !u.banned)
  ElMessage.success(`已${action}`)
  load()
}

async function resetPwd(u: User) {
  const { value } = await ElMessageBox.prompt('输入新密码', `重置「${u.nickname}」的密码`, {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    inputPattern: /^.{6,}$/,
    inputErrorMessage: '密码至少 6 位',
  })
  await resetPassword(u.id, value)
  ElMessage.success('密码已重置')
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
      <el-table-column prop="username" label="用户名" width="120" />
      <el-table-column prop="nickname" label="昵称" width="120" />
      <el-table-column prop="phone" label="手机号" width="130" />
      <el-table-column prop="address" label="地址" min-width="150" show-overflow-tooltip />
      <el-table-column label="角色" width="90">
        <template #default="{ row }">
          <el-tag :type="row.role === 'admin' ? 'danger' : 'warning'">
            {{ row.role === 'admin' ? '管理员' : '学生' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="状态" width="90">
        <template #default="{ row }">
          <el-tag v-if="row.banned" type="danger">已封禁</el-tag>
          <el-tag v-else type="success">正常</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="230" fixed="right">
        <template #default="{ row }">
          <el-button
            v-if="row.role !== 'admin'"
            :type="row.banned ? 'success' : 'danger'"
            size="small"
            @click="toggleBan(row)"
          >
            {{ row.banned ? '解封' : '封禁' }}
          </el-button>
          <el-button size="small" @click="resetPwd(row)">重置密码</el-button>
          <el-button type="danger" size="small" :disabled="row.role === 'admin'" @click="remove(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>
