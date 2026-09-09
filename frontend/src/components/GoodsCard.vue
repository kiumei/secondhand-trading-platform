<script setup lang="ts">
import { computed } from 'vue'
import type { Goods } from '@/types'

const props = defineProps<{ goods: Goods }>()

const statusText = computed(() => {
  const map: Record<number, string> = {
    0: '待审核',
    1: '',
    2: '已下架',
    3: '已售出',
    4: '已驳回',
  }
  return map[props.goods.goodsStatus] ?? ''
})

const img = computed(() => props.goods.images[0] ?? '')
</script>

<template>
  <div class="goods-card hover-card" @click="$router.push({ name: 'goods-detail', params: { id: goods.goodsId } })">
    <div class="img-wrap">
      <img :src="img" :alt="goods.title" class="img" />
      <span v-if="statusText" class="status-tag">{{ statusText }}</span>
    </div>
    <div class="info">
      <div class="title ellipsis-2">{{ goods.title }}</div>
      <div class="bottom">
        <span class="price">¥{{ goods.sellPrice }}</span>
      </div>
      <div class="meta">
        <span class="seller ellipsis">{{ goods.sellerName ?? '匿名' }}</span>
        <span class="date">{{ goods.publishTime.slice(0, 10) }}</span>
      </div>
    </div>
  </div>
</template>

<style scoped>
.goods-card {
  background: var(--card-bg);
  border-radius: var(--radius-md);
  overflow: hidden;
  cursor: pointer;
  border: 1px solid var(--border-color);
}
.img-wrap {
  position: relative;
  aspect-ratio: 1 / 1;
  background: var(--color-surface-strong);
  overflow: hidden;
}
.img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
  transition: transform 0.3s ease;
}
.goods-card:hover .img {
  transform: scale(1.03);
}
.status-tag {
  position: absolute;
  top: var(--space-2);
  left: var(--space-2);
  background: rgba(0, 0, 0, 0.6);
  color: #fff;
  font-size: var(--text-xs);
  padding: 2px var(--space-2);
  border-radius: var(--radius-xs);
}
.info {
  padding: var(--space-3);
}
.title {
  font-size: var(--text-base);
  color: var(--text-main);
  line-height: 1.4;
  height: 2.8em;
}
.bottom {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  margin-top: var(--space-2);
}
.price {
  font-size: var(--text-lg);
  font-weight: 700;
  color: var(--color-primary);
}
.meta {
  display: flex;
  align-items: center;
  gap: var(--space-2);
  margin-top: var(--space-2);
  font-size: var(--text-xs);
  color: var(--text-sub);
}
.seller {
  flex: 1;
  min-width: 0;
}
.date {
  flex-shrink: 0;
}
</style>
