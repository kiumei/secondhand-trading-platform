# 数据库连接配置与联调启动指引（DBA提供）

> **发布人**：DBA / 测试员
> **发布时间**：2026-09-09
> **目的**：为后端提供连接真实 MySQL 数据库的最终配置参数，开启三端联调。

## 一、 数据库环境信息

| 配置项 | 值 |
| :--- | :--- |
| 数据库类型 | MySQL |
| 版本 | 8.0.44 |
| 数据库名 | secondhand |
| 主机地址 | localhost |
| 端口号 | 3306 |
| 字符集 | utf8mb4 |
| 排序规则 | utf8mb4_unicode_ci |
| 存储引擎 | InnoDB |
| 联调用户名 | root |
| **联调密码** | **（重要： DBA 在群聊中已发，严禁写在文档或代码中上传至 GitHub）** |

---

## 二、 后端配置参数（请直接复制到环境变量中）

请在配置环境变量时，**严格使用以下完整的连接字符串**：

```powershell
$env:DB_URL = 'jdbc:mysql://localhost:3306/secondhand?connectionTimeZone=Asia/Shanghai&useUnicode=true&characterEncoding=utf8'
$env:DB_USERNAME = 'root'
$env:DB_PASSWORD = 'DBA提供的密码'

---

## 三、 启动命令（必须使用 mysql 模式）

在 `backend` 目录下执行：

```powershell
mvn spring-boot:run "-Dspring-boot.run.profiles=mysql"