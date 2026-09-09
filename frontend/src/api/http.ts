import axios, { type InternalAxiosRequestConfig } from 'axios'

// CSRF token 状态：登录前获取，登录后需重新获取
let csrfToken = ''
let csrfHeaderName = 'X-CSRF-TOKEN'

const http = axios.create({
  baseURL: '/api',
  timeout: 10000,
  withCredentials: true,
})

// 请求拦截器：写请求自动带上 CSRF 头
http.interceptors.request.use((config) => {
  const method = (config.method ?? 'get').toLowerCase()
  if (csrfToken && ['post', 'put', 'patch', 'delete'].includes(method)) {
    config.headers.set(csrfHeaderName, csrfToken)
  }
  return config
})

// 响应拦截器：解包 {code, message, data}，成功直接返回 data
http.interceptors.response.use(
  (response) => {
    const body = response.data as { code: string; data: unknown }
    return (body && body.code === 'OK' ? body.data : body) as never
  },
  async (error) => {
    const status = error.response?.status as number | undefined
    // 刷新页面恢复会话后，本地 CSRF token 为空或已过期 → 403。
    // 重新取 token 后原样重试一次（仅写请求会走到这）。
    const cfg = error.config as (InternalAxiosRequestConfig & { _csrfRetried?: boolean }) | undefined
    if (status === 403 && cfg && !cfg._csrfRetried && !String(cfg.url ?? '').includes('/auth/')) {
      cfg._csrfRetried = true
      try {
        await refreshCsrf()
        return http(cfg)
      } catch {
        // 重新取 token 失败则继续走下面的统一错误
      }
    }
    const body = error.response?.data as { code?: string; message?: string } | undefined
    return Promise.reject({
      status,
      code: body?.code,
      message: body?.message || error.message || '网络错误',
    })
  },
)

// 获取 CSRF token（登录前、登录后、退出前调用）
export async function refreshCsrf() {
  const data = (await http.get('/auth/csrf')) as { token: string; headerName?: string }
  csrfToken = data.token
  if (data.headerName) csrfHeaderName = data.headerName
  return data
}

// 后端分页 pageSize 上限 50；需要全量数据时按页翻取聚合
export async function getAllPages<T>(
  url: string,
  params: Record<string, string | number> = {},
): Promise<T[]> {
  const pageSize = 50
  let page = 1
  const result: T[] = []
  for (;;) {
    const res = (await http.get(url, {
      params: { ...params, page, pageSize },
    })) as { items?: T[] } | null
    const items = res?.items ?? []
    result.push(...items)
    if (items.length < pageSize) break
    page += 1
  }
  return result
}

export default http
