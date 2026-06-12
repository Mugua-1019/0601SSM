<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>用户注册</title>
    <link href="css/style.css" rel="stylesheet" type="text/css" />
    <style type="text/css">body { background:#FFF }</style>
</head>
<body>
<form method="post" action="register" name="ThisForm">
    <div id="contentWrap">
        <div id="widget table-widget">
            <div class="pageTitle">患者注册</div>
            <% String error = (String) request.getAttribute("error"); if (error != null) { %>
            <p style="color:red;margin-left:20px;"><%= error %></p>
            <% } %>
            <div class="pageInfo">
                <table>
                    <tr>
                        <td width="20%" align="right">账号</td>
                        <td width="80%"><input type="text" name="username" /></td>
                    </tr>
                    <tr>
                        <td align="right">姓名</td>
                        <td><input type="text" name="realName" /></td>
                    </tr>
                    <tr>
                        <td align="right">密码</td>
                        <td><input type="password" name="password" /></td>
                    </tr>
                    <tr>
                        <td align="right">确认密码</td>
                        <td><input type="password" name="confirmPassword" /></td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center">
                            <input type="submit" value="注册" />
                            <input type="button" value="返回登录" onclick="window.location.href='login'" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</form>
</body>
</html>
