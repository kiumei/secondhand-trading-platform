<script setup lang="ts">
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { useUserStore } from '@/stores/user'

const router = useRouter()
const userStore = useUserStore()

const formRef = ref()
const loading = ref(false)
const form = reactive({
  username: '',
  password: '',
  confirmPassword: '',
  nickname: '',
  phone: '',
})

const rules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '长度 3-20 个字符', trigger: 'blur' },
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码至少 6 位', trigger: 'blur' },
  ],
  confirmPassword: [
    {
      validator: (_r: unknown, v: string, cb: (e?: Error) => void) => {
        if (v !== form.password) cb(new Error('两次密码不一致'))
        else cb()
      },
      trigger: 'blur',
    },
  ],
  nickname: [{ required: true, message: '请输入昵称', trigger: 'blur' }],
  phone: [
    { required: true, message: '请输入手机号', trigger: 'blur' },
    { pattern: /^1\d{10}$/, message: '手机号格式不正确', trigger: 'blur' },
  ],
}

async function submit() {
  if (!formRef.value) return
  await formRef.value.validate()
  loading.value = true
  const ok = await userStore.register({
    username: form.username,
    password: form.password,
    nickname: form.nickname,
    phone: form.phone,
  })
  loading.value = false
  if (ok) {
    ElMessage.success('注册成功')
    router.push({ name: 'home' })
  } else {
    ElMessage.error('用户名已存在')
  }
}
</script>

<template>
  <div class="auth-page">
    <div class="auth-card">
      <div class="auth-logo">闲</div>
      <h2 class="auth-title">注册</h2>
      <p class="auth-sub">加入校园二手集市</p>
      <el-form ref="formRef" :model="form" :rules="rules" size="large">
        <el-form-item prop="username">
          <el-input v-model="form.username" placeholder="用户名" />
        </el-form-item>
        <el-form-item prop="password">
          <el-input v-model="form.password" type="password" show-password placeholder="密码" />
        </el-form-item>
        <el-form-item prop="confirmPassword">
          <el-input v-model="form.confirmPassword" type="password" show-password placeholder="确认密码" />
        </el-form-item>
        <el-form-item prop="nickname">
          <el-input v-model="form.nickname" placeholder="昵称" />
        </el-form-item>
        <el-form-item prop="phone">
          <el-input v-model="form.phone" placeholder="手机号" />
        </el-form-item>
        <el-button type="primary" class="submit-btn" :loading="loading" @click="submit">
          注册
        </el-button>
      </el-form>
      <div class="auth-footer">
        <span>已有账号？</span>
        <el-link type="primary" @click="router.push({ name: 'login' })">去登录</el-link>
      </div>
    </div>
  </div>
</template>

<style scoped>
.auth-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, var(--color-brand) 0%, var(--color-primary) 100%);
  padding: var(--space-5);
}
.auth-card {
  width: 380px;
  background: var(--color-canvas);
  border-radius: var(--radius-lg);
  padding: var(--space-7) var(--space-6);
  box-shadow: var(--shadow-float);
}
.auth-logo {
  width: 48px;
  height: 48px;
  background: var(--color-brand);
  color: #fff;
  border-radius: var(--radius-md);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 26px;
  font-weight: 700;
  margin: 0 auto var(--space-4);
}
.auth-title {
  text-align: center;
  font-size: var(--text-xl);
  margin-bottom: var(--space-1);
  color: var(--color-ink);
}
.auth-sub {
  text-align: center;
  color: var(--text-sub);
  margin-bottom: var(--space-5);
  font-size: var(--text-base);
}
.submit-btn {
  width: 100%;
  margin-top: var(--space-2);
}
.auth-footer {
  text-align: center;
  margin-top: var(--space-4);
  font-size: var(--text-base);
  color: var(--text-sub);
}
</style>
