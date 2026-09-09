<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { listOrders, updateOrderStatus, updateOrderShippingAddress } from '@/api/order'
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
const counterpartyNames = ref<Record<number, string>>({})

const detailVisible = ref(false)
const detailOrder = ref<Order | null>(null)
const buyer = ref<User | null>(null)
const seller = ref<User | null>(null)

const statusText: Record<number, string> = {
  0: '待付款',
  1: '待发货',
  2: '待收货',
  3: '已完成',
  4: '已取消',
  5: '售后',
}
const statusType: Record<number, 'info' | 'warning' | 'primary' | 'success' | 'danger'> = {
  0: 'warning',
  1: 'primary',
  2: 'info',
  3: 'success',
  4: 'danger',
  5: 'danger',
}

const isBuyTab = computed(() => activeTab.value === 'buy')

async function load() {
  if (!userStore.currentUser) return
  loading.value = true
  const uid = userStore.currentUser.userId
  orders.value = await listOrders(
    activeTab.value === 'buy' ? { buyerId: uid } : { sellerId: uid },
  )
  const all = await listGoods()
  goodsMap.value = Object.fromEntries(all.map((g) => [g.goodsId, g]))
  const ids = new Set<number>()
  orders.value.forEach((o) => ids.add(activeTab.value === 'buy' ? o.sellerId : o.buyerId))
  for (const id of ids) {
    const u = await getUser(id)
    if (u) counterpartyNames.value[id] = u.userName
  }
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

function counterpartyName(o: Order): string {
  const id = activeTab.value === 'buy' ? o.sellerId : o.buyerId
  return counterpartyNames.value[id] ?? '未知'
}

async function openDetail(o: Order) {
  detailOrder.value = o
  detailVisible.value = true
  buyer.value = (await getUser(o.buyerId)) ?? null
  seller.value = (await getUser(o.sellerId)) ?? null
}

async function pay(order: Order) {
  await updateOrderStatus(order.orderId, 1)
  ElMessage.success('支付成功（模拟）')
  detailVisible.value = false
  load()
}

async function ship(order: Order) {
  await updateOrderStatus(order.orderId, 2)
  await sendMessage(order.sellerId, order.buyerId, `你的订单 #${order.orderId} 已发货`)
  ElMessage.success('已发货，并已通知买家')
  detailVisible.value = false
  load()
}

async function confirm(order: Order) {
  await updateOrderStatus(order.orderId, 3)
  await sendMessage(order.buyerId, order.sellerId, `订单 #${order.orderId} 已被买家确认收货，交易完成`)
  ElMessage.success('已确认收货，并已通知卖家')
  detailVisible.value = false
  load()
}

async function editAddress(order: Order) {
  const { value, action } = await ElMessageBox.prompt('请修改收货地址', '修改收货地址', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    inputValue: order.shippingAddress ?? '',
    inputPlaceholder: '请输入收货地址',
  })
  if (action !== 'confirm') return
  await updateOrderShippingAddress(order.orderId, value)
  ElMessage.success('地址已修改')
  detailVisible.value = false
  load()
}

async function cancel(order: Order) {
  try {
    await ElMessageBox.confirm('确定取消该订单？取消后商品将重新上架', '提示', { type: 'warning' })
  } catch {
    return
  }
  await updateOrderStatus(order.orderId, 4)
  ElMessage.success('订单已取消')
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
      <div v-for="o in orders" :key="o.orderId" class="order-card hover-card" @click="openDetail(o)">
        <div class="order-head">
          <span class="order-id">订单号 #{{ o.orderId }}</span>
          <span class="order-counterparty">{{ activeTab === 'buy' ? '卖家' : '买家' }}：{{ counterpartyName(o) }}</span>
          <span class="order-time">{{ o.createTime }}</span>
          <el-tag :type="statusType[o.orderStatus]">{{ statusText[o.orderStatus] }}</el-tag>
        </div>
        <div class="order-body">
          <img :src="goodsOf(o)?.images[0]" class="order-img" />
          <div class="order-info">
            <div class="order-title ellipsis">{{ goodsOf(o)?.title }}</div>
            <div class="order-price price">¥{{ o.orderPrice }}</div>
          </div>
          <div class="order-actions" @click.stop>
            <el-button v-if="o.orderStatus === 0 && isBuyTab" size="small" @click="editAddress(o)">修改地址</el-button>
            <el-button v-if="o.orderStatus === 0 && isBuyTab" type="primary" size="small" @click="pay(o)">去支付</el-button>
            <el-button v-if="o.orderStatus === 0 && isBuyTab" type="danger" size="small" @click="cancel(o)">取消订单</el-button>
            <el-button v-if="o.orderStatus === 1 && !isBuyTab" type="primary" size="small" @click="ship(o)">发货</el-button>
            <el-button v-if="o.orderStatus === 2 && isBuyTab" type="success" size="small" @click="confirm(o)">确认收货</el-button>
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
            <div class="detail-goods-price price">¥{{ detailOrder.orderPrice }}</div>
          </div>
        </div>

        <el-descriptions :column="1" border class="detail-desc">
          <el-descriptions-item label="订单号">#{{ detailOrder.orderId }}</el-descriptions-item>
          <el-descriptions-item label="下单时间">{{ detailOrder.createTime }}</el-descriptions-item>
          <el-descriptions-item label="状态">
            <el-tag :type="statusType[detailOrder.orderStatus]">{{ statusText[detailOrder.orderStatus] }}</el-tag>
          </el-descriptions-item>
          <el-descriptions-item v-if="detailOrder.shippingAddress" label="收货地址">
            {{ detailOrder.shippingAddress }}
          </el-descriptions-item>
        </el-descriptions>

        <!-- 交易对方信息 -->
        <div v-if="isBuyTab && seller" class="counter-party">
          <div class="cp-title">卖家信息</div>
          <div class="cp-row" @click="goUser(seller.userId)">
            <el-avatar :size="36" :src="seller.avatar" />
            <span class="cp-name">{{ seller.userName }}</span>
            <el-icon><ArrowRight /></el-icon>
          </div>
          <div class="cp-row"><el-icon><Phone /></el-icon><span>{{ seller.phone }}</span></div>
        </div>
        <div v-if="!isBuyTab && buyer" class="counter-party">
          <div class="cp-title">买家信息</div>
          <div class="cp-row" @click="goUser(buyer.userId)">
            <el-avatar :size="36" :src="buyer.avatar" />
            <span class="cp-name">{{ buyer.userName }}</span>
            <el-icon><ArrowRight /></el-icon>
          </div>
          <div class="cp-row"><el-icon><Phone /></el-icon><span>{{ buyer.phone }}</span></div>
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
.order-counterparty {
  color: var(--text-main);
  font-size: 13px;
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
.order-price {
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
