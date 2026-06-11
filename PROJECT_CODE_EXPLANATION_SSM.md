# 0601SSM 项目代码具体说明

这份说明面向刚接触 Java Web、SSM、JSP 的同学。可以先把这个项目理解成一个“医院信息管理系统”：用户在浏览器里点菜单，页面把请求发给后端，后端查数据库或修改数据库，再把结果交给 JSP 页面显示。

当前项目位置：

```text
C:\Users\15982\Desktop\0601SSM
```

它是从桌面的旧项目 `0601Sys` 改造成 SSM 项目的。旧项目主要是：

```text
JSP 页面 -> Servlet -> DAO/JDBC -> DBUtil -> MySQL
```

当前项目主要是：

```text
JSP 页面 -> Spring MVC Controller -> Service -> MyBatis Mapper -> MySQL
```

两者做的是同一套医院业务，区别是“后端分层方式”变了。旧项目像是每个窗口自己拿钥匙去数据库房间取东西；SSM 项目像是有前台、业务员、数据库专员分工协作，结构更清楚。

## 一、项目整体结构

当前项目是 Maven WAR 项目，最终会打包成：

```text
target\0601Sys.war
```

主要目录如下：

```text
0601SSM
├─ pom.xml
├─ SSM迁移步骤框架.md
├─ PROJECT_CODE_EXPLANATION_SSM.md
├─ src
│  └─ main
│     ├─ java
│     │  └─ hospital
│     │     ├─ controller
│     │     ├─ interceptor
│     │     ├─ mapper
│     │     ├─ model
│     │     └─ service
│     │        └─ impl
│     ├─ resources
│     │  ├─ applicationContext.xml
│     │  ├─ spring-mvc.xml
│     │  ├─ mybatis-config.xml
│     │  ├─ jdbc.properties
│     │  ├─ mapper
│     │  └─ sql
│     └─ webapp
│        ├─ WEB-INF
│        │  └─ web.xml
│        ├─ css
│        ├─ js
│        ├─ images
│        ├─ html
│        └─ *.jsp
└─ target
```

各目录作用：

| 位置 | 作用 |
|---|---|
| `pom.xml` | Maven 配置，声明 Spring、MyBatis、MySQL、JSTL 等依赖 |
| `src/main/java/hospital/controller` | 控制层，接收浏览器请求，决定调用哪个业务功能，最后返回哪个 JSP |
| `src/main/java/hospital/service` | 业务层接口，定义业务能做什么 |
| `src/main/java/hospital/service/impl` | 业务层实现，真正调用 Mapper，并处理事务 |
| `src/main/java/hospital/mapper` | MyBatis Mapper 接口，对应数据库操作方法 |
| `src/main/resources/mapper` | MyBatis XML，写具体 SQL |
| `src/main/java/hospital/model` | 实体类，也就是数据对象，例如患者、医生、药品 |
| `src/main/java/hospital/interceptor` | 登录和权限拦截器 |
| `src/main/resources` | Spring、MyBatis、数据库连接配置 |
| `src/main/webapp` | JSP 页面、CSS、JS、图片等 Web 资源 |
| `src/main/resources/sql/init.sql` | 数据库初始化脚本 |
| `target` | Maven 编译和打包输出，不建议手动修改 |

## 二、和 0601Sys 的结构类比

旧项目 `C:\Users\15982\Desktop\0601Sys` 的主要结构是：

```text
src/main/java/hospital/controller  放 Servlet
src/main/java/hospital/dao         放 DAO
src/main/java/hospital/filter      放登录过滤器
src/main/java/hospital/util        放 DBUtil 数据库连接工具
src/main/java/hospital/model       放实体类
src/main/webapp                    放 JSP、CSS、JS、图片
```

当前 `0601SSM` 的对应关系是：

