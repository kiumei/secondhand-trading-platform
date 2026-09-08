// 分类体系：4 个实物父类 + 1 个校园服务父类
// 每个实物父类下 2 个子类；校园服务下 2 个子类（技能服务、回收）

export interface CategoryGroup {
  id: number
  name: string
  icon: string
  color: string
  tint: string
  children: { id: number; name: string }[]
  service?: boolean
}

export const categoryGroups: CategoryGroup[] = [
  {
    id: 1,
    name: '学习考试',
    icon: 'Reading',
    color: '#ff8200',
    tint: '#fff3e6',
    children: [
      { id: 11, name: '教材文具' },
      { id: 12, name: '书籍资料' },
    ],
  },
  {
    id: 2,
    name: '数码装备',
    icon: 'Cellphone',
    color: '#409eff',
    tint: '#ecf5ff',
    children: [
      { id: 21, name: '手机电脑' },
      { id: 22, name: '数码配件' },
    ],
  },
  {
    id: 3,
    name: '宿舍生活',
    icon: 'House',
    color: '#07c160',
    tint: '#e8f9ef',
    children: [
      { id: 31, name: '宿舍用品' },
      { id: 32, name: '日常个护' },
    ],
  },
  {
    id: 4,
    name: '穿搭休闲',
    icon: 'ShoppingBag',
    color: '#a855f7',
    tint: '#f5e9ff',
    children: [
      { id: 41, name: '运动服饰' },
      { id: 42, name: '零食美妆' },
    ],
  },
  {
    id: 5,
    name: '校园服务',
    icon: 'Service',
    color: '#f59e0b',
    tint: '#fef3e2',
    service: true,
    children: [
      { id: 51, name: '技能服务' },
      { id: 52, name: '回收' },
    ],
  },
]

// 所有子分类（扁平，用于发布/搜索选子类）
export const subCategories = categoryGroups.flatMap((g) =>
  g.children.map((c) => ({ ...c, parentId: g.id, parentName: g.name })),
)

// 根据子类 id 找父类
export function getGroupBySubId(subId: number): CategoryGroup | undefined {
  return categoryGroups.find((g) => g.children.some((c) => c.id === subId))
}

// 父类 id -> 子类 id 列表
export function getSubIds(groupId: number): number[] {
  return categoryGroups.find((g) => g.id === groupId)?.children.map((c) => c.id) ?? []
}
