<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="hospital.model.Registration" %>
<%@ page import="java.util.List" %>
<%
    List<Registration> registrations = (List<Registration>) request.getAttribute("registrations");
    String patientName = (String) request.getAttribute("patientName");
    String departmentName = (String) request.getAttribute("departmentName");
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>挂号管理</title>
    <link href="css/style.css" rel="stylesheet" type="text/css" />
    <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <script type="text/javascript">$(function(){ $('tbody tr:odd').addClass("trLight"); });</script>
    <style type="text/css">body { background:#FFF }</style>
</head>
<body>
<div id="contentWrap">
    <div id="widget table-widget">
        <div class="pageTitle">挂号管理</div>
        <form method="get" action="registrations">
            <div class="querybody">
                <ul class="seachform">
                    <li><label>患者姓名</label><input name="patientName" type="text" class="scinput" value="<%= patientName == null ? "" : patientName %>" /></li>
                    <li><label>科室</label><input name="departmentName" type="text" class="scinput" value="<%= departmentName == null ? "" : departmentName %>" /></li>
                    <li><label>&nbsp;</label><input type="submit" class="scbtn" value="查询"/></li>
                </ul>
            </div>
        </form>
        <div class="pageColumn">
            <div class="pageButton">
                <a href="registrations?action=new"><img src="images/t01.png" title="新增"/></a>
                <span>挂号列表</span>
            </div>
            <table>
                <thead>
                <th width="">挂号ID</th>
                <th width="">患者姓名</th>
                <th width="">科室</th>
                <th width="">医生</th>
                <th width="">挂号费</th>
                <th width="">状态</th>
                <th width="10%">操作</th>
                </thead>
                <tbody>
                <% if (registrations == null || registrations.isEmpty()) { %>
                <tr><td colspan="7">暂无挂号数据</td></tr>
                <% } else { for (Registration registration : registrations) { %>
                <tr>
                    <td><%= registration.getId() %></td>
                    <td><%= registration.getPatientName() == null ? "" : registration.getPatientName() %></td>
                    <td><%= registration.getDepartmentName() == null ? "" : registration.getDepartmentName() %></td>
                    <td><%= registration.getDoctorName() == null ? "" : registration.getDoctorName() %></td>
                    <td><%= registration.getFee() == null ? "0" : registration.getFee() %></td>
                    <td><%= registration.getStatus() == null ? "" : registration.getStatus() %></td>
                    <td>
                        <a href="registrations?action=edit&id=<%= registration.getId() %>"><img src="images/icon/edit.png" width="16" height="16" /></a>
                        <a href="registrations?action=delete&id=<%= registration.getId() %>" onclick="return confirm('确认删除该挂号记录吗？');"><img src="images/icon/del.png" width="16" height="16" /></a>
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
