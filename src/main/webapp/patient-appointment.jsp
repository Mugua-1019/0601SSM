<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="hospital.model.Registration" %>
<%
    String patientName = (String) request.getAttribute("patientName");
    Registration registration = (Registration) request.getAttribute("registration");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>预约挂号</title>
    <link href="css/style.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <style type="text/css">body { background:#FFF }</style>
</head>
<body>
<form method="post" action="patient-appointment" name="ThisForm">
    <div id="contentWrap">
        <div id="widget table-widget">
            <div class="pageTitle">预约挂号</div>
            <% if (error != null) { %><p style="color:red;margin-left:20px;"><%= error %></p><% } %>
            <div class="pageInfo">
                <table>
                    <tr>
                        <td width="20%" align="right">患者姓名</td>
                        <td width="20%"><input type="text" value="<%= patientName == null ? "" : patientName %>" readonly="readonly" /></td>
                        <td width="10%" align="right">科室</td>
                        <td width="50%"><input type="text" name="departmentName" value="<%= registration == null || registration.getDepartmentName() == null ? "" : registration.getDepartmentName() %>" /></td>
                    </tr>
                    <tr>
                        <td align="right">医生</td>
                        <td><input type="text" name="doctorName" value="<%= registration == null || registration.getDoctorName() == null ? "" : registration.getDoctorName() %>" /></td>
                        <td align="right">挂号费</td>
                        <td><input type="text" name="fee" value="<%= registration == null || registration.getFee() == null ? "0" : registration.getFee() %>" /></td>
                    </tr>
                    <tr>
                        <td colspan="4" align="center">
                            <input type="submit" value="确定" />
                            <input type="button" value="返回" onclick="window.location.href='patient-registrations'" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</form>
</body>
</html>
