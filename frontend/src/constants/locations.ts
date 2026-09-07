// 校园地点数据：南昌大学前湖/青山湖/东湖校区

export interface LocationOption {
  value: string
  label: string
  children?: LocationOption[]
}

const leaf = (label: string): LocationOption => ({ value: label, label })

const group = (label: string, children: LocationOption[]): LocationOption => ({
  value: label,
  label,
  children,
})

// 生成「修贤 1 栋」~「修贤 18 栋」这类序列
const seq = (prefix: string, from: number, to: number, suffix = '栋'): LocationOption[] =>
  Array.from({ length: to - from + 1 }, (_, i) => leaf(`${prefix}${from + i}${suffix}`))

export const locationTree: LocationOption[] = [
  group('前湖校区北区', [
    group('宿舍区', [
      ...seq('修贤', 1, 18),
      ...seq('天健', 19, 30),
    ]),
    group('教学楼 / 公共建筑', [
      leaf('学府大道正校门'),
      leaf('图书馆'),
      leaf('慧源楼'),
      leaf('人文楼'),
      leaf('法学楼'),
      leaf('外经楼'),
      leaf('艺术楼'),
      leaf('信工楼'),
      leaf('机电楼'),
      leaf('建工楼'),
      leaf('环材楼'),
      leaf('理生楼'),
      leaf('实验大楼'),
      leaf('研究生院楼'),
      leaf('学工楼'),
      leaf('前湖大厦'),
      leaf('体育馆'),
      leaf('白帆运动场'),
      leaf('游泳馆'),
      leaf('正气广场'),
      leaf('树人广场'),
      leaf('贝莲喷泉'),
    ]),
  ]),
  group('前湖校区南区', [
    group('宿舍区', [
      leaf('康健社区'),
      ...seq('医学', 1, 11),
      ...seq('人才公寓', 1, 5),
    ]),
    group('教学楼', [
      leaf('基础医学院大楼'),
      leaf('临床教学楼'),
      leaf('第一教学大楼'),
      leaf('第二教学大楼'),
      leaf('第一实验大楼'),
      leaf('第二实验大楼'),
      leaf('第三实验大楼'),
      leaf('第四实验大楼'),
      leaf('第五实验大楼'),
      leaf('第六实验大楼'),
      leaf('康健运动场'),
      leaf('白求恩广场'),
    ]),
  ]),
  group('青山湖校区', [
    leaf('青山湖校区北区'),
    leaf('青山湖校区南区'),
    ...seq('学生宿舍', 1, 9),
    leaf('逸夫馆'),
  ]),
  group('东湖校区', [
    leaf('东湖校区'),
    leaf('江西医学院'),
    leaf('学生公寓'),
    leaf('老教学楼'),
    leaf('军体楼'),
  ]),
  group('快递站点', [
    leaf('修贤2栋快递点'),
    leaf('天健27栋快递点'),
    leaf('天健24栋驿站'),
    leaf('天健26栋驿站'),
    leaf('医学院8栋快递点'),
  ]),
]

// 扁平化所有地点（用于搜索联想）
export function flattenLocations(): string[] {
  const result: string[] = []
  const walk = (nodes: LocationOption[], prefix: string) => {
    for (const n of nodes) {
      const full = prefix ? `${prefix}·${n.label}` : n.label
      if (n.children?.length) walk(n.children, full)
      else result.push(full)
    }
  }
  walk(locationTree, '')
  return result
}

// 校园高频搜索热词
export const hotKeywords = [
  '考研',
  '教材',
  '自行车',
  '电动车',
  '台灯',
  '床上桌',
  '吉他',
  '篮球',
  '数码',
  '毕业出',
]
