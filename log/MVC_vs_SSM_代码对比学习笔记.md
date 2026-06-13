# MVC 和 SSM 代码对比学习笔记

本文参考两个项目：

- 老项目：`C:\Users\15982\Desktop\0601Sys`
- 当前项目：`C:\Users\15982\Desktop\0601SSM`

这份笔记适合“会一点 MVC/Servlet/JSP，但是刚接触 SSM”的同学。目标不是背概念，而是让你能看懂这个项目为什么这么分层，并且以后能照着写出一个 SSM 模块。

## 一句话先记住

老 MVC 项目大概是：

```text
JSP 页面 -> Servlet -> DAO -> DBUtil/JDBC -> MySQL
```

SSM 项目大概是：

```text
JSP 页面 -> Spring MVC Controller -> Service -> MyBatis Mapper -> MySQL
```

最关键的区别：

```text
以前很多事情靠你手写：
接收请求、判断 action、转发页面、创建 DAO、获取连接、写 PreparedStatement、遍历 ResultSet、提交/回滚事务。

现在很多事情交给框架：
Spring MVC 管请求分发和页面跳转；
Spring 管对象创建和依赖注入；
MyBatis 管 SQL 执行和结果封装；
Spring 事务管提交和回滚。
```

## 先别被 SSM 吓住

SSM 是三个框架合在一起：

| 名字 | 全称 | 在项目里负责什么 | 你可以把它理解成 |
|---|---|---|---|
| Spring | Spring Framework | 创建对象、管理对象、注入对象、事务管理 | 项目的“大管家” |
| Spring MVC | Spring Web MVC | 接收浏览器请求，调用 Controller，返回 JSP 页面 | Servlet 的升级版 |
| MyBatis | MyBatis | 执行 SQL，把查询结果变成 Java 对象 | JDBC DAO 的升级版 |

所以 SSM 不是一个神秘东西，它只是把老项目里你手写的重复代码拆给框架做。

## 用科室管理看整体区别

老项目科室管理主要文件：

```text
0601Sys
├─ src/main/java/hospital/controller/DepartmentServlet.java
├─ src/main/java/hospital/dao/DepartmentDao.java
├─ src/main/java/hospital/util/DBUtil.java
├─ src/main/java/hospital/model/Department.java
├─ src/main/webapp/department-list.jsp
└─ src/main/webapp/department-form.jsp
```

SSM 项目科室管理主要文件：

```text
0601SSM
├─ src/main/java/hospital/controller/DepartmentController.java
├─ src/main/java/hospital/service/DepartmentService.java
├─ src/main/java/hospital/service/impl/DepartmentServiceImpl.java
├─ src/main/java/hospital/mapper/DepartmentMapper.java
├─ src/main/resources/mapper/DepartmentMapper.xml
├─ src/main/java/hospital/model/Department.java
├─ src/main/webapp/department-list.jsp
└─ src/main/webapp/department-form.jsp
```

你会发现 JSP 和 model 基本还在，变化最大的是：

```text
Servlet 变成 Controller
DAO 变成 Mapper
中间多了一层 Service
DBUtil 变成 Spring 配置的数据源
```

## 请求流程对比

比如用户访问：

```text
/departments
```

老 MVC 项目流程：

```text
浏览器请求 /departments
  -> DepartmentServlet.doGet()
  -> 判断 action 参数
  -> DepartmentDao.findAll()
  -> DBUtil.getConnection()
  -> 手写 SQL、PreparedStatement、ResultSet
  -> req.setAttribute("departments", list)
  -> req.getRequestDispatcher("department-list.jsp").forward(req, resp)
```

SSM 项目流程：

```text
浏览器请求 /departments
  -> DispatcherServlet 统一接收
  -> 找到 DepartmentController.list()
  -> departmentService.findAll()
  -> DepartmentServiceImpl 调 DepartmentMapper.findAll()
  -> MyBatis 根据 DepartmentMapper.xml 执行 SQL
  -> req.setAttribute("departments", list)
  -> return "department-list"
  -> Spring MVC 拼成 /department-list.jsp
```