| 旧 0601Sys | 新 0601SSM | 变化说明 |
|---|---|---|
| `PatientServlet.java` | `PatientController.java` | Servlet 改成 Spring MVC Controller |
| `PatientDao.java` | `PatientMapper.java` + `PatientMapper.xml` | JDBC SQL 改成 MyBatis SQL |
| `DBUtil.java` | `jdbc.properties` + `DruidDataSource` | 手写连接工具改成连接池配置 |
| `LoginFilter.java` | `LoginInterceptor.java` | Servlet Filter 改成 Spring MVC Interceptor |
| 无明确 Service 层 | `PatientService.java` + `PatientServiceImpl.java` | 新增业务层，避免 Controller 直接访问数据库 |
| `model` 实体类 | `model` 实体类 | 基本保留 |
| JSP、CSS、JS、images | JSP、CSS、JS、images | 页面和静态资源大体保留 |

所以，小白可以这样理解：

```text
Servlet 以前负责的“接请求和跳页面”
现在交给 Controller。

DAO 以前负责的“写 SQL 查数据库”
现在拆成 Mapper 接口 + Mapper XML。

DBUtil 以前负责的“拿数据库连接”
现在交给 Spring + Druid 连接池。

Filter 以前负责的“登录检查”
现在交给 Spring MVC 的 Interceptor。
```

## 三、项目启动和请求入口

### 1. Maven 入口：`pom.xml`

`pom.xml` 说明项目使用 Java 8，打包方式是 WAR：

```xml
<packaging>war</packaging>
```

核心依赖包括：

- `spring-webmvc`：Spring MVC 控制器和请求分发。
- `spring-context`：Spring 容器。
- `spring-jdbc`、`spring-tx`：数据库和事务支持。
- `mybatis`、`mybatis-spring`：MyBatis 和 Spring 整合。
- `druid`：数据库连接池。
- `mysql-connector-j`：MySQL 驱动。
- `jstl`：JSP 页面标签支持。

### 2. Web 入口：`src/main/webapp/WEB-INF/web.xml`

`web.xml` 是传统 Java Web 项目的入口配置。当前项目里它主要做四件事：

1. 启动 Spring 根容器：

```text
classpath:applicationContext.xml
```

2. 配置 UTF-8 编码过滤器，避免表单中文乱码。

3. 启动 Spring MVC 的 `DispatcherServlet`：

```text
classpath:spring-mvc.xml
```

4. 设置欢迎页：

```text
index.jsp
```

浏览器访问项目时，请求先进入 Tomcat，再进入 `DispatcherServlet`，然后由 Spring MVC 分发给对应 Controller。

## 四、Spring 和 MyBatis 配置逻辑

### 1. `applicationContext.xml`

位置：

```text
src/main/resources/applicationContext.xml
```

它负责后端核心对象：

- 读取 `jdbc.properties`。
- 创建 Druid 数据库连接池 `dataSource`。
- 创建 MyBatis 的 `SqlSessionFactoryBean`。
- 扫描 `hospital.mapper` 下的 Mapper 接口。
- 扫描 `hospital.service` 下的 Service。
- 配置事务管理器 `DataSourceTransactionManager`。

一句话：它负责“数据库、Mapper、Service、事务”。

### 2. `spring-mvc.xml`

位置：

```text
src/main/resources/spring-mvc.xml
```

它负责 Web 层：

- 扫描 `hospital.controller`。
- 开启注解驱动，让 `@Controller`、`@RequestMapping` 生效。
- 配置静态资源访问：

```xml
<mvc:resources mapping="/css/**" location="/css/"/>
<mvc:resources mapping="/js/**" location="/js/"/>
<mvc:resources mapping="/images/**" location="/images/"/>
<mvc:resources mapping="/html/**" location="/html/"/>
```

- 配置登录拦截器 `LoginInterceptor`。
- 配置 JSP 视图解析器：

```xml
prefix="/"
suffix=".jsp"
```

所以 Controller 返回 `"patient-list"` 时，实际打开的是：

```text
src/main/webapp/patient-list.jsp
```

### 3. `mybatis-config.xml`

位置：

