<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getGoods } from '@/api/goods'
import { getUser } from '@/api/user'
import { listEvaluates, createEvaluate } from '@/api/evaluate'
import { createOrder } from '@/api/order'
import { createReport } from '@/api/report'
import { sendMessage } from '@/api/message'
import { useUserStore } from '@/stores/user'
import { useFavoriteStore } from '@/stores/favorite'
import type { Goods, User, Evaluate } from '@/types'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()
const favoriteStore = useFavoriteStore()

const goods = ref<Goods | null>(null)
const seller = ref<User | null>(null)
const evaluates = ref<Evaluate[]>([])
const activeImg = ref(0)

const goodsId = computed(() => Number(route.params.id))
const isSeller = computed(() => goods.value?.sellerId === userStore.currentUser?.id)
const faved = computed(() => favoriteStore.isFavorite(goodsId.value))

async function load() {
  goods.value = await getGoods(goodsId.value) ?? null
  if (goods.value) {
    seller.value = (await getUser(goods.value.sellerId)) ?? null
    evaluates.value = await listEvaluates(goods.value.id)
  }
}

function toggleFavorite() {
  if (!userStore.isLoggedIn) {
    router.push({ name: 'login', query: { redirect: route.fullPath } })
    return
  }
  favoriteStore.toggle(goodsId.value)
  ElMessage.success(faved.value ? '已取消收藏' : '已收藏')
}

async function onBuy() {
  if (!userStore.isLoggedIn) {
    router.push({ name: 'login', query: { redirect: route.fullPath } })
    return
  }
  if (!goods.value || isSeller.value) return
  await createOrder({
    goodsId: goods.value.id,
    buyerId: userStore.currentUser!.id,
    sellerId: goods.value.sellerId,
    price: goods.value.price,
  })
  ElMessage.success('下单成功，请到我的订单中支付')
  router.push({ name: 'orders' })
}

async function onMessage() {
  if (!userStore.isLoggedIn) {
    router.push({ name: 'login', query: { redirect: route.fullPath } })
    return
  }
  if (!goods.value) return
  const { value } = await ElMessageBox.prompt('给卖家留言', '私信', {
    confirmButtonText: '发送',
    cancelButtonText: '取消',
  })
  await sendMessage(userStore.currentUser!.id, goods.value.sellerId, value)
  ElMessage.success('消息已发送')
}

async function onReport() {
  if (!userStore.isLoggedIn) {
    router.push({ name: 'login', query: { redirect: route.fullPath } })
    return
  }
  if (!goods.value) return
  const { value } = await ElMessageBox.prompt('举报原因', '举报商品', {
    confirmButtonText: '提交',
    cancelButtonText: '取消',
  })
  await createReport({ goodsId: goods.value.id, userId: userStore.currentUser!.id, reason: value })
  ElMessage.success('举报已提交')
}

async function onEvaluate() {
  if (!goods.value) return
  const { value, action } = await ElMessageBox.prompt('评价内容', '评价', {
    confirmButtonText: '提交',
    cancelButtonText: '取消',
    inputPlaceholder: '写下你的评价…',
  })
  if (action !== 'confirm') return
  await createEvaluate({
    orderId: 0,
    goodsId: goods.value.id,
    userId: userStore.currentUser!.id,
    score: 5,
    content: value,
  })
  ElMessage.success('评价成功')
  evaluates.value = await listEvaluates(goods.value.id)
}

onMounted(() => {
  load()
  if (userStore.isLoggedIn) favoriteStore.refresh()
})
</script>

