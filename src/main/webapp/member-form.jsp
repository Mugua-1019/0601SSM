<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="hospital.model.Member" %>
<%
    Member member = (Member) request.getAttribute("member");
    String error = (String) request.getAttribute("error");
    boolean edit = member != null && member.getId() > 0;
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%= edit ? "会员修改" : "会员添加" %></title>
    <link href="css/style.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <style type="text/css">body { background:#FFF }</style>
</head>
<body>
<form method="post" action="members" name="ThisForm">
    <input type="hidden" name="action" value="<%= edit ? "update" : "add" %>" />
    <% if (edit) { %><input type="hidden" name="id" value="<%= member.getId() %>" /><% } %>
    <div id="contentWrap">
        <div id="widget table-widget">
            <div class="pageTitle"><%= edit ? "会员修改" : "会员添加" %></div>
            <% if (error != null) { %><p style="color:red;margin-left:20px;"><%= error %></p><% } %>
            <div class="pageInfo">
                <table>
                    <tr>
                        <td width="20%" align="right">姓名</td>
                        <td width="20%"><input type="text" name="name" value="<%= member == null || member.getName() == null ? "" : member.getName() %>" /></td>
                        <td width="10%" align="right">性别</td>
                        <td width="50%"><input type="text" name="gender" value="<%= member == null || member.getGender() == null ? "" : member.getGender() %>" /></td>
                    </tr>
                    <tr>
                        <td align="right">电话</td>
                        <td><input type="text" name="phone" value="<%= member == null || member.getPhone() == null ? "" : member.getPhone() %>" /></td>
                        <td align="right">等级</td>
                        <td><input type="text" name="level" value="<%= member == null || member.getLevel() == null ? "普通会员" : member.getLevel() %>" /></td>
                    </tr>
                    <tr>
                        <td align="right">积分</td>
                        <td><input type="number" name="points" value="<%= member == null ? 0 : member.getPoints() %>" /></td>
                        <td align="right">状态</td>
                        <td><input type="text" name="status" value="<%= member == null || member.getStatus() == null ? "正常" : member.getStatus() %>" /></td>
                    </tr>
                    <tr>
                        <td colspan="4" align="center">
                            <input type="submit" value="确定" />
                            <input type="button" value="返回" onclick="window.location.href='members'" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</form>
</body>
</html>
