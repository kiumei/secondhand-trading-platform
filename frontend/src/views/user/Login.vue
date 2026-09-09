<script setup lang="ts">
import { ref, reactive } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { useUserStore } from '@/stores/user'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const formRef = ref()
const loading = ref(false)
const form = reactive({ phone: '', password: '' })

const rules = {
  phone: [{ required: true, message: '请输入手机号', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }],
}

async function submit() {
  if (!formRef.value) return
  await formRef.value.validate()
  loading.value = true
  const ok = await userStore.login(form.phone, form.password)
  loading.value = false
  if (ok) {
    ElMessage.success('登录成功')
    const redirect = (route.query.redirect as string) || '/'
    router.push(redirect)
  } else {
    ElMessage.error('手机号或密码错误')
  }
}
</script>

<template>
  <div class="auth-page">
    <div class="auth-card">
      <div class="auth-logo">闲</div>
      <h2 class="auth-title">登录</h2>
      <p class="auth-sub">欢迎回到校园二手集市</p>
      <el-form ref="formRef" :model="form" :rules="rules" size="large">
        <el-form-item prop="phone">
          <el-input v-model="form.phone" placeholder="手机号">
            <template #prefix><el-icon><Iphone /></el-icon></template>
          </el-input>
        </el-form-item>
        <el-form-item prop="password">
          <el-input v-model="form.password" type="password" show-password placeholder="密码">
            <template #prefix><el-icon><Lock /></el-icon></template>
          </el-input>
        </el-form-item>
        <el-button type="primary" class="submit-btn" :loading="loading" @click="submit">
          登录
        </el-button>
      </el-form>
      <div class="auth-footer">
        <span>还没有账号？</span>
        <el-link type="primary" @click="router.push({ name: 'register' })">立即注册</el-link>
      </div>
      <div class="demo-hint">
        测试账号：19028135411 / admin123（管理员），15861176797 / admin123（学生）
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
.demo-hint {
  margin-top: var(--space-4);
  text-align: center;
  font-size: var(--text-xs);
  color: var(--text-sub);
  background: var(--color-surface);
  border-radius: var(--radius-sm);
  padding: var(--space-2);
}
</style>
