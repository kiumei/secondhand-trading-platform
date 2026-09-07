<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { getSiteConfig, updateSiteConfig } from '@/api/admin'
import type { SiteConfig } from '@/types'

const form = ref<SiteConfig>({ title: '', footer: '', heroTitle: '', heroSubtitle: '' })
const loading = ref(false)

async function load() {
  form.value = await getSiteConfig()
}

async function save() {
  loading.value = true
  await updateSiteConfig(form.value)
  loading.value = false
  ElMessage.success('保存成功')
}

onMounted(load)
</script>

<template>
  <div class="settings">
    <el-card>
      <template #header>站点信息</template>
      <el-form label-width="90px" style="max-width: 480px">
        <el-form-item label="站点标题">
          <el-input v-model="form.title" />
        </el-form-item>
        <el-form-item label="首页主标题">
          <el-input v-model="form.heroTitle" />
        </el-form-item>
        <el-form-item label="首页副标题">
          <el-input v-model="form.heroSubtitle" />
        </el-form-item>
        <el-form-item label="页脚信息">
          <el-input v-model="form.footer" type="textarea" :rows="2" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" :loading="loading" @click="save">保存</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>
