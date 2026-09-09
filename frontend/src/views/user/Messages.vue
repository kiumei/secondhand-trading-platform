<script setup lang="ts">
import { ref, computed, onMounted, onBeforeUnmount, watch, nextTick } from 'vue'
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
const chatBody = ref<HTMLElement | null>(null)

function isNearBottom(el: HTMLElement): boolean {
  return el.scrollHeight - el.scrollTop - el.clientHeight < 80
}
function scrollChatToBottom() {
  const el = chatBody.value
  if (el) el.scrollTop = el.scrollHeight
}

const activeUser = computed(() => users.value.find((u) => u.userId === activeUserId.value))

const conversations = computed(() => {
  const uid = userStore.currentUser?.userId
  const map = new Map<string, Message[]>()
  for (const m of messages.value) {
    const other = m.sendUserId === uid ? m.receiveUserId : m.sendUserId
    if (!map.has(other)) map.set(other, [])
    map.get(other)!.push(m)
  }
  // 后端按新→旧返回，msgs[0] 即该会话最新一条；按时间倒序让新会话置顶
  return Array.from(map.entries())
    .map(([id, msgs]) => ({
      id,
      user: users.value.find((u) => u.userId === id),
      msgs,
      last: msgs[0],
      unread: msgs.filter((m) => m.receiveUserId === uid && m.isRead === 0).length,
    }))
    .sort(
      (a, b) =>
        new Date(b.last?.sendTime ?? 0).getTime() - new Date(a.last?.sendTime ?? 0).getTime() ||
        Number(b.last?.msgId ?? 0) - Number(a.last?.msgId ?? 0),
    )
})

const activeMessages = computed(() => {
  if (activeUserId.value == null) return []
  // 时间正序展示：最老在上、最新在下；同秒时按 msgId 升序保证顺序确定，两端一致
  return messages.value
    .filter(
      (m) =>
        (m.sendUserId === userStore.currentUser?.userId && m.receiveUserId === activeUserId.value) ||
        (m.sendUserId === activeUserId.value && m.receiveUserId === userStore.currentUser?.userId),
    )
    .sort(
      (a, b) =>
        new Date(a.sendTime).getTime() - new Date(b.sendTime).getTime() ||
        Number(a.msgId) - Number(b.msgId),
    )
})

async function load() {
  if (!userStore.currentUser) return
  const uid = userStore.currentUser.userId
  const el = chatBody.value
  // 刷新前在底部（或还没渲染）→ 刷新后继续贴底；正在往上翻历史则不打扰
  const stick = el ? isNearBottom(el) : true
  messages.value = await listMessages(uid)
  // 提取会话对象 ID（含当前正在聊的人），逐个拉公开资料
  const ids = new Set<string>()
  for (const m of messages.value) {
    if (m.sendUserId !== uid) ids.add(m.sendUserId)
    if (m.receiveUserId !== uid) ids.add(m.receiveUserId)
  }
  if (activeUserId.value) ids.add(activeUserId.value)
  const list: User[] = []
  for (const id of ids) {
    const u = await getUser(id)
    if (u) list.push(u)
  }
  users.value = list
  await nextTick()
  if (stick) scrollChatToBottom()
}

// 打开/切换到某人的会话：设为当前人、标记已读、拉取消息与资料
async function openConversation(id: string) {
  if (!userStore.currentUser) return
  activeUserId.value = id
  await markConversationRead(userStore.currentUser.userId, id)
  await load()
  // 通知 DockBar 重新计算"消息"红点
  window.dispatchEvent(new Event('messages-read'))
}

const sending = ref(false)
async function send() {
  const uid = userStore.currentUser?.userId
  if (!uid || activeUserId.value == null) return
  if (activeUserId.value === uid) return // 不允许给自己发消息
  const text = draft.value.trim()
  if (!text || sending.value) return
  sending.value = true
  // 看门狗：万一本次发送/刷新卡住，最多 5 秒后释放发送锁，避免"点了没反应"
  const guard = setTimeout(() => {
    sending.value = false
  }, 5000)
  try {
    await sendMessage(uid, activeUserId.value, text)
    draft.value = ''
    await load()
  } catch (err) {
    const msg = (err as { message?: string })?.message || '发送失败，请稍后重试'
    ElMessage.error(`发送失败：${msg}`)
  } finally {
    clearTimeout(guard)
    sending.value = false
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
  if (!uid || peerId == null || peerId === uid) return
  uploadImage(file).then(async (url) => {
    await sendMessage(uid, peerId, '', url)
    await load()
  }).catch(() => ElMessage.error('图片发送失败，请稍后重试'))
  input.value = ''
}

async function selectUser(id: string) {
  await openConversation(id)
}

function goProfile(id: string) {
  router.push({ name: 'user-profile', params: { id } })
}

// 切换会话时滚到最新
watch(activeUserId, async () => {
  await nextTick()
  scrollChatToBottom()
})

watch(
  () => userStore.currentUser?.userId,
  (id) => {
    // 切换账号时先清空旧账号残留，避免把上一个账号的会话/聊天记录显示给无关的人
    activeUserId.value = null
    messages.value = []
    users.value = []
    if (id) load()
  },
)

// 在消息页内点"私信某人"（同路由 query.to 变化）时切换会话，避免停留在上一个会话
watch(
  () => route.query.to as string | undefined,
  (to) => {
    if (!to || !userStore.currentUser) return
    openConversation(to)
  },
)

let pollTimer: ReturnType<typeof setInterval> | null = null

onMounted(() => {
  // 从商品页"私信卖家"跳过来时直接打开该会话；否则先加载会话列表
  const to = route.query.to as string | undefined
  if (to) openConversation(to)
  else load()
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
          :key="c.id"
          class="conv-item"
          :class="{ active: activeUserId === c.id }"
          @click="selectUser(c.id)"
        >
          <el-avatar :size="40" :src="c.user?.avatar" />
          <div class="conv-info">
            <div class="conv-name">{{ c.user?.userName || '未知用户' }}</div>
            <div class="conv-last ellipsis">{{ c.last?.image ? '[图片]' : c.last?.content }}</div>
          </div>
          <span v-if="c.unread" class="conv-unread">{{ c.unread > 99 ? '99+' : c.unread }}</span>
        </div>
        <el-empty v-if="!conversations.length" description="暂无消息" />
      </div>

      <div class="chat-window">
        <template v-if="activeUser">
          <div class="chat-header" @click="goProfile(activeUser.userId)">
            <el-avatar :size="28" :src="activeUser.avatar" />
            <span class="chat-header-name">{{ activeUser.userName }}</span>
          </div>
          <div ref="chatBody" class="chat-body">
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
            <el-empty
              v-if="activeUser && !activeMessages.length"
              description="暂无聊天记录，发条消息开始吧"
              :image-size="60"
            />
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
.conv-unread {
  flex-shrink: 0;
  min-width: 18px;
  height: 18px;
  padding: 0 5px;
  border-radius: 9px;
  background: var(--color-danger);
  color: #fff;
  font-size: 12px;
  line-height: 18px;
  text-align: center;
  box-sizing: border-box;
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
