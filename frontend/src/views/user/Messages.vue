<script setup lang="ts">
import { ref, computed, onMounted, onBeforeUnmount, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { listMessages, sendMessage, markConversationRead } from '@/api/message'
import { uploadImage } from '@/api/media'
import { getUser } from '@/api/user'
import { useUserStore } from '@/stores/user'
import type { Message, User } from '@/types'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()
const messages = ref<Message[]>([])
const users = ref<User[]>([])
const activeUserId = ref<string | null>(null)
const draft = ref('')

const activeUser = computed(() => users.value.find((u) => u.userId === activeUserId.value))

const conversations = computed(() => {
  const map = new Map<string, Message[]>()
  for (const m of messages.value) {
    const other =
      m.sendUserId === userStore.currentUser?.userId ? m.receiveUserId : m.sendUserId
    if (!map.has(other)) map.set(other, [])
    map.get(other)!.push(m)
  }
  return Array.from(map.entries()).map(([id, msgs]) => ({
    user: users.value.find((u) => u.userId === id),
    msgs,
    last: msgs[msgs.length - 1],
  }))
})

const activeMessages = computed(() => {
  if (activeUserId.value == null) return []
  return messages.value.filter(
    (m) =>
      (m.sendUserId === userStore.currentUser?.userId && m.receiveUserId === activeUserId.value) ||
      (m.sendUserId === activeUserId.value && m.receiveUserId === userStore.currentUser?.userId),
  )
})

async function load() {
  if (!userStore.currentUser) return
  const uid = userStore.currentUser.userId
  messages.value = await listMessages(uid)
  const to = (route.query.to as string) || ''
  // 从消息里提取会话对象 ID，加上跳转目标，逐个拉公开资料
  const ids = new Set<string>()
  for (const m of messages.value) {
    if (m.sendUserId !== uid) ids.add(m.sendUserId)
    if (m.receiveUserId !== uid) ids.add(m.receiveUserId)
  }
  if (to) ids.add(to)
  const list: User[] = []
  for (const id of ids) {
    const u = await getUser(id)
    if (u) list.push(u)
  }
  users.value = list
  if (to) {
    activeUserId.value = to
    await markConversationRead(uid, to)
  }
}

async function send() {
  if (!userStore.currentUser || activeUserId.value == null) return
  if (!draft.value.trim()) return
  try {
    await sendMessage(userStore.currentUser.userId, activeUserId.value, draft.value.trim())
    draft.value = ''
    await load()
  } catch {
    ElMessage.error('发送失败，请稍后重试')
  }
}

function compressImage(file: File): Promise<string> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader()
    reader.onload = () => {
      const img = new Image()
      img.onload = () => {
        const maxSize = 800
        let { width, height } = img
        if (width > maxSize || height > maxSize) {
          const ratio = Math.min(maxSize / width, maxSize / height)
          width = Math.round(width * ratio)
          height = Math.round(height * ratio)
        }
        const canvas = document.createElement('canvas')
        canvas.width = width
        canvas.height = height
        const ctx = canvas.getContext('2d')
        if (!ctx) {
          resolve(reader.result as string)
          return
        }
        ctx.drawImage(img, 0, 0, width, height)
        resolve(canvas.toDataURL('image/jpeg', 0.75))
      }
      img.onerror = () => resolve(reader.result as string)
      img.src = reader.result as string
    }
    reader.onerror = reject
    reader.readAsDataURL(file)
  })
}

function onPickImage(e: Event) {
  const input = e.target as HTMLInputElement
  const file = input.files?.[0]
  if (!file) return
  const uid = userStore.currentUser?.userId
  const peerId = activeUserId.value
  if (!uid || peerId == null) return
  uploadImage(file).then(async (url) => {
    await sendMessage(uid, peerId, '', url)
    await load()
  }).catch(() => ElMessage.error('图片发送失败，请稍后重试'))
  input.value = ''
}

async function selectUser(id: string) {
  activeUserId.value = id
  if (userStore.currentUser) {
    await markConversationRead(userStore.currentUser.userId, id)
  }
}

function goProfile(id: string) {
  router.push({ name: 'user-profile', params: { id } })
}

watch(
  () => userStore.currentUser?.userId,
  () => {
    activeUserId.value = null
    load()
  },
)

