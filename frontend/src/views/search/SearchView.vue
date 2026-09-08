<script setup lang="ts">
import { ref, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { listGoods } from '@/api/goods'
import type { Goods } from '@/types'
import GoodsGrid from '@/components/GoodsGrid.vue'
import { categoryGroups, getSubIds } from '@/constants/categories'

const route = useRoute()
const router = useRouter()

const keyword = ref((route.query.q as string) || '')
const categoryPath = ref<number[]>([])
const minPrice = ref<number>()
const maxPrice = ref<number>()
const goods = ref<Goods[]>([])
const loading = ref(false)

const categoryOptions = categoryGroups.map((g) => ({
  value: g.id,
  label: g.name,
  children: g.children.map((c) => ({ value: c.id, label: c.name })),
}))

// 从 query 初始化分类：支持 group=父类id 或 category=子类id
const groupParam = Number(route.query.group) || 0
const categoryParam = Number(route.query.category) || 0
if (groupParam) {
  const g = categoryGroups.find((x) => x.id === groupParam)
  if (g) categoryPath.value = [g.id]
}
if (categoryParam) {
  const g = categoryGroups.find((x) => x.children.some((c) => c.id === categoryParam))
  if (g) categoryPath.value = [g.id, categoryParam]
}

async function load() {
  loading.value = true
  const last = categoryPath.value[categoryPath.value.length - 1]
  // 选了父类（路径长度1）→ 按父类下所有子类筛选；选了子类（长度2）→ 按子类筛选
  const categoryIds =
    categoryPath.value.length === 1 && categoryPath.value[0] != null
      ? getSubIds(categoryPath.value[0])
      : last != null
        ? [last]
        : undefined
  goods.value = await listGoods({
    keyword: keyword.value || undefined,
    categoryIds,
    minPrice: minPrice.value,
    maxPrice: maxPrice.value,
    status: 'on',
  })
  loading.value = false
}

function reset() {
  keyword.value = ''
  categoryPath.value = []
  minPrice.value = undefined
  maxPrice.value = undefined
  load()
}

watch(
  () => route.query.q,
  (v) => {
    keyword.value = (v as string) || ''
    load()
  },
)

onMounted(load)
</script>

<template>
  <div class="search page-container">
    <div class="filter-card">
      <div class="filter-row">
        <span class="filter-label">关键词</span>
        <el-input v-model="keyword" placeholder="搜索宝贝" clearable style="width: 260px" />
      </div>
      <div class="filter-row">
        <span class="filter-label">分类</span>
        <el-cascader
          v-model="categoryPath"
          :options="categoryOptions"
          :props="{ expandTrigger: 'hover' }"
          clearable
          placeholder="全部分类"
          style="width: 240px"
        />
      </div>
      <div class="filter-row">
        <span class="filter-label">价格</span>
        <el-input-number v-model="minPrice" :min="0" placeholder="最低" style="width: 130px" />
        <span style="margin: 0 8px">-</span>
        <el-input-number v-model="maxPrice" :min="0" placeholder="最高" style="width: 130px" />
      </div>
      <div class="filter-actions">
        <el-button type="primary" @click="load">筛选</el-button>
        <el-button @click="reset">重置</el-button>
      </div>
    </div>

    <div v-loading="loading" class="result">
      <div class="result-header">共 {{ goods.length }} 件宝贝</div>
      <GoodsGrid v-if="goods.length" :goods="goods" />
      <el-empty v-else description="没有找到相关宝贝" />
    </div>
  </div>
</template>

<style scoped>
.search {
  padding-top: 24px;
}
.filter-card {
  background: var(--card-bg);
  border-radius: 8px;
  padding: 20px 24px;
  display: flex;
  flex-direction: column;
  gap: 14px;
}
.filter-row {
  display: flex;
  align-items: center;
  gap: 12px;
}
.filter-label {
  width: 60px;
  color: var(--text-sub);
  flex-shrink: 0;
}
.filter-actions {
  padding-left: 72px;
}
.result {
  margin-top: 20px;
  min-height: 300px;
}
.result-header {
  font-size: 14px;
  color: var(--text-sub);
  margin-bottom: 16px;
}
</style>
