import { createRouter, createWebHistory } from 'vue-router'
import { useUserStore } from '@/stores/user'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      component: () => import('@/layouts/DefaultLayout.vue'),
      children: [
        {
          path: '',
          name: 'home',
          component: () => import('@/views/home/HomeView.vue'),
        },
        {
          path: 'goods/:id',
          name: 'goods-detail',
          component: () => import('@/views/goods/GoodsDetail.vue'),
        },
        {
          path: 'search',
          name: 'search',
          component: () => import('@/views/search/SearchView.vue'),
        },
        {
          path: 'publish',
          name: 'publish',
          component: () => import('@/views/goods/Publish.vue'),
          meta: { requiresAuth: true },
        },
        {
          path: 'favorites',
          name: 'favorites',
          component: () => import('@/views/user/Favorites.vue'),
          meta: { requiresAuth: true },
        },
        {
          path: 'messages',
          name: 'messages',
          component: () => import('@/views/user/Messages.vue'),
          meta: { requiresAuth: true },
        },
        {
          path: 'orders',
          name: 'orders',
          component: () => import('@/views/user/Orders.vue'),
          meta: { requiresAuth: true },
        },
        {
          path: 'profile',
          name: 'profile',
          component: () => import('@/views/user/Profile.vue'),
          meta: { requiresAuth: true },
        },
        {
          path: 'user/:id',
          name: 'user-profile',
          component: () => import('@/views/user/UserProfile.vue'),
        },
      ],
    },
    {
      path: '/login',
      name: 'login',
      component: () => import('@/views/user/Login.vue'),
    },
    {
      path: '/register',
      name: 'register',
      component: () => import('@/views/user/Register.vue'),
    },
    {
      path: '/admin',
      component: () => import('@/layouts/AdminLayout.vue'),
      meta: { requiresAuth: true, requiresAdmin: true },
      children: [
        {
          path: '',
          name: 'admin-dashboard',
          component: () => import('@/views/admin/Dashboard.vue'),
        },
        {
          path: 'audit',
          name: 'admin-audit',
          component: () => import('@/views/admin/Audit.vue'),
        },
        {
          path: 'categories',
          name: 'admin-categories',
          component: () => import('@/views/admin/Categories.vue'),
        },
        {
          path: 'users',
          name: 'admin-users',
          component: () => import('@/views/admin/Users.vue'),
        },
        {
          path: 'reports',
          name: 'admin-reports',
          component: () => import('@/views/admin/Reports.vue'),
        },
        {
          path: 'bulletin',
          name: 'admin-bulletin',
          component: () => import('@/views/admin/Bulletin.vue'),
        },
        {
          path: 'evaluates',
          name: 'admin-evaluates',
          component: () => import('@/views/admin/Evaluates.vue'),
        },
        {
          path: 'orders',
          name: 'admin-orders',
          component: () => import('@/views/admin/Orders.vue'),
        },
        {
          path: 'settings',
          name: 'admin-settings',
          component: () => import('@/views/admin/Settings.vue'),
        },
      ],
    },
    {
      path: '/setup',
      name: 'setup',
      component: () => import('@/views/setup/SetupWizard.vue'),
    },
    {
      path: '/:pathMatch(.*)*',
      name: 'not-found',
      component: () => import('@/views/error/NotFound.vue'),
    },
  ],
})

router.beforeEach((to) => {
  const userStore = useUserStore()
  if (to.meta.requiresAuth && !userStore.isLoggedIn) {
    return { name: 'login', query: { redirect: to.fullPath } }
  }
  if (to.meta.requiresAdmin && !userStore.isAdmin) {
    return { name: 'home' }
  }
  return true
})

export default router
