<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { listGoods } from '@/api/goods'
import { listCategories } from '@/api/admin'
import type { Goods, Category } from '@/types'
import GoodsGrid from '@/components/GoodsGrid.vue'
import { categoryStyle } from '@/constants/categories'

const router = useRouter()
const goods = ref<Goods[]>([])
const allGoods = ref<Goods[]>([])
const categories = ref<Category[]>([])
const activeCate = ref<string>('')
const loading = ref(false)

// 排序
type SortKey = 'default' | 'price-asc' | 'price-desc' | 'newest'
const sortBy = ref<SortKey>('default')
const sortOptions: { key: SortKey; label: string }[] = [
  { key: 'default', label: '综合排序' },
  { key: 'newest', label: '最新发布' },
  { key: 'price-asc', label: '价格从低到高' },
  { key: 'price-desc', label: '价格从高到低' },
]

const sortedGoods = computed(() => {
  const list = goods.value.slice()
  switch (sortBy.value) {
    case 'price-asc':
      return list.sort((a, b) => a.sellPrice - b.sellPrice)
    case 'price-desc':
      return list.sort((a, b) => b.sellPrice - a.sellPrice)
    case 'newest':
      return list.sort((a, b) => b.publishTime.localeCompare(a.publishTime))
    default:
      return list
  }
})

const activeCateName = computed(
  () => categories.value.find((c) => c.cateId === activeCate.value)?.cateName ?? '',
)

function featGoods(cateId: string): Goods[] {
  return allGoods.value.filter((g) => g.cateId === cateId).slice(0, 3)
}

async function loadAll() {
  loading.value = true
  const [goodsList, catList] = await Promise.all([
    listGoods({ status: 1 }), // 上架
    listCategories(),
  ])
  // 首页是购物入口，只展示可购买商品（过滤掉已被他人拍下/订单中的）
  allGoods.value = goodsList.filter((g) => g.purchasable)
  categories.value = catList
  goods.value = allGoods.value
  loading.value = false
}

function switchCate(cateId: string) {
  activeCate.value = cateId
  goods.value = cateId === '' ? allGoods.value : allGoods.value.filter((g) => g.cateId === cateId)
}

function goCateGoods(cateId: string) {
  router.push({ name: 'search', query: { category: cateId } })
}

function goAll() {
  router.push({ name: 'search' })
}

onMounted(loadAll)
</script>

<template>
  <div class="home">
    <div class="home-layout">
      <!-- 左侧分类导航 -->
      <aside class="side-nav">
        <div
          class="side-nav-item"
          :class="{ active: activeCate === '' }"
          @click="switchCate('')"
        >
          <el-icon :size="18"><Grid /></el-icon>
          <span>全部</span>
        </div>
        <div
          v-for="(c, i) in categories"
          :key="c.cateId"
          class="side-nav-item"
          :class="{ active: activeCate === c.cateId }"
          @click="switchCate(c.cateId)"
        >
          <el-icon :size="18"><component :is="categoryStyle(i).icon" /></el-icon>
          <span>{{ c.cateName }}</span>
        </div>
      </aside>

      <!-- 中间内容区 -->
      <div class="content">
        <!-- 选中分类时：分类商品列表 -->
        <template v-if="activeCate !== ''">
          <div class="featured">
            <div class="featured-head">
              <h2 class="featured-title">{{ activeCateName }}</h2>
              <div class="featured-right">
                <span class="featured-count">共 {{ goods.length }} 件</span>
                <el-dropdown trigger="click" @command="(k: string) => sortBy = k as SortKey">
                  <span class="sort-btn">
                    <el-icon :size="14"><Sort /></el-icon>
                    {{ sortOptions.find((s) => s.key === sortBy)?.label }}
                  </span>
                  <template #dropdown>
                    <el-dropdown-menu>
                      <el-dropdown-item
                        v-for="s in sortOptions"
                        :key="s.key"
                        :command="s.key"
                        :class="{ 'is-active': sortBy === s.key }"
                      >
                        {{ s.label }}
                      </el-dropdown-item>
                    </el-dropdown-menu>
                  </template>
                </el-dropdown>
              </div>
            </div>
            <div v-loading="loading">
              <GoodsGrid v-if="sortedGoods.length" :goods="sortedGoods" />
              <el-empty v-else description="该分类暂无商品" />
            </div>
          </div>
        </template>

        <!-- 默认首页 -->
        <template v-else>
          <!-- 主 Banner -->
          <div class="banner">
            <div class="banner-text">
              <h1 class="banner-title">二手市场</h1>
              <p class="banner-sub">每一件二手物品，都是独一无二的故事！</p>
            </div>
          </div>

          <!-- 分类推荐卡片 -->
          <div class="feat-grid">
            <div
              v-for="(f, i) in categories"
              :key="f.cateId"
              class="feat-card"
              :style="{ background: categoryStyle(i).tint }"
              @click="goCateGoods(f.cateId)"
            >
              <div class="feat-head">
                <span class="feat-name" :style="{ color: categoryStyle(i).color }">
                  <el-icon :size="16" style="margin-right: 4px"><component :is="categoryStyle(i).icon" /></el-icon>
                  {{ f.cateName }}
                </span>
              </div>
              <div class="feat-thumbs">
                <div v-for="g in featGoods(f.cateId)" :key="g.goodsId" class="feat-thumb">
                  <img :src="g.images[0]" :alt="g.title" />
                  <span class="feat-price">¥{{ g.sellPrice }}</span>
                </div>
                <el-empty v-if="!featGoods(f.cateId).length" description="暂无" :image-size="40" />
              </div>
            </div>
          </div>

          <!-- 精选好物 -->
          <div class="featured">
            <div class="featured-head">
              <h2 class="featured-title">精选好物</h2>
              <div class="featured-right">
                <el-dropdown trigger="click" @command="(k: string) => sortBy = k as SortKey">
                  <span class="sort-btn">
                    <el-icon :size="14"><Sort /></el-icon>
                    {{ sortOptions.find((s) => s.key === sortBy)?.label }}
                  </span>
                  <template #dropdown>
                    <el-dropdown-menu>
                      <el-dropdown-item
                        v-for="s in sortOptions"
                        :key="s.key"
                        :command="s.key"
                        :class="{ 'is-active': sortBy === s.key }"
                      >
                        {{ s.label }}
                      </el-dropdown-item>
                    </el-dropdown-menu>
                  </template>
                </el-dropdown>
                <span class="featured-more" @click="goAll">查看全部 <el-icon><ArrowRight /></el-icon></span>
              </div>
            </div>
            <div v-loading="loading">
              <GoodsGrid v-if="sortedGoods.length" :goods="sortedGoods" />
              <el-empty v-else description="暂无商品" />
            </div>
          </div>
        </template>
      </div>
    </div>
  </div>
