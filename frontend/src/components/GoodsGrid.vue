<script setup lang="ts">
import type { Goods } from '@/types'
import GoodsCard from './GoodsCard.vue'

defineProps<{ goods: Goods[] }>()
</script>

<template>
  <div class="goods-grid">
    <GoodsCard v-for="g in goods" :key="g.id" :goods="g" />
  </div>
</template>

<style scoped>
.goods-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 16px;
}
</style>
