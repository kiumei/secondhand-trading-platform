// 校园地点数据：南昌大学前湖 / 青山湖 / 东湖校区
// 依据用户提供的南昌大学全校区建筑清单整理

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

// 生成「1 栋」~「4 栋」这类纯数字栋号序列
const seq = (from: number, to: number, suffix = '栋'): LocationOption[] =>
  Array.from({ length: to - from + 1 }, (_, i) => leaf(`${from + i}${suffix}`))

export const locationTree: LocationOption[] = [
  group('前湖校区北区', [
    group('宿舍区', [
      group('慧源社区', seq(1, 4)),
      group('修贤社区', seq(5, 18)),
      group('天健社区', seq(19, 27)),
      leaf('休闲区高层 14/15/18栋'),
      leaf('硕士宿舍楼'),
      leaf('博士宿舍楼'),
      leaf('33栋学生宿舍'),
      leaf('34栋学生宿舍'),
      leaf('焕奎医学创新综合楼宿舍'),
    ]),
    group('教学楼', [
      leaf('主教楼'),
      leaf('基础实验大楼'),
      leaf('慧源楼'),
      leaf('外经楼'),
      leaf('文法楼'),
      leaf('建工楼'),
      leaf('环材楼'),
      leaf('理生楼'),
      leaf('机电楼'),
      leaf('研究生楼'),
      leaf('智华楼'),
      leaf('信工楼'),
      leaf('艺术楼'),
      leaf('学工楼'),
      leaf('工程训练中心'),
    ]),
    group('图书馆 / 行政 / 公共设施', [
      leaf('图书馆'),
      leaf('行政楼'),
      leaf('校史馆'),
      leaf('红色文化馆'),
      leaf('生物博物馆'),
      leaf('前湖大厦'),
      leaf('校医院'),
      leaf('大学生活动中心大礼堂'),
      leaf('游泳馆'),
      leaf('室内体育馆'),
      leaf('白帆体育场'),
      leaf('主体育场'),
      leaf('正气广场'),
      leaf('兰苑'),
    ]),
    group('食堂', [
      leaf('一食堂'),
      leaf('二食堂'),
      leaf('一食堂三楼风味美食城'),
      leaf('民族食堂'),
      leaf('天健园九食堂'),
      leaf('修贤五栋0层食堂'),
    ]),
    group('校门', [
      leaf('一号门（学府大道正门）'),
      leaf('二号门（学府大道东门）'),
      leaf('三号门（前湖大道北门）'),
      leaf('五号门（嘉言路北门）'),
    ]),
  ]),
  group('前湖校区南区（医学部）', [
    group('宿舍区', [
      leaf('康健社区'),
      leaf('医学-8栋'),
      leaf('药学院学生公寓'),
      leaf('眼视光学院学生公寓'),
      leaf('公共卫生学院公寓'),
      leaf('护理学系学生公寓'),
      leaf('第四临床医学院学生公寓'),
      leaf('玛丽女王学院学生公寓'),
      leaf('留学生公寓'),
      leaf('南区学生宿舍8栋'),
      leaf('南区学生宿舍10栋'),
    ]),
    group('教学楼 / 学院', [
      leaf('医学部1号教学楼'),
      leaf('医学部2号教学楼'),
      leaf('第一临床医学院'),
      leaf('第二临床医学院'),
      leaf('第三临床医学院'),
      leaf('第四临床医学院'),
      leaf('人民临床医学院'),
      leaf('基础医学院'),
      leaf('护理学院'),
      leaf('药学院'),
      leaf('公共卫生学院'),
      leaf('第三实验楼'),
    ]),
    group('公共设施', [
      leaf('崇德广场'),
    ]),
  ]),
  group('青山湖校区', [
    group('宿舍区', [
      leaf('北区学生宿舍7栋'),
      leaf('北区学生宿舍8栋'),
      leaf('北区学生宿舍10栋'),
      leaf('南区学生宿舍45栋'),
      leaf('教工宿舍（南区36栋）'),
    ]),
    group('教学楼 / 实验楼', [
      leaf('软件楼'),
      leaf('实验教学楼（南区）'),
      leaf('综合楼'),
      leaf('机械楼'),
      leaf('食品科学与资源挖掘全国重点实验室'),
      leaf('汽车楼'),
      leaf('青山湖校区图书馆'),
    ]),
    group('公共设施', [
      leaf('青山湖校区体育馆'),
      leaf('网球场'),
      leaf('餐厅 / 食堂'),
      leaf('小篮球场'),
      leaf('青山湖校区幼儿园'),
    ]),
  ]),
  group('东湖校区', [
    group('宿舍区', [
      leaf('研究生宿舍2栋'),
      leaf('研究生宿舍3栋'),
      leaf('学生公寓2栋'),
      leaf('北院17栋'),
    ]),
    group('教学楼 / 实验楼', [
      leaf('德高医精楼'),
      leaf('教学大楼'),
      leaf('北院教学楼'),
      leaf('基础部大楼'),
      leaf('医学院实验大楼'),
      leaf('继续教育学院'),
      leaf('医学院图书馆'),
      leaf('门诊大楼'),
    ]),
    group('历史建筑 / 景观', [
      leaf('红楼'),
      leaf('月亮湖'),
      leaf('粤友桥'),
      leaf('医学院礼堂'),
      leaf('樟树群'),
    ]),
  ]),
  group('快递站点', [
    leaf('修贤2栋快递点'),
    leaf('天健24栋快递点'),
    leaf('天健26栋快递点'),
    leaf('天健27栋快递点'),
    leaf('南院学生公寓8栋快递点'),
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
