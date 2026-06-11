# 0601Sys 医院管理系统

这是一个基于 Spring MVC、Spring、MyBatis 和 JSP 的传统 SSM Web 项目，使用 Maven 打包为 WAR 后部署到 Tomcat 运行。

## 如何下载项目

如果项目在 Git 仓库中，使用下面的命令下载：

```bash
git clone <项目仓库地址>
cd 0601SSM
```

如果拿到的是压缩包，直接解压到本地目录即可，例如：

```text
C:\Users\15982\Desktop\0601SSM
```

## 需要安装什么环境

建议安装以下环境：

- JDK 8
- Maven 3.6 或以上
- MySQL 8.x
- Tomcat 9.x
- IntelliJ IDEA 或 Eclipse

检查命令：

```bash
java -version
mvn -version
mysql --version
```

注意：项目使用的是 `javax.servlet`，适合部署到 Tomcat 9。不要直接部署到 Tomcat 10，因为 Tomcat 10 使用 `jakarta.servlet`，可能导致启动失败。

## 如何配置数据库

数据库连接配置文件在：

```text
src/main/resources/jdbc.properties
```

默认配置如下：

```properties
jdbc.driver=com.mysql.cj.jdbc.Driver
jdbc.url=jdbc:mysql://localhost:3306/hospital_sys?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai
jdbc.username=root
jdbc.password=123456
```

如果你的 MySQL 用户名、密码或端口不同，需要修改：

```properties
jdbc.url=jdbc:mysql://localhost:3306/hospital_sys?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai
jdbc.username=你的用户名
jdbc.password=你的密码
```

数据库名默认为：

```text
hospital_sys
```

## 如何执行 init.sql

初始化脚本位置：

```text
src/main/resources/sql/init.sql
```

方式一：使用命令行执行。

```bash
mysql -u root -p < src/main/resources/sql/init.sql
```

输入 MySQL 密码后，脚本会自动创建 `hospital_sys` 数据库和项目所需数据表。

方式二：使用数据库工具执行。

1. 打开 Navicat、DataGrip、DBeaver 或 MySQL Workbench。
2. 连接本机 MySQL。
3. 打开 `src/main/resources/sql/init.sql`。
4. 执行整个 SQL 文件。

执行成功后，可以检查数据库：

```sql
SHOW DATABASES;
USE hospital_sys;
SHOW TABLES;
SELECT username, role FROM users;
```

## 如何打包

在项目根目录执行：

```bash
mvn clean package
```

打包成功后会生成：

```text
target/0601Sys.war
```

如果只想编译检查，可以执行：

```bash
mvn clean compile
```

## 如何部署到 Tomcat

1. 先执行打包命令：

```bash
mvn clean package
```

2. 将生成的 WAR 文件复制到 Tomcat 的 `webapps` 目录：

```text
target/0601Sys.war
```

复制到：

```text
<Tomcat目录>/webapps/0601Sys.war
```

3. 启动 Tomcat。

Windows：

```bat
<Tomcat目录>\bin\startup.bat
```

Linux 或 macOS：

```bash
<Tomcat目录>/bin/startup.sh
```

4. 浏览器访问：

```text
http://localhost:8080/0601Sys/
```

项目首页会跳转到登录页。

## 默认登录账号

初始化脚本和登录代码中都包含以下默认账号：

| 角色 | 用户名 | 密码 |
| --- | --- | --- |
| 管理员 | admin | 123456 |
| 患者 | patient | 123456 |
| 医生 | doctor | 123456 |
| 药剂师 | pharmacist | 123456 |

登录地址：

```text
http://localhost:8080/0601Sys/login.jsp
```

如果第一次登录前数据库没有默认用户，登录逻辑也会尝试自动创建默认用户。

## 简单常见问题

### 1. 页面打不开

先确认 Tomcat 是否启动成功，再确认访问地址是否正确：

```text
http://localhost:8080/0601Sys/
```

如果 Tomcat 端口不是 8080，需要改成你的实际端口。

### 2. 登录失败

先确认已经执行 `init.sql`，并检查 `users` 表是否有默认账号：

```sql
USE hospital_sys;
SELECT username, password, role FROM users;
```

默认密码都是 `123456`。

### 3. 数据库连接失败

检查 `src/main/resources/jdbc.properties`：

- MySQL 是否已启动
- 数据库名是否是 `hospital_sys`
- 用户名和密码是否正确
- MySQL 端口是否是 `3306`

修改配置后需要重新打包并重新部署 WAR。

### 4. Tomcat 启动后报 servlet 或 javax 相关错误

项目依赖 `javax.servlet`，推荐使用 Tomcat 9。不要使用 Tomcat 10。

### 5. 执行 SQL 后中文显示乱码

建议用 UTF-8 打开并执行 `init.sql`。数据库默认字符集为 `utf8mb4`：

```sql
CREATE DATABASE IF NOT EXISTS hospital_sys DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
```

### 6. 修改代码后页面没有变化

重新执行：

```bash
mvn clean package
```

然后删除 Tomcat `webapps` 下旧的 `0601Sys` 文件夹和 `0601Sys.war`，再复制新的 `target/0601Sys.war` 重新启动 Tomcat。

