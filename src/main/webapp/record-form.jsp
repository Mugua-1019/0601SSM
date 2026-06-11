<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="hospital.model.MedicalRecord" %>
<%
    MedicalRecord record = (MedicalRecord) request.getAttribute("record");
    String error = (String) request.getAttribute("error");
    boolean edit = record != null && record.getId() > 0;
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%= edit ? "诊断记录修改" : "诊断记录添加" %></title>
    <link href="css/style.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <style type="text/css">body { background:#FFF }</style>
</head>
<body>
<form method="post" action="records" name="ThisForm">
    <input type="hidden" name="action" value="<%= edit ? "update" : "add" %>" />
    <% if (edit) { %><input type="hidden" name="id" value="<%= record.getId() %>" /><% } %>
    <div id="contentWrap">
        <div id="widget table-widget">
            <div class="pageTitle"><%= edit ? "诊断记录修改" : "诊断记录添加" %></div>
            <% if (error != null) { %><p style="color:red;margin-left:20px;"><%= error %></p><% } %>
            <div class="pageInfo">
                <table>
                    <tr>
                        <td width="20%" align="right">患者姓名</td>
                        <td width="20%"><input type="text" name="patientName" value="<%= record == null || record.getPatientName() == null ? "" : record.getPatientName() %>" /></td>
                        <td width="10%" align="right">医生姓名</td>
                        <td width="50%"><input type="text" name="doctorName" value="<%= record == null || record.getDoctorName() == null ? "" : record.getDoctorName() %>" /></td>
                    </tr>
                    <tr>
                        <td align="right">诊断结果</td>
                        <td><textarea name="diagnosis" rows="3" cols="30"><%= record == null || record.getDiagnosis() == null ? "" : record.getDiagnosis() %></textarea></td>
                        <td align="right">治疗方案</td>
                        <td><textarea name="treatment" rows="3" cols="30"><%= record == null || record.getTreatment() == null ? "" : record.getTreatment() %></textarea></td>
                    </tr>
                    <tr>
                        <td colspan="4" align="center">
                            <input type="submit" value="确定" />
                            <input type="button" value="返回" onclick="window.location.href='records'" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</form>
</body>
</html>