<template>
  <div v-if="goods" class="detail page-container">
    <div class="top">
      <div class="gallery">
        <div class="main-img-wrap">
          <img :src="goods.images[activeImg]" :alt="goods.title" class="main-img" />
        </div>
        <div class="thumb-list">
          <img
            v-for="(im, i) in goods.images"
            :key="i"
            :src="im"
            class="thumb"
            :class="{ active: i === activeImg }"
            @click="activeImg = i"
          />
        </div>
      </div>

      <div class="meta">
        <h1 class="title">{{ goods.title }}</h1>
        <div class="price-row">
          <span class="price big">{{ goods.price }}</span>
          <span v-if="goods.originalPrice" class="original">原价 ¥{{ goods.originalPrice }}</span>
        </div>
        <div class="meta-row">
          <span class="label">发布类型</span>
          <el-tag :type="goods.type === 'sell' ? 'warning' : 'info'">
            {{ goods.type === 'sell' ? '售卖' : '求购' }}
          </el-tag>
        </div>
        <div class="meta-row">
          <span class="label">浏览量</span>
          <span>{{ goods.views }} 次</span>
        </div>
        <div class="meta-row">
          <span class="label">发布时间</span>
          <span>{{ goods.createdAt }}</span>
        </div>

        <div v-if="seller" class="seller-box" @click="router.push({ name: 'user-profile', params: { id: seller.id } })">
          <el-avatar :size="40" :src="seller.avatar" />
          <div class="seller-info">
            <div class="seller-name">{{ seller.nickname }}</div>
            <div class="seller-sub">卖家 · 点击查看主页</div>
          </div>
        </div>

        <div class="actions">
          <el-button
            type="primary"
            size="large"
            :disabled="isSeller || goods.status !== 'on'"
            @click="onBuy"
          >
            立即购买
          </el-button>
          <el-button size="large" @click="toggleFavorite">
            <el-icon style="margin-right: 4px">
              <StarFilled v-if="faved" style="color: var(--color-brand)" />
              <Star v-else />
            </el-icon>
            {{ faved ? '已收藏' : '收藏' }}
          </el-button>
          <el-button size="large" :disabled="isSeller" @click="onMessage">私信卖家</el-button>
          <el-button size="large" :disabled="isSeller" @click="onReport">举报</el-button>
        </div>
      </div>
    </div>

    <div class="section">
      <h2 class="section-title">商品描述</h2>
      <p class="desc">{{ goods.desc }}</p>
    </div>

    <div class="section">
      <div class="section-header">
        <h2 class="section-title">商品评价（{{ evaluates.length }}）</h2>
        <el-button size="small" type="primary" link @click="onEvaluate">写评价</el-button>
      </div>
      <div v-if="evaluates.length" class="evaluate-list">
        <div v-for="e in evaluates" :key="e.id" class="evaluate-item">
          <div class="evaluate-top">
            <el-rate :model-value="e.score" disabled />
            <span class="evaluate-time">{{ e.createdAt }}</span>
          </div>
          <p class="evaluate-content">{{ e.content }}</p>
        </div>
      </div>
      <el-empty v-else description="暂无评价" :image-size="60" />
    </div>
  </div>
  <el-skeleton v-else class="page-container" :rows="6" animated />
</template>

<style scoped>
.detail {
  padding-top: var(--space-5);
}
.top {
  display: flex;
  gap: var(--space-6);
  background: var(--card-bg);
  padding: var(--space-5);
  border-radius: var(--radius-md);
  border: 1px solid var(--border-color);
}
.gallery {
  width: 420px;
  flex-shrink: 0;
}
.main-img-wrap {
  aspect-ratio: 1 / 1;
  border-radius: var(--radius-md);
  overflow: hidden;
  background: var(--color-surface-strong);
}
.main-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.thumb-list {
  display: flex;
  gap: var(--space-2);
  margin-top: var(--space-3);
}
.thumb {
  width: 64px;
  height: 64px;
  object-fit: cover;
  border-radius: var(--radius-sm);
  cursor: pointer;
  border: 2px solid transparent;
  transition: border-color 0.2s;
}
.thumb.active {
  border-color: var(--color-primary);
}
.meta {
  flex: 1;
}
.title {
  font-size: var(--text-xl);
  font-weight: 600;
  margin-bottom: var(--space-4);
  color: var(--color-ink);
}
.price-row {
  display: flex;
  align-items: baseline;
  gap: var(--space-3);
  margin-bottom: var(--space-4);
}
.price.big {
  font-size: 32px;
  font-weight: 700;
}
.original {
  color: var(--text-sub);
  text-decoration: line-through;
}
.meta-row {
  display: flex;
  gap: var(--space-4);
  margin-bottom: var(--space-2);
  color: var(--text-main);
}
.label {
  color: var(--text-sub);
  width: 70px;
  flex-shrink: 0;
}
.seller-box {
  display: flex;
  align-items: center;
  gap: var(--space-3);
  padding: var(--space-3);
  background: var(--page-bg);
  border-radius: var(--radius-sm);
  margin: var(--space-4) 0;
  cursor: pointer;
  transition: background 0.2s;
}
.seller-box:hover {
  background: var(--color-surface-strong);
}
.seller-name {
  font-weight: 600;
}
.seller-sub {
  font-size: var(--text-xs);
  color: var(--text-sub);
}
.actions {
  display: flex;
  flex-wrap: wrap;
  gap: var(--space-3);
  margin-top: var(--space-5);
}
.section {
  background: var(--card-bg);
  border-radius: var(--radius-md);
  padding: var(--space-5);
  margin-top: var(--space-4);
  border: 1px solid var(--border-color);
}
.section-title {
  font-size: var(--text-md);
  margin-bottom: var(--space-3);
  color: var(--color-ink);
}
.section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.desc {
  color: var(--text-main);
  line-height: 1.8;
  white-space: pre-wrap;
}
.evaluate-item {
  padding: var(--space-3) 0;
  border-bottom: 1px solid var(--border-color);
}
.evaluate-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: var(--space-2);
}
.evaluate-time {
  font-size: var(--text-xs);
  color: var(--text-sub);
}
.evaluate-content {
  color: var(--text-main);
}
</style>
