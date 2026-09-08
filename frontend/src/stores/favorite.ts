import { ref } from 'vue'
import { defineStore } from 'pinia'
import type { Favorite } from '@/types'
import * as favoriteApi from '@/api/favorite'
import { useUserStore } from './user'

export const useFavoriteStore = defineStore('favorite', () => {
  const favorites = ref<Favorite[]>([])
  const loading = ref(false)

  async function refresh() {
    const userStore = useUserStore()
    if (!userStore.currentUser) return
    loading.value = true
    favorites.value = await favoriteApi.listFavorites(userStore.currentUser.userId)
    loading.value = false
  }

  async function toggle(goodsId: number) {
    const userStore = useUserStore()
    if (!userStore.currentUser) return
    const uid = userStore.currentUser.userId
    const exist = favorites.value.some((f) => f.goodsId === goodsId)
    if (exist) {
      await favoriteApi.removeFavorite(uid, goodsId)
      favorites.value = favorites.value.filter((f) => f.goodsId !== goodsId)
    } else {
      await favoriteApi.addFavorite(uid, goodsId)
      favorites.value.unshift({
        favoriteId: Date.now(),
        userId: uid,
        goodsId,
        createTime: new Date().toLocaleString('zh-CN'),
      })
    }
  }

  function isFavorite(goodsId: number) {
    return favorites.value.some((f) => f.goodsId === goodsId)
  }

  return { favorites, loading, refresh, toggle, isFavorite }
})
