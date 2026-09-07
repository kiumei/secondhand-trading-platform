import type {
  User,
  Goods,
  Order,
  Evaluate,
  Message,
  Report,
  Favorite,
  Category,
  Bulletin,
  SiteConfig,
} from '@/types'

// 内存数据库，localStorage 持久化以便刷新后数据不丢
const STORAGE_KEY = 'xianyu-mock-db'

const placeholder = (seed: number) =>
  `https://picsum.photos/seed/goods${seed}/400/400`

function seedUsers(): User[] {
  return [
    {
      id: 1,
      username: 'admin',
      password: '123456',
      nickname: '平台管理员',
      phone: '13800000000',
      address: '校园服务中心',
      bio: '负责平台审核与运营',
      role: 'admin',
      avatar: placeholder(100),
    },
    {
      id: 2,
      username: 'xiaoming',
      password: '123456',
      nickname: '小明同学',
      phone: '13811112222',
      address: '北校区 3 号宿舍楼 502',
      bio: '考研上岸，出一些教材和生活用品',
      role: 'student',
      avatar: placeholder(101),
    },
    {
      id: 3,
      username: 'xiaohong',
      password: '123456',
      nickname: '小红',
      phone: '13933334444',
      address: '南校区 1 号宿舍楼 201',
      bio: '医学院大二，喜欢淘好物',
      role: 'student',
      avatar: placeholder(102),
    },
    {
      id: 4,
      username: 'laowang',
      password: '123456',
      nickname: '老王学长',
      phone: '13755556666',
      address: '东校区教师公寓 3 栋',
      bio: '毕业清理，数码设备自用保养好',
      role: 'student',
      avatar: placeholder(103),
    },
  ]
}

function seedCategories(): Category[] {
  return [
    { id: 1, name: '教材教辅' },
    { id: 2, name: '数码产品' },
    { id: 3, name: '生活用品' },
    { id: 4, name: '运动户外' },
    { id: 5, name: '服饰鞋包' },
    { id: 6, name: '其他' },
  ]
}

function seedGoods(): Goods[] {
  const items: Array<[number, string, string, number, number, string, number]> = [
    [1, '高等数学（第七版）上下册', '考研上岸，教材全新，无笔记无划痕，两本一起出。', 35, 1, '教材教辅', 2],
    [2, 'iPhone 12 128G 蓝色', '自用一年，无磕碰，电池健康 87%，配原装充电器。', 2800, 2, '数码产品', 2],
    [3, '小米平板 5 Pro', '吃灰了，几乎全新，看网课神器，带保护壳和笔。', 1500, 2, '数码产品', 3],
    [4, '罗技 G304 无线鼠标', '手感很好，换新了所以出，箱说全。', 129, 2, '数码产品', 4],
    [5, '宿舍小冰箱 45L', '毕业出，制冷正常，噪音小，只支持校内自提。', 199, 3, '生活用品', 2],
    [6, '台灯 护眼 led', '可调亮度色温，考研学习必备，九成新。', 45, 3, '生活用品', 3],
    [7, '尤尼克斯羽毛球拍', '正品，26 磅线，送手胶和球袋。', 260, 4, '运动户外', 4],
    [8, '篮球 斯伯丁 7号', '室内用，成色新，手感好。', 88, 4, '运动户外', 2],
    [9, '牛仔外套 M码', '穿过两次，尺码不合适，学生价出。', 79, 5, '服饰鞋包', 3],
    [10, '考研英语真题 全套', '张剑黄皮书，几乎全新，送答题卡。', 40, 1, '教材教辅', 4],
    [11, 'AirPods Pro 一代', '降噪正常，送新耳塞，配件齐全。', 620, 2, '数码产品', 2],
    [12, '电热水壶 1.8L', '宿舍可用，功率安全，九五新。', 39, 3, '生活用品', 3],
  ]
  const conditions: Goods['condition'][] = ['全新', '9成新', '8成新', '7成新', '6成新及以下']
  const locations = ['前湖校区北区·修贤2栋', '前湖校区南区·医学8栋', '前湖校区北区·图书馆', '青山湖校区·学生宿舍3栋', '东湖校区·学生公寓']
  const sellerNames: Record<number, string> = { 2: '小明同学', 3: '小红', 4: '老王学长' }
  return items.map(
    ([id, title, desc, price, categoryId, _cat, sellerId], i) => ({
      id,
      title,
      desc,
      price,
      originalPrice: i % 3 === 0 ? Math.round(price * 1.4) : undefined,
      categoryId,
      images: [placeholder(id + 200), placeholder(id + 300), placeholder(id + 400)],
      status: (['on', 'on', 'on', 'on', 'pending', 'sold', 'on', 'on', 'on', 'on', 'on', 'rejected'] as Goods['status'][])[i] ?? 'on',
      sellerId,
      type: 'sell' as const,
      condition: conditions[i % conditions.length],
      location: locations[i % locations.length],
      freeShipping: i % 2 === 0,
      sellerName: sellerNames[sellerId] ?? '匿名用户',
      wantCount: 5 + ((id * 13) % 60),
      createdAt: `2026-09-0${(i % 6) + 1} 1${i % 10}:00`,
      views: 20 + ((id * 37) % 300),
    }),
  )
}

