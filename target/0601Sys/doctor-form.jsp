<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="hospital.model.Department" %>
<%@ page import="hospital.model.Doctor" %>
<%@ page import="java.util.List" %>
<%
    Doctor doctor = (Doctor) request.getAttribute("doctor");
    List<Department> departments = (List<Department>) request.getAttribute("departments");
    String currentDepartment = doctor == null || doctor.getDepartment() == null ? "" : doctor.getDepartment();
    String error = (String) request.getAttribute("error");
    boolean edit = doctor != null && doctor.getId() > 0;
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%= edit ? "医生修改" : "医生添加" %></title>
    <link href="css/style.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <style type="text/css">body { background:#FFF }</style>
</head>
<body>
<form method="post" action="doctors" name="ThisForm">
    <input type="hidden" name="action" value="<%= edit ? "update" : "add" %>" />
    <% if (edit) { %><input type="hidden" name="id" value="<%= doctor.getId() %>" /><% } %>
    <div id="contentWrap">
        <div id="widget table-widget">
            <div class="pageTitle"><%= edit ? "医生修改" : "医生添加" %></div>
            <% if (error != null) { %><p style="color:red;margin-left:20px;"><%= error %></p><% } %>
            <div class="pageInfo">
                <table>
                    <tr>
                        <td width="20%" align="right">医生姓名</td>
                        <td width="20%"><input type="text" name="name" value="<%= doctor == null || doctor.getName() == null ? "" : doctor.getName() %>" /></td>
                        <td width="10%" align="right">所属科室</td>
                        <td width="50%">
                            <select name="department">
                                <option value="">--select--</option>
                                <% if (departments != null) { for (Department department : departments) {
                                    String departmentName = department.getName() == null ? "" : department.getName();
                                %>
                                <option value="<%= departmentName %>" <%= departmentName.equals(currentDepartment) ? "selected" : "" %>><%= departmentName %></option>
                                <% }} %>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">职称</td>
                        <td><input type="text" name="title" value="<%= doctor == null || doctor.getTitle() == null ? "" : doctor.getTitle() %>" /></td>
                        <td align="right">联系电话</td>
                        <td><input type="text" name="phone" value="<%= doctor == null || doctor.getPhone() == null ? "" : doctor.getPhone() %>" /></td>
                    </tr>
                    <tr>
                        <td align="right">邮箱</td>
                        <td><input type="text" name="email" value="<%= doctor == null || doctor.getEmail() == null ? "" : doctor.getEmail() %>" /></td>
                        <td></td><td></td>
                    </tr>
                    <tr>
                        <td colspan="4" align="center">
                            <input type="submit" value="确定" />
                            <input type="button" value="返回" onclick="window.location.href='doctors'" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</form>
</body>
</html>
