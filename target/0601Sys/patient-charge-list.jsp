<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="hospital.model.Charge" %>
<%@ page import="java.util.List" %>
<%
    List<Charge> charges = (List<Charge>) request.getAttribute("charges");
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>我的费用</title>
    <link href="css/style.css" rel="stylesheet" type="text/css" />
    <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <script type="text/javascript">$(function(){ $('tbody tr:odd').addClass("trLight"); });</script>
    <style type="text/css">body { background:#FFF }</style>
</head>
<body>
<div id="contentWrap">
    <div id="widget table-widget">
        <div class="pageTitle">我的费用</div>
        <div class="pageColumn">
            <div class="pageButton"><span>费用记录</span></div>
            <table>
                <thead>
                <th width="">费用ID</th>
                <th width="">收费项目</th>
                <th width="">金额</th>
                <th width="">状态</th>
                </thead>
                <tbody>
                <% if (charges == null || charges.isEmpty()) { %>
                <tr><td colspan="4">暂无费用记录</td></tr>
                <% } else { for (Charge charge : charges) { %>
                <tr>
                    <td><%= charge.getId() %></td>
                    <td><%= charge.getItemName() == null ? "" : charge.getItemName() %></td>
                    <td><%= charge.getAmount() == null ? "0" : charge.getAmount() %></td>
                    <td><%= charge.getStatus() == null ? "" : charge.getStatus() %></td>
                </tr>
                <% }} %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
