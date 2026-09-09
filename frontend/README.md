<!--
 * @Author       : Hidden Goose yanzhuangqiang@email.ncu.edu.cn
 * @Date         : 2026-09-05 15:58:14
 * @LastEditors  : Hidden Goose yanzhuangqiang@email.ncu.edu.cn
 * @LastEditTime : 2026-09-08 21:50:00
 * @FilePath     : /secondhand-trading-platform/frontend/README.md
 * @Description  : 如果你喜欢的话， 请你一定要保持好的心情继续喜欢下去😘🥰
-->

# **校园二手交易平台 · 前端**

南昌大学校园二手交易平台的前端部分，基于 Vue 3 + Vite + Pinia 构建。当前为纯前端 mock 阶段，数据层采用 localStorage 持久化 + 模拟延迟，接口签名、字段名与状态码均已按可无缝替换真实后端的方式设计对齐。

## ✨ 功能特性

### 🏠 首页

- 三栏布局：左侧分类导航 + 中间内容区 + 右侧悬浮 Dock 栏
- 主 Banner、4 组分类推荐卡片（含商品缩略图 + 价格）、精选好物
- 商品排序（综合 / 最新 / 价格从低到高 / 价格从高到低）
- 商品卡片：主图、标题、价格、卖家、发布时间

### 🗂️ 分类体系

- 两级分类：4 个实物父类 × 2 子类
  - 学习考试（教材文具 / 书籍资料）
  - 数码装备（手机电脑 / 数码配件）
  - 宿舍生活（宿舍用品 / 日常个护）
  - 穿搭休闲（运动服饰 / 零食美妆）

### 📦 发布商品

- 圆形主图预览 + 多图上传（最多 4 张）
- 商品名称字数计数、两级级联分类、成色等级、价格/原价、交易方式（邮寄/自提/两者）
- 富文本详情描述（wangEditor）

### 💬 私信与社交

- 会话列表 + 聊天窗口，发送文字和图片消息
- 用户个人主页：简介、统计（在售 / 评价 / 评分）、联系方式、收货地址、在售商品、收到的评价

### 🛒 交易

- 完整订单流：下单 → 模拟支付 → 发货 → 确认收货（另有取消态）
- 下单确认弹窗：显示商品 / 价格 / 收货人昵称 / 收货地址（可改）
- 订单列表显示交易对方昵称；订单详情含收货地址（下单快照）
- 待付款订单可修改地址、取消订单（取消后商品恢复可购买）
- 评价绑定已完成订单，同一订单仅可评价一次
- 收藏、举报

### 👤 用户与管理

- 手机号登录 / 注册（封禁用户禁止登录）
- 个人资料编辑（昵称 / 简介 / 收货地址）、修改密码
- 管理员后台：仪表盘、商品审核（编辑 / 通过 / 驳回 / 下架）、分类管理、用户管理（封禁 / 重置密码）、举报处理、评价管理、订单管理

### 🎛️ 外观

- 主题切换：浅色 / 深色 / 跟随系统

## 🧰 技术栈

**前端**

- **框架**: [Vue 3.5](https://vuejs.org/)
- **构建工具**: [Vite](https://vitejs.dev/)
- **状态管理**: [Pinia 4](https://pinia.vuejs.org/)
- **路由**: [Vue Router](https://router.vuejs.org/)
- **UI 组件库**: [Element Plus](https://element-plus.org/)
- **富文本编辑器**: [wangEditor 5](https://www.wangeditor.com/)
- **语言**: TypeScript

**后端**（规划）

- **框架**: Spring Boot
- **持久层**: MyBatis
- **数据库**: MySQL

## 🚀 快速开始

### 安装依赖

```bash
npm install
```

### 启动开发服务器

```bash
npm run dev
```

**注意**：启动服务器要求在 `./frontend` 目录下：

```bash
cd frontend
```

应用将在 <http://localhost:5173> 启动（默认 Vite 端口）。

### 构建生产版本

```bash
npm run build
```

## ⚡ 可用命令

| 命令                 | 说明                         |
| -------------------- | ---------------------------- |
| `npm run dev`        | 开发模式（热重载）           |
| `npm run build`      | 类型检查 + 构建生产版本      |
| `npm run build-only` | 仅构建（不做类型检查）       |
| `npm run type-check` | 类型检查                     |
| `npm run test:unit`  | 单元测试（Vitest）           |
| `npm run preview`    | 预览生产构建                 |

## 🧩 开发说明

### 数据层（Mock）

数据访问统一走 `src/api/`，内部用 localStorage 持久化 + `setTimeout` 模拟网络延迟。接口签名与真实后端一致，接后端时只需替换实现、不改调用方。

- 数据带版本号，seed 结构变化时旧数据自动重置
- 测试账号（手机号登录，密码均为 `123456`）：
  - 管理员：`13800000000`
  - 学生：`13811112222`（星遥）、`13933334444`（知予）、`13755556666`（景安）、`13677778888`（书珩）、`13566667777`（清禾）

### 路径别名

- `@/`：前端源码目录（映射到 `src/`）

### 分类与地点

- 分类常量见 `src/constants/categories.ts`
- 收货地址联想数据见 `src/constants/locations.ts`（南昌大学全校区建筑清单）

### 状态码（与后端 / 数据库对齐）

- 商品 `goodsStatus`：`0待审核 / 1上架 / 2下架 / 3已售出 / 4驳回`
- 订单 `orderStatus`：`0待付款 / 1待发货 / 2待收货 / 3完成 / 4取消 / 5售后`
- 用户 `status`：`0正常 / 1封禁`；角色 `role`：`0学生 / 1管理员`

## 🧱 项目结构

```text
src/
├── api/             # 数据访问层（mock 实现）
│   └── mock/        # mock 数据库
├── assets/          # 静态资源（含真实商品图）
├── components/      # 通用组件（商品卡片、网格、Dock 栏）
├── constants/       # 分类、地点常量
├── layouts/         # 前台布局、后台布局
├── router/          # 路由配置 + 导航守卫
├── stores/          # Pinia 状态管理
├── types/           # TypeScript 类型定义
├── views/           # 页面视图（home/goods/search/user/admin/error）
├── App.vue          # 根组件
└── main.ts          # 应用入口
```

## ✅ 环境要求

- Node.js: ^22.18.0 或 >=24.12.0
