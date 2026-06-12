<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Object registrationFee = request.getAttribute("registrationFee");
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>挂号费设置</title>
    <link href="css/style.css" rel="stylesheet" type="text/css" />
    <style type="text/css">body { background:#FFF }</style>
</head>
<body>
<form method="post" action="charges" name="ThisForm">
    <input type="hidden" name="action" value="updateFee" />
    <div id="contentWrap">
        <div id="widget table-widget">
            <div class="pageTitle">挂号费设置</div>
            <div class="pageInfo">
                <table>
                    <tr>
                        <td width="20%" align="right">挂号费</td>
                        <td width="80%"><input type="text" name="registrationFee" value="<%= registrationFee == null ? "0" : registrationFee %>" /></td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center">
                            <input type="submit" value="确定" />
                            <input type="button" value="返回" onclick="window.location.href='charges'" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</form>
</body>
</html>
