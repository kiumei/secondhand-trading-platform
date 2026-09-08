// 分类体系：4 个实物父类，每个父类下 2 个子类（两级分类，数据库 category 表含 parent_id）

export interface CategoryGroup {
  categoryId: number
  cateName: string
  icon: string
  color: string
  tint: string
  children: { categoryId: number; cateName: string }[]
}

export const categoryGroups: CategoryGroup[] = [
  {
    categoryId: 1,
    cateName: '学习考试',
    icon: 'Reading',
    color: '#ff8200',
    tint: '#fff3e6',
    children: [
      { categoryId: 11, cateName: '教材文具' },
      { categoryId: 12, cateName: '书籍资料' },
    ],
  },
  {
    categoryId: 2,
    cateName: '数码装备',
    icon: 'Cellphone',
    color: '#409eff',
    tint: '#ecf5ff',
    children: [
      { categoryId: 21, cateName: '手机电脑' },
      { categoryId: 22, cateName: '数码配件' },
    ],
  },
  {
    categoryId: 3,
    cateName: '宿舍生活',
    icon: 'House',
    color: '#07c160',
    tint: '#e8f9ef',
    children: [
      { categoryId: 31, cateName: '宿舍用品' },
      { categoryId: 32, cateName: '日常个护' },
    ],
  },
  {
    categoryId: 4,
    cateName: '穿搭休闲',
    icon: 'ShoppingBag',
    color: '#a855f7',
    tint: '#f5e9ff',
    children: [
      { categoryId: 41, cateName: '运动服饰' },
      { categoryId: 42, cateName: '零食美妆' },
    ],
  },
]

// 所有子分类（扁平，用于发布/搜索选子类）
export const subCategories = categoryGroups.flatMap((g) =>
  g.children.map((c) => ({ ...c, parentId: g.categoryId, parentName: g.cateName })),
)

// 根据子类 id 找父类
export function getGroupBySubId(subId: number): CategoryGroup | undefined {
  return categoryGroups.find((g) => g.children.some((c) => c.categoryId === subId))
}

// 父类 id -> 子类 id 列表
export function getSubIds(groupId: number): number[] {
  return categoryGroups.find((g) => g.categoryId === groupId)?.children.map((c) => c.categoryId) ?? []
}
