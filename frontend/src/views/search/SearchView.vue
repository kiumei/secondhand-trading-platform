<script setup lang="ts">
import { ref, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { listGoods } from '@/api/goods'
import { listCategories } from '@/api/admin'
import type { Goods, Category } from '@/types'
import GoodsGrid from '@/components/GoodsGrid.vue'

const route = useRoute()
const router = useRouter()

const keyword = ref((route.query.q as string) || '')
const category = ref((route.query.category as string) || '')
const categories = ref<Category[]>([])
const minPrice = ref<number>()
const maxPrice = ref<number>()
const goods = ref<Goods[]>([])
const loading = ref(false)

async function load() {
  loading.value = true
  let list = await listGoods({
    keyword: keyword.value || undefined,
    minPrice: minPrice.value,
    maxPrice: maxPrice.value,
    status: 1, // 上架
  })
  // 搜索结果作为购物入口，只展示可购买商品
  list = list.filter((g) => g.purchasable)
  if (category.value) {
    list = list.filter((g) => g.cateId === category.value)
  }
  goods.value = list
  loading.value = false
}

function reset() {
  keyword.value = ''
  category.value = ''
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

onMounted(async () => {
  categories.value = await listCategories()
  load()
})
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
        <el-select v-model="category" clearable placeholder="全部分类" style="width: 240px">
          <el-option v-for="c in categories" :key="c.cateId" :label="c.cateName" :value="c.cateId" />
        </el-select>
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
