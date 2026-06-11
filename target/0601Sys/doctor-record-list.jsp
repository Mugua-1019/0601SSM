<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="hospital.model.MedicalRecord" %>
<%@ page import="java.util.List" %>
<%
    List<MedicalRecord> records = (List<MedicalRecord>) request.getAttribute("records");
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>我的诊断</title>
    <link href="css/style.css" rel="stylesheet" type="text/css" />
    <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <script type="text/javascript">$(function(){ $('tbody tr:odd').addClass("trLight"); });</script>
    <style type="text/css">body { background:#FFF }</style>
</head>
<body>
<div id="contentWrap">
    <div id="widget table-widget">
        <div class="pageTitle">我的诊断</div>
        <div class="pageColumn">
            <div class="pageButton">
                <a href="doctor-record-new"><img src="images/t01.png" title="新增诊断"/></a>
                <span>诊断记录</span>
            </div>
            <table>
                <thead>
                <th width="">记录ID</th>
                <th width="">患者姓名</th>
                <th width="">诊断结果</th>
                <th width="">治疗方案</th>
                </thead>
                <tbody>
                <% if (records == null || records.isEmpty()) { %>
                <tr><td colspan="4">暂无诊断记录</td></tr>
                <% } else { for (MedicalRecord record : records) { %>
                <tr>
                    <td><%= record.getId() %></td>
                    <td><%= record.getPatientName() == null ? "" : record.getPatientName() %></td>
                    <td><%= record.getDiagnosis() == null ? "" : record.getDiagnosis() %></td>
                    <td><%= record.getTreatment() == null ? "" : record.getTreatment() %></td>
                </tr>
                <% }} %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
