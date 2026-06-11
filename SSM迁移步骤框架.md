# 0601Sys 转 SSM 项目步骤框架

> 本项目需要的是传统、简单的 SSM：Spring + Spring MVC + MyBatis。不是 Spring Boot，也不引入复杂架构，只在原 Servlet + JSP + JDBC 项目基础上做课程要求范围内的改造。

## 一、当前项目判断

原项目位置：

`C:\Users\15982\Desktop\0601Sys`

目标目录：

`C:\Users\15982\Desktop\0601SSM`

当前 `0601Sys` 是一个 Maven WAR 类型的 Java Web 项目，主要技术结构为：

```text
JSP -> Servlet -> DAO/JDBC -> MySQL
```

项目中已经存在较完整的 JSP 页面、实体类、Servlet 控制器、DAO 类和数据库初始化 SQL。

改造目标是转成标准 SSM 项目：

```text
JSP -> Spring MVC Controller -> Service -> MyBatis Mapper -> MySQL
```

## 二、改造成功标准

1. `0601SSM` 目录中形成可独立运行的 SSM 项目。
2. Maven 能成功执行 `mvn package` 并生成 WAR 包。
3. Tomcat 部署后能正常启动，无 Spring、MyBatis 配置错误。
4. 登录、退出功能正常。
5. 患者、医生、科室、挂号、病历、药品、收费等模块能完成原有增删改查功能。
6. 原有 JSP 页面尽量复用，页面跳转和数据展示正常。
7. 数据库访问全部通过 MyBatis Mapper 完成，不再依赖原来的 JDBC DAO 和 `DBUtil`。

## 三、总体迁移思路

优先采用“小步迁移、逐个验证”的方式。

先复制原项目结构到 `0601SSM`，再搭建 SSM 基础配置。之后选择一个模块作为样板，建议先迁移患者模块 `Patient`。患者模块跑通后，再按同样模式迁移其他模块。

这种方式的优点：

1. 保留原项目页面和业务路径，改造风险低。
2. 每完成一个模块就能验证一次，问题更容易定位。
3. 避免一次性重写所有功能导致错误堆叠。

## 四、目录结构规划

建议改造后的主要目录如下：

```text
0601SSM
├── pom.xml
└── src
    └── main
        ├── java
        │   └── hospital
        │       ├── controller
        │       ├── service
        │       ├── service
        │       │   └── impl
        │       ├── mapper
        │       ├── model
        │       └── interceptor
        ├── resources
        │   ├── applicationContext.xml
        │   ├── spring-mvc.xml
        │   ├── mybatis-config.xml
        │   ├── jdbc.properties
        │   ├── mapper
        │   └── sql
        │       └── init.sql
        └── webapp
            ├── WEB-INF
            │   └── web.xml
            ├── css
            ├── js
            ├── images
            └── *.jsp
```

说明：

1. `model` 可以保留原实体类。
2. `controller` 用 Spring MVC Controller 替换原 Servlet。
3. `service` 新增业务层，避免 Controller 直接访问 Mapper。
4. `mapper` 放 MyBatis Mapper 接口。
5. `resources/mapper` 放 MyBatis XML 映射文件。
6. `interceptor` 用来替代原来的登录过滤器。

## 五、具体步骤

### 第一步：复制原项目基础文件

从 `0601Sys` 复制必要内容到 `0601SSM`：

1. `pom.xml`
2. `src/main/webapp`
3. `src/main/java/hospital/model`
4. `src/main/resources/sql/init.sql`

暂时不直接复用原来的 Servlet、DAO 和 `DBUtil`，这些会被 Spring MVC、Service、MyBatis Mapper 逐步替换。

### 第二步：改造 Maven 依赖

在 `pom.xml` 中增加 SSM 需要的依赖：

1. Spring MVC
2. Spring Context
3. Spring JDBC
4. Spring TX
5. MyBatis
6. mybatis-spring
7. 数据库连接池
8. MySQL Connector
9. JSTL
10. Servlet/JSP API

打包方式继续保持：

```xml
<packaging>war</packaging>
```

### 第三步：新增 Spring 和 MyBatis 配置

新增配置文件：

1. `src/main/resources/applicationContext.xml`
2. `src/main/resources/spring-mvc.xml`
3. `src/main/resources/mybatis-config.xml`
4. `src/main/resources/jdbc.properties`

