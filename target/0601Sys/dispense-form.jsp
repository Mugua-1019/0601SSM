<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="hospital.model.Medicine" %>
<%@ page import="java.util.List" %>
<%
    Medicine selectedMedicine = (Medicine) request.getAttribute("medicine");
    List<Medicine> medicines = (List<Medicine>) request.getAttribute("medicines");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>发放药品</title>
    <link href="css/style.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <style type="text/css">body { background:#FFF }</style>
</head>
<body>
<form method="post" action="dispenses" name="ThisForm">
    <div id="contentWrap">
        <div id="widget table-widget">
            <div class="pageTitle">发放药品</div>
            <% if (error != null) { %><p style="color:red;margin-left:20px;"><%= error %></p><% } %>
            <div class="pageInfo">
                <table>
                    <tr>
                        <td width="20%" align="right">患者姓名</td>
                        <td width="20%"><input type="text" name="patientName" value="<%= request.getParameter("patientName") == null ? "" : request.getParameter("patientName") %>" /></td>
                        <td width="10%" align="right">药品</td>
                        <td width="50%">
                            <select name="medicineId">
                                <% if (medicines != null) { for (Medicine medicine : medicines) { %>
                                <option value="<%= medicine.getId() %>" <%= selectedMedicine != null && selectedMedicine.getId() == medicine.getId() ? "selected=\"selected\"" : "" %>>
                                    <%= medicine.getName() %>（库存：<%= medicine.getStock() %>）
                                </option>
                                <% }} %>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">发放数量</td>
                        <td><input type="text" name="quantity" value="<%= request.getParameter("quantity") == null ? "1" : request.getParameter("quantity") %>" /></td>
                        <td align="right">当前库存</td>
                        <td><%= selectedMedicine == null ? "请选择药品" : selectedMedicine.getStock() %></td>
                    </tr>
                    <tr>
                        <td colspan="4" align="center">
                            <input type="submit" value="确认发放" />
                            <input type="button" value="返回" onclick="window.location.href='dispenses'" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</form>
</body>
</html>
