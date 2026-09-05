<!--
 * @Author       : Hidden Goose yanzhuangqiang@email.ncu.edu.cn
 * @Date         : 2026-09-05 15:58:14
 * @LastEditors  : Hidden Goose yanzhuangqiang@email.ncu.edu.cn
 * @LastEditTime : 2026-09-05 16:42:17
 * @FilePath     : /secondhand-trading-platform/frontend/README.md
 * @Description  : 如果你喜欢的话， 请你一定要保持好的心情继续喜欢下去😘🥰
-->

# **校园二手交易平台 · 前端**

校园二手交易平台的前端部分，基于 Vue 3 + Vite + Pinia 构建，通过 REST API 与后端（Spring Boot + MyBatis + MySQL）交互。

## ✨ 功能特性

### 🎨 前台体验

- [x] 我的：个人主页，昵称、电话、收货地址
- [x] Header 搜索：关键词推荐，词根联想
- [x] 收藏：按照收录顺序排序
- [x] 消息：卖家或买家的消息收录
- [x] 发布：发布自己想要售卖的物品或者想要购入的物品

### 🧩 管理与内容

- [x] 登录 / 找回密码
- [x] 仪表盘、系统设置
- [x] 封面图 / 行内图上传

### 🎛️ 外观与本地化

- [x] 主题模式：浅色 / 深色 / 跟随系统
- [x] 语言切换：zh-CN / en-US

### ⚙️ 初始化向导

- [x] 外观设置：主题模式 / 色相 / 语言
- [x] 站点信息：标题 / 页脚（由于时间问题，无法做到备案）
- [x] 管理员账号初始化
- [x] 个人信息与首页 Hero 配置
- [x] SMTP 配置与测试

## 🧰 技术栈

**前端**

- **框架**: [Vue 3.5](https://vuejs.org/)
- **构建工具**: [Vite](https://vitejs.dev/)
- **状态管理**: [Pinia 4](https://pinia.vuejs.org/)
- **路由**: [Vue Router](https://router.vuejs.org/)
- **语言**: TypeScript

**后端**

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

应用将在 <http://localhost:5173> 启动（默认 Vite 端口）。

开发环境下，所有 `/api` 请求会自动代理到后端服务器（后端地址请按实际部署修改，见下方「开发代理」）。

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

### 路径别名

- `@/`：前端源码目录（映射到 `src/`）

### 开发代理

开发环境下，Vite 会将 `/api` 前缀的请求代理到后端服务器，避免跨域问题。后端地址在 `vite.config.ts` 中配置（当前为占位，请按后端实际地址修改）。

## 🧱 项目结构

```text
src/
├── assets/          # 静态资源
├── components/      # Vue 组件
├── router/          # 路由配置
├── stores/          # Pinia 状态管理
├── views/           # 页面视图
├── App.vue          # 根组件
└── main.ts          # 应用入口
```

## ✅ 环境要求

- Node.js: ^22.18.0 或 >=24.12.0