核心配置内容包括：

1. 数据库连接池。
2. `SqlSessionFactoryBean`。
3. Mapper 扫描。
4. Service 扫描。
5. Spring MVC Controller 扫描。
6. JSP 视图解析器。
7. 事务管理器。

### 第四步：改造 web.xml

在 `WEB-INF/web.xml` 中配置：

1. `ContextLoaderListener`
2. Spring 根容器配置路径
3. `DispatcherServlet`
4. Spring MVC 配置路径
5. 编码过滤器
6. 欢迎页

原项目使用 `@WebServlet` 注解注册 Servlet，改造后由 `DispatcherServlet` 接管请求分发。

### 第五步：迁移患者模块作为样板

建议第一个迁移 `Patient` 模块。

原结构：

```text
PatientServlet.java
PatientDao.java
Patient.java
patient-list.jsp
patient-form.jsp
```

改造后：

```text
PatientController.java
PatientService.java
PatientServiceImpl.java
PatientMapper.java
PatientMapper.xml
Patient.java
patient-list.jsp
patient-form.jsp
```

迁移内容：

1. `PatientServlet` 中的请求处理逻辑迁移到 `PatientController`。
2. `PatientDao` 中的 SQL 迁移到 `PatientMapper.xml`。
3. 新增 `PatientService` 封装业务逻辑。
4. JSP 页面先尽量保持原样，只调整必要的请求地址和表单提交地址。

### 第六步：迁移登录和权限

原项目包括：

1. `LoginServlet`
2. `LogoutServlet`
3. `LoginFilter`
4. `UserDao`

改造为：

1. `LoginController`
2. `UserService`
3. `UserMapper`
4. `UserMapper.xml`
5. `LoginInterceptor`

登录成功后继续使用 Session 保存用户信息。

拦截器负责判断用户是否已登录，以及是否有权限访问对应页面。

### 第七步：逐个迁移其他业务模块

患者模块和登录模块跑通后，再迁移其他模块。

建议顺序：

1. 科室模块 `Department`
2. 医生模块 `Doctor`
3. 会员模块 `Member`
4. 挂号模块 `Registration`
5. 病历模块 `MedicalRecord`
6. 药品模块 `Medicine`
7. 排班模块 `DoctorSchedule`
8. 发药模块 `MedicineDispense`
9. 收费模块 `Charge`
10. 医生端、患者端门户页面

每个模块都按同样模式迁移：

```text
Servlet -> Controller
DAO -> Mapper 接口 + Mapper XML
直接调用 DAO -> 调用 Service
JDBC SQL -> MyBatis SQL
```

### 第八步：删除旧 JDBC 代码

当所有模块迁移完成后，删除或停用：

1. `hospital.dao`
2. `hospital.util.DBUtil`
3. 原 Servlet 类

如果为了对照代码，也可以先保留旧代码，但不让它参与编译或运行。

### 第九步：统一验证

完成迁移后执行验证：

1. `mvn package`
2. 部署 WAR 到 Tomcat
3. 初始化数据库
4. 打开首页
5. 登录系统
6. 验证各模块列表页
7. 验证新增、编辑、删除、查询
8. 验证无权限访问时是否正确跳转
9. 验证中文编码是否正常

如果某一步失败，需要先解决当前模块问题，再继续迁移下一个模块。

## 六、推荐执行顺序

推荐按下面顺序正式动手：

```text
1. 复制基础项目到 0601SSM
2. 改 pom.xml
3. 加 SSM 配置文件
4. 改 web.xml
5. 迁移 Patient 模块
6. 编译验证
7. 部署验证 Patient 模块
8. 迁移登录和权限
9. 逐个迁移其他模块
10. 删除旧 JDBC/Servlet 代码
11. 最终整体测试
```

## 七、注意事项

1. 不建议一开始就大规模重写所有模块。
2. JSP 页面优先复用，只有请求路径不兼容时再改。
3. Mapper XML 中的 SQL 应尽量从原 DAO 原样迁移，避免改出新问题。
4. Controller 不直接访问 Mapper，统一通过 Service。
5. 参数校验和错误提示要保留原功能。
6. 异常不能静默吞掉，必须明确抛出或显示错误信息。
7. 每迁移一个模块都要编译并测试，不要等全部迁完再测试。
