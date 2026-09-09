// 分类配色方案（后端返回单级分类，前端按索引循环配色/图标）

const colors = ['#ff8200', '#409eff', '#07c160', '#a855f7', '#f56c6c', '#00bcd4']
const icons = ['Reading', 'Cellphone', 'House', 'Box', 'Basketball', 'ShoppingBag']
const tints = ['#fff3e6', '#ecf5ff', '#e8f9ef', '#f5e9ff', '#feeceb', '#e0f7fa']

export function categoryStyle(index: number) {
  const i = index % colors.length
  return { color: colors[i], icon: icons[i], tint: tints[i] }
}