重点记忆：

```text
老 MVC：你自己找 Servlet，Servlet 自己 forward。
SSM：请求先进 DispatcherServlet，Controller 只返回视图名。
```

## Controller 和 Servlet 对比

老项目 `DepartmentServlet.java`：

```java
@WebServlet("/departments")
public class DepartmentServlet extends HttpServlet {

    private final DepartmentDao departmentDao = new DepartmentDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("new".equals(action)) {
            req.getRequestDispatcher("department-form.jsp").forward(req, resp);
            return;
        }

        if ("delete".equals(action)) {
            departmentDao.deleteById(parseId(req.getParameter("id")));
            resp.sendRedirect("departments");
            return;
        }

        listDepartments(req, resp);
    }
}
```

SSM 项目 `DepartmentController.java`：

```java
@Controller
@RequestMapping("/departments")
public class DepartmentController {

    @Autowired
    private DepartmentService departmentService;

    @RequestMapping(method = RequestMethod.GET)
    public String list(HttpServletRequest req) {
        String action = req.getParameter("action");

        if ("new".equals(action)) {
            return "department-form";
        }

        if ("delete".equals(action)) {
            departmentService.deleteById(parseId(req.getParameter("id")));
            return "redirect:/departments";
        }

        return listDepartments(req);
    }
}
```

### 代码差异怎么理解

老 MVC 写法：

```text
extends HttpServlet
@WebServlet("/departments")
doGet/doPost
new DepartmentDao()
req.getRequestDispatcher(...).forward(...)
resp.sendRedirect(...)
```

SSM 写法：

```text
@Controller
@RequestMapping("/departments")
普通 Java 方法
@Autowired DepartmentService
return "department-list"
return "redirect:/departments"
```

最重要的变化是：

```text
Servlet 是“自己处理整个 HTTP 请求”。
Controller 是“告诉 Spring MVC 该做什么”。
```

老项目里你必须手写：

```java
req.getRequestDispatcher("department-list.jsp").forward(req, resp);
```

SSM 里只写：

```java
return "department-list";
```

因为 `spring-mvc.xml` 里配置了视图解析器：

```xml
<bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
    <property name="prefix" value="/"/>
    <property name="suffix" value=".jsp"/>
</bean>
```

这代表：

```text
return "department-list"
  -> prefix + 视图名 + suffix
  -> / + department-list + .jsp
  -> /department-list.jsp
```

所以你写 Controller 时要记住：

```text
返回普通字符串：跳到 JSP
返回 redirect:/xxx：重定向到另一个地址
```

## 为什么 SSM 多了 Service 层

老 MVC 项目里，Servlet 直接调用 DAO：

```java
private final DepartmentDao departmentDao = new DepartmentDao();

departmentDao.insert(department);
departmentDao.update(department);
departmentDao.deleteById(id);
```

SSM 项目里，Controller 不直接调 Mapper，而是调 Service：

```java
@Autowired
private DepartmentService departmentService;

departmentService.insert(department);
departmentService.update(department);
departmentService.deleteById(id);
```

中间多出来的是：

```text
DepartmentService.java
DepartmentServiceImpl.java
```

接口：

```java
public interface DepartmentService {
    List<Department> findAll();
    Department findById(int id);
    int insert(Department department);
    int update(Department department);
    int deleteById(int id);
}
```

实现类：

```java
@Service
public class DepartmentServiceImpl implements DepartmentService {

    @Autowired
    private DepartmentMapper departmentMapper;

    @Override
    public List<Department> findAll() {
        return departmentMapper.findAll();
    }

    @Override
    @Transactional
    public int insert(Department department) {
        return departmentMapper.insert(department);
    }
}
```

### Service 到底有什么用

小白最容易问：

```text
Service 里面只是调 Mapper，那不是多此一举吗？
```

