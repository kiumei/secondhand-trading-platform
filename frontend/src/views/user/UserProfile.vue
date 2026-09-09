<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { getUser } from '@/api/user'
import { listGoods } from '@/api/goods'
import { listEvaluates } from '@/api/evaluate'
import { useUserStore } from '@/stores/user'
import type { User, Goods, Evaluate } from '@/types'
import GoodsGrid from '@/components/GoodsGrid.vue'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const profile = ref<User | null>(null)
const goods = ref<Goods[]>([])
const evaluates = ref<Evaluate[]>([])
const loading = ref(false)

const userId = computed(() => String(route.params.id))
const isSelf = computed(() => userStore.currentUser?.userId === userId.value)
const avgScore = computed(() => {
  if (!evaluates.value.length) return 0
  return evaluates.value.reduce((s, e) => s + e.score, 0) / evaluates.value.length
})

async function load() {
  loading.value = true
  profile.value = (await getUser(userId.value)) ?? null
  if (profile.value) {
    const all = await listGoods()
    goods.value = all.filter((g) => g.publishUserId === userId.value && g.goodsStatus === 1)
    const sold = all.filter((g) => g.publishUserId === userId.value)
    const list: Evaluate[] = []
    for (const g of sold) {
      list.push(...(await listEvaluates(g.goodsId)))
    }
    evaluates.value = list
  }
  loading.value = false
}

function goMessage() {
  if (!userStore.isLoggedIn) {
    router.push({ name: 'login', query: { redirect: route.fullPath } })
    return
  }
  router.push({ name: 'messages', query: { to: userId.value } })
}

function goEdit() {
  router.push({ name: 'profile' })
}

onMounted(load)
</script>

<template>
  <div v-loading="loading" class="user-profile page-container">
    <template v-if="profile">
      <!-- 头部卡片 -->
      <div class="profile-header">
        <el-avatar :size="88" :src="profile.avatar" class="avatar" />
        <div class="header-info">
          <div class="name-row">
            <h1 class="name">{{ profile.userName }}</h1>
            <el-tag :type="profile.role === 1 ? 'danger' : 'warning'" size="small">
              {{ profile.role === 1 ? '管理员' : '学生' }}
            </el-tag>
          </div>
          <p v-if="profile.intro" class="bio">{{ profile.intro }}</p>
        </div>
        <div class="header-actions">
          <el-button v-if="isSelf" type="primary" @click="goEdit">编辑资料</el-button>
          <el-button v-else type="primary" @click="goMessage">
            <el-icon style="margin-right: 4px"><ChatDotRound /></el-icon>私信 TA
          </el-button>
        </div>
      </div>

      <!-- 统计 -->
      <div class="stats">
        <div class="stat">
          <div class="stat-value">{{ goods.length }}</div>
          <div class="stat-label">在售商品</div>
        </div>
        <div class="stat">
          <div class="stat-value">{{ evaluates.length }}</div>
          <div class="stat-label">收到评价</div>
        </div>
        <div class="stat">
          <div class="stat-value">{{ avgScore ? avgScore.toFixed(1) : '—' }}</div>
          <div class="stat-label">平均评分</div>
        </div>
      </div>

      <!-- 联系方式 -->
      <div class="panel">
        <h3 class="panel-title">联系方式</h3>
        <div class="contact-row">
          <el-icon><Phone /></el-icon>
          <span>{{ profile.phone }}</span>
        </div>
        <div class="contact-row">
          <el-icon><Location /></el-icon>
          <span>{{ profile.address || '未填写地址' }}</span>
        </div>
      </div>

      <!-- 在售商品 -->
      <div class="panel">
        <h3 class="panel-title">在售商品（{{ goods.length }}）</h3>
        <GoodsGrid v-if="goods.length" :goods="goods" />
        <el-empty v-else description="暂无在售商品" />
      </div>

      <!-- 收到的评价 -->
      <div class="panel">
        <h3 class="panel-title">收到的评价（{{ evaluates.length }}）</h3>
        <div v-if="evaluates.length" class="eval-list">
          <div v-for="e in evaluates" :key="e.evaluateId" class="eval-item">
            <div class="eval-top">
              <el-rate :model-value="e.score" disabled size="small" />
              <span class="eval-time">{{ e.evaluateTime }}</span>
            </div>
            <p class="eval-content">{{ e.evaluateContent }}</p>
          </div>
        </div>
        <el-empty v-else description="暂无评价" :image-size="60" />
      </div>
    </template>
    <el-skeleton v-else :rows="8" animated />
  </div>
</template>

<style scoped>
.user-profile {
  padding-top: var(--space-5);
}
.profile-header {
  display: flex;
  align-items: center;
  gap: var(--space-5);
  background: var(--card-bg);
  border-radius: var(--radius-md);
  border: 1px solid var(--border-color);
  padding: var(--space-6);
}
.avatar {
  flex-shrink: 0;
}
.header-info {
  flex: 1;
  min-width: 0;
}
.name-row {
  display: flex;
  align-items: center;
  gap: var(--space-2);
}
.name {
  font-size: var(--text-xl);
  font-weight: 600;
  color: var(--color-ink);
}
.bio {
  color: var(--text-main);
  margin-top: var(--space-2);
}
.header-actions {
  flex-shrink: 0;
}
.stats {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: var(--space-4);
  margin-top: var(--space-4);
}
.stat {
  background: var(--card-bg);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md);
  padding: var(--space-4);
  text-align: center;
}
.stat-value {
  font-size: var(--text-2xl);
  font-weight: 700;
  color: var(--color-ink);
}
.stat-label {
  color: var(--text-sub);
  font-size: var(--text-sm);
  margin-top: var(--space-1);
}
.panel {
  background: var(--card-bg);
  border-radius: var(--radius-md);
  border: 1px solid var(--border-color);
  padding: var(--space-5);
  margin-top: var(--space-4);
}
.panel-title {
  font-size: var(--text-md);
  color: var(--color-ink);
  margin-bottom: var(--space-4);
}
.contact-row {
  display: flex;
  align-items: center;
  gap: var(--space-2);
  color: var(--text-main);
  padding: var(--space-2) 0;
}
.eval-item {
  padding: var(--space-3) 0;
  border-bottom: 1px solid var(--border-color);
}
.eval-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.eval-time {
  font-size: var(--text-xs);
  color: var(--text-sub);
}
.eval-content {
  color: var(--text-main);
  margin-top: var(--space-1);
}
</style>
