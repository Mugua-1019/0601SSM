<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>社区医疗管理系统</title>
<link href="css/login.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="js/jquery.min.js"></script>
<script type="text/javascript">
    $(function(){
        $('.captcha').focus(function(){
            $('.yzm-box').show();
        });

        $('.captcha').focusout(function(){
            $('.yzm-box').hide();
        });
    });
</script>
</head>
<body>
<%
    String error = (String) request.getAttribute("error");
    if (error != null) {
%>
<div id="message-box"><%= error %></div>
<%
    }
%>
<div id="wrap">
    <div id="header"> </div>
    <div id="content-wrap">
        <div class="space"> </div>
        <form action="login" method="post" name="ThisForm">
            <div class="content">
                <div class="field"><label>账　　号：</label><input class="username" name="username" type="text" /></div>
                <div class="field"><label>密　　码：</label><input class="password" name="password" type="password" /><br /></div>
                <div class="yzm-box">
                    <!-- <label>验证码：</label>
                    <img src="image.do" id="yzmimage" align="middle" onclick="this.src=this.src+'?'" />
                    <label style="color: red" id="yzmerror"></label> -->
                </div>
            </div>
            <div class="btn"><input type="submit" class="login-btn" value="" /></div>
            <div style="text-align:center;margin-top:10px;"><a href="register">患者注册</a></div>
        </form>
    </div>
    <div id="footer"> </div>
</div>
</body>
</html>