在这个项目里，有些 Service 现在确实比较简单，因为业务不复杂。但是它仍然有价值：

| 层 | 该写什么 | 不该写什么 |
|---|---|---|
| Controller | 接收请求、取参数、放 request 属性、返回页面 | 不直接写 SQL，不处理复杂业务 |
| Service | 业务规则、事务、多个 Mapper 的组合操作 | 不关心 JSP 怎么跳 |
| Mapper | 单表或具体 SQL 操作 | 不判断页面跳转 |

比如将来“挂号”可能要做三件事：

```text
1. 新增挂号记录
2. 扣患者余额
3. 增加收费记录
```

这时不能把三件事散在 Controller 里，更不能让 JSP 处理。应该放进 Service：

```java
@Transactional
public void createRegistration(...) {
    registrationMapper.insert(...);
    memberMapper.updateBalance(...);
    chargeMapper.insert(...);
}
```

`@Transactional` 的意思是：

```text
要么三件事全部成功；
只要中间有一步失败，前面的数据库操作一起回滚。
```

这就是 Service 层的真正意义。

## DAO 和 MyBatis Mapper 对比

老项目 `DepartmentDao.java` 里手写 JDBC：

```java
public List<Department> findAll() throws SQLException {
    String sql = "SELECT id, name, description FROM departments ORDER BY id DESC";
    List<Department> list = new ArrayList<>();

    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            Department department = new Department();
            department.setId(rs.getInt("id"));
            department.setName(rs.getString("name"));
            department.setDescription(rs.getString("description"));
            list.add(department);
        }
    }
    return list;
}
```

SSM 项目拆成两部分。

第一部分：`DepartmentMapper.java` 只写方法名：

```java
public interface DepartmentMapper {
    List<Department> findAll();
    Department findById(@Param("id") int id);
    int insert(Department department);
    int update(Department department);
    int deleteById(@Param("id") int id);
}
```

第二部分：`DepartmentMapper.xml` 写 SQL：

```xml
<mapper namespace="hospital.mapper.DepartmentMapper">

    <select id="findAll" resultType="Department">
        SELECT id, name, description
        FROM departments
        ORDER BY id DESC
    </select>

    <insert id="insert" parameterType="Department">
        INSERT INTO departments (name, description)
        VALUES (#{name}, #{description})
    </insert>

</mapper>
```

### MyBatis 怎么知道哪个 SQL 对应哪个方法

靠两个对应关系。

第一个对应：

```xml
<mapper namespace="hospital.mapper.DepartmentMapper">
```

它必须对应 Java 接口：

```java
hospital.mapper.DepartmentMapper
```

第二个对应：

```xml
<select id="findAll">
```

它必须对应接口方法：

```java
List<Department> findAll();
```

所以你要记：

```text
namespace 对接口全名
id 对接口方法名
#{属性名} 对 Java 对象的属性名
resultType 对返回对象类型
```

### MyBatis 替你省了哪些代码

老 DAO 里你手写：

```text
Connection conn = DBUtil.getConnection()
PreparedStatement ps = conn.prepareStatement(sql)
ps.setString(1, ...)
ResultSet rs = ps.executeQuery()
while (rs.next()) { new Department(); setId(); setName(); }
关闭连接
抛 SQLException
```

MyBatis 里你只写：

```xml
<select id="findAll" resultType="Department">
    SELECT id, name, description
    FROM departments
    ORDER BY id DESC
</select>
```

它会帮你做：

```text
拿连接
预编译 SQL
设置参数
执行 SQL
读取 ResultSet
封装成 Department
关闭资源
```

## DBUtil 和 Spring 数据源对比

老项目 `DBUtil.java`：

```java
public class DBUtil {
    private static String URL = "jdbc:mysql://localhost:3306/hospital_sys?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    private static String USER = "root";
    private static String PASSWORD = "123456";

    static {
        Class.forName("com.mysql.cj.jdbc.Driver");
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
```

