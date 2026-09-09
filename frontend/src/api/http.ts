import axios from 'axios'

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
  (error) => {
    const status = error.response?.status as number | undefined
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

export default http
