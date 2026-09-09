<script setup lang="ts">
import { ref, reactive, onBeforeUnmount, shallowRef } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Editor, Toolbar } from '@wangeditor/editor-for-vue'
import '@wangeditor/editor/dist/css/style.css'
import { createGoods } from '@/api/goods'
import { useUserStore } from '@/stores/user'
import { categoryGroups } from '@/constants/categories'
import type { QualityLevel, TradeType } from '@/types'

const router = useRouter()
const userStore = useUserStore()

const submitting = ref(false)

const qualityLevels: { value: QualityLevel; label: string }[] = [
  { value: 1, label: '全新' },
  { value: 2, label: '9成新' },
  { value: 3, label: '8成新' },
  { value: 4, label: '7成新' },
  { value: 5, label: '6成新及以下' },
]

// 级联选择：父类 + 子类
const categoryOptions = categoryGroups.map((g) => ({
  value: g.cateId,
  label: g.cateName,
  children: g.children.map((c) => ({ value: c.cateId, label: c.cateName })),
}))

const form = reactive({
  title: '',
  categoryPath: [] as string[],
  qualityLevel: 1 as QualityLevel,
  sellPrice: 0,
  originalPrice: undefined as number | undefined,
  tradeType: 2 as TradeType,
})

// 商品主图（单张，圆形预览）
const mainImage = ref('')
// 更多图片（最多 4 张）
const extraImages = ref<string[]>([])

// 富文本编辑器
const editorRef = shallowRef()
const editorHtml = ref('')
const editorConfig = {
  placeholder: '描述商品成色、入手渠道、转手原因等…',
  height: 300,
}
const editorMode = 'default'

function handleCreated(editor: any) {
  editorRef.value = editor
}

onBeforeUnmount(() => {
  editorRef.value?.destroy()
})

// ---- 图片上传：读取为 base64 预览，并压缩（最长边 800px，JPEG 0.75）避免撑爆 localStorage 配额 ----
function readAsDataUrl(file: File): Promise<string> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader()
    reader.onload = () => {
      const img = new Image()
      img.onload = () => {
        const maxSize = 800
        let { width, height } = img
        if (width > maxSize || height > maxSize) {
          const ratio = Math.min(maxSize / width, maxSize / height)
          width = Math.round(width * ratio)
          height = Math.round(height * ratio)
        }
        const canvas = document.createElement('canvas')
        canvas.width = width
        canvas.height = height
        const ctx = canvas.getContext('2d')
        if (!ctx) {
          resolve(reader.result as string)
          return
        }
        ctx.drawImage(img, 0, 0, width, height)
        resolve(canvas.toDataURL('image/jpeg', 0.75))
      }
      img.onerror = () => resolve(reader.result as string)
      img.src = reader.result as string
    }
    reader.onerror = reject
    reader.readAsDataURL(file)
  })
}

function onMainImageChange(e: Event) {
  const input = e.target as HTMLInputElement
  const file = input.files?.[0]
  if (!file) return
  readAsDataUrl(file).then((url) => {
    mainImage.value = url
  })
  input.value = ''
}

function onExtraImagesChange(e: Event) {
  const input = e.target as HTMLInputElement
  const files = Array.from(input.files ?? [])
  const remain = 4 - extraImages.value.length
  if (files.length > remain) {
    ElMessage.warning(`最多上传 4 张图片，还能再传 ${remain} 张`)
  }
  Promise.all(files.slice(0, remain).map(readAsDataUrl)).then((urls) => {
    extraImages.value.push(...urls)
  })
  input.value = ''
}

function removeExtraImage(index: number) {
  extraImages.value.splice(index, 1)
}

// ---- 提交 ----
function validate(): string | null {
  if (!mainImage.value) return '请上传商品主图'
  if (!form.title.trim()) return '请输入商品名称'
  if (!form.categoryPath.length) return '请选择商品分类'
  if (!form.sellPrice || form.sellPrice <= 0) return '请输入价格'
  return null
}

