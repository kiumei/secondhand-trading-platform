import { ref } from 'vue'
import { defineStore } from 'pinia'
import type { Goods } from '@/types'
import * as favoriteApi from '@/api/favorite'

export const useFavoriteStore = defineStore('favorite', () => {
  const favorites = ref<Goods[]>([])
  const loading = ref(false)

  async function refresh() {
    loading.value = true
    favorites.value = await favoriteApi.listFavorites()
    loading.value = false
  }

  async function toggle(goodsId: string) {
    const exist = favorites.value.some((g) => g.goodsId === goodsId)
    if (exist) {
      await favoriteApi.removeFavorite(goodsId)
      favorites.value = favorites.value.filter((g) => g.goodsId !== goodsId)
    } else {
      await favoriteApi.addFavorite(goodsId)
      await refresh()
    }
  }

  function isFavorite(goodsId: string) {
    return favorites.value.some((g) => g.goodsId === goodsId)
  }

  return { favorites, loading, refresh, toggle, isFavorite }
})
