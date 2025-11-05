# 8am Lab 项目

## 本地 MySQL 配置

应用已经切换为使用本地 MySQL 数据库。默认连接信息如下：

```
URL:      jdbc:mysql://localhost:3306/eightam_lab
用户名:   root
密码:     password
```

可以通过环境变量覆盖这些默认值：

| 环境变量        | 说明                 | 默认值         |
|-----------------|----------------------|----------------|
| `DB_HOST`       | 数据库主机名         | `localhost`    |
| `DB_PORT`       | 数据库端口           | `3306`         |
| `DB_NAME`       | 数据库名             | `eightam_lab`  |
| `DB_USERNAME`   | 数据库用户名         | `root`         |
| `DB_PASSWORD`   | 数据库密码           | `password`     |

首次运行前请自行在 MySQL 中创建对应的数据库实例：

```sql
CREATE DATABASE eightam_lab CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

## SQL 模型文件

启动 Spring Boot 应用时会在项目根目录生成/更新 `schema.sql` 文件，内容为根据当前实体模型导出的建表语句，可直接在 MySQL 中执行以初始化结构。仓库中也提供了一个示例版本，便于快速查看结构。

## 启动后端服务

进入 `demo` 目录后执行：

```bash
./mvnw spring-boot:run
```

应用会自动更新数据库结构，并在根目录生成最新的 `schema.sql` 文件。

### 提供的核心接口

**公开接口**

| 功能         | Method & Path        | 说明                   |
|--------------|----------------------|------------------------|
| 查询饮品列表 | `GET /api/drinks`    | 返回全部上架饮品摘要信息 |

**管理接口**

| 功能         | Method & Path                 | 说明                         |
|--------------|-------------------------------|------------------------------|
| 查询饮品列表 | `GET /api/admin/drinks`       | 返回完整饮品信息用于后台管理 |
| 新增饮品     | `POST /api/admin/drinks`      | 创建饮品（需要名称/价格）     |
| 更新饮品     | `PUT /api/admin/drinks/{id}`  | 修改饮品信息                 |
| 删除饮品     | `DELETE /api/admin/drinks/{id}` | 移除饮品                    |
| 用户注册     | `POST /api/auth/register`     | 创建账号（含昵称）           |
| 用户登录     | `POST /api/auth/login`        | 校验用户名/密码              |

接口使用 JSON 传输，失败时会返回统一的错误结构，方便前端处理。

## 启动前端小程序风格页面

进入 `front` 目录后执行：

```bash
npm install
npm run dev
```

页面包含四个底部导航：

1. **首页**：展示今日灵感饮品卡片。
2. **点单**：完成饮品的新增、编辑、删除操作，并实时同步后端数据。
3. **灵感**：用于承载新品提案与互动的占位页，可继续拓展。
4. **主页**：提供注册、登录入口，完成账号管理。

所有操作都会调用后端接口，并持久化到本地 MySQL 数据库，实现前端 → 后端 → 数据库的完整闭环。
