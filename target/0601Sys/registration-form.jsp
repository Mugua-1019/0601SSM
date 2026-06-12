<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="hospital.model.Department" %>
<%@ page import="hospital.model.Doctor" %>
<%@ page import="hospital.model.Registration" %>
<%@ page import="java.util.List" %>
<%
    Registration registration = (Registration) request.getAttribute("registration");
    List<Department> departments = (List<Department>) request.getAttribute("departments");
    List<Doctor> doctors = (List<Doctor>) request.getAttribute("doctors");
    String currentDepartmentName = registration == null || registration.getDepartmentName() == null ? "" : registration.getDepartmentName();
    String currentDoctorName = registration == null || registration.getDoctorName() == null ? "" : registration.getDoctorName();
    String error = (String) request.getAttribute("error");
    boolean edit = registration != null && registration.getId() > 0;
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%= edit ? "挂号修改" : "挂号添加" %></title>
    <link href="css/style.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <style type="text/css">body { background:#FFF }</style>
</head>
<body>
<form method="post" action="registrations" name="ThisForm">
    <input type="hidden" name="action" value="<%= edit ? "update" : "add" %>" />
    <% if (edit) { %><input type="hidden" name="id" value="<%= registration.getId() %>" /><% } %>
    <div id="contentWrap">
        <div id="widget table-widget">
            <div class="pageTitle"><%= edit ? "挂号修改" : "挂号添加" %></div>
            <% if (error != null) { %><p style="color:red;margin-left:20px;"><%= error %></p><% } %>
            <div class="pageInfo">
                <table>
                    <tr>
                        <td width="20%" align="right">患者姓名</td>
                        <td width="20%"><input type="text" name="patientName" value="<%= registration == null || registration.getPatientName() == null ? "" : registration.getPatientName() %>" /></td>
                        <td width="10%" align="right">科室</td>
                        <td width="50%">
                            <select name="departmentName">
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
                        <td align="right">医生</td>
                        <td>
                            <select name="doctorName">
                                <option value="">--select--</option>
                                <% if (doctors != null) { for (Doctor doctor : doctors) {
                                    String doctorName = doctor.getName() == null ? "" : doctor.getName();
                                %>
                                <option value="<%= doctorName %>" <%= doctorName.equals(currentDoctorName) ? "selected" : "" %>><%= doctorName %></option>
                                <% }} %>
                            </select>
                        </td>
                        <td align="right">挂号费</td>
                        <td><input type="text" name="fee" value="<%= registration == null || registration.getFee() == null ? "0" : registration.getFee() %>" /></td>
                    </tr>
                    <tr>
                        <td align="right">状态</td>
                        <td><input type="text" name="status" value="<%= registration == null || registration.getStatus() == null ? "" : registration.getStatus() %>" /></td>
                        <td></td><td></td>
                    </tr>
                    <tr>
                        <td colspan="4" align="center">
                            <input type="submit" value="确定" />
                            <input type="button" value="返回" onclick="window.location.href='registrations'" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</form>
</body>
</html>
