<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="hospital.model.DoctorSchedule" %>
<%@ page import="java.util.List" %>
<%
    List<DoctorSchedule> schedules = (List<DoctorSchedule>) request.getAttribute("schedules");
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>我的值班</title>
    <link href="css/style.css" rel="stylesheet" type="text/css" />
    <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <script type="text/javascript">$(function(){ $('tbody tr:odd').addClass("trLight"); });</script>
    <style type="text/css">body { background:#FFF }</style>
</head>
<body>
<div id="contentWrap">
    <div id="widget table-widget">
        <div class="pageTitle">我的值班</div>
        <div class="pageColumn">
            <div class="pageButton"><span>值班列表</span></div>
            <table>
                <thead>
                <th width="">科室</th>
                <th width="">值班日期</th>
                <th width="">时段</th>
                <th width="">诊室</th>
                <th width="">状态</th>
                </thead>
                <tbody>
                <% if (schedules == null || schedules.isEmpty()) { %>
                <tr><td colspan="5">暂无值班数据</td></tr>
                <% } else { for (DoctorSchedule schedule : schedules) { %>
                <tr>
                    <td><%= schedule.getDepartmentName() == null ? "" : schedule.getDepartmentName() %></td>
                    <td><%= schedule.getWorkDate() == null ? "" : schedule.getWorkDate() %></td>
                    <td><%= schedule.getTimeSlot() == null ? "" : schedule.getTimeSlot() %></td>
                    <td><%= schedule.getRoom() == null ? "" : schedule.getRoom() %></td>
                    <td><%= schedule.getStatus() == null ? "" : schedule.getStatus() %></td>
                </tr>
                <% }} %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
