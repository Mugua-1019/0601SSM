<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="hospital.model.Medicine" %>
<%@ page import="hospital.model.MedicineDispense" %>
<%@ page import="java.util.List" %>
<%
    List<Medicine> medicines = (List<Medicine>) request.getAttribute("medicines");
    List<MedicineDispense> dispenses = (List<MedicineDispense>) request.getAttribute("dispenses");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>药品发放</title>
    <link href="css/style.css" rel="stylesheet" type="text/css" />
    <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <script type="text/javascript">$(function(){ $('tbody tr:odd').addClass("trLight"); });</script>
    <style type="text/css">body { background:#FFF }</style>
</head>
<body>
<div id="contentWrap">
    <div id="widget table-widget">
        <div class="pageTitle">药品发放</div>
        <% if (error != null) { %><p style="color:red;margin-left:20px;"><%= error %></p><% } %>
        <div class="pageColumn">
            <div class="pageButton">
                <a href="dispenses?action=new"><img src="images/t01.png" title="新增发放"/></a>
                <span>可发放药品</span>
            </div>
            <table>
                <thead>
                <th width="">药品ID</th>
                <th width="">药品名称</th>
                <th width="">规格</th>
                <th width="">库存数量</th>
                <th width="">售价</th>
                <th width="10%">操作</th>
                <th width="10%">操作</th>
                </thead>
                <tbody>
                <% if (medicines == null || medicines.isEmpty()) { %>
                <tr><td colspan="6">暂无药品数据</td></tr>
                <% } else { for (Medicine medicine : medicines) { %>
                <tr>
                    <td><%= medicine.getId() %></td>
                    <td><%= medicine.getName() == null ? "" : medicine.getName() %></td>
                    <td><%= medicine.getSpecification() == null ? "" : medicine.getSpecification() %></td>
                    <td><%= medicine.getStock() %></td>
                    <td><%= medicine.getPrice() == null ? "0" : medicine.getPrice() %></td>
                    <td><a href="dispenses?action=new&medicineId=<%= medicine.getId() %>">发放</a></td>
                </tr>
                <% }} %>
                </tbody>
            </table>
        </div>
        <div class="pageColumn" style="margin-top:20px;">
            <div class="pageButton"><span>发放记录</span></div>
            <table>
                <thead>
                <th width="">记录ID</th>
                <th width="">患者姓名</th>
                <th width="">药品名称</th>
                <th width="">数量</th>
                <th width="">药剂师</th>
                <th width="">发放时间</th>
                </thead>
                <tbody>
                <% if (dispenses == null || dispenses.isEmpty()) { %>
                <tr><td colspan="6">暂无发放记录</td></tr>
                <% } else { for (MedicineDispense dispense : dispenses) { %>
                <tr>
                    <td><%= dispense.getId() %></td>
                    <td><%= dispense.getPatientName() == null ? "" : dispense.getPatientName() %></td>
                    <td><%= dispense.getMedicineName() == null ? "" : dispense.getMedicineName() %></td>
                    <td><%= dispense.getQuantity() %></td>
                    <td><%= dispense.getPharmacistName() == null ? "" : dispense.getPharmacistName() %></td>
                    <td><%= dispense.getDispensedAt() == null ? "" : dispense.getDispensedAt() %></td>
                    <td>
                        <% if ("待发放".equals(dispense.getPharmacistName())) { %>
                        <a href="dispenses?action=release&id=<%= dispense.getId() %>">发药</a>
                        <% } %>
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