async function submit() {
  const err = validate()
  if (err) {
    ElMessage.warning(err)
    return
  }
  if (!userStore.currentUser) return
  submitting.value = true
  const images = [mainImage.value, ...extraImages.value]
  const cateId = form.categoryPath[form.categoryPath.length - 1] ?? ''
  await createGoods({
    title: form.title.trim(),
    goodsDesc: editorHtml.value,
    sellPrice: form.sellPrice,
    originalPrice: form.originalPrice,
    cateId,
    tradeType: form.tradeType,
    qualityLevel: form.qualityLevel,
    images,
    publishUserId: userStore.currentUser.userId,
  })
  submitting.value = false
  ElMessage.success('发布成功，商品进入待审核，可在「我的 → 我发布的商品」查看审核进度')
  router.push({ name: 'profile' })
}
</script>

<template>
  <div class="publish page-container">
    <div class="form-card">
      <h2 class="page-title">发布商品</h2>

      <!-- 基础信息 -->
      <div class="form-section">
        <h3 class="section-title">基础信息</h3>

        <!-- 商品主图 -->
        <div class="field">
          <div class="field-label">
            <span class="required">*</span>商品主图
          </div>
          <div class="main-img-row">
            <div class="round-preview main">
              <img v-if="mainImage" :src="mainImage" class="round-img" />
              <el-icon v-else :size="32" class="placeholder-icon"><Plus /></el-icon>
            </div>
            <label class="upload-btn">
              更换图片
              <input type="file" accept="image/*" hidden @change="onMainImageChange" />
            </label>
          </div>
        </div>

        <!-- 更多图片 -->
        <div class="field">
          <div class="field-label">
            <span class="optional">更多图片</span>
            <span class="field-hint">最多上传 4 张图片</span>
          </div>
          <div class="extra-img-row">
            <div
              v-for="(img, i) in extraImages"
              :key="i"
              class="round-preview extra"
            >
              <img :src="img" class="round-img" />
              <span class="remove-badge" @click="removeExtraImage(i)">×</span>
            </div>
            <label v-if="extraImages.length < 4" class="round-preview extra upload">
              <el-icon :size="24" class="placeholder-icon"><Plus /></el-icon>
              <input type="file" accept="image/*" multiple hidden @change="onExtraImagesChange" />
            </label>
          </div>
        </div>

        <!-- 商品名称 -->
        <div class="field">
          <div class="field-label"><span class="required">*</span>商品名称</div>
          <el-input
            v-model="form.title"
            placeholder="取个清晰的好名字吸引更多人"
            maxlength="100"
            show-word-limit
          />
        </div>

        <!-- 商品分类 -->
        <div class="field">
          <div class="field-label"><span class="required">*</span>商品分类</div>
          <el-cascader
            v-model="form.categoryPath"
            :options="categoryOptions"
            :props="{ expandTrigger: 'hover' }"
            placeholder="请选择商品分类"
            clearable
            style="width: 100%"
          />
        </div>

        <!-- 商品成色 -->
        <div class="field">
          <div class="field-label"><span class="required">*</span>商品成色</div>
          <div class="condition-group">
            <button
              v-for="q in qualityLevels"
              :key="q.value"
              type="button"
              class="condition-pill"
              :class="{ active: form.qualityLevel === q.value }"
              @click="form.qualityLevel = q.value"
            >
              {{ q.label }}
            </button>
          </div>
        </div>

        <!-- 价格 -->
        <div class="field">
          <div class="field-label"><span class="required">*</span>价格</div>
          <div class="price-row">
            <el-input-number v-model="form.sellPrice" :min="0" :precision="2" :step="10" :controls="false" style="width: 200px" />
            <span class="price-unit">元</span>
          </div>
        </div>

        <!-- 原价 -->
        <div class="field">
          <div class="field-label"><span class="optional">原价</span></div>
          <div class="price-row">
            <el-input-number v-model="form.originalPrice" :min="0" :precision="2" :step="10" :controls="false" style="width: 200px" />
            <span class="price-unit">元（选填）</span>
          </div>
        </div>

        <!-- 商品详情描述 -->
        <div class="field">
          <div class="field-label"><span class="required">*</span>商品详情描述</div>
          <div class="editor-wrap">
            <Toolbar class="editor-toolbar" :editor="editorRef" :default-config="editorConfig" :mode="editorMode" />
            <Editor
              class="editor-body"
              :default-config="editorConfig"
              :mode="editorMode"
              v-model="editorHtml"
              @onCreated="handleCreated"
            />
          </div>
        </div>
      </div>

      <!-- 交易方式 -->
      <div class="form-section">
        <h3 class="section-title">交易方式</h3>
        <el-radio-group v-model="form.tradeType">
          <el-radio-button :value="1">邮寄</el-radio-button>
          <el-radio-button :value="2">自提</el-radio-button>
          <el-radio-button :value="3">两者均可</el-radio-button>
        </el-radio-group>
      </div>

      <div class="form-actions">
        <el-button type="primary" size="large" :loading="submitting" @click="submit">发布</el-button>
        <el-button size="large" @click="router.back()">取消</el-button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.publish {
  padding-top: var(--space-5);
}
.form-card {
  max-width: 720px;
  margin: 0 auto;
  background: var(--card-bg);
  border-radius: var(--radius-md);
  border: 1px solid var(--border-color);
  padding: var(--space-6);
}
.page-title {
  font-size: var(--text-xl);
  color: var(--color-ink);
  margin-bottom: var(--space-5);
}
.form-section {
  margin-bottom: var(--space-6);
}
.section-title {
  font-size: var(--text-md);
  font-weight: 600;
  color: var(--color-ink);
  padding-bottom: var(--space-3);
  border-bottom: 1px solid var(--border-color);
  margin-bottom: var(--space-5);
}
.field {
  margin-bottom: var(--space-5);
}
.field-label {
  display: flex;
  align-items: center;
  gap: var(--space-1);
  font-size: var(--text-base);
  color: var(--text-main);
  margin-bottom: var(--space-3);
}
.required {
  color: var(--color-danger);
  font-weight: 600;
}
.optional {
  color: var(--text-main);
}
.field-hint {
  margin-left: var(--space-2);
  font-size: var(--text-xs);
  color: var(--text-sub);
}

