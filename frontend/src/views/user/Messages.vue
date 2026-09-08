<script setup lang="ts">
import { ref, computed, onMounted, onBeforeUnmount, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { listMessages, sendMessage } from '@/api/message'
import { listUsers } from '@/api/user'
import { useUserStore } from '@/stores/user'
import type { Message, User } from '@/types'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()
const messages = ref<Message[]>([])
const users = ref<User[]>([])
const activeUserId = ref<number | null>(null)
const draft = ref('')

// 新建会话弹窗
const newChatVisible = ref(false)

const activeUser = computed(() => users.value.find((u) => u.id === activeUserId.value))

const conversations = computed(() => {
  const map = new Map<number, Message[]>()
  for (const m of messages.value) {
    const other = m.from === userStore.currentUser?.id ? m.to : m.from
    if (!map.has(other)) map.set(other, [])
    map.get(other)!.push(m)
  }
  return Array.from(map.entries()).map(([id, msgs]) => ({
    user: users.value.find((u) => u.id === id),
    msgs,
    last: msgs[msgs.length - 1],
  }))
})

// 可发起新会话的用户（排除自己和已有会话的？不排除，保留全部非自己用户）
const newChatUsers = computed(() =>
  users.value.filter((u) => u.id !== userStore.currentUser?.id),
)

const activeMessages = computed(() => {
  if (activeUserId.value == null) return []
  return messages.value.filter(
    (m) =>
      (m.from === userStore.currentUser?.id && m.to === activeUserId.value) ||
      (m.from === activeUserId.value && m.to === userStore.currentUser?.id),
  )
})

async function load() {
  if (!userStore.currentUser) return
  messages.value = await listMessages(userStore.currentUser.id)
  users.value = await listUsers()
  // 支持 ?to= 参数，直接定位到某个用户会话
  const to = Number(route.query.to)
  if (to && users.value.some((u) => u.id === to)) {
    activeUserId.value = to
  }
}

async function send() {
  if (!userStore.currentUser || activeUserId.value == null) return
  if (!draft.value.trim()) return
  await sendMessage(userStore.currentUser.id, activeUserId.value, draft.value.trim())
  draft.value = ''
  await load()
}

// 发送图片
function onPickImage(e: Event) {
  const input = e.target as HTMLInputElement
  const file = input.files?.[0]
  if (!file) return
  const reader = new FileReader()
  reader.onload = async () => {
    if (!userStore.currentUser || activeUserId.value == null) return
    await sendMessage(userStore.currentUser.id, activeUserId.value, '图片', reader.result as string)
    await load()
  }
  reader.readAsDataURL(file)
  input.value = ''
}

function selectUser(id: number) {
  activeUserId.value = id
}

function goProfile(id: number) {
  router.push({ name: 'user-profile', params: { id } })
}

function startNewChat(u: User) {
  activeUserId.value = u.id
  newChatVisible.value = false
}

// 切换账号时重新加载（清空当前会话，避免看到上一个账号的视角）
watch(
  () => userStore.currentUser?.id,
  () => {
    activeUserId.value = null
    load()
  },
)

// 轮询刷新，模拟实时收消息
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
      <el-button type="primary" size="small" @click="newChatVisible = true">
        <el-icon style="margin-right: 4px"><Plus /></el-icon>新建会话
      </el-button>
    </div>
    <div class="chat-layout">
      <div class="conv-list">
        <div
          v-for="c in conversations"
          :key="c.user?.id"
          class="conv-item"
          :class="{ active: activeUserId === c.user?.id }"
          @click="selectUser(c.user!.id)"
        >
          <div class="avatar-wrap" @click.stop="goProfile(c.user!.id)">
            <el-avatar :size="40" :src="c.user?.avatar" />
            <span class="online-dot" :class="{ on: c.user?.online }" />
          </div>
          <div class="conv-info">
            <div class="conv-name">{{ c.user?.nickname }}</div>
            <div class="conv-last ellipsis">{{ c.last?.image ? '[图片]' : c.last?.content }}</div>
          </div>
        </div>
        <el-empty v-if="!conversations.length" description="暂无消息，点击右上角发起会话" />
      </div>

      <div class="chat-window">
        <template v-if="activeUser">
          <div class="chat-header" @click="goProfile(activeUser.id)">
            <div class="avatar-wrap">
              <el-avatar :size="28" :src="activeUser.avatar" />
              <span class="online-dot small" :class="{ on: activeUser.online }" />
            </div>
            <span class="chat-header-name">{{ activeUser.nickname }}</span>
          </div>
          <div class="chat-body">
            <div
              v-for="m in activeMessages"
              :key="m.id"
              class="bubble-row"
              :class="{ mine: m.from === userStore.currentUser?.id }"
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

    <!-- 新建会话弹窗 -->
    <el-dialog v-model="newChatVisible" title="发起新会话" width="420px">
      <div class="new-chat-list">
        <div
          v-for="u in newChatUsers"
          :key="u.id"
          class="new-chat-item"
          @click="startNewChat(u)"
        >
          <div class="avatar-wrap">
            <el-avatar :size="36" :src="u.avatar" />
            <span class="online-dot" :class="{ on: u.online }" />
          </div>
          <span class="new-chat-name">{{ u.nickname }}</span>
          <el-tag v-if="u.banned" type="danger" size="small">已封禁</el-tag>
        </div>
      </div>
    </el-dialog>
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
.avatar-wrap {
  position: relative;
  flex-shrink: 0;
}
.online-dot {
  position: absolute;
  right: -1px;
  bottom: -1px;
  width: 11px;
  height: 11px;
  border-radius: 50%;
  background: #ccc;
  border: 2px solid var(--card-bg);
}
.online-dot.on {
  background: #07c160;
}
.online-dot.small {
  width: 9px;
  height: 9px;
  right: -2px;
  bottom: -2px;
}
.new-chat-list {
  max-height: 360px;
  overflow-y: auto;
}
.new-chat-item {
  display: flex;
  align-items: center;
  gap: var(--space-3);
  padding: var(--space-2) var(--space-3);
  border-radius: var(--radius-sm);
  cursor: pointer;
  transition: background 0.2s;
}
.new-chat-item:hover {
  background: var(--page-bg);
}
.new-chat-name {
  flex: 1;
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
.chat-input {
  display: flex;
  gap: 8px;
  padding: 12px 20px;
  border-top: 1px solid var(--border-color);
  align-items: center;
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
</style>