SSM 项目不再让 DAO 自己拿连接，而是在 `applicationContext.xml` 里配置数据源：

```xml
<context:property-placeholder location="classpath:jdbc.properties"/>

<bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource">
    <property name="driverClassName" value="${jdbc.driver}"/>
    <property name="url" value="${jdbc.url}"/>
    <property name="username" value="${jdbc.username}"/>
    <property name="password" value="${jdbc.password}"/>
</bean>
```

然后交给 MyBatis：

```xml
<bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
    <property name="dataSource" ref="dataSource"/>
    <property name="configLocation" value="classpath:mybatis-config.xml"/>
    <property name="mapperLocations" value="classpath:mapper/*.xml"/>
</bean>
```

意思是：

```text
Spring 创建数据库连接池 dataSource
MyBatis 使用这个 dataSource 执行 SQL
Service/Mapper 不需要知道连接怎么来的
```

老项目像是每次用车都自己去发动一辆车。

SSM 像是公司有车队，Spring 管车，MyBatis 只管开车办事。

## 对象创建方式对比

老项目常见写法：

```java
private final DepartmentDao departmentDao = new DepartmentDao();
```

这叫“自己 new”。

SSM 常见写法：

```java
@Autowired
private DepartmentService departmentService;
```

这叫“让 Spring 注入”。

你可以这样理解：

```text
@Controller：告诉 Spring，这是一个控制器对象，请帮我创建。
@Service：告诉 Spring，这是一个业务对象，请帮我创建。
@Autowired：告诉 Spring，我这里需要一个对象，请帮我塞进来。
```

在本项目里：

```java
@Controller
public class DepartmentController {
    @Autowired
    private DepartmentService departmentService;
}
```

Spring 会做：

```text
看到 @Controller，创建 DepartmentController
看到 @Autowired DepartmentService，寻找 DepartmentService 的实现类
看到 DepartmentServiceImpl 上有 @Service，创建它
把 DepartmentServiceImpl 放进 DepartmentController
```

这就是依赖注入。

## web.xml 对比

老项目 `web.xml` 很简单：

```xml
<welcome-file-list>
    <welcome-file>index.jsp</welcome-file>
</welcome-file-list>
```

为什么这么简单？

因为老项目 Servlet 自己用注解接 URL：

```java
@WebServlet("/departments")
public class DepartmentServlet extends HttpServlet {
}
```

SSM 项目 `web.xml` 多了很多配置：

```xml
<listener>
    <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
</listener>

<servlet>
    <servlet-name>dispatcherServlet</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <init-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>classpath:spring-mvc.xml</param-value>
    </init-param>
</servlet>

<servlet-mapping>
    <servlet-name>dispatcherServlet</servlet-name>
    <url-pattern>/</url-pattern>
</servlet-mapping>
```

你可以这样记：

```text
ContextLoaderListener：启动 Spring 大容器，加载 applicationContext.xml，主要管理 Service、Mapper、数据源、事务。

DispatcherServlet：启动 Spring MVC 小容器，加载 spring-mvc.xml，主要管理 Controller、视图解析器、拦截器、静态资源。
```

SSM 项目里有两个重要配置文件：

```text
applicationContext.xml：管后端业务和数据库
spring-mvc.xml：管 Web 请求和页面跳转
```

## Filter 和 Interceptor 对比

老项目登录校验用 `LoginFilter`：

```java
@WebFilter("/*")
public class LoginFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        // 判断是否登录
        chain.doFilter(request, response);
    }
}
```

SSM 项目登录校验用 `LoginInterceptor`：

```java
public class LoginInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest req, HttpServletResponse resp, Object handler)
            throws Exception {
        // 判断是否登录
        return true;
    }
}
```

并在 `spring-mvc.xml` 里注册：

```xml
<mvc:interceptors>
    <mvc:interceptor>
        <mvc:mapping path="/**"/>
        <bean class="hospital.interceptor.LoginInterceptor"/>
    </mvc:interceptor>
</mvc:interceptors>
```

