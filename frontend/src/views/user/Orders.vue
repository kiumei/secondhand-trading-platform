<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { listOrders, updateOrderStatus } from '@/api/order'
import { listGoods } from '@/api/goods'
import { getUser } from '@/api/user'
import { sendMessage } from '@/api/message'
import { useUserStore } from '@/stores/user'
import type { Order, Goods, User } from '@/types'

const router = useRouter()
const userStore = useUserStore()
const activeTab = ref<'buy' | 'sell'>('buy')
const orders = ref<Order[]>([])
const goodsMap = ref<Record<number, Goods>>({})
const loading = ref(false)

// 详情弹窗
const detailVisible = ref(false)
const detailOrder = ref<Order | null>(null)
const buyer = ref<User | null>(null)
const seller = ref<User | null>(null)

const statusText: Record<string, string> = {
  unpaid: '待支付',
  paid: '待发货',
  shipped: '运输中',
  done: '已完成',
  cancelled: '已取消',
}
const statusType: Record<string, 'info' | 'warning' | 'primary' | 'success' | 'danger'> = {
  unpaid: 'warning',
  paid: 'primary',
  shipped: 'info',
  done: 'success',
  cancelled: 'danger',
}

const isBuyTab = computed(() => activeTab.value === 'buy')

async function load() {
  if (!userStore.currentUser) return
  loading.value = true
  const uid = userStore.currentUser.id
  orders.value = await listOrders(
    activeTab.value === 'buy' ? { buyerId: uid } : { sellerId: uid },
  )
  const all = await listGoods()
  goodsMap.value = Object.fromEntries(all.map((g) => [g.id, g]))
  loading.value = false
}

function switchTab(tab: 'buy' | 'sell') {
  activeTab.value = tab
  detailVisible.value = false
  load()
}

function goodsOf(o: Order): Goods | undefined {
  return goodsMap.value[o.goodsId]
}

async function openDetail(o: Order) {
  detailOrder.value = o
  detailVisible.value = true
  buyer.value = (await getUser(o.buyerId)) ?? null
  seller.value = (await getUser(o.sellerId)) ?? null
}

async function pay(order: Order) {
  await updateOrderStatus(order.id, 'paid')
  ElMessage.success('支付成功（模拟）')
  detailVisible.value = false
  load()
}

async function ship(order: Order) {
  const no = 'SF' + Math.random().toString().slice(2, 12)
  await updateOrderStatus(order.id, 'shipped', no + ' 运输中')
  // 通知买家
  await sendMessage(order.sellerId, order.buyerId, `你的订单 #${order.id} 已发货，物流单号 ${no}`)
  ElMessage.success('已发货，并已通知买家')
  detailVisible.value = false
  load()
}

async function confirm(order: Order) {
  await updateOrderStatus(order.id, 'done', '已签收')
  // 通知卖家
  await sendMessage(order.buyerId, order.sellerId, `订单 #${order.id} 已被买家确认收货，交易完成`)
  ElMessage.success('已确认收货，并已通知卖家')
  detailVisible.value = false
  load()
}

function goUser(id: number) {
  router.push({ name: 'user-profile', params: { id } })
}

onMounted(load)
</script>

