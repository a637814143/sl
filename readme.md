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

## 启动服务

进入 `demo` 目录后执行：

```bash
./mvnw spring-boot:run
```

应用会自动更新数据库结构，并在根目录生成最新的 `schema.sql` 文件。

