import type {
  User,
  Goods,
  Order,
  Evaluate,
  Message,
  Report,
  Favorite,
  Category,
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
import imgXiaobingxiang from '@/assets/小冰箱.jpg'
import imgTaideng from '@/assets/台灯.jpg'
import imgShuayafen from '@/assets/刷牙粉.jpg'
import imgFufu from '@/assets/玩偶fufu.jpg'

// 内存数据库，localStorage 持久化以便刷新后数据不丢
const STORAGE_KEY = 'xianyu-mock-db'
// 数据版本号：seed 结构变化时 +1，旧数据会自动重置
const DB_VERSION = 8

const placeholder = (_seed: number) =>
  'data:image/svg+xml;charset=utf-8,' +
  encodeURIComponent(
    '<svg xmlns="http://www.w3.org/2000/svg" width="400" height="400"><rect width="400" height="400" fill="#e8e8e8"/></svg>',
  )

function seedUsers(): User[] {
  return [
    {
      userId: '1',
      userName: '平台管理员',
      phone: '13800000000',
      password: '123456',
      avatar: placeholder(100),
      intro: '负责平台审核与运营',
      address: '校园服务中心',
      role: 1,
      status: 0,
      registerTime: '2026-08-01 10:00:00',
    },
    {
      userId: '2',
      userName: '星遥',
      phone: '13811112222',
      password: '123456',
      avatar: placeholder(101),
      intro: '考研上岸，出一些教材和生活用品',
      address: '前湖校区北区·修贤社区·5栋',
      role: 0,
      status: 0,
      registerTime: '2026-08-02 10:00:00',
    },
    {
      userId: '3',
      userName: '知予',
      phone: '13933334444',
      password: '123456',
      avatar: placeholder(102),
      intro: '医学院大二，喜欢淘好物',
      address: '前湖校区南区（医学部）·医学-8栋',
      role: 0,
      status: 0,
      registerTime: '2026-08-03 10:00:00',
    },
    {
      userId: '4',
      userName: '景安',
      phone: '13755556666',
      password: '123456',
      avatar: placeholder(103),
      intro: '毕业清理，数码设备自用保养好',
      address: '青山湖校区·北区学生宿舍7栋',
      role: 0,
      status: 0,
      registerTime: '2026-08-04 10:00:00',
    },
    {
      userId: '5',
      userName: '书珩',
      phone: '13677778888',
      password: '123456',
      avatar: placeholder(104),
      intro: '计算机大三，出各种数码配件',
      address: '前湖校区北区·图书馆',
      role: 0,
      status: 0,
      registerTime: '2026-08-05 10:00:00',
    },
    {
      userId: '6',
      userName: '清禾',
      phone: '13566667777',
      password: '123456',
      avatar: placeholder(105),
      intro: '文学社成员，出闲置书籍',
      address: '东湖校区·研究生宿舍2栋',
      role: 0,
      status: 0,
      registerTime: '2026-08-06 10:00:00',
    },
  ]
}

function seedCategories(): Category[] {
  return [
    { cateId: '1', cateName: '学习考试', parentId: 0, sort: 1 },
    { cateId: '2', cateName: '数码装备', parentId: 0, sort: 2 },
    { cateId: '3', cateName: '宿舍生活', parentId: 0, sort: 3 },
    { cateId: '4', cateName: '穿搭休闲', parentId: 0, sort: 4 },
    { cateId: '11', cateName: '教材文具', parentId: 1, sort: 1 },
    { cateId: '12', cateName: '书籍资料', parentId: 1, sort: 2 },
    { cateId: '21', cateName: '手机电脑', parentId: 2, sort: 1 },
    { cateId: '22', cateName: '数码配件', parentId: 2, sort: 2 },
    { cateId: '31', cateName: '宿舍用品', parentId: 3, sort: 1 },
    { cateId: '32', cateName: '日常个护', parentId: 3, sort: 2 },
    { cateId: '41', cateName: '运动服饰', parentId: 4, sort: 1 },
    { cateId: '42', cateName: '零食美妆', parentId: 4, sort: 2 },
  ]
}

// items: [goodsId, title, desc, sellPrice, cateId, cateName, sellerId, qualityLevel, tradeType, goodsStatus]
function seedGoods(): Goods[] {
  const items: Array<[string, string, string, number, string, string, string, number, number, number]> = [
    ['1', '高等数学（第七版）上下册', '考研上岸，教材全新，无笔记无划痕，两本一起出。', 35, '11', '教材文具', '2', 1, 2, 1],
    ['2', 'iPhone 12 128G 蓝色', '自用一年，无磕碰，电池健康 87%，配原装充电器。', 2800, '21', '手机电脑', '2', 2, 2, 1],
    ['3', '联想平板电脑', '吃灰了，几乎全新，看网课神器，带保护壳和笔。', 1500, '21', '手机电脑', '5', 2, 2, 1],
    ['4', '雷蛇蝰蛇 V3 Pro 鼠标', '手感很好，换新了所以出，箱说全。', 129, '22', '数码配件', '4', 3, 2, 1],
    ['5', '宿舍小冰箱 45L', '毕业出，制冷正常，噪音小，只支持校内自提。', 199, '31', '宿舍用品', '2', 2, 2, 0],
    ['6', '台灯 护眼 led', '可调亮度色温，考研学习必备，九成新。', 45, '31', '宿舍用品', '3', 3, 2, 3],
    ['7', '羽毛球拍', '正品，26 磅线，送手胶和球袋。', 260, '41', '运动服饰', '6', 4, 2, 1],
    ['8', '篮球 斯伯丁 7号', '室内用，成色新，手感好。', 88, '41', '运动服饰', '2', 1, 2, 1],
    ['9', '运动跑鞋 42 码', '穿过两次，尺码不合适，学生价出。', 79, '41', '运动服饰', '5', 5, 2, 1],
    ['10', '考研英语真题 全套', '张剑黄皮书，几乎全新，送答题卡。', 40, '12', '书籍资料', '6', 4, 2, 1],
    ['11', 'AirPods Pro 一代', '降噪正常，送新耳塞，配件齐全。', 620, '22', '数码配件', '2', 2, 2, 1],
    ['12', '习概（习近平新时代中国特色社会主义思想概论）', '考研政治必备用书，几乎全新。', 39, '12', '书籍资料', '3', 3, 2, 1],
    ['13', '刷牙粉', '全新未拆封，宿舍日常口腔护理用品。', 20, '32', '日常个护', '2', 1, 2, 1],
    ['14', '玩偶 fufu', '九成新，无污渍，宿舍桌面摆件。', 50, '31', '宿舍用品', '3', 2, 2, 1],
  ]
  const sellerNames: Record<string, string> = { '2': '星遥', '3': '知予', '4': '景安', '5': '书珩', '6': '清禾' }
  const realImages: Record<string, string[]> = {
    '1': [imgGaoshu],
    '2': [imgIphone, imgIphone11],
    '3': [imgPad],
    '4': [imgMouse],
    '5': [imgXiaobingxiang],
    '6': [imgTaideng],
    '7': [imgBadminton],
    '8': [imgBasketball],
    '9': [imgShoes],
    '10': [imgKaoyan],
    '11': [imgAirpods],
    '12': [imgXigai],
    '13': [imgShuayafen],
    '14': [imgFufu],
  }
  return items.map(
    ([goodsId, title, goodsDesc, sellPrice, cateId, cateName, sellerId, qualityLevel, tradeType, goodsStatus], i) => ({
      goodsId,
      publishUserId: sellerId,
      cateId,
      title,
      sellPrice,
      originalPrice: i % 3 === 0 ? Math.round(sellPrice * 1.4) : undefined,
      tradeType: tradeType as 1 | 2 | 3,
      goodsDesc,
      qualityLevel: qualityLevel as 1 | 2 | 3 | 4 | 5,
      rejectReason: goodsStatus === 4 ? '商品信息不完整，请补充描述后重新提交' : undefined,
      publishTime: `2026-09-0${(i % 6) + 1} 1${i % 10}:00`,
      goodsStatus: goodsStatus as 0 | 1 | 2 | 3 | 4,
      sellerName: sellerNames[sellerId] ?? '匿名用户',
      cateName,
      coverUrl: realImages[goodsId]?.[0],
      purchasable: goodsStatus === 1,
      images: realImages[goodsId] ?? [placeholder(200 + i)],
      views: 20 + ((i + 1) * 37) % 300,
    }),
  )
}

function seedOrders(): Order[] {
  return [
    { orderId: '1', goodsId: '1', buyerId: '3', sellerId: '2', orderPrice: 35, payStatus: 1, orderStatus: 3, payTime: '2026-09-02 10:05', finishTime: '2026-09-03 12:00', createTime: '2026-09-02 10:00', shippingAddress: '前湖校区南区（医学部）·医学-8栋' },
    { orderId: '2', goodsId: '2', buyerId: '4', sellerId: '2', orderPrice: 2800, payStatus: 1, orderStatus: 2, payTime: '2026-09-05 14:25', finishTime: undefined, createTime: '2026-09-05 14:20', shippingAddress: '青山湖校区·北区学生宿舍7栋' },
    { orderId: '3', goodsId: '5', buyerId: '3', sellerId: '2', orderPrice: 199, payStatus: 0, orderStatus: 0, payTime: undefined, finishTime: undefined, createTime: '2026-09-06 09:15', shippingAddress: '前湖校区南区（医学部）·医学-8栋' },
  ]
}

function seedEvaluates(): Evaluate[] {
  return [
    { evaluateId: '1', orderId: '1', goodsId: '1', evaluateUserId: '3', score: 5, evaluateContent: '书很新，学长人很好，交易顺利！', evaluateTime: '2026-09-03 15:00' },
  ]
}

function seedMessages(): Message[] {
  return [
    { msgId: '1', sendUserId: '3', receiveUserId: '2', content: '学长，高数教材还在吗？', isRead: 1, sendTime: '2026-09-01 10:00' },
    { msgId: '2', sendUserId: '2', receiveUserId: '3', content: '在的，全新无笔记。', isRead: 1, sendTime: '2026-09-01 10:05' },
    { msgId: '3', sendUserId: '3', receiveUserId: '2', content: '好的，可以便宜点吗？', isRead: 1, sendTime: '2026-09-01 10:08' },
    { msgId: '4', sendUserId: '3', receiveUserId: '2', content: '', image: placeholder(500), isRead: 1, sendTime: '2026-09-01 10:09' },
  ]
}

function seedReports(): Report[] {
  return [
    { reportId: '1', reportUserId: '3', goodsId: '12', reportType: 1, reportContent: '收到的商品与页面描述严重不符', handleStatus: 0 },
  ]
}

function seedFavorites(): Favorite[] {
  return [
    { favoriteId: '1', userId: '3', goodsId: '2', createTime: '2026-09-05 12:00' },
    { favoriteId: '2', userId: '3', goodsId: '11', createTime: '2026-09-06 08:00' },
  ]
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
    seq: { goods: 15, order: 4, evaluate: 2, message: 5, report: 2, favorite: 3, user: 7 },
  }
}

let db: MockDB | null = null

function load(): MockDB {
  if (db) return db
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    if (raw) {
      const parsed = JSON.parse(raw) as MockDB & { version?: number }
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
  if (!db) return
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(db))
  } catch (e) {
    console.warn('本地存储写入失败（可能超出配额）：', e)
  }
}

export function getDB(): MockDB {
  return load()
}

export function nextId(key: keyof MockDB['seq']): string {
  const d = getDB()
  const id = d.seq[key] ?? 1
  d.seq[key] = id + 1
  return String(id)
}

export function resetDB() {
  db = createInitial()
  persist()
}

// 模拟网络延迟
export function delay<T>(data: T, ms = 200): Promise<T> {
  return new Promise((resolve) => setTimeout(() => resolve(structuredClone(data)), ms))
}
