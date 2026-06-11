<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="hospital.model.Registration" %>
<%@ page import="java.util.List" %>
<%@ page import="java.net.URLEncoder" %>
<%
    List<Registration> registrations = (List<Registration>) request.getAttribute("registrations");
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>待诊挂号</title>
    <link href="css/style.css" rel="stylesheet" type="text/css" />
    <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <script type="text/javascript">$(function(){ $('tbody tr:odd').addClass("trLight"); });</script>
    <style type="text/css">body { background:#FFF }</style>
</head>
<body>
<div id="contentWrap">
    <div id="widget table-widget">
        <div class="pageTitle">待诊挂号</div>
        <div class="pageColumn">
            <div class="pageButton"><span>待诊挂号列表</span></div>
            <table>
                <thead>
                <th width="">挂号ID</th>
                <th width="">患者姓名</th>
                <th width="">科室</th>
                <th width="">挂号费</th>
                <th width="">状态</th>
                <th width="10%">操作</th>
                </thead>
                <tbody>
                <% if (registrations == null || registrations.isEmpty()) { %>
                <tr><td colspan="6">暂无待诊挂号</td></tr>
                <% } else { for (Registration registration : registrations) { %>
                <tr>
                    <td><%= registration.getId() %></td>
                    <td><%= registration.getPatientName() == null ? "" : registration.getPatientName() %></td>
                    <td><%= registration.getDepartmentName() == null ? "" : registration.getDepartmentName() %></td>
                    <td><%= registration.getFee() == null ? "0" : registration.getFee() %></td>
                    <td><%= registration.getStatus() == null ? "" : registration.getStatus() %></td>
                    <td>
                        <a href="doctor-record-new?registrationId=<%= registration.getId() %>&patientName=<%= registration.getPatientName() == null ? "" : URLEncoder.encode(registration.getPatientName(), "UTF-8") %>">诊断</a>
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
