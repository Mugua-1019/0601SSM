<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="hospital.model.Member" %>
<%@ page import="java.util.List" %>
<%
    List<Member> members = (List<Member>) request.getAttribute("members");
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>用户管理</title>
    <link href="css/style.css" rel="stylesheet" type="text/css" />
    <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <script type="text/javascript">$(function(){ $('tbody tr:odd').addClass("trLight"); });</script>
    <style type="text/css">body { background:#FFF }</style>
</head>
<body>
<div id="contentWrap">
    <div id="widget table-widget">
        <div class="pageTitle">用户管理</div>
        <div class="pageColumn">
            <div class="pageButton">
                <a href="members?action=new"><img src="images/t01.png" title="新增"/></a>
                <span>用户列表</span>
            </div>
            <table>
                <thead>
                <th width="">ID</th>
                <th width="">姓名</th>
                <th width="">性别</th>
                <th width="">电话</th>
                <th width="">等级</th>
                <th width="">积分</th>
                <th width="">状态</th>
                <th width="10%">操作</th>
                </thead>
                <tbody>
                <% if (members == null || members.isEmpty()) { %>
                <tr><td colspan="8">暂无数据</td></tr>
                <% } else { for (Member member : members) { %>
                <tr>
                    <td><%= member.getId() %></td>
                    <td><%= member.getName() == null ? "" : member.getName() %></td>
                    <td><%= member.getGender() == null ? "" : member.getGender() %></td>
                    <td><%= member.getPhone() == null ? "" : member.getPhone() %></td>
                    <td><%= member.getLevel() == null ? "" : member.getLevel() %></td>
                    <td><%= member.getPoints() %></td>
                    <td><%= member.getStatus() == null ? "" : member.getStatus() %></td>
                    <td>
                        <a href="members?action=edit&id=<%= member.getId() %>"><img src="images/icon/edit.png" width="16" height="16" /></a>
                        <a href="members?action=delete&id=<%= member.getId() %>" onclick="return confirm('确认删除该会员吗？');"><img src="images/icon/del.png" width="16" height="16" /></a>
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
