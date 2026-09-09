<script setup lang="ts">
import { reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { useUserStore } from '@/stores/user'
import { listMyGoods } from '@/api/goods'
import type { Goods } from '@/types'
import GoodsGrid from '@/components/GoodsGrid.vue'
import { flattenLocations } from '@/constants/locations'

const userStore = useUserStore()

const myGoods = ref<Goods[]>([])
const profileForm = reactive({
  userName: userStore.currentUser?.userName ?? '',
  intro: userStore.currentUser?.intro ?? '',
  address: userStore.currentUser?.address ?? '',
})

const addressOptions = flattenLocations()
function queryAddress(query: string, cb: (list: { value: string }[]) => void) {
  const kw = query.trim()
  if (!kw) {
    cb([])
    return
  }
  cb(addressOptions.filter((a) => a.includes(kw)).slice(0, 10).map((a) => ({ value: a })))
}

const pwdForm = reactive({ oldPassword: '', newPassword: '', confirmPassword: '' })

async function saveProfile() {
  await userStore.updateProfile(profileForm)
  ElMessage.success('保存成功')
}

async function changePassword() {
  if (pwdForm.newPassword !== pwdForm.confirmPassword) {
    ElMessage.error('两次密码不一致')
    return
  }
  const ok = await userStore.updatePassword(pwdForm.oldPassword, pwdForm.newPassword)
  if (ok) {
    ElMessage.success('密码修改成功')
    pwdForm.oldPassword = pwdForm.newPassword = pwdForm.confirmPassword = ''
  } else {
    ElMessage.error('原密码错误')
  }
}

async function loadMyGoods() {
  if (!userStore.currentUser) return
  myGoods.value = await listMyGoods()
}
loadMyGoods()
</script>

<template>
  <div class="profile page-container">
    <div class="profile-card">
      <el-avatar :size="72" :src="userStore.currentUser?.avatar" />
      <div class="profile-info">
        <h2 class="name">{{ userStore.currentUser?.userName }}</h2>
        <p class="username">{{ userStore.currentUser?.phone }}</p>
      </div>
      <el-tag :type="userStore.isAdmin ? 'danger' : 'warning'">
        {{ userStore.isAdmin ? '管理员' : '学生' }}
      </el-tag>
    </div>

    <div class="two-col">
      <div class="panel">
        <h3 class="panel-title">个人资料</h3>
        <el-form label-width="70px">
          <el-form-item label="昵称">
            <el-input v-model="profileForm.userName" />
          </el-form-item>
          <el-form-item label="简介">
            <el-input v-model="profileForm.intro" type="textarea" :rows="3" placeholder="介绍一下自己" />
          </el-form-item>
          <el-form-item label="收货地址">
            <el-autocomplete
              v-model="profileForm.address"
              :fetch-suggestions="queryAddress"
              placeholder="输入或选择收货地址"
              clearable
              style="width: 100%"
            />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="saveProfile">保存</el-button>
          </el-form-item>
        </el-form>
      </div>

      <div class="panel">
        <h3 class="panel-title">修改密码</h3>
        <el-form label-width="70px">
          <el-form-item label="原密码">
            <el-input v-model="pwdForm.oldPassword" type="password" show-password />
          </el-form-item>
          <el-form-item label="新密码">
            <el-input v-model="pwdForm.newPassword" type="password" show-password />
          </el-form-item>
          <el-form-item label="确认密码">
            <el-input v-model="pwdForm.confirmPassword" type="password" show-password />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="changePassword">修改密码</el-button>
          </el-form-item>
        </el-form>
      </div>
    </div>

    <div class="panel">
      <h3 class="panel-title">我发布的商品</h3>
      <GoodsGrid v-if="myGoods.length" :goods="myGoods" />
      <el-empty v-else description="还没有发布商品" />
    </div>
  </div>
</template>

<style scoped>
.profile {
  padding-top: 24px;
}
.profile-card {
  display: flex;
  align-items: center;
  gap: 20px;
  background: var(--card-bg);
  border-radius: 8px;
  padding: 24px;
  margin-bottom: 16px;
}
.profile-info {
  flex: 1;
}
.name {
  font-size: 20px;
}
.username {
  color: var(--text-sub);
}
.two-col {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
  margin-bottom: 16px;
}
.panel {
  background: var(--card-bg);
  border-radius: 8px;
  padding: 24px;
}
.panel-title {
  font-size: 16px;
  margin-bottom: 16px;
}
@media (max-width: 768px) {
  .two-col {
    grid-template-columns: 1fr;
  }
}
</style>
