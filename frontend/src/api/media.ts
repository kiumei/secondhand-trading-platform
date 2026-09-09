import http from './http'

// 上传图片，返回后端图片地址（/api/media/{filename}）
export async function uploadImage(file: File): Promise<string> {
  const formData = new FormData()
  formData.append('file', file)
  const data = (await http.post('/uploads/images', formData, {
    headers: { 'Content-Type': 'multipart/form-data' },
  })) as { url: string; width: number; height: number }
  return data.url
}
