import { getDB, persist, nextId, delay } from './mock/db'
import type { Message } from '@/types'

export function listMessages(userId: string): Promise<Message[]> {
  const list = getDB().messages.filter(
    (m) => m.sendUserId === userId || m.receiveUserId === userId,
  )
  list.sort((a, b) => a.sendTime.localeCompare(b.sendTime))
  return delay(list)
}

export function sendMessage(
  sendUserId: string,
  receiveUserId: string,
  content: string,
  image?: string,
): Promise<Message> {
  const db = getDB()
  const msg: Message = {
    msgId: nextId('message'),
    sendUserId,
    receiveUserId,
    content,
    image,
    isRead: 0,
    sendTime: new Date().toLocaleString('zh-CN'),
  }
  db.messages.push(msg)
  persist()
  return delay(msg)
}

export function markConversationRead(userId: string, peerId: string): Promise<void> {
  const db = getDB()
  let changed = false
  for (const m of db.messages) {
    if (m.sendUserId === peerId && m.receiveUserId === userId && m.isRead === 0) {
      m.isRead = 1
      changed = true
    }
  }
  if (changed) persist()
  return delay(undefined)
}
