import http, { getAllPages } from './http'
import type { Message } from '@/types'

interface ApiMessage {
  msgId: string
  sendUserId: string
  receiveUserId: string
  content: string
  isRead: number
  sendTime: string
}

function isImageUrl(content: string): boolean {
  return content.startsWith('/api/media/') || content.startsWith('http')
}

function toMessage(api: ApiMessage): Message {
  const isImage = isImageUrl(api.content)
  return {
    msgId: api.msgId,
    sendUserId: api.sendUserId,
    receiveUserId: api.receiveUserId,
    content: isImage ? '' : api.content,
    image: isImage ? api.content : undefined,
    isRead: api.isRead as 0 | 1,
    sendTime: api.sendTime,
  }
}

export async function listMessages(userId: string): Promise<Message[]> {
  const items = await getAllPages<ApiMessage>('/users/me/messages')
  return items
    .filter((m) => m.sendUserId !== m.receiveUserId) // 过滤"发给自己"的系统通知
    .map(toMessage)
}

export async function sendMessage(
  sendUserId: string,
  receiveUserId: string,
  content: string,
  image?: string,
): Promise<Message> {
  const api = (await http.post('/messages', {
    receiveUserId,
    content: image ?? content,
  })) as ApiMessage
  return toMessage(api)
}

export async function markConversationRead(userId: string, peerId: string): Promise<void> {
  const data = (await http.get('/messages', { params: { peerId, page: 1, pageSize: 50 } })) as {
    items: ApiMessage[]
  }
  for (const m of data.items ?? []) {
    if (m.receiveUserId === userId && m.isRead === 0) {
      await http.patch(`/messages/${m.msgId}/read`)
    }
  }
}