/* 圆形图片预览 */
.main-img-row {
  display: flex;
  align-items: center;
  gap: var(--space-4);
}
.round-preview {
  position: relative;
  border-radius: var(--radius-full);
  overflow: hidden;
  background: var(--color-surface);
  border: 1px dashed var(--color-hairline);
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
}
.round-preview.main {
  width: 120px;
  height: 120px;
}
.round-preview.extra {
  width: 80px;
  height: 80px;
}
.round-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}
.placeholder-icon {
  color: var(--text-sub);
}
.upload-btn {
  color: var(--color-primary);
  cursor: pointer;
  font-size: var(--text-base);
  padding: var(--space-2) var(--space-3);
  border: 1px solid var(--color-primary);
  border-radius: var(--radius-sm);
}
.upload-btn:hover {
  background: var(--el-color-primary-light-9);
}
.extra-img-row {
  display: flex;
  align-items: center;
  gap: var(--space-3);
  flex-wrap: wrap;
}
.round-preview.extra.upload {
  border-style: dashed;
}
.remove-badge {
  position: absolute;
  top: 0;
  right: 0;
  width: 20px;
  height: 20px;
  background: var(--color-danger);
  color: #fff;
  border-radius: var(--radius-full);
  font-size: 14px;
  line-height: 20px;
  text-align: center;
  cursor: pointer;
}

/* 成色标签组 */
.condition-group {
  display: flex;
  flex-wrap: wrap;
  gap: var(--space-2);
}
.condition-pill {
  padding: var(--space-2) var(--space-4);
  border: 1px solid var(--color-hairline);
  border-radius: var(--radius-full);
  background: var(--color-canvas);
  color: var(--text-main);
  cursor: pointer;
  font-size: var(--text-base);
  transition: all 0.2s;
}
.condition-pill:hover {
  border-color: var(--color-primary);
  color: var(--color-primary);
}
.condition-pill.active {
  background: var(--color-primary);
  border-color: var(--color-primary);
  color: #fff;
}

/* 价格 */
.price-row {
  display: flex;
  align-items: center;
  gap: var(--space-2);
}
.price-unit {
  color: var(--text-sub);
  font-size: var(--text-base);
}

/* 富文本编辑器 */
.editor-wrap {
  border: 1px solid var(--color-hairline);
  border-radius: var(--radius-sm);
  overflow: hidden;
}
.editor-toolbar {
  border-bottom: 1px solid var(--color-hairline);
}
.editor-body {
  height: 300px;
  overflow-y: hidden;
}

.form-actions {
  display: flex;
  gap: var(--space-3);
  justify-content: center;
  padding-top: var(--space-4);
  border-top: 1px solid var(--border-color);
}
</style>
