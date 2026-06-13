<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="hospital.model.Doctor" %>
<%@ page import="java.util.List" %>
<%
    List<Doctor> doctors = (List<Doctor>) request.getAttribute("doctors");
    String name = (String) request.getAttribute("name");
    String department = (String) request.getAttribute("department");
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>医生管理</title>
    <link href="css/style.css" rel="stylesheet" type="text/css" />
    <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <script type="text/javascript">$(function(){ $('tbody tr:odd').addClass("trLight"); });</script>
    <style type="text/css">body { background:#FFF }</style>
</head>
<body>
<div id="contentWrap">
    <div id="widget table-widget">
        <div class="pageTitle">医生管理</div>
        <form method="get" action="doctors">
            <div class="querybody">
                <ul class="seachform">
                    <li><label>医生名称</label><input name="name" type="text" class="scinput" value="<%= name == null ? "" : name %>" /></li>
                    <li><label>科室</label><input name="department" type="text" class="scinput" value="<%= department == null ? "" : department %>" /></li>
                    <li><label>&nbsp;</label><input type="submit" class="scbtn" value="查询"/></li>
                </ul>
            </div>
        </form>
        <div class="pageColumn">
            <div class="pageButton">
                <a href="doctors?action=new"><img src="images/t01.png" title="新增"/></a>
                <span>医生列表</span>
            </div>
            <table>
                <thead>
                <th width="">医生ID</th>
                <th width="">医生名</th>
                <th width="">所属科室</th>
                <th width="">职称</th>
                <th width="">联系电话</th>
                <th width="">邮箱</th>
                <th width="10%">操作</th>
                </thead>
                <tbody>
                <% if (doctors == null || doctors.isEmpty()) { %>
                <tr><td colspan="7">暂无医生数据</td></tr>
                <% } else { for (Doctor doctor : doctors) { %>
                <tr>
                    <td><%= doctor.getId() %></td>
                    <td><%= doctor.getName() %></td>
                    <td><%= doctor.getDepartment() == null ? "" : doctor.getDepartment() %></td>
                    <td><%= doctor.getTitle() == null ? "" : doctor.getTitle() %></td>
                    <td><%= doctor.getPhone() == null ? "" : doctor.getPhone() %></td>
                    <td><%= doctor.getEmail() == null ? "" : doctor.getEmail() %></td>
                    <td>
                        <a href="doctors?action=edit&id=<%= doctor.getId() %>"><img src="images/icon/edit.png" width="16" height="16" /></a>
                        <a href="doctors?action=delete&id=<%= doctor.getId() %>" onclick="return confirm('确认删除该医生吗？');"><img src="images/icon/del.png" width="16" height="16" /></a>
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