```text
src/main/resources/mybatis-config.xml
```

它主要做两件事：

- 开启下划线转驼峰：数据库字段 `patient_name` 可以对应 Java 属性 `patientName`。
- 扫描 `hospital.model` 作为类型别名，这样 XML 里可以写 `resultType="Patient"`，不用写完整包名。

## 五、一条请求是怎么跑完的

以“患者管理”为例，相关文件是：

```text
src/main/java/hospital/controller/PatientController.java
src/main/java/hospital/service/PatientService.java
src/main/java/hospital/service/impl/PatientServiceImpl.java
src/main/java/hospital/mapper/PatientMapper.java
src/main/resources/mapper/PatientMapper.xml
src/main/java/hospital/model/Patient.java
src/main/webapp/patient-list.jsp
src/main/webapp/patient-form.jsp
```

流程如下：

```text
用户点击患者管理
-> 浏览器请求 /patients
-> PatientController 接收请求
-> PatientController 调用 PatientService
-> PatientServiceImpl 调用 PatientMapper
-> MyBatis 根据 PatientMapper.xml 执行 SQL
-> 数据库返回 patients 表数据
-> MyBatis 封装成 Patient 对象
-> Controller 把 patients 放到 request
-> 返回 patient-list
-> Spring MVC 打开 patient-list.jsp
-> JSP 把患者列表显示出来
```

患者模块里 `GET /patients` 会根据 `action` 参数判断操作：

| 请求 | 作用 | 返回页面 |
|---|---|---|
| `/patients` | 查询患者列表 | `patient-list.jsp` |
| `/patients?action=new` | 打开新增页面 | `patient-form.jsp` |
| `/patients?action=edit&id=1` | 打开编辑页面 | `patient-form.jsp` |
| `/patients?action=delete&id=1` | 删除患者 | 重定向回 `/patients` |
| `POST /patients?action=add` | 新增保存 | 重定向回 `/patients` |
| `POST /patients?action=update` | 修改保存 | 重定向回 `/patients` |

其他大多数管理模块也是这个套路。看懂患者模块，再看医生、科室、药品、会员，就会轻松很多。

## 六、各功能的位置

| 功能 | Controller | Service | Mapper XML | JSP 页面 |
|---|---|---|---|---|
| 登录、退出、改密码 | `LoginController.java` | `UserService.java` | `UserMapper.xml` | `login.jsp`, `main.jsp` |
| 患者管理 | `PatientController.java` | `PatientService.java` | `PatientMapper.xml` | `patient-list.jsp`, `patient-form.jsp` |
| 医生管理 | `DoctorController.java` | `DoctorService.java` | `DoctorMapper.xml` | `doctor-list.jsp`, `doctor-form.jsp` |
| 科室管理 | `DepartmentController.java` | `DepartmentService.java` | `DepartmentMapper.xml` | `department-list.jsp`, `department-form.jsp` |
| 医生排班 | `DoctorScheduleController.java` | `DoctorScheduleService.java` | `DoctorScheduleMapper.xml` | `doctor-schedule-list.jsp`, `doctor-schedule-form.jsp` |
| 药品管理 | `MedicineController.java` | `MedicineService.java` | `MedicineMapper.xml` | `medicine-list.jsp`, `medicine-form.jsp` |
| 药品发放 | `MedicineDispenseController.java` | `MedicineDispenseService.java` | `MedicineDispenseMapper.xml` | `dispense-list.jsp`, `dispense-form.jsp` |
| 挂号管理 | `RegistrationController.java` | `RegistrationService.java` | `RegistrationMapper.xml` | `registration-list.jsp`, `registration-form.jsp` |
| 诊断/病历 | `MedicalRecordController.java` | `MedicalRecordService.java` | `MedicalRecordMapper.xml` | `record-list.jsp`, `record-form.jsp` |
| 收费管理 | `ChargeController.java` | `ChargeService.java` | `ChargeMapper.xml` | `charge-list.jsp`, `charge-form.jsp` |
| 会员管理 | `MemberController.java` | `MemberService.java` | `MemberMapper.xml` | `member-list.jsp`, `member-form.jsp` |
| 患者端功能 | `PatientPortalController.java` | `RegistrationService`, `MedicalRecordService`, `ChargeService` | 多个 Mapper XML | `patient-appointment.jsp`, `patient-registration-list.jsp`, `patient-record-list.jsp`, `patient-charge-list.jsp` |
| 医生端功能 | `DoctorPortalController.java` | `RegistrationService`, `MedicalRecordService`, `DoctorScheduleService` | 多个 Mapper XML | `doctor-registration-list.jsp`, `doctor-record-list.jsp`, `doctor-record-form.jsp`, `doctor-schedule-my.jsp` |
| 权限拦截 | `LoginInterceptor.java` | 无 | 无 | `unauthorized.jsp`, `login.jsp` |