let pollTimer: ReturnType<typeof setInterval> | null = null

onMounted(() => {
  load()
  pollTimer = setInterval(() => {
    if (userStore.isLoggedIn) load()
  }, 3000)
})

onBeforeUnmount(() => {
  if (pollTimer) clearInterval(pollTimer)
})
</script>

<template>
  <div class="messages page-container">
    <div class="msg-toolbar">
      <h2 class="page-title">消息</h2>
    </div>
    <div class="chat-layout">
      <div class="conv-list">
        <div
          v-for="c in conversations"
          :key="c.user?.userId"
          class="conv-item"
          :class="{ active: activeUserId === c.user?.userId }"
          @click="selectUser(c.user!.userId)"
        >
          <el-avatar :size="40" :src="c.user?.avatar" />
          <div class="conv-info">
            <div class="conv-name">{{ c.user?.userName }}</div>
            <div class="conv-last ellipsis">{{ c.last?.image ? '[图片]' : c.last?.content }}</div>
          </div>
        </div>
        <el-empty v-if="!conversations.length" description="暂无消息" />
      </div>

      <div class="chat-window">
        <template v-if="activeUser">
          <div class="chat-header" @click="goProfile(activeUser.userId)">
            <el-avatar :size="28" :src="activeUser.avatar" />
            <span class="chat-header-name">{{ activeUser.userName }}</span>
          </div>
          <div class="chat-body">
            <div
              v-for="m in activeMessages"
              :key="m.msgId"
              class="bubble-row"
              :class="{ mine: m.sendUserId === userStore.currentUser?.userId }"
            >
              <div class="bubble">
                <img v-if="m.image" :src="m.image" class="bubble-img" />
                <span v-else>{{ m.content }}</span>
              </div>
            </div>
          </div>
          <div class="chat-input">
            <label class="img-btn">
              <el-icon :size="20"><Picture /></el-icon>
              <input type="file" accept="image/*" hidden @change="onPickImage" />
            </label>
            <el-input v-model="draft" placeholder="输入消息…" @keyup.enter="send" />
            <el-button type="primary" @click="send">发送</el-button>
          </div>
        </template>
        <el-empty v-else description="选择左侧会话开始聊天" />
      </div>
    </div>

  </div>
</template>

<style scoped>
.messages {
  padding-top: 24px;
}
.msg-toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 20px;
}
.page-title {
  font-size: 20px;
  margin: 0;
}
.chat-layout {
  display: flex;
  height: 560px;
  background: var(--card-bg);
  border-radius: 8px;
  overflow: hidden;
}
.conv-list {
  width: 260px;
  border-right: 1px solid var(--border-color);
  overflow-y: auto;
}
.conv-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px 16px;
  cursor: pointer;
  border-bottom: 1px solid var(--border-color);
}
.conv-item:hover,
.conv-item.active {
  background: var(--page-bg);
}
.conv-info {
  flex: 1;
  min-width: 0;
}
.conv-name {
  font-weight: 600;
}
.conv-last {
  font-size: 12px;
  color: var(--text-sub);
}
.chat-window {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-width: 0;
}
.chat-header {
  padding: 10px 20px;
  font-weight: 600;
  border-bottom: 1px solid var(--border-color);
  display: flex;
  align-items: center;
  gap: var(--space-2);
  cursor: pointer;
}
.chat-header-name {
  font-size: var(--text-base);
}
.chat-body {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.bubble-row {
  display: flex;
}
.bubble-row.mine {
  justify-content: flex-end;
}
.bubble {
  max-width: 60%;
  padding: 10px 14px;
  border-radius: 8px;
  background: var(--page-bg);
  word-break: break-word;
}
.bubble-row.mine .bubble {
  background: var(--xianyu-yellow);
  color: #fff;
}
.bubble-img {
  max-width: 200px;
  max-height: 200px;
  border-radius: 6px;
  display: block;
}
.img-btn {
  cursor: pointer;
  color: var(--text-main);
  display: flex;
  align-items: center;
  transition: color 0.2s;
}
.img-btn:hover {
  color: var(--color-primary);
}
.chat-input {
  display: flex;
  gap: 8px;
  padding: 12px 20px;
  border-top: 1px solid var(--border-color);
  align-items: center;
}
</style>
