<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="hospital.model.Department" %>
<%
    Department department = (Department) request.getAttribute("department");
    String error = (String) request.getAttribute("error");
    boolean edit = department != null && department.getId() > 0;
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%= edit ? "科室修改" : "科室添加" %></title>
    <link href="css/style.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <style type="text/css">body { background:#FFF }</style>
</head>
<body>
<form method="post" action="departments" name="ThisForm">
    <input type="hidden" name="action" value="<%= edit ? "update" : "add" %>" />
    <% if (edit) { %><input type="hidden" name="id" value="<%= department.getId() %>" /><% } %>
    <div id="contentWrap">
        <div id="widget table-widget">
            <div class="pageTitle"><%= edit ? "科室修改" : "科室添加" %></div>
            <% if (error != null) { %>
            <p style="color:red;margin-left:20px;"><%= error %></p>
            <% } %>
            <div class="pageInfo">
                <table>
                    <tr>
                        <td width="20%" align="right">科室名称</td>
                        <td width="20%"><input type="text" name="name" value="<%= department == null || department.getName() == null ? "" : department.getName() %>" /></td>
                        <td width="10%" align="right">科室说明</td>
                        <td width="50%"><input type="text" name="description" value="<%= department == null || department.getDescription() == null ? "" : department.getDescription() %>" /></td>
                    </tr>
                    <tr>
                        <td colspan="4" align="center">
                            <input type="submit" value="确定" />
                            <input type="button" value="返回" onclick="window.location.href='departments'" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</form>
</body>
</html>
