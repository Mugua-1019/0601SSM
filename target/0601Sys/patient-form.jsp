<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="hospital.model.Patient" %>
<%
    Patient patient = (Patient) request.getAttribute("patient");
    String error = (String) request.getAttribute("error");
    boolean edit = patient != null && patient.getId() > 0;
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%= edit ? "患者修改" : "患者添加" %></title>
    <link href="css/style.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <style type="text/css">body { background:#FFF }</style>
</head>
<body>
<form method="post" action="patients" name="ThisForm">
    <input type="hidden" name="action" value="<%= edit ? "update" : "add" %>" />
    <% if (edit) { %><input type="hidden" name="id" value="<%= patient.getId() %>" /><% } %>
    <div id="contentWrap">
        <div id="widget table-widget">
            <div class="pageTitle"><%= edit ? "患者修改" : "患者添加" %></div>
            <% if (error != null) { %><p style="color:red;margin-left:20px;"><%= error %></p><% } %>
            <div class="pageInfo">
                <table>
                    <tr>
                        <td width="20%" align="right">患者名称</td>
                        <td width="20%"><input type="text" name="name" value="<%= patient == null || patient.getName() == null ? "" : patient.getName() %>" /></td>
                        <td width="10%" align="right">电话</td>
                        <td width="50%"><input type="text" name="phone" value="<%= patient == null || patient.getPhone() == null ? "" : patient.getPhone() %>" /></td>
                    </tr>
                    <tr>
                        <td align="right">年龄</td>
                        <td><input type="text" name="age" value="<%= patient == null ? 0 : patient.getAge() %>" /></td>
                        <td align="right">性别</td>
                        <td><input type="text" name="gender" value="<%= patient == null || patient.getGender() == null ? "" : patient.getGender() %>" /></td>
                    </tr>
                    <tr>
                        <td align="right">地址</td>
                        <td><input type="text" name="address" value="<%= patient == null || patient.getAddress() == null ? "" : patient.getAddress() %>" /></td>
                        <td></td><td></td>
                    </tr>
                    <tr>
                        <td colspan="4" align="center">
                            <input type="submit" value="确定" />
                            <input type="button" value="返回" onclick="window.location.href='patients'" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</form>
</body>
</html>
