<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="hospital.model.Medicine" %>
<%
    Medicine medicine = (Medicine) request.getAttribute("medicine");
    String error = (String) request.getAttribute("error");
    boolean edit = medicine != null && medicine.getId() > 0;
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%= edit ? "药品修改" : "药品添加" %></title>
    <link href="css/style.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <style type="text/css">body { background:#FFF }</style>
</head>
<body>
<form method="post" action="medicines" name="ThisForm">
    <input type="hidden" name="action" value="<%= edit ? "update" : "add" %>" />
    <% if (edit) { %><input type="hidden" name="id" value="<%= medicine.getId() %>" /><% } %>
    <div id="contentWrap">
        <div id="widget table-widget">
            <div class="pageTitle"><%= edit ? "药品修改" : "药品添加" %></div>
            <% if (error != null) { %><p style="color:red;margin-left:20px;"><%= error %></p><% } %>
            <div class="pageInfo">
                <table>
                    <tr>
                        <td width="20%" align="right">药品名</td>
                        <td width="20%"><input type="text" name="name" value="<%= medicine == null || medicine.getName() == null ? "" : medicine.getName() %>" /></td>
                        <td width="10%" align="right">规格</td>
                        <td width="50%"><input type="text" name="specification" value="<%= medicine == null || medicine.getSpecification() == null ? "" : medicine.getSpecification() %>" /></td>
                    </tr>
                    <tr>
                        <td align="right">库存数量</td>
                        <td><input type="text" name="stock" value="<%= medicine == null ? 0 : medicine.getStock() %>" /></td>
                        <td align="right">售价</td>
                        <td><input type="text" name="price" value="<%= medicine == null || medicine.getPrice() == null ? "0" : medicine.getPrice() %>" /></td>
                    </tr>
                    <tr>
                        <td colspan="4" align="center">
                            <input type="submit" value="确定" />
                            <input type="button" value="返回" onclick="window.location.href='medicines'" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</form>
</body>
</html>
