import { getDB, persist, nextId, delay } from './mock/db'
import type { Report } from '@/types'

export function listReports(): Promise<Report[]> {
  const list = getDB().reports.slice().sort((a, b) => b.createdAt.localeCompare(a.createdAt))
  return delay(list)
}

export function createReport(input: { goodsId: number; userId: number; reason: string }): Promise<Report> {
  const db = getDB()
  const r: Report = {
    id: nextId('report'),
    ...input,
    status: 'pending',
    createdAt: new Date().toLocaleString('zh-CN'),
  }
  db.reports.unshift(r)
  persist()
  return delay(r)
}

export function resolveReport(id: number): Promise<void> {
  const db = getDB()
  const r = db.reports.find((x) => x.id === id)
  if (r) {
    r.status = 'done'
    persist()
  }
  return delay(undefined)
}
