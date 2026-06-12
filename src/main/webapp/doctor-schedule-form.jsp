<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="hospital.model.Department" %>
<%@ page import="hospital.model.Doctor" %>
<%@ page import="hospital.model.DoctorSchedule" %>
<%@ page import="java.util.List" %>
<%
    DoctorSchedule schedule = (DoctorSchedule) request.getAttribute("schedule");
    List<Department> departments = (List<Department>) request.getAttribute("departments");
    List<Doctor> doctors = (List<Doctor>) request.getAttribute("doctors");
    String currentDepartmentName = schedule == null || schedule.getDepartmentName() == null ? "" : schedule.getDepartmentName();
    String currentDoctorName = schedule == null || schedule.getDoctorName() == null ? "" : schedule.getDoctorName();
    String error = (String) request.getAttribute("error");
    boolean edit = schedule != null && schedule.getId() > 0;
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%= edit ? "值班修改" : "值班添加" %></title>
    <link href="css/style.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <script type="text/javascript">
        $(function () {
            function filterDoctors() {
                var department = $('#departmentName').val();
                var selectedVisible = false;
                $('#doctorName option').each(function () {
                    var doctorDepartment = $(this).data('department');
                    var show = !doctorDepartment || !department || doctorDepartment === department;
                    $(this).toggle(show);
                    if (show && this.selected) {
                        selectedVisible = true;
                    }
                });
                if (!selectedVisible) {
                    $('#doctorName').val('');
                }
            }
            $('#departmentName').change(filterDoctors);
            filterDoctors();
        });
    </script>
    <style type="text/css">body { background:#FFF }</style>
</head>
<body>
<form method="post" action="doctor-schedules" name="ThisForm">
    <input type="hidden" name="action" value="<%= edit ? "update" : "add" %>" />
    <% if (edit) { %><input type="hidden" name="id" value="<%= schedule.getId() %>" /><% } %>
    <div id="contentWrap">
        <div id="widget table-widget">
            <div class="pageTitle"><%= edit ? "值班修改" : "值班添加" %></div>
            <% if (error != null) { %><p style="color:red;margin-left:20px;"><%= error %></p><% } %>
            <div class="pageInfo">
                <table>
                    <tr>
                        <td width="20%" align="right">医生姓名</td>
                        <td width="20%">
                            <select name="doctorName" id="doctorName">
                                <option value="">--select--</option>
                                <% if (doctors != null) { for (Doctor doctor : doctors) {
                                    String doctorName = doctor.getName() == null ? "" : doctor.getName();
                                    String doctorDepartment = doctor.getDepartment() == null ? "" : doctor.getDepartment();
                                %>
                                <option value="<%= doctorName %>" data-department="<%= doctorDepartment %>" <%= doctorName.equals(currentDoctorName) ? "selected" : "" %>><%= doctorName %></option>
                                <% }} %>
                            </select>
                        </td>
                        <td width="10%" align="right">科室</td>
                        <td width="50%">
                            <select name="departmentName" id="departmentName">
                                <option value="">--select--</option>
                                <% if (departments != null) { for (Department department : departments) {
                                    String departmentName = department.getName() == null ? "" : department.getName();
                                %>
                                <option value="<%= departmentName %>" <%= departmentName.equals(currentDepartmentName) ? "selected" : "" %>><%= departmentName %></option>
                                <% }} %>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">值班日期</td>
                        <td><input type="date" name="workDate" value="<%= schedule == null || schedule.getWorkDate() == null ? "" : schedule.getWorkDate() %>" /></td>
                        <td align="right">时段</td>
                        <td><input type="text" name="timeSlot" value="<%= schedule == null || schedule.getTimeSlot() == null ? "" : schedule.getTimeSlot() %>" /></td>
                    </tr>
                    <tr>
                        <td align="right">诊室</td>
                        <td><input type="text" name="room" value="<%= schedule == null || schedule.getRoom() == null ? "" : schedule.getRoom() %>" /></td>
                        <td align="right">状态</td>
                        <td><input type="text" name="status" value="<%= schedule == null || schedule.getStatus() == null ? "正常" : schedule.getStatus() %>" /></td>
                    </tr>
                    <tr>
                        <td colspan="4" align="center">
                            <input type="submit" value="确定" />
                            <input type="button" value="返回" onclick="window.location.href='doctor-schedules'" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</form>
</body>
</html>