## 七、核心业务逻辑说明

### 1. 登录逻辑

相关文件：

```text
src/main/java/hospital/controller/LoginController.java
src/main/java/hospital/service/UserService.java
src/main/java/hospital/service/impl/UserServiceImpl.java
src/main/resources/mapper/UserMapper.xml
src/main/java/hospital/model/User.java
src/main/webapp/login.jsp
```

流程：

1. 用户在 `login.jsp` 输入账号密码。
2. 表单提交到 `/login`。
3. `LoginController` 调用 `UserService.login(...)`。
4. `UserServiceImpl` 调用 `UserMapper.findByUsernameAndPassword(...)`。
5. `UserMapper.xml` 查询 `users` 表。
6. 登录成功后，把 `User` 保存到 session：

```text
loginUser
```

7. 跳转到 `main.jsp`。

`main.jsp` 会根据 `loginUser.role` 显示不同菜单。管理员、患者、医生、药剂师看到的功能入口不同。

### 2. 权限逻辑

相关文件：

```text
src/main/java/hospital/interceptor/LoginInterceptor.java
src/main/resources/spring-mvc.xml
```

`spring-mvc.xml` 里配置了：

```xml
<mvc:mapping path="/**"/>
```

表示大多数请求都会先经过 `LoginInterceptor`。它主要判断：

- 是否是公开路径，例如登录页、CSS、JS、图片。
- 用户是否已经登录。
- 当前角色是否有权限访问当前路径。

例如：

- 患者端功能只能患者访问。
- 医生端功能只能医生访问。
- 药品发放功能主要给药剂师访问。
- 管理类页面主要给管理员访问。

不符合权限时，会跳到 `unauthorized.jsp`。

### 3. 管理员 CRUD 逻辑

CRUD 指：

```text
Create 新增
Read 查询
Update 修改
Delete 删除
```

患者、医生、科室、药品、会员、挂号、病历、收费等模块，大部分都是同样模式：

```text
列表页面
-> 点击新增/编辑/删除
-> Controller 根据 action 判断
-> Service 处理业务
-> Mapper 执行 SQL
-> 返回列表或表单页面
```

例如科室管理：

```text
/departments
/departments?action=new
/departments?action=edit&id=1
/departments?action=delete&id=1
POST /departments?action=add
POST /departments?action=update
```

### 4. 患者端逻辑

相关文件：

```text
src/main/java/hospital/controller/PatientPortalController.java
```

主要路径：

| 路径 | 作用 | 页面 |
|---|---|---|
| `/patient-appointment` | 患者预约挂号 | `patient-appointment.jsp` |
| `/patient-registrations` | 查看我的挂号 | `patient-registration-list.jsp` |
| `/patient-records` | 查看我的诊断 | `patient-record-list.jsp` |
| `/patient-charges` | 查看我的费用 | `patient-charge-list.jsp` |

患者端不是看全系统数据，而是根据当前登录用户的姓名去查自己的挂号、诊断和费用记录。

### 5. 医生端逻辑

相关文件：

```text
src/main/java/hospital/controller/DoctorPortalController.java
```