</template>

<style scoped>
.home {
  max-width: 1200px;
  margin: 0 auto;
  padding: var(--space-4);
}
.home-layout {
  display: flex;
  gap: var(--space-4);
}

/* 左侧分类导航 */
.side-nav {
  width: 160px;
  flex-shrink: 0;
  background: var(--card-bg);
  border-radius: var(--radius-md);
  border: 1px solid var(--border-color);
  padding: var(--space-2);
  align-self: flex-start;
  position: sticky;
  top: 80px;
}
.side-nav-item {
  display: flex;
  align-items: center;
  gap: var(--space-2);
  padding: var(--space-2) var(--space-3);
  border-radius: var(--radius-sm);
  cursor: pointer;
  color: var(--text-main);
  font-size: var(--text-base);
  transition: all 0.2s;
  border-left: 3px solid transparent;
}
.side-nav-item:hover {
  background: var(--color-surface);
}
.side-nav-item.active {
  background: var(--el-color-primary-light-9);
  color: var(--color-primary);
  font-weight: 600;
  border-left-color: var(--color-primary);
  border-radius: 0 var(--radius-sm) var(--radius-sm) 0;
}

/* 中间内容 */
.content {
  flex: 1;
  min-width: 0;
}

/* Banner */
.banner {
  height: 220px;
  border-radius: var(--radius-md);
  background: linear-gradient(135deg, rgba(7, 193, 96, 0.15), rgba(7, 193, 96, 0.45));
  display: flex;
  align-items: center;
  padding: var(--space-6);
  margin-bottom: var(--space-4);
}
.banner-title {
  font-size: 40px;
  font-weight: 800;
  color: #fff;
  letter-spacing: 2px;
  text-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
}
.banner-sub {
  font-size: var(--text-md);
  color: rgba(255, 255, 255, 0.95);
  margin-top: var(--space-2);
  text-shadow: 0 1px 4px rgba(0, 0, 0, 0.3);
}

/* 分类推荐卡片 */
.feat-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--space-4);
  margin-bottom: var(--space-5);
}
.feat-card {
  border-radius: var(--radius-md);
  padding: var(--space-4);
  cursor: pointer;
  transition: transform 0.2s;
}
.feat-card:hover {
  transform: translateY(-2px);
}
.feat-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: var(--space-3);
}
.feat-name {
  font-weight: 700;
  font-size: var(--text-md);
  display: inline-flex;
  align-items: center;
}
.feat-thumbs {
  display: flex;
  gap: var(--space-2);
}
.feat-thumb {
  width: 72px;
  position: relative;
}
.feat-thumb img {
  width: 72px;
  height: 72px;
  object-fit: cover;
  border-radius: var(--radius-sm);
  display: block;
}
.feat-price {
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  font-size: var(--text-xs);
  color: #fff;
  font-weight: 600;
  background: rgba(0, 0, 0, 0.55);
  border-radius: 0 0 var(--radius-sm) var(--radius-sm);
  text-align: center;
  padding: 1px 0;
  line-height: 1.4;
}

/* 精选好物 */
.featured-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: var(--space-4);
}
.featured-title {
  font-size: var(--text-xl);
  color: var(--color-ink);
}
.featured-right {
  display: flex;
  align-items: center;
  gap: var(--space-4);
}
.featured-count {
  color: var(--text-sub);
  font-size: var(--text-base);
}
.sort-btn {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  cursor: pointer;
  color: var(--text-sub);
  font-size: var(--text-base);
  padding: var(--space-1) var(--space-2);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-sm);
  outline: none;
  transition: color 0.2s, border-color 0.2s;
}
.sort-btn:hover {
  color: var(--color-primary);
  border-color: var(--color-primary);
}
.featured-more {
  display: flex;
  align-items: center;
  gap: 2px;
  color: var(--text-sub);
  cursor: pointer;
  font-size: var(--text-base);
}
.featured-more:hover {
  color: var(--color-primary);
}

@media (max-width: 768px) {
  .side-nav {
    display: none;
  }
  .feat-grid {
    grid-template-columns: 1fr;
  }
}
</style>
