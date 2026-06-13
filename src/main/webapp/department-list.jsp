<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="hospital.model.Department" %>
<%@ page import="java.util.List" %>
<%
    List<Department> departments = (List<Department>) request.getAttribute("departments");
    String name = (String) request.getAttribute("name");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>科室管理</title>
    <link href="css/style.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <script type="text/javascript">
        $(function(){ $('tbody tr:odd').addClass("trLight"); });
    </script>
    <style type="text/css">body { background:#FFF }</style>
</head>
<body>
<div id="contentWrap">
    <div id="widget table-widget">
        <div class="pageTitle">科室管理</div>
        <form method="get" action="departments">
            <div class="querybody">
                <ul class="seachform">
                    <li><label>科室名称</label><input name="name" type="text" class="scinput" value="<%= name == null ? "" : name %>" /></li>
                    <li><label>&nbsp;</label><input type="submit" class="scbtn" value="查询"/></li>
                </ul>
            </div>
        </form>
        <% if (error != null) { %>
        <p style="color:red;margin-left:20px;"><%= error %></p>
        <% } %>
        <div class="pageColumn">
            <div class="pageButton">
                <a href="departments?action=new"><img src="images/t01.png" title="新增"/></a>
                <span>科室列表</span>
            </div>
            <table>
                <thead>
                <th width="">科室ID</th>
                <th width="">科室名称</th>
                <th width="">科室说明</th>
                <th width="10%">操作</th>
                </thead>
                <tbody>
                <% if (departments == null || departments.isEmpty()) { %>
                <tr><td colspan="4">暂无科室数据</td></tr>
                <% } else { for (Department department : departments) { %>
                <tr>
                    <td><%= department.getId() %></td>
                    <td><%= department.getName() %></td>
                    <td><%= department.getDescription() == null ? "" : department.getDescription() %></td>
                    <td>
                        <a href="departments?action=edit&id=<%= department.getId() %>"><img src="images/icon/edit.png" width="16" height="16" /></a>
                        <a href="departments?action=delete&id=<%= department.getId() %>" onclick="return confirm('确认删除该科室吗？');"><img src="images/icon/del.png" width="16" height="16" /></a>
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
