<script setup lang="ts">
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { updateSiteConfig } from '@/api/admin'
import { useThemeStore } from '@/stores/theme'
import { useUserStore } from '@/stores/user'

const router = useRouter()
const themeStore = useThemeStore()
const userStore = useUserStore()

const step = ref(0)
const form = reactive({
  theme: 'light' as 'light' | 'dark' | 'system',
  locale: 'zh-CN' as 'zh-CN' | 'en-US',
  title: '',
  footer: '',
  adminUsername: 'admin',
  adminPassword: '',
  heroTitle: '',
  heroSubtitle: '',
  smtpHost: '',
  smtpPort: '',
  smtpUser: '',
})

const steps = [
  { title: '外观设置', desc: '主题模式与语言' },
  { title: '站点信息', desc: '标题与页脚' },
  { title: '管理员账号', desc: '初始化管理员' },
  { title: '首页配置', desc: 'Hero 区域' },
  { title: 'SMTP 配置', desc: '邮件服务' },
]

function next() {
  if (step.value < steps.length - 1) step.value++
}

function prev() {
  if (step.value > 0) step.value--
}

async function finish() {
  themeStore.setTheme(form.theme)
  themeStore.setLocale(form.locale)
  await updateSiteConfig({
    title: form.title || '校园二手集市',
    footer: form.footer,
    heroTitle: form.heroTitle || '让闲置流动起来',
    heroSubtitle: form.heroSubtitle,
  })
  ElMessage.success('初始化完成')
  router.push({ name: 'home' })
}
</script>

<template>
  <div class="setup">
    <div class="setup-card">
      <div class="setup-header">
        <h2>初始化向导</h2>
        <p>快速配置你的校园二手平台</p>
      </div>

      <el-steps :active="step" align-center finish-status="success">
        <el-step v-for="s in steps" :key="s.title" :title="s.title" :description="s.desc" />
      </el-steps>

      <div class="step-content">
        <!-- 步骤 1：外观 -->
        <div v-if="step === 0">
          <h3 class="step-title">外观设置</h3>
          <el-form label-width="90px">
            <el-form-item label="主题模式">
              <el-radio-group v-model="form.theme">
                <el-radio-button value="light">浅色</el-radio-button>
                <el-radio-button value="dark">深色</el-radio-button>
                <el-radio-button value="system">跟随系统</el-radio-button>
              </el-radio-group>
            </el-form-item>
            <el-form-item label="语言">
              <el-radio-group v-model="form.locale">
                <el-radio-button value="zh-CN">中文</el-radio-button>
                <el-radio-button value="en-US">English</el-radio-button>
              </el-radio-group>
            </el-form-item>
          </el-form>
        </div>

        <!-- 步骤 2：站点信息 -->
        <div v-else-if="step === 1">
          <h3 class="step-title">站点信息</h3>
          <el-form label-width="90px">
            <el-form-item label="站点标题">
              <el-input v-model="form.title" placeholder="校园二手集市" />
            </el-form-item>
            <el-form-item label="页脚信息">
              <el-input v-model="form.footer" placeholder="© 2026 校园二手交易平台" />
            </el-form-item>
          </el-form>
        </div>

        <!-- 步骤 3：管理员 -->
        <div v-else-if="step === 2">
          <h3 class="step-title">管理员账号初始化</h3>
          <el-form label-width="90px">
            <el-form-item label="用户名">
              <el-input v-model="form.adminUsername" disabled />
            </el-form-item>
            <el-form-item label="密码">
              <el-input v-model="form.adminPassword" type="password" show-password placeholder="设置管理员密码" />
            </el-form-item>
          </el-form>
        </div>

        <!-- 步骤 4：首页 Hero -->
        <div v-else-if="step === 3">
          <h3 class="step-title">首页 Hero 配置</h3>
          <el-form label-width="90px">
            <el-form-item label="主标题">
              <el-input v-model="form.heroTitle" placeholder="让闲置流动起来" />
            </el-form-item>
            <el-form-item label="副标题">
              <el-input v-model="form.heroSubtitle" placeholder="买卖闲置，就在校园二手集市" />
            </el-form-item>
          </el-form>
        </div>

        <!-- 步骤 5：SMTP -->
        <div v-else>
          <h3 class="step-title">SMTP 配置</h3>
          <el-form label-width="90px">
            <el-form-item label="SMTP 主机">
              <el-input v-model="form.smtpHost" placeholder="smtp.example.com" />
            </el-form-item>
            <el-form-item label="端口">
              <el-input v-model="form.smtpPort" placeholder="465" />
            </el-form-item>
            <el-form-item label="发件邮箱">
              <el-input v-model="form.smtpUser" placeholder="noreply@example.com" />
            </el-form-item>
            <el-alert title="SMTP 配置用于找回密码等邮件通知，可稍后在系统设置中完善。" type="info" :closable="false" show-icon />
          </el-form>
        </div>
      </div>

      <div class="setup-actions">
        <el-button v-if="step > 0" @click="prev">上一步</el-button>
        <el-button v-if="step < steps.length - 1" type="primary" @click="next">下一步</el-button>
        <el-button v-else type="primary" @click="finish">完成</el-button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.setup {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #ffc300 0%, #ff8200 100%);
  padding: 24px;
}
.setup-card {
  width: 640px;
  max-width: 100%;
  background: #fff;
  border-radius: 12px;
  padding: 36px;
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
}
.setup-header {
  text-align: center;
  margin-bottom: 28px;
}
.setup-header h2 {
  font-size: 22px;
}
.setup-header p {
  color: var(--text-sub);
  font-size: 14px;
  margin-top: 4px;
}
.step-content {
  margin-top: 32px;
  min-height: 220px;
}
.step-title {
  font-size: 16px;
  margin-bottom: 20px;
}
.setup-actions {
  display: flex;
  justify-content: center;
  gap: 12px;
  margin-top: 24px;
}
</style>
