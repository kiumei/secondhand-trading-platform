import { getDB, persist, delay } from './mock/db'
import type { Category } from '@/types'

export function listCategories(): Promise<Category[]> {
  return delay(getDB().categories.slice())
}

export function createCategory(cateName: string, parentId = 0): Promise<Category> {
  const db = getDB()
  const categoryId = db.categories.reduce((m, c) => Math.max(m, c.categoryId), 0) + 1
  const c: Category = { categoryId, cateName, parentId }
  db.categories.push(c)
  persist()
  return delay(c)
}

export function updateCategory(id: number, cateName: string): Promise<void> {
  const db = getDB()
  const c = db.categories.find((x) => x.categoryId === id)
  if (c) {
    c.cateName = cateName
    persist()
  }
  return delay(undefined)
}

export function deleteCategory(id: number): Promise<void> {
  const db = getDB()
  db.categories = db.categories.filter((c) => c.categoryId !== id)
  persist()
  return delay(undefined)
}