区别：

| 对比项 | Filter | Interceptor |
|---|---|---|
| 属于谁 | Servlet 规范 | Spring MVC |
| 作用位置 | 请求进入 Servlet 之前 | 请求进入 Controller 前后 |
| 放行方式 | `chain.doFilter(...)` | `return true` |
| 拦截方式 | `@WebFilter` 或 web.xml | `spring-mvc.xml` |

在这个项目里，逻辑基本没变，只是从 Servlet 体系迁移到了 Spring MVC 体系。

## 依赖对比

老项目 `pom.xml` 主要依赖：

```text
servlet-api
jsp-api
jstl
mysql-connector-j
```

说明老项目只需要：

```text
能写 Servlet/JSP
能连 MySQL
```

SSM 项目 `pom.xml` 新增：

```text
spring-webmvc
spring-context
spring-jdbc
spring-tx
mybatis
mybatis-spring
druid
```

它们分别负责：

| 依赖 | 作用 |
|---|---|
| `spring-webmvc` | Spring MVC，处理 Web 请求 |
| `spring-context` | Spring 容器，创建和管理对象 |
| `spring-jdbc` | Spring 对 JDBC/数据源的支持 |
| `spring-tx` | Spring 事务管理 |
| `mybatis` | SQL 映射框架 |
| `mybatis-spring` | 让 MyBatis 和 Spring 整合 |
| `druid` | 数据库连接池 |

## SSM 里每层到底写什么

你以后写一个 SSM 模块，可以按这个顺序写。

假设要写“科室管理”。

### 第 1 步：Model

Model 就是数据库表对应的 Java 类。

比如 `Department.java`：

```java
public class Department {
    private Integer id;
    private String name;
    private String description;

    // getter/setter
}
```

记法：

```text
表名 departments
  -> 类名 Department

字段 id/name/description
  -> 属性 id/name/description
```

### 第 2 步：Mapper 接口

写你要对数据库做什么。

```java
public interface DepartmentMapper {
    List<Department> findAll();
    Department findById(@Param("id") int id);
    int insert(Department department);
    int update(Department department);
    int deleteById(@Param("id") int id);
}
```

记法：

```text
查全部：findAll
按 id 查：findById
新增：insert
修改：update
删除：deleteById
```

`@Param("id")` 的作用：

```text
告诉 MyBatis：XML 里的 #{id} 对应这个参数。
```

### 第 3 步：Mapper XML

写真正的 SQL。

```xml
<mapper namespace="hospital.mapper.DepartmentMapper">
    <select id="findAll" resultType="Department">
        SELECT id, name, description
        FROM departments
        ORDER BY id DESC
    </select>
</mapper>
```

记法：

```text
接口方法返回 List，用 <select>
接口方法新增，用 <insert>
接口方法修改，用 <update>
接口方法删除，用 <delete>
```

### 第 4 步：Service 接口

Service 接口一般和 Mapper 方法接近，但它代表“业务能力”，不是“SQL 能力”。

```java
public interface DepartmentService {
    List<Department> findAll();
    Department findById(int id);
    int insert(Department department);
    int update(Department department);
    int deleteById(int id);
}
```

简单模块里，Service 和 Mapper 很像，这是正常的。

### 第 5 步：Service 实现类

```java
@Service
public class DepartmentServiceImpl implements DepartmentService {

    @Autowired
    private DepartmentMapper departmentMapper;

    @Override
    public List<Department> findAll() {
        return departmentMapper.findAll();
    }

    @Override
    @Transactional
    public int insert(Department department) {
        return departmentMapper.insert(department);
    }
}
```

记法：

```text
类上写 @Service
需要 Mapper 就 @Autowired
增删改写 @Transactional
```

为什么查询一般不写 `@Transactional`？

```text
查询不改数据库，通常不需要事务。
增删改会改变数据库，失败时需要回滚，所以加事务更稳。
```

### 第 6 步：Controller