<template>
  <div class="orders page-container">
    <h2 class="page-title">我的订单</h2>
    <el-tabs v-model="activeTab" @tab-change="switchTab">
      <el-tab-pane label="我买到的" name="buy" />
      <el-tab-pane label="我卖出的" name="sell" />
    </el-tabs>

    <div v-loading="loading" class="order-list">
      <div v-for="o in orders" :key="o.id" class="order-card hover-card" @click="openDetail(o)">
        <div class="order-head">
          <span class="order-id">订单号 #{{ o.id }}</span>
          <span class="order-time">{{ o.createdAt }}</span>
          <el-tag :type="statusType[o.status]">{{ statusText[o.status] }}</el-tag>
        </div>
        <div class="order-body">
          <img :src="goodsOf(o)?.images[0]" class="order-img" />
          <div class="order-info">
            <div class="order-title ellipsis">{{ goodsOf(o)?.title }}</div>
            <div class="order-price price">{{ o.price }}</div>
            <div v-if="o.logistics" class="order-logistics">物流：{{ o.logistics }}</div>
          </div>
          <div class="order-actions" @click.stop>
            <el-button v-if="o.status === 'unpaid' && isBuyTab" type="primary" size="small" @click="pay(o)">去支付</el-button>
            <el-button v-if="o.status === 'paid' && !isBuyTab" type="primary" size="small" @click="ship(o)">发货</el-button>
            <el-button v-if="o.status === 'shipped' && isBuyTab" type="success" size="small" @click="confirm(o)">确认收货</el-button>
          </div>
        </div>
      </div>
      <el-empty v-if="!orders.length" description="暂无订单" />
    </div>

    <!-- 订单详情弹窗 -->
    <el-dialog v-model="detailVisible" title="订单详情" width="520px">
      <template v-if="detailOrder">
        <div class="detail-goods">
          <img :src="goodsOf(detailOrder)?.images[0]" class="detail-goods-img" />
          <div>
            <div class="detail-goods-title">{{ goodsOf(detailOrder)?.title }}</div>
            <div class="detail-goods-price price">{{ detailOrder.price }}</div>
          </div>
        </div>

        <el-descriptions :column="1" border class="detail-desc">
          <el-descriptions-item label="订单号">#{{ detailOrder.id }}</el-descriptions-item>
          <el-descriptions-item label="下单时间">{{ detailOrder.createdAt }}</el-descriptions-item>
          <el-descriptions-item label="状态">
            <el-tag :type="statusType[detailOrder.status]">{{ statusText[detailOrder.status] }}</el-tag>
          </el-descriptions-item>
          <el-descriptions-item v-if="detailOrder.logistics" label="物流">
            {{ detailOrder.logistics }}
          </el-descriptions-item>
        </el-descriptions>

        <!-- 交易对方信息 -->
        <div v-if="isBuyTab && seller" class="counter-party">
          <div class="cp-title">卖家信息</div>
          <div class="cp-row" @click="goUser(seller.id)">
            <el-avatar :size="36" :src="seller.avatar" />
            <span class="cp-name">{{ seller.nickname }}</span>
            <el-icon><ArrowRight /></el-icon>
          </div>
          <div class="cp-row"><el-icon><Phone /></el-icon><span>{{ seller.phone }}</span></div>
        </div>
        <div v-if="!isBuyTab && buyer" class="counter-party">
          <div class="cp-title">买家信息</div>
          <div class="cp-row" @click="goUser(buyer.id)">
            <el-avatar :size="36" :src="buyer.avatar" />
            <span class="cp-name">{{ buyer.nickname }}</span>
            <el-icon><ArrowRight /></el-icon>
          </div>
          <div class="cp-row"><el-icon><Phone /></el-icon><span>{{ buyer.phone }}</span></div>
          <div class="cp-row"><el-icon><Location /></el-icon><span>{{ buyer.address || '未填写地址' }}</span></div>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped>
.orders {
  padding-top: 24px;
}
.page-title {
  font-size: 20px;
  margin-bottom: 16px;
}
.order-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.order-card {
  background: var(--card-bg);
  border-radius: var(--radius-md);
  border: 1px solid var(--border-color);
  padding: 16px;
  cursor: pointer;
}
.order-head {
  display: flex;
  align-items: center;
  gap: 16px;
  padding-bottom: 12px;
  border-bottom: 1px solid var(--border-color);
}
.order-id {
  font-weight: 600;
}
.order-time {
  color: var(--text-sub);
  font-size: 13px;
  flex: 1;
}
.order-body {
  display: flex;
  gap: 16px;
  padding-top: 12px;
  align-items: center;
}
.order-img {
  width: 80px;
  height: 80px;
  object-fit: cover;
  border-radius: 6px;
}
.order-info {
  flex: 1;
}
.order-title {
  font-size: 15px;
}
.order-logistics {
  font-size: 13px;
  color: var(--text-sub);
  margin-top: 4px;
}
.order-actions {
  display: flex;
  gap: 8px;
}
.detail-goods {
  display: flex;
  gap: 12px;
  margin-bottom: 16px;
}
.detail-goods-img {
  width: 80px;
  height: 80px;
  object-fit: cover;
  border-radius: 6px;
}
.detail-goods-title {
  font-size: 15px;
  margin-bottom: 4px;
}
.detail-desc {
  margin-bottom: 16px;
}
.counter-party {
  background: var(--page-bg);
  border-radius: var(--radius-sm);
  padding: 12px;
}
.cp-title {
  font-weight: 600;
  margin-bottom: 8px;
}
.cp-row {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 4px 0;
  color: var(--text-main);
}
.cp-row:hover {
  color: var(--color-primary);
}
.cp-name {
  flex: 1;
  font-weight: 500;
}
</style>
