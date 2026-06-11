<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="hospital.model.Patient" %>
<%@ page import="java.util.List" %>
<%
    List<Patient> patients = (List<Patient>) request.getAttribute("patients");
    String keyword = (String) request.getAttribute("keyword");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>患者管理</title>
    <link href="css/style.css" rel="stylesheet" type="text/css" />
    <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <script type="text/javascript">$(function(){ $('tbody tr:odd').addClass("trLight"); });</script>
    <style type="text/css">body { background:#FFF }</style>
</head>
<body>
<div id="contentWrap">
    <div id="widget table-widget">
        <div class="pageTitle">患者管理</div>
        <form method="get" action="patients">
            <div class="querybody">
                <ul class="seachform">
                    <li><label>患者名称</label><input name="keyword" type="text" class="scinput" value="<%= keyword == null ? "" : keyword %>" /></li>
                    <li><label>&nbsp;</label><input type="submit" class="scbtn" value="查询"/></li>
                </ul>
            </div>
        </form>
        <% if (error != null) { %><p style="color:red;margin-left:20px;"><%= error %></p><% } %>
        <div class="pageColumn">
            <div class="pageButton">
                <a href="patients?action=new"><img src="images/t01.png" title="新增"/></a>
                <span>患者列表</span>
            </div>
            <table>
                <thead>
                <th width="">患者ID</th>
                <th width="">患者名称</th>
                <th width="">性别</th>
                <th width="">年龄</th>
                <th width="">电话</th>
                <th width="">地址</th>
                <th width="10%">操作</th>
                </thead>
                <tbody>
                <% if (patients == null || patients.isEmpty()) { %>
                <tr><td colspan="7">暂无患者数据</td></tr>
                <% } else { for (Patient patient : patients) { %>
                <tr>
                    <td><%= patient.getId() %></td>
                    <td><%= patient.getName() %></td>
                    <td><%= patient.getGender() == null ? "" : patient.getGender() %></td>
                    <td><%= patient.getAge() %></td>
                    <td><%= patient.getPhone() == null ? "" : patient.getPhone() %></td>
                    <td><%= patient.getAddress() == null ? "" : patient.getAddress() %></td>
                    <td>
                        <a href="patients?action=edit&id=<%= patient.getId() %>"><img src="images/icon/edit.png" width="16" height="16" /></a>
                        <a href="patients?action=delete&id=<%= patient.getId() %>" onclick="return confirm('确认删除该患者吗？');"><img src="images/icon/del.png" width="16" height="16" /></a>
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
