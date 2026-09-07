import { getDB, persist, nextId, delay } from './mock/db'
import type { Message } from '@/types'

export function listMessages(userId: number): Promise<Message[]> {
  const list = getDB().messages.filter((m) => m.from === userId || m.to === userId)
  list.sort((a, b) => a.createdAt.localeCompare(b.createdAt))
  return delay(list)
}

export function sendMessage(from: number, to: number, content: string, image?: string): Promise<Message> {
  const db = getDB()
  const msg: Message = {
    id: nextId('message'),
    from,
    to,
    content,
    image,
    createdAt: new Date().toLocaleString('zh-CN'),
  }
  db.messages.push(msg)
  persist()
  return delay(msg)
}