Controller 管页面请求。

```java
@Controller
@RequestMapping("/departments")
public class DepartmentController {

    @Autowired
    private DepartmentService departmentService;

    @RequestMapping(method = RequestMethod.GET)
    public String list(HttpServletRequest req) {
        req.setAttribute("departments", departmentService.findAll());
        return "department-list";
    }
}
```

记法：

```text
类上 @Controller
类上 @RequestMapping("/模块路径")
方法上 @RequestMapping(method = RequestMethod.GET/POST)
查数据后 req.setAttribute(...)
最后 return JSP 名字
```

### 第 7 步：JSP 页面

JSP 负责展示数据。

Controller 放：

```java
req.setAttribute("departments", departments);
```

JSP 取：

```jsp
${departments}
```

或者用 JSTL 循环：

```jsp
<c:forEach items="${departments}" var="department">
    ${department.name}
</c:forEach>
```

记法：

```text
Controller 放什么名字，JSP 就用什么名字取。
```

## 用 CRUD 记住 SSM 写法

### 查询列表

Controller：

```java
@RequestMapping(method = RequestMethod.GET)
public String list(HttpServletRequest req) {
    req.setAttribute("departments", departmentService.findAll());
    return "department-list";
}
```

Service：

```java
public List<Department> findAll() {
    return departmentMapper.findAll();
}
```

Mapper：

```java
List<Department> findAll();
```

XML：

```xml
<select id="findAll" resultType="Department">
    SELECT id, name, description FROM departments ORDER BY id DESC
</select>
```

### 新增

Controller：

```java
@RequestMapping(method = RequestMethod.POST)
public String save(HttpServletRequest req) {
    Department department = new Department();
    department.setName(req.getParameter("name"));
    department.setDescription(req.getParameter("description"));
    departmentService.insert(department);
    return "redirect:/departments";
}
```

Service：

```java
@Transactional
public int insert(Department department) {
    return departmentMapper.insert(department);
}
```

Mapper：

```java
int insert(Department department);
```

XML：

```xml
<insert id="insert" parameterType="Department">
    INSERT INTO departments (name, description)
    VALUES (#{name}, #{description})
</insert>
```

### 修改

Controller：

```java
department.setId(parseId(req.getParameter("id")));
departmentService.update(department);
return "redirect:/departments";
```

XML：

```xml
<update id="update" parameterType="Department">
    UPDATE departments
    SET name = #{name},
        description = #{description}
    WHERE id = #{id}
</update>
```

### 删除

Controller：

```java
departmentService.deleteById(parseId(req.getParameter("id")));
return "redirect:/departments";
```

XML：

```xml
<delete id="deleteById">
    DELETE FROM departments
    WHERE id = #{id}
</delete>
```

## 你应该怎么记住 MVC 到 SSM 的映射

直接背这张表。

| 老 MVC 里的东西 | SSM 里的东西 | 记忆方式 |
|---|---|---|
| `@WebServlet` | `@Controller` + `@RequestMapping` | URL 不再绑 Servlet，改绑 Controller 方法 |
| `doGet/doPost` | 普通方法 + `RequestMethod.GET/POST` | 请求方法由注解决定 |
| `new Dao()` | `@Autowired Service` | 对象由 Spring 注入 |
| `DAO` | `Mapper接口 + Mapper.xml` | Java 写方法，XML 写 SQL |
| `DBUtil.getConnection()` | `dataSource` + `SqlSessionFactory` | 连接由 Spring/MyBatis 管 |
| `PreparedStatement` | `#{}` | 参数绑定交给 MyBatis |
| `ResultSet` 手动封装 | `resultType` 自动封装 | 查询结果自动变对象 |
| `forward("xxx.jsp")` | `return "xxx"` | 视图解析器自动拼 JSP |
| `sendRedirect("xxx")` | `return "redirect:/xxx"` | 重定向写在返回值里 |
| `Filter` | `Interceptor` | 登录权限校验迁到 Spring MVC |
| 手动事务 | `@Transactional` | 事务交给 Spring |

