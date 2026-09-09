<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getGoods } from '@/api/goods'
import { getUser } from '@/api/user'
import { listEvaluates, createEvaluate } from '@/api/evaluate'
import { createOrder, listOrders } from '@/api/order'
import { createReport } from '@/api/report'
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
const buyDialogVisible = ref(false)
const buyAddress = ref('')

const goodsId = computed(() => String(route.params.id))
const isSeller = computed(() => goods.value?.publishUserId === userStore.currentUser?.userId)
const faved = computed(() => favoriteStore.isFavorite(goodsId.value))

const tradeTypeText = computed(() => {
  const map: Record<number, string> = { 1: '邮寄', 2: '自提', 3: '两者' }
  return map[goods.value?.tradeType ?? 2] ?? ''
})

const qualityText = computed(() => {
  const map: Record<number, string> = { 1: '全新', 2: '9成新', 3: '8成新', 4: '7成新', 5: '6成新及以下' }
  return goods.value?.qualityLevel ? map[goods.value.qualityLevel] : '未填写'
})

async function load() {
  goods.value = (await getGoods(goodsId.value)) ?? null
  if (goods.value) {
    seller.value = (await getUser(goods.value.publishUserId)) ?? null
    evaluates.value = await listEvaluates(goods.value.goodsId)
  }
}

async function toggleFavorite() {
  if (!userStore.isLoggedIn) {
    router.push({ name: 'login', query: { redirect: route.fullPath } })
    return
  }
  try {
    await favoriteStore.toggle(goodsId.value)
    ElMessage.success(favoriteStore.isFavorite(goodsId.value) ? '收藏成功' : '已取消收藏')
  } catch {
    ElMessage.error('操作失败，请稍后重试')
  }
}

function openBuy() {
  if (!userStore.isLoggedIn) {
    router.push({ name: 'login', query: { redirect: route.fullPath } })
    return
  }
  if (!goods.value || isSeller.value) return
  buyAddress.value = userStore.currentUser?.address ?? ''
  buyDialogVisible.value = true
}

async function confirmBuy() {
  if (!goods.value) return
  const order = await createOrder({
    goodsId: goods.value.goodsId,
    buyerId: userStore.currentUser!.userId,
    sellerId: goods.value.publishUserId,
    orderPrice: goods.value.sellPrice,
    shippingAddress: buyAddress.value,
  })
  buyDialogVisible.value = false
  if (!order) {
    ElMessage.warning('该商品当前不可购买')
    return
  }
  ElMessage.success('下单成功，请到我的订单中支付')
  router.push({ name: 'orders' })
}

async function onMessage() {
  if (!userStore.isLoggedIn) {
    router.push({ name: 'login', query: { redirect: route.fullPath } })
    return
  }
  if (!goods.value) return
  router.push({ name: 'messages', query: { to: String(goods.value.publishUserId) } })
}

async function onReport() {
  if (!userStore.isLoggedIn) {
    router.push({ name: 'login', query: { redirect: route.fullPath } })
    return
  }
  if (!goods.value) return
  const { value } = await ElMessageBox.prompt('请填写举报原因', '举报商品', {
    confirmButtonText: '提交',
    cancelButtonText: '取消',
  })
  await createReport({
    goodsId: goods.value.goodsId,
    reportUserId: userStore.currentUser!.userId,
    reportType: 1,
    reportContent: value,
  })
  ElMessage.success('举报已提交')
}

