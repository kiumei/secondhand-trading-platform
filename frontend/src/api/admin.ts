import { getDB, persist, nextId, delay } from './mock/db'
import type { Category, Bulletin, SiteConfig } from '@/types'

export function listCategories(): Promise<Category[]> {
  return delay(getDB().categories.slice())
}

export function createCategory(name: string): Promise<Category> {
  const db = getDB()
  const c: Category = { id: nextId('goods'), name, parentId: 0 }
  db.categories.push(c)
  persist()
  return delay(c)
}

export function deleteCategory(id: number): Promise<void> {
  const db = getDB()
  db.categories = db.categories.filter((c) => c.id !== id)
  persist()
  return delay(undefined)
}

export function listBulletins(): Promise<Bulletin[]> {
  return delay(getDB().bulletins.slice().sort((a, b) => b.createdAt.localeCompare(a.createdAt)))
}

export function createBulletin(title: string, content: string): Promise<Bulletin> {
  const db = getDB()
  const b: Bulletin = {
    id: nextId('bulletin'),
    title,
    content,
    createdAt: new Date().toLocaleDateString('zh-CN'),
  }
  db.bulletins.unshift(b)
  persist()
  return delay(b)
}

export function deleteBulletin(id: number): Promise<void> {
  const db = getDB()
  db.bulletins = db.bulletins.filter((b) => b.id !== id)
  persist()
  return delay(undefined)
}

export function getSiteConfig(): Promise<SiteConfig> {
  return delay(getDB().siteConfig)
}

export function updateSiteConfig(config: SiteConfig): Promise<void> {
  const db = getDB()
  db.siteConfig = config
  persist()
  return delay(undefined)
}
