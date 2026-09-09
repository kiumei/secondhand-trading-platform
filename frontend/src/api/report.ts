import http from './http'
import type { Report, ReportType } from '@/types'

interface ApiReport {
  reportId: string
  reportUserId: string
  goodsId: string
  reportType: number
  reportContent: string
  proofImg?: string | null
  handleStatus: number
  handleResult?: string | null
  reportTime?: string | null
}

function toReport(api: ApiReport): Report {
  return {
    reportId: api.reportId,
    reportUserId: api.reportUserId,
    goodsId: api.goodsId,
    reportType: api.reportType as ReportType,
    reportContent: api.reportContent,
    proofImg: api.proofImg ?? undefined,
    handleStatus: api.handleStatus,
    handleResult: api.handleResult ?? undefined,
    reportTime: api.reportTime ?? undefined,
  }
}

// 管理员举报列表
export async function listReports(): Promise<Report[]> {
  const data = (await http.get('/admin/reports', { params: { page: 1, pageSize: 50 } })) as {
    items: ApiReport[]
  }
  return (data.items ?? []).map(toReport)
}

export async function createReport(input: {
  goodsId: string
  reportUserId: string
  reportType: ReportType
  reportContent: string
  proofImg?: string
}): Promise<Report> {
  const api = (await http.post('/reports', {
    goodsId: input.goodsId,
    reportType: input.reportType,
    reportContent: input.reportContent,
    proofImg: input.proofImg,
  })) as ApiReport
  return toReport(api)
}

export async function handleReport(id: string, handleResult: string): Promise<void> {
  await http.post(`/admin/reports/${id}/handle`, { handleResult })
}
