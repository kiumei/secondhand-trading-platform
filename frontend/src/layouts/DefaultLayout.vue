<script setup lang="ts">
import { ref, watch, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { useThemeStore } from '@/stores/theme'
import { useFavoriteStore } from '@/stores/favorite'
import { listGoods } from '@/api/goods'
import { listCategories } from '@/api/admin'
import { ElMessage } from 'element-plus'
import DockBar from '@/components/DockBar.vue'

const router = useRouter()
const userStore = useUserStore()
const themeStore = useThemeStore()
const favoriteStore = useFavoriteStore()

const keyword = ref('')
const suggestWords = ref<string[]>([])

// 加载联想词源：商品标题 + 分类名
async function loadSuggestWords() {
  const [goods, categories] = await Promise.all([listGoods(), listCategories()])
  const set = new Set<string>()
  categories.forEach((c) => set.add(c.cateName))
  goods.forEach((g) => set.add(g.title))
  suggestWords.value = Array.from(set)
}

function querySuggest(query: string, cb: (list: { value: string }[]) => void) {
  const kw = query.trim()
  if (!kw) {
    cb([])
    return
  }
  const prefix = suggestWords.value.filter((w) => w.startsWith(kw))
  const contains = suggestWords.value.filter((w) => !w.startsWith(kw) && w.includes(kw))
  cb([...prefix, ...contains].slice(0, 10).map((w) => ({ value: w })))
}

function onSearch() {
  router.push({ name: 'search', query: keyword.value ? { q: keyword.value } : {} })
}

function onLogout() {
  userStore.logout()
  ElMessage.success('已退出登录')
  router.push({ name: 'home' })
}

function toggleTheme() {
  themeStore.setTheme(themeStore.theme === 'light' ? 'dark' : 'light')
}

onMounted(loadSuggestWords)

watch(() => userStore.isLoggedIn, () => {
  if (userStore.isLoggedIn) {
    favoriteStore.refresh()
    userStore.syncBanStatus()
  }
})
</script>

<template>
  <div class="layout">
    <!-- 顶部导航（绿色通栏） -->
    <header class="navbar">
      <div class="navbar-inner">
        <div class="logo" @click="router.push({ name: 'home' })">
          <span class="logo-icon">闲</span>
          <span class="logo-text">校园二手集市</span>
        </div>

        <div class="search-box">
          <el-autocomplete
            v-model="keyword"
            :fetch-suggestions="querySuggest"
            :placeholder="'搜索你想要的闲置商品…'"
            clearable
            :trigger-on-focus="true"
            @select="onSearch"
            @keyup.enter="onSearch"
          >
            <template #prefix><el-icon><Search /></el-icon></template>
          </el-autocomplete>
          <el-button class="search-btn" @click="onSearch">搜索</el-button>
        </div>

        <div class="actions">
          <el-tooltip :content="themeStore.theme === 'light' ? '深色模式' : '浅色模式'" placement="bottom">
            <el-icon :size="20" class="icon-btn" @click="toggleTheme">
              <Moon v-if="themeStore.theme === 'light'" />
              <Sunny v-else />
            </el-icon>
          </el-tooltip>

          <template v-if="userStore.isLoggedIn">
            <el-dropdown>
              <span class="avatar-wrap">
                <el-avatar :size="36" :src="userStore.currentUser?.avatar" />
                <span class="nav-username">{{ userStore.currentUser?.userName }}</span>
              </span>
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item @click="router.push({ name: 'profile' })">
                    我的
                  </el-dropdown-item>
                  <el-dropdown-item @click="router.push({ name: 'orders' })">我的订单</el-dropdown-item>
                  <el-dropdown-item @click="router.push({ name: 'favorites' })">我的收藏</el-dropdown-item>
                  <el-dropdown-item
                    v-if="userStore.isAdmin"
                    @click="router.push({ name: 'admin-dashboard' })"
                  >
                    后台管理
                  </el-dropdown-item>
                  <el-dropdown-item divided @click="onLogout">退出登录</el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </template>
          <template v-else>
            <el-button class="login-btn" round @click="router.push({ name: 'login' })">
              登录
            </el-button>
          </template>
        </div>
      </div>
    </header>

    <main class="main">
      <RouterView />
    </main>

    <!-- 右侧悬浮 Dock 栏 -->
    <DockBar />

    <footer class="footer">校园二手交易平台 · 让闲置流动起来</footer>
  </div>
</template>

<style scoped>
.layout {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}
.navbar {
  position: sticky;
  top: 0;
  z-index: 100;
  background: var(--card-bg);
  border-bottom: 1px solid var(--color-hairline-soft);
}
.navbar-inner {
  max-width: 1200px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  gap: var(--space-5);
  padding: 0 var(--space-4);
  height: 64px;
}
.logo {
  display: flex;
  align-items: center;
  gap: var(--space-2);
  cursor: pointer;
  flex-shrink: 0;
}
.logo-icon {
  width: 36px;
  height: 36px;
  background: var(--color-brand);
  color: #fff;
  border-radius: var(--radius-sm);
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  font-size: 20px;
}
.logo-text {
  font-size: var(--text-lg);
  font-weight: 700;
  color: var(--text-main);
}
.search-box {
  flex: 0 1 420px;
  display: flex;
  gap: var(--space-2);
  margin-left: var(--space-6);
}
.search-box :deep(.el-input__wrapper) {
  border-radius: var(--radius-full);
}
.search-btn {
  border-radius: var(--radius-full);
  background: var(--color-primary);
  color: #fff;
  border: none;
  font-weight: 600;
}
.search-btn:hover {
  background: var(--color-primary-active);
  color: #fff;
}
.actions {
  display: flex;
  align-items: center;
  gap: var(--space-4);
  margin-left: auto;
}
.icon-btn {
  cursor: pointer;
  color: var(--text-main);
  transition: color 0.2s;
}
.icon-btn:hover {
  color: var(--color-primary);
}
.avatar-wrap {
  display: flex;
  align-items: center;
  cursor: pointer;
  outline: none;
}
.nav-username {
  margin-left: var(--space-2);
  font-size: var(--text-base);
  color: var(--text-main);
}
.login-btn {
  background: var(--color-primary);
  color: #fff;
  border: none;
  font-weight: 600;
}
.login-btn:hover {
  background: var(--color-primary-active);
  color: #fff;
}
.main {
  flex: 1;
  width: 100%;
}
.footer {
  text-align: center;
  padding: var(--space-5);
  color: var(--text-sub);
  font-size: var(--text-sm);
}
</style>
