import http from './http'
import type { Category } from '@/types'

// 分类列表（公开）
export function listCategories(): Promise<Category[]> {
  return http.get('/categories') as unknown as Promise<Category[]>
}

// 新增分类（管理员）
export function createCategory(cateName: string, parentId = 0): Promise<Category> {
  return http.post('/admin/categories', { cateName, parentId }) as unknown as Promise<Category>
}

// 更新分类（管理员）
export function updateCategory(id: string, cateName: string): Promise<void> {
  return http.put(`/admin/categories/${id}`, { cateName }) as unknown as Promise<void>
}

// 删除分类（管理员）
export function deleteCategory(id: string): Promise<void> {
  return http.delete(`/admin/categories/${id}`) as unknown as Promise<void>
}
