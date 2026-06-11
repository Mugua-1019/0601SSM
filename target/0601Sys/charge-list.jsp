<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="hospital.model.Charge" %>
<%@ page import="java.util.List" %>
<%
    List<Charge> charges = (List<Charge>) request.getAttribute("charges");
    String patientName = (String) request.getAttribute("patientName");
    String itemName = (String) request.getAttribute("itemName");
    String status = (String) request.getAttribute("status");
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>缴费明细查询</title>
    <link href="css/style.css" rel="stylesheet" type="text/css" />
    <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <script type="text/javascript">$(function(){ $('tbody tr:odd').addClass("trLight"); });</script>
    <style type="text/css">body { background:#FFF }</style>
</head>
<body>
<div id="contentWrap">
    <div id="widget table-widget">
        <div class="pageTitle">缴费明细查询</div>
        <form method="get" action="charges">
            <div class="querybody">
                <ul class="seachform">
                    <li><label>患者姓名</label><input name="patientName" type="text" class="scinput" value="<%= patientName == null ? "" : patientName %>" /></li>
                    <li><label>收费项目</label><input name="itemName" type="text" class="scinput" value="<%= itemName == null ? "" : itemName %>" /></li>
                    <li><label>状态</label><input name="status" type="text" class="scinput" value="<%= status == null ? "" : status %>" /></li>
                    <li><label>&nbsp;</label><input type="submit" class="scbtn" value="查询"/></li>
                </ul>
            </div>
        </form>
        <div class="pageColumn">
            <div class="pageButton">
                <a href="charges?action=new"><img src="images/t01.png" title="新增"/></a>
                <span>缴费明细列表</span>
            </div>
            <table>
                <thead>
                <th width="">费用ID</th>
                <th width="">患者姓名</th>
                <th width="">收费项目</th>
                <th width="">金额</th>
                <th width="">状态</th>
                <th width="10%">操作</th>
                </thead>
                <tbody>
                <% if (charges == null || charges.isEmpty()) { %>
                <tr><td colspan="6">暂无费用数据</td></tr>
                <% } else { for (Charge charge : charges) { %>
                <tr>
                    <td><%= charge.getId() %></td>
                    <td><%= charge.getPatientName() == null ? "" : charge.getPatientName() %></td>
                    <td><%= charge.getItemName() == null ? "" : charge.getItemName() %></td>
                    <td><%= charge.getAmount() == null ? "0" : charge.getAmount() %></td>
                    <td><%= charge.getStatus() == null ? "" : charge.getStatus() %></td>
                    <td>
                        <a href="charges?action=edit&id=<%= charge.getId() %>"><img src="images/icon/edit.png" width="16" height="16" /></a>
                        <a href="charges?action=delete&id=<%= charge.getId() %>" onclick="return confirm('确认删除该费用记录吗？');"><img src="images/icon/del.png" width="16" height="16" /></a>
                    </td>
                </tr>
                <% }} %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
