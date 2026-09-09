import { getDB, persist, nextId, delay } from './mock/db'
import type { Report, ReportType } from '@/types'

export function listReports(): Promise<Report[]> {
  const list = getDB().reports.slice().sort((a, b) => Number(b.reportId) - Number(a.reportId))
  return delay(list)
}

export function createReport(input: {
  goodsId: string
  reportUserId: string
  reportType: ReportType
  reportContent: string
  proofImg?: string
}): Promise<Report> {
  const db = getDB()
  const r: Report = {
    reportId: nextId('report'),
    ...input,
    handleStatus: 0,
    reportTime: new Date().toLocaleString('zh-CN'),
  }
  db.reports.unshift(r)
  persist()
  return delay(r)
}

export function handleReport(id: string, handleResult: string): Promise<void> {
  const db = getDB()
  const r = db.reports.find((x) => x.reportId === id)
  if (r) {
    r.handleStatus = 1
    r.handleResult = handleResult
    persist()
  }
  return delay(undefined)
}
