<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { listGoods } from '@/api/goods'
import { useFavoriteStore } from '@/stores/favorite'
import type { Goods } from '@/types'
import GoodsGrid from '@/components/GoodsGrid.vue'

const favoriteStore = useFavoriteStore()
const goods = ref<Goods[]>([])
const loading = ref(false)

async function load() {
  await favoriteStore.refresh()
  loading.value = true
  const ids = favoriteStore.favorites.map((f) => f.goodsId)
  const all = await listGoods()
  goods.value = all.filter((g) => ids.includes(g.goodsId))
  loading.value = false
}

onMounted(load)
</script>

<template>
  <div class="favorites page-container">
    <h2 class="page-title">我的收藏</h2>
    <div v-loading="loading">
      <GoodsGrid v-if="goods.length" :goods="goods" />
      <el-empty v-else description="还没有收藏任何宝贝" />
    </div>
  </div>
</template>

<style scoped>
.favorites {
  padding-top: 24px;
}
.page-title {
  font-size: 20px;
  margin-bottom: 20px;
}
</style>