再压缩成一句话：

```text
Servlet 变 Controller，DAO 变 Mapper，中间加 Service，连接和事务交给 Spring。
```

## SSM 文件命名套路

以 `Department` 为例：

```text
实体类：
Department.java

控制层：
DepartmentController.java

业务接口：
DepartmentService.java

业务实现：
DepartmentServiceImpl.java

Mapper 接口：
DepartmentMapper.java

Mapper SQL：
DepartmentMapper.xml

列表页面：
department-list.jsp

表单页面：
department-form.jsp
```

换成医生模块就是：

```text
Doctor.java
DoctorController.java
DoctorService.java
DoctorServiceImpl.java
DoctorMapper.java
DoctorMapper.xml
doctor-list.jsp
doctor-form.jsp
```

换成药品模块就是：

```text
Medicine.java
MedicineController.java
MedicineService.java
MedicineServiceImpl.java
MedicineMapper.java
MedicineMapper.xml
medicine-list.jsp
medicine-form.jsp
```

这就是 SSM 项目的规律。

## 写 SSM 模块时的顺序

建议固定顺序，不要乱跳：

```text
1. 看数据库表字段
2. 写 model 实体类
3. 写 mapper 接口
4. 写 mapper XML
5. 写 service 接口
6. 写 serviceImpl
7. 写 controller
8. 写 JSP
9. 启动测试列表、新增、修改、删除
```

为什么这个顺序好？

```text
数据库是源头；
Mapper 负责 SQL；
Service 调 Mapper；
Controller 调 Service；
JSP 展示 Controller 给的数据。
```

它是从底层到上层，一层一层搭起来。

## 反过来看请求怎么跑

写代码时从底层往上写。

用户访问时从上层往下跑：

```text
JSP/浏览器
  -> Controller
  -> Service
  -> Mapper
  -> XML SQL
  -> 数据库
```

数据库结果回来：

```text
数据库
  -> MyBatis 封装成对象
  -> Mapper 返回
  -> Service 返回
  -> Controller 放进 request
  -> JSP 显示
```

这条链路一定要背熟。

## 初学者最容易错的地方

### 1. Mapper 接口方法名和 XML 的 id 不一致

错误例子：

```java
List<Department> findAll();
```

```xml
<select id="listAll" resultType="Department">
```

这样 MyBatis 找不到 SQL。

正确：

```xml
<select id="findAll" resultType="Department">
```

### 2. XML 的 namespace 写错

错误：

```xml
<mapper namespace="hospital.dao.DepartmentDao">
```

正确：

```xml
<mapper namespace="hospital.mapper.DepartmentMapper">
```

namespace 必须是 Mapper 接口全名。

### 3. Controller 返回值多写 `.jsp`

本项目视图解析器已经配置了后缀：

```xml
<property name="suffix" value=".jsp"/>
```

所以 Controller 应该写：

```java
return "department-list";
```

不要写：

```java
return "department-list.jsp";
```

否则可能拼成：

```text
/department-list.jsp.jsp
```

### 4. 忘记加 `@Service`

如果实现类没有：

```java
@Service
```

Spring 就不会创建这个对象，Controller 里的 `@Autowired` 就可能注入失败。

### 5. 忘记 Mapper XML 放到正确目录

本项目配置：

```xml
<property name="mapperLocations" value="classpath:mapper/*.xml"/>
```

所以 XML 应该放在：

```text
src/main/resources/mapper/
```

### 6. `#{}` 写错属性名

如果实体类是：

```java
private String description;
```

XML 里就写：

```xml
#{description}
```

不要写数据库字段以外的乱名。

### 7. 增删改忘记事务

简单单表操作忘了事务不一定马上爆炸，但习惯上 Service 的增删改应该加：

```java
@Transactional
```

尤其是一个业务方法里有多条 SQL 时必须加。

## MVC 和 SSM 的本质区别

