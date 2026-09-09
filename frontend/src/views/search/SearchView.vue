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
const categoryPath = ref<string[]>([])
const minPrice = ref<number>()
const maxPrice = ref<number>()
const goods = ref<Goods[]>([])
const loading = ref(false)

const categoryOptions = categoryGroups.map((g) => ({
  value: g.cateId,
  label: g.cateName,
  children: g.children.map((c) => ({ value: c.cateId, label: c.cateName })),
}))

// 从 query 初始化分类：支持 group=父类id 或 category=子类id
const groupParam = (route.query.group as string) || ''
const categoryParam = (route.query.category as string) || ''
if (groupParam) {
  const g = categoryGroups.find((x) => x.cateId === groupParam)
  if (g) categoryPath.value = [g.cateId]
}
if (categoryParam) {
  const g = categoryGroups.find((x) => x.children.some((c) => c.cateId === categoryParam))
  if (g) categoryPath.value = [g.cateId, categoryParam]
}

async function load() {
  loading.value = true
  let list = await listGoods({
    keyword: keyword.value || undefined,
    minPrice: minPrice.value,
    maxPrice: maxPrice.value,
    status: 1, // 上架
  })
  // 分类筛选（客户端）：父类 → 其下所有子类；子类 → 单个子类
  const last = categoryPath.value[categoryPath.value.length - 1]
  if (categoryPath.value.length === 1 && categoryPath.value[0] != null) {
    const ids = getSubIds(categoryPath.value[0])
    list = list.filter((g) => ids.includes(g.cateId))
  } else if (last != null) {
    list = list.filter((g) => g.cateId === last)
  }
  goods.value = list
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
