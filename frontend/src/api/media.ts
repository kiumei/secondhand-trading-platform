import http from './http'

// 上传图片，返回后端图片地址（/api/media/{filename}）
export async function uploadImage(file: File): Promise<string> {
  const formData = new FormData()
  formData.append('file', file)
  // 不要手动设置 Content-Type：浏览器会为 FormData 自动带上带 boundary 的 multipart 头，
  // 手动写成 multipart/form-data 反而会丢掉 boundary，导致后端解析失败。
  const data = (await http.post('/uploads/images', formData)) as {
    url: string
    width: number
    height: number
  }
  return data.url
}
