// 分类体系（mock 阶段暂用两级结构，接后端后改为后端返回的单级分类）

export interface CategoryGroup {
  cateId: string
  cateName: string
  icon: string
  color: string
  tint: string
  children: { cateId: string; cateName: string }[]
}

export const categoryGroups: CategoryGroup[] = [
  {
    cateId: '1',
    cateName: '学习考试',
    icon: 'Reading',
    color: '#ff8200',
    tint: '#fff3e6',
    children: [
      { cateId: '11', cateName: '教材文具' },
      { cateId: '12', cateName: '书籍资料' },
    ],
  },
  {
    cateId: '2',
    cateName: '数码装备',
    icon: 'Cellphone',
    color: '#409eff',
    tint: '#ecf5ff',
    children: [
      { cateId: '21', cateName: '手机电脑' },
      { cateId: '22', cateName: '数码配件' },
    ],
  },
  {
    cateId: '3',
    cateName: '宿舍生活',
    icon: 'House',
    color: '#07c160',
    tint: '#e8f9ef',
    children: [
      { cateId: '31', cateName: '宿舍用品' },
      { cateId: '32', cateName: '日常个护' },
    ],
  },
  {
    cateId: '4',
    cateName: '穿搭休闲',
    icon: 'ShoppingBag',
    color: '#a855f7',
    tint: '#f5e9ff',
    children: [
      { cateId: '41', cateName: '运动服饰' },
      { cateId: '42', cateName: '零食美妆' },
    ],
  },
]

// 所有子分类（扁平，用于发布/搜索选子类）
export const subCategories = categoryGroups.flatMap((g) =>
  g.children.map((c) => ({ ...c, parentId: g.cateId, parentName: g.cateName })),
)

// 根据子类 id 找父类
export function getGroupBySubId(subId: string): CategoryGroup | undefined {
  return categoryGroups.find((g) => g.children.some((c) => c.cateId === subId))
}

// 父类 id -> 子类 id 列表
export function getSubIds(groupId: string): string[] {
  return categoryGroups.find((g) => g.cateId === groupId)?.children.map((c) => c.cateId) ?? []
}
