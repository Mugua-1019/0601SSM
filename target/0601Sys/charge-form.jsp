<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="hospital.model.Charge" %>
<%
    Charge charge = (Charge) request.getAttribute("charge");
    String error = (String) request.getAttribute("error");
    boolean edit = charge != null && charge.getId() > 0;
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%= edit ? "费用修改" : "费用添加" %></title>
    <link href="css/style.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <style type="text/css">body { background:#FFF }</style>
</head>
<body>
<form method="post" action="charges" name="ThisForm">
    <input type="hidden" name="action" value="<%= edit ? "update" : "add" %>" />
    <% if (edit) { %><input type="hidden" name="id" value="<%= charge.getId() %>" /><% } %>
    <div id="contentWrap">
        <div id="widget table-widget">
            <div class="pageTitle"><%= edit ? "费用修改" : "费用添加" %></div>
            <% if (error != null) { %><p style="color:red;margin-left:20px;"><%= error %></p><% } %>
            <div class="pageInfo">
                <table>
                    <tr>
                        <td width="20%" align="right">患者姓名</td>
                        <td width="20%"><input type="text" name="patientName" value="<%= charge == null || charge.getPatientName() == null ? "" : charge.getPatientName() %>" /></td>
                        <td width="10%" align="right">收费项目</td>
                        <td width="50%"><input type="text" name="itemName" value="<%= charge == null || charge.getItemName() == null ? "" : charge.getItemName() %>" /></td>
                    </tr>
                    <tr>
                        <td align="right">金额</td>
                        <td><input type="text" name="amount" value="<%= charge == null || charge.getAmount() == null ? "0" : charge.getAmount() %>" /></td>
                        <td align="right">状态</td>
                        <td><input type="text" name="status" value="<%= charge == null || charge.getStatus() == null ? "" : charge.getStatus() %>" /></td>
                    </tr>
                    <tr>
                        <td colspan="4" align="center">
                            <input type="submit" value="确定" />
                            <input type="button" value="返回" onclick="window.location.href='charges'" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</form>
</body>
</html>