async function onEvaluate() {
  if (!goods.value) return
  if (!userStore.isLoggedIn) {
    router.push({ name: 'login', query: { redirect: route.fullPath } })
    return
  }
  // 评价必须绑定当前用户对该商品的已完成订单
  const orders = await listOrders({ buyerId: userStore.currentUser!.userId })
  const order = orders.find(
    (o) => o.goodsId === goods.value!.goodsId && o.orderStatus === 3,
  )
  if (!order) {
    ElMessage.warning('仅完成交易后可评价')
    return
  }
  // 同一订单只能评价一次
  const existing = await listEvaluates(goods.value.goodsId)
  if (existing.some((e) => e.orderId === order.orderId)) {
    ElMessage.warning('该订单已评价过')
    return
  }
  const { value, action } = await ElMessageBox.prompt('请写下你的评价', '评价', {
    confirmButtonText: '提交',
    cancelButtonText: '取消',
    inputPlaceholder: '写下你的评价…',
  })
  if (action !== 'confirm') return
  const ev = await createEvaluate({
    orderId: order.orderId,
    goodsId: goods.value.goodsId,
    evaluateUserId: userStore.currentUser!.userId,
    score: 5,
    evaluateContent: value,
  })
  if (!ev) {
    ElMessage.warning('该订单已评价过')
    return
  }
  ElMessage.success('评价成功')
  evaluates.value = await listEvaluates(goods.value.goodsId)
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
          <span class="price big">¥{{ goods.sellPrice }}</span>
          <span v-if="goods.originalPrice" class="original">原价 ¥{{ goods.originalPrice }}</span>
        </div>
        <div class="meta-row">
          <span class="label">交易方式</span>
          <el-tag>{{ tradeTypeText }}</el-tag>
        </div>
        <div class="meta-row">
          <span class="label">成色</span>
          <span>{{ qualityText }}</span>
        </div>
        <div class="meta-row">
          <span class="label">浏览量</span>
          <span>{{ goods.views }} 次</span>
        </div>
        <div class="meta-row">
          <span class="label">发布时间</span>
          <span>{{ goods.publishTime }}</span>
        </div>
        <div v-if="goods.rejectReason" class="meta-row">
          <span class="label">驳回原因</span>
          <span class="reject">{{ goods.rejectReason }}</span>
        </div>

        <div v-if="seller" class="seller-box" @click="router.push({ name: 'user-profile', params: { id: seller.userId } })">
          <el-avatar :size="40" :src="seller.avatar" />
          <div class="seller-info">
            <div class="seller-name">{{ seller.userName }}</div>
            <div class="seller-sub">卖家 · 点击查看主页</div>
          </div>
        </div>

        <div class="actions">
          <el-button
            type="primary"
            size="large"
            :disabled="isSeller || !goods.purchasable"
            @click="openBuy"
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
      <div class="desc" v-html="goods.goodsDesc"></div>
    </div>

    <div class="section">
      <div class="section-header">
        <h2 class="section-title">商品评价（{{ evaluates.length }}）</h2>
        <el-button size="small" type="primary" link @click="onEvaluate">写评价</el-button>
      </div>
      <div v-if="evaluates.length" class="evaluate-list">
        <div v-for="e in evaluates" :key="e.evaluateId" class="evaluate-item">
          <div class="evaluate-top">
            <el-rate :model-value="e.score" disabled />
            <span class="evaluate-time">{{ e.evaluateTime }}</span>
          </div>
          <p class="evaluate-content">{{ e.evaluateContent }}</p>
        </div>
      </div>
      <el-empty v-else description="暂无评价" :image-size="60" />
    </div>
  </div>
  <el-skeleton v-else class="page-container" :rows="6" animated />

  <!-- 下单确认弹窗 -->
  <el-dialog v-model="buyDialogVisible" title="确认订单" width="480px">
    <div v-if="goods" class="buy-confirm">
      <div class="buy-goods">
        <img :src="goods.images[0]" class="buy-img" />
        <div>
          <div class="buy-title">{{ goods.title }}</div>
          <div class="buy-price">¥{{ goods.sellPrice }}</div>
        </div>
      </div>
      <el-form label-width="80px" class="buy-form">
        <el-form-item label="收货人">
          <span>{{ userStore.currentUser?.userName }}</span>
        </el-form-item>
        <el-form-item label="收货地址">
          <el-input v-model="buyAddress" placeholder="请输入收货地址" />
        </el-form-item>
      </el-form>
    </div>
    <template #footer>
      <el-button @click="buyDialogVisible = false">取消</el-button>
      <el-button type="primary" @click="confirmBuy">确认下单</el-button>
    </template>
  </el-dialog>
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
  color: var(--color-primary);
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
.reject {
  color: var(--color-danger);
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
.buy-confirm {
  padding: 0 4px;
}
.buy-goods {
  display: flex;
  gap: 12px;
  padding-bottom: 16px;
  border-bottom: 1px solid var(--border-color);
}
.buy-img {
  width: 72px;
  height: 72px;
  object-fit: cover;
  border-radius: 6px;
}
.buy-title {
  font-size: 15px;
  font-weight: 600;
}
.buy-price {
  color: var(--color-primary);
  font-weight: 700;
  margin-top: 6px;
}
.buy-form {
  margin-top: 16px;
}
</style>