主要路径：

| 路径 | 作用 | 页面 |
|---|---|---|
| `/doctor-registrations` | 查看分配给当前医生的挂号 | `doctor-registration-list.jsp` |
| `/doctor-records` | 查看当前医生写过的诊断 | `doctor-record-list.jsp` |
| `/doctor-record-new` | 新增诊断记录 | `doctor-record-form.jsp` |
| `/doctor-schedule-my` | 查看我的排班 | `doctor-schedule-my.jsp` |

医生写完诊断后，如果请求里带了挂号 ID，系统还会把对应挂号状态更新为已就诊。

### 6. 药品发放逻辑

相关文件：

```text
src/main/java/hospital/controller/MedicineDispenseController.java
src/main/java/hospital/service/impl/MedicineDispenseServiceImpl.java
src/main/resources/mapper/MedicineDispenseMapper.xml
```

药品发放比普通新增复杂，因为它要同时做两件事：

1. 扣减药品库存。
2. 新增一条发放记录。

这两件事必须一起成功。如果库存不足，不能新增发放记录；如果新增记录失败，也不应该扣库存。项目里通过 `@Transactional` 保证事务一致性。

## 八、Model、Mapper、Service、Controller 的关系

以患者为例：

```text
Patient.java
```

代表一条患者数据，字段大致对应数据库 `patients` 表。

```text
PatientMapper.java
```

定义可以做哪些数据库操作，例如：

```text
findAll
findById
insert
update
deleteById
```

```text
PatientMapper.xml
```

写每个方法背后的 SQL。

```text
PatientService.java
PatientServiceImpl.java
```

定义和实现业务逻辑。比如查询时处理空关键字，新增、修改、删除时加事务。

```text
PatientController.java
```

接收页面请求，读取参数，调用 Service，把结果交给 JSP。

这几层可以用一句话记：

```text
Controller 管“网页请求”
Service 管“业务规则”
Mapper 管“数据库 SQL”
Model 管“数据长什么样”
JSP 管“显示给用户看”
```

## 九、静态资源是如何移植的

旧项目 `0601Sys` 里已经有完整的页面模板和静态资源：

```text
src/main/webapp/css
src/main/webapp/js
src/main/webapp/images
src/main/webapp/html
src/main/webapp/*.jsp
```

当前 SSM 项目迁移时，静态资源基本沿用原来的目录：

```text
src/main/webapp/css
src/main/webapp/js
src/main/webapp/images
src/main/webapp/html
```

这样做的好处是：页面里原来的资源路径可以尽量少改。

例如 CSS 里原来这样引用图片：

```css
background:url(../images/index-header-bg.gif)
background:url(../images/login-bg.gif)
```

因为 `css` 和 `images` 仍然同在 `src/main/webapp` 下，所以 `../images/...` 继续有效。

JSP 页面里也继续使用类似路径：

```html
<link href="css/style.css" rel="stylesheet" type="text/css" />
<script src="js/jquery.min.js"></script>
<img src="images/t01.png" />
<img src="images/icon/edit.png" />
```

迁移静态资源的实际思路是：

1. 保留原来的 `css`、`js`、`images`、`html` 目录。
2. 把原静态 HTML 的页面样式和布局迁到 JSP。
3. 把写死的演示数据改成后端传来的动态数据。
4. 把按钮和表单的地址改成 Spring MVC 路由。
5. 在 `spring-mvc.xml` 里显式放行静态资源路径：

```xml
<mvc:resources mapping="/css/**" location="/css/"/>
<mvc:resources mapping="/js/**" location="/js/"/>
<mvc:resources mapping="/images/**" location="/images/"/>
<mvc:resources mapping="/html/**" location="/html/"/>
```

如果没有这几行，`DispatcherServlet` 可能会把 `/css/style.css`、`/js/jquery.min.js` 也当成普通业务请求处理，导致页面样式或脚本加载失败。

所以，静态资源迁移不是“把图片变成 Java 代码”，而是：