老 MVC 不是错，它只是更原始。

老 MVC 的优点：

```text
结构简单；
文件少；
初学者能直接看到请求、SQL、连接怎么执行。
```

老 MVC 的缺点：

```text
Servlet 代码容易变长；
每个 DAO 都有大量重复 JDBC 代码；
对象都自己 new，不方便统一管理；
事务不好统一控制；
项目一大就容易乱。
```

SSM 的优点：

```text
分层更清楚；
重复代码少；
SQL 和 Java 逻辑分离；
对象交给 Spring 管；
事务交给 Spring 管；
大项目更容易维护。
```

SSM 的缺点：

```text
配置文件更多；
刚学时链路更长；
报错时要检查 Controller、Service、Mapper、XML、配置多个地方。
```

所以你应该这样理解：

```text
MVC 适合入门理解 Web 项目怎么跑。
SSM 适合正式项目，让代码更规范、更好维护。
```

## 这个项目里的 SSM 分层口诀

可以直接背：

```text
页面请求找 Controller，
业务处理找 Service，
数据库操作找 Mapper，
SQL 语句写 XML，
对象创建交 Spring，
事务回滚靠注解。
```

再短一点：

```text
C 调 S，S 调 M，M 找 XML。
```

解释：

```text
C = Controller
S = Service
M = Mapper
XML = MyBatis SQL
```

## 如果让你现场写一个 SSM 功能

你可以按下面模板回答或写代码。

### 第一步：实体类

```java
public class Xxx {
    private Integer id;
    // 其他字段
}
```

### 第二步：Mapper 接口

```java
public interface XxxMapper {
    List<Xxx> findAll();
    Xxx findById(@Param("id") int id);
    int insert(Xxx xxx);
    int update(Xxx xxx);
    int deleteById(@Param("id") int id);
}
```

### 第三步：Mapper XML

```xml
<mapper namespace="hospital.mapper.XxxMapper">
    <select id="findAll" resultType="Xxx">
        SELECT ...
        FROM xxx_table
        ORDER BY id DESC
    </select>
</mapper>
```

### 第四步：Service

```java
public interface XxxService {
    List<Xxx> findAll();
    Xxx findById(int id);
    int insert(Xxx xxx);
    int update(Xxx xxx);
    int deleteById(int id);
}
```

### 第五步：ServiceImpl

```java
@Service
public class XxxServiceImpl implements XxxService {

    @Autowired
    private XxxMapper xxxMapper;

    public List<Xxx> findAll() {
        return xxxMapper.findAll();
    }

    @Transactional
    public int insert(Xxx xxx) {
        return xxxMapper.insert(xxx);
    }
}
```

### 第六步：Controller

```java
@Controller
@RequestMapping("/xxxs")
public class XxxController {

    @Autowired
    private XxxService xxxService;

    @RequestMapping(method = RequestMethod.GET)
    public String list(HttpServletRequest req) {
        req.setAttribute("xxxs", xxxService.findAll());
        return "xxx-list";
    }

    @RequestMapping(method = RequestMethod.POST)
    public String save(HttpServletRequest req) {
        Xxx xxx = new Xxx();
        // 从 req.getParameter(...) 取值
        xxxService.insert(xxx);
        return "redirect:/xxxs";
    }
}
```

## 最后用一张图记住

```text
老 MVC：

Browser
  |
  v
Servlet
  |
  v
DAO
  |
  v
DBUtil + JDBC
  |
  v
MySQL
```

```text
SSM：

Browser
  |
  v
DispatcherServlet
  |
  v
Controller
  |
  v
Service
  |
  v
Mapper 接口
  |
  v
Mapper XML
  |
  v
MyBatis + DataSource
  |
  v
MySQL
```

如果你只能记一句，就记：

```text
SSM 不是推翻 MVC，而是把 MVC 里 Servlet、DAO、JDBC 的重复工作交给 Spring MVC、Spring、MyBatis 来做。
```

