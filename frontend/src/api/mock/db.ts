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

// 真实商品图（src/assets 导入）
import imgGaoshu from '@/assets/高等数学.jpg'
import imgKaoyan from '@/assets/考研英语.jpg'
import imgXigai from '@/assets/习概.jpg'
import imgIphone from '@/assets/苹果手机.jpg'
import imgIphone11 from '@/assets/iphone11.jpg'
import imgAirpods from '@/assets/airprodpro3.jpg'
import imgPad from '@/assets/联想平板电脑.jpg'
import imgMouse from '@/assets/蝰蛇v3pro.jpg'
import imgBasketball from '@/assets/篮球.jpg'
import imgBadminton from '@/assets/二手羽毛球拍.jpg'
import imgShoes from '@/assets/运动跑鞋.jpg'

// 内存数据库，localStorage 持久化以便刷新后数据不丢
const STORAGE_KEY = 'xianyu-mock-db'
// 数据版本号：seed 结构变化时 +1，旧数据会自动重置
const DB_VERSION = 5

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
      online: true,
    },
    {
      id: 2,
      username: 'xingyao',
      password: '123456',
      nickname: '星遥',
      phone: '13811112222',
      address: '北校区 3 号宿舍楼 502',
      bio: '考研上岸，出一些教材和生活用品',
      role: 'student',
      avatar: placeholder(101),
      online: true,
    },
    {
      id: 3,
      username: 'zhiyu',
      password: '123456',
      nickname: '知予',
      phone: '13933334444',
      address: '南校区 1 号宿舍楼 201',
      bio: '医学院大二，喜欢淘好物',
      role: 'student',
      avatar: placeholder(102),
      online: false,
    },
    {
      id: 4,
      username: 'jingan',
      password: '123456',
      nickname: '景安',
      phone: '13755556666',
      address: '东校区教师公寓 3 栋',
      bio: '毕业清理，数码设备自用保养好',
      role: 'student',
      avatar: placeholder(103),
      online: true,
    },
    {
      id: 5,
      username: 'shuheng',
      password: '123456',
      nickname: '书珩',
      phone: '13677778888',
      address: '西校区 2 号宿舍楼 305',
      bio: '计算机大三，出各种数码配件',
      role: 'student',
      avatar: placeholder(104),
      online: false,
    },
    {
      id: 6,
      username: 'qinghe',
      password: '123456',
      nickname: '清禾',
      phone: '13566667777',
      address: '前湖校区南区 4 号宿舍楼 108',
      bio: '文学社成员，出闲置书籍',
      role: 'student',
      avatar: placeholder(105),
      online: true,
    },
  ]
}

function seedCategories(): Category[] {
  return [
    // 4 个实物父类 + 1 个校园服务父类（parentId = 0）
    { id: 1, name: '学习考试', parentId: 0 },
    { id: 2, name: '数码装备', parentId: 0 },
    { id: 3, name: '宿舍生活', parentId: 0 },
    { id: 4, name: '穿搭休闲', parentId: 0 },
    { id: 5, name: '校园服务', parentId: 0 },
    // 子类
    { id: 11, name: '教材文具', parentId: 1 },
    { id: 12, name: '书籍资料', parentId: 1 },
    { id: 21, name: '手机电脑', parentId: 2 },
    { id: 22, name: '数码配件', parentId: 2 },
    { id: 31, name: '宿舍用品', parentId: 3 },
    { id: 32, name: '日常个护', parentId: 3 },
    { id: 41, name: '运动服饰', parentId: 4 },
    { id: 42, name: '零食美妆', parentId: 4 },
    { id: 51, name: '技能服务', parentId: 5 },
    { id: 52, name: '回收', parentId: 5 },
  ]
}

function seedGoods(): Goods[] {
  const items: Array<[number, string, string, number, number, string, number]> = [
    [1, '高等数学（第七版）上下册', '考研上岸，教材全新，无笔记无划痕，两本一起出。', 35, 11, '教材文具', 2],
    [2, 'iPhone 12 128G 蓝色', '自用一年，无磕碰，电池健康 87%，配原装充电器。', 2800, 21, '手机电脑', 2],
    [3, '联想平板电脑', '吃灰了，几乎全新，看网课神器，带保护壳和笔。', 1500, 21, '手机电脑', 5],
    [4, '雷蛇蝰蛇 V3 Pro 鼠标', '手感很好，换新了所以出，箱说全。', 129, 22, '数码配件', 4],
    [5, '宿舍小冰箱 45L', '毕业出，制冷正常，噪音小，只支持校内自提。', 199, 31, '宿舍用品', 2],
    [6, '台灯 护眼 led', '可调亮度色温，考研学习必备，九成新。', 45, 31, '宿舍用品', 3],
    [7, '羽毛球拍', '正品，26 磅线，送手胶和球袋。', 260, 41, '运动服饰', 6],
    [8, '篮球 斯伯丁 7号', '室内用，成色新，手感好。', 88, 41, '运动服饰', 2],
    [9, '运动跑鞋 42 码', '穿过两次，尺码不合适，学生价出。', 79, 41, '运动服饰', 5],
    [10, '考研英语真题 全套', '张剑黄皮书，几乎全新，送答题卡。', 40, 12, '书籍资料', 6],
    [11, 'AirPods Pro 一代', '降噪正常，送新耳塞，配件齐全。', 620, 22, '数码配件', 2],
    [12, '习概（习近平新时代中国特色社会主义思想概论）', '考研政治必备用书，几乎全新。', 39, 12, '书籍资料', 3],
  ]
  const conditions: Goods['condition'][] = ['全新', '9成新', '8成新', '7成新', '6成新及以下']
  const locations = ['前湖校区北区·修贤社区·5栋', '前湖校区南区（医学部）·医学-8栋', '前湖校区北区·图书馆', '青山湖校区·北区学生宿舍7栋', '东湖校区·研究生宿舍2栋']
  const sellerNames: Record<number, string> = { 2: '星遥', 3: '知予', 4: '景安', 5: '书珩', 6: '清禾' }
  // 真实商品图映射（id -> 主图 + 附图）
  const realImages: Record<number, string[]> = {
    1: [imgGaoshu],
    2: [imgIphone, imgIphone11],
    3: [imgPad],
    4: [imgMouse],
    7: [imgBadminton],
    8: [imgBasketball],
    9: [imgShoes],
    10: [imgKaoyan],
    11: [imgAirpods],
    12: [imgXigai],
  }
  return items.map(
    ([id, title, desc, price, categoryId, _cat, sellerId], i) => ({
      id,
      title,
      desc,
      price,
      originalPrice: i % 3 === 0 ? Math.round(price * 1.4) : undefined,
      categoryId,
      images: realImages[id] ?? [placeholder(id + 200), placeholder(id + 300), placeholder(id + 400)],
      status: (['on', 'on', 'on', 'on', 'pending', 'sold', 'on', 'on', 'on', 'on', 'on', 'on'] as Goods['status'][])[i] ?? 'on',
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
  version: number
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
    version: DB_VERSION,
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
    seq: { goods: 13, order: 4, evaluate: 2, message: 5, report: 2, favorite: 3, bulletin: 3, user: 7 },
  }
}

let db: MockDB | null = null

function load(): MockDB {
  if (db) return db
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    if (raw) {
      const parsed = JSON.parse(raw) as MockDB & { version?: number }
      // 版本不匹配则丢弃旧数据，重新初始化
      if (parsed.version === DB_VERSION) {
        db = parsed
        return db
      }
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