```text
保留原页面外观资源
-> 让 Spring MVC 能访问这些资源
-> 把页面里的静态数据换成后端动态数据
-> 把旧 Servlet 地址换成新 Controller 地址
```

## 十、数据库和 SQL 的位置

数据库初始化脚本：

```text
src/main/resources/sql/init.sql
```

数据库连接配置：

```text
src/main/resources/jdbc.properties
```

SQL 映射文件：

```text
src/main/resources/mapper/*.xml
```

主要数据表和代码对应关系：

| 数据表 | Model | Mapper |
|---|---|---|
| `users` | `User.java` | `UserMapper.xml` |
| `patients` | `Patient.java` | `PatientMapper.xml` |
| `doctors` | `Doctor.java` | `DoctorMapper.xml` |
| `departments` | `Department.java` | `DepartmentMapper.xml` |
| `doctor_schedules` | `DoctorSchedule.java` | `DoctorScheduleMapper.xml` |
| `medicines` | `Medicine.java` | `MedicineMapper.xml` |
| `medicine_dispenses` | `MedicineDispense.java` | `MedicineDispenseMapper.xml` |
| `registrations` | `Registration.java` | `RegistrationMapper.xml` |
| `medical_records` | `MedicalRecord.java` | `MedicalRecordMapper.xml` |
| `charges` | `Charge.java` | `ChargeMapper.xml` |
| `members` | `Member.java` | `MemberMapper.xml` |

MyBatis 的好处是 SQL 集中放在 XML 里，Java 代码不用再手写 `Connection`、`PreparedStatement`、`ResultSet` 这些 JDBC 样板代码。

## 十一、从旧项目迁移到 SSM 的核心变化

旧项目的患者查询大致是：

```text
PatientServlet
-> PatientDao
-> DBUtil.getConnection()
-> PreparedStatement 执行 SQL
-> ResultSet 转 Patient
-> JSP 显示
```

当前项目变成：

```text
PatientController
-> PatientService
-> PatientMapper
-> PatientMapper.xml
-> MyBatis 执行 SQL 并封装 Patient
-> JSP 显示
```

旧项目代码更直接，适合初学者理解请求和数据库；新项目分层更多，但每层职责更清楚，也更符合课程里 SSM 的要求。

## 十二、建议阅读顺序

如果完全不会这门课，建议按这个顺序看：

1. 看 `pom.xml`，知道项目用了哪些框架。
2. 看 `web.xml`，知道请求从哪里进来。
3. 看 `spring-mvc.xml`，知道 Controller、JSP、静态资源怎么关联。
4. 看 `applicationContext.xml`，知道 Service、Mapper、数据库怎么关联。
5. 看 `LoginController.java` 和 `LoginInterceptor.java`，理解登录和权限。
6. 看 `main.jsp`，理解菜单如何进入各功能。
7. 看一个简单模块，例如科室：

```text
Department.java
DepartmentController.java
DepartmentService.java
DepartmentServiceImpl.java
DepartmentMapper.java
DepartmentMapper.xml
department-list.jsp
department-form.jsp
```

8. 再看患者模块，因为它带关键字查询。
9. 最后看药品发放模块，因为它有库存扣减和事务。

## 十三、一句话总结

当前 `0601SSM` 的核心关系是：

```text
浏览器访问 JSP/路由
-> Spring MVC Controller 接请求
-> Service 处理业务
-> MyBatis Mapper 执行 SQL
-> Model 承载数据
-> JSP 渲染结果
```

和桌面旧项目 `0601Sys` 相比，本质功能没有变，主要是把：

```text
Servlet + DAO + DBUtil
```

升级成了：

```text
Controller + Service + Mapper + Spring 配置
```

页面外观和静态资源则尽量保留原结构，通过 `css`、`js`、`images` 原目录复用，再配合 `spring-mvc.xml` 的静态资源映射，让迁移后的 SSM 项目既保留旧页面样式，又使用新的后端分层逻辑。