function seedOrders(): Order[] {
  return [
    { id: 1, goodsId: 1, buyerId: 3, sellerId: 2, price: 35, status: 'done', logistics: '已签收', createdAt: '2026-09-02 10:00' },
    { id: 2, goodsId: 2, buyerId: 4, sellerId: 2, price: 2800, status: 'shipped', logistics: 'SF123456789 运输中', createdAt: '2026-09-05 14:20' },
    { id: 3, goodsId: 5, buyerId: 3, sellerId: 2, price: 199, status: 'paid', createdAt: '2026-09-06 09:15' },
  ]
}

function seedEvaluates(): Evaluate[] {
  return [
    { id: 1, orderId: 1, goodsId: 1, userId: 3, score: 5, content: '书很新，学长人很好，交易顺利！', createdAt: '2026-09-03 15:00' },
  ]
}

function seedMessages(): Message[] {
  return [
    { id: 1, from: 3, to: 2, content: '学长，高数教材还在吗？', createdAt: '2026-09-01 10:00' },
    { id: 2, from: 2, to: 3, content: '在的，全新无笔记。', createdAt: '2026-09-01 10:05' },
    { id: 3, from: 3, to: 2, content: '好的，可以便宜点吗？', createdAt: '2026-09-01 10:08' },
    { id: 4, from: 3, to: 2, content: '这是书的内页实拍', image: placeholder(500), createdAt: '2026-09-01 10:09' },
  ]
}

function seedReports(): Report[] {
  return [
    { id: 1, goodsId: 12, userId: 3, reason: '商品与描述不符', status: 'pending', createdAt: '2026-09-04 11:00' },
  ]
}

function seedFavorites(): Favorite[] {
  return [
    { id: 1, userId: 3, goodsId: 2, createdAt: '2026-09-05 12:00' },
    { id: 2, userId: 3, goodsId: 11, createdAt: '2026-09-06 08:00' },
  ]
}

function seedBulletins(): Bulletin[] {
  return [
    { id: 1, title: '平台上线公告', content: '校园二手交易平台正式上线，欢迎同学们发布闲置！', createdAt: '2026-09-01' },
    { id: 2, title: '交易安全提醒', content: '请同学们线下交易注意安全，建议在校内公共场所当面验货。', createdAt: '2026-09-03' },
  ]
}

const defaultSiteConfig: SiteConfig = {
  title: '校园二手集市',
  footer: '© 2026 校园二手交易平台',
  heroTitle: '让闲置流动起来',
  heroSubtitle: '买卖闲置，就在校园二手集市',
}

export interface MockDB {
  users: User[]
  goods: Goods[]
  orders: Order[]
  evaluates: Evaluate[]
  messages: Message[]
  reports: Report[]
  favorites: Favorite[]
  categories: Category[]
  bulletins: Bulletin[]
  siteConfig: SiteConfig
  seq: Record<string, number>
}

function createInitial(): MockDB {
  return {
    users: seedUsers(),
    goods: seedGoods(),
    orders: seedOrders(),
    evaluates: seedEvaluates(),
    messages: seedMessages(),
    reports: seedReports(),
    favorites: seedFavorites(),
    categories: seedCategories(),
    bulletins: seedBulletins(),
    siteConfig: defaultSiteConfig,
    seq: { goods: 13, order: 4, evaluate: 2, message: 4, report: 2, favorite: 3, bulletin: 3, user: 5 },
  }
}

let db: MockDB | null = null

function load(): MockDB {
  if (db) return db
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    if (raw) {
      db = JSON.parse(raw) as MockDB
      return db
    }
  } catch {
    // ignore corrupt storage
  }
  db = createInitial()
  persist()
  return db
}

export function persist() {
  if (db) localStorage.setItem(STORAGE_KEY, JSON.stringify(db))
}

export function getDB(): MockDB {
  return load()
}

export function nextId(key: keyof MockDB['seq']): number {
  const d = getDB()
  const id = d.seq[key] ?? 1
  d.seq[key] = id + 1
  return id
}

export function resetDB() {
  db = createInitial()
  persist()
}

// 模拟网络延迟
export function delay<T>(data: T, ms = 200): Promise<T> {
  return new Promise((resolve) => setTimeout(() => resolve(structuredClone(data)), ms))
}
