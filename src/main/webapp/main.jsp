<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="hospital.model.User" %>
<%
    User loginUser = (User) session.getAttribute("loginUser");
    String role = loginUser == null ? "" : loginUser.getRole();
    boolean admin = "admin".equals(role);
    boolean patient = "patient".equals(role);
    boolean doctor = "doctor".equals(role);
    boolean pharmacist = "pharmacist".equals(role);
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>社区医疗管理系统</title>
<link href="css/style.css" rel="stylesheet" type="text/css" />
<link href="css/jquery-ui.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="js/jquery.min.js"></script>
<script type="text/javascript" src="js/jquery-ui.js"></script>
<script type="text/javascript">
$(function(){
    $("#modifyPassword").click(function() {
         $("#showModify").dialog({
                title:'修改密码',
                width:430,
                height:260,
                buttons:{
                    "确定":function(){
                        var dialog = $(this);
                        var oldPassword = $.trim($("#oldPassword").val());
                        var newPassword = $.trim($("#newPassword").val());
                        var confirmPassword = $.trim($("#confirmPassword").val());
                        $("#modifyPasswordMsg").css("color", "red").text("");
                        if (!oldPassword || !newPassword || !confirmPassword) {
                            $("#modifyPasswordMsg").text("原密码、新密码和确认密码不能为空");
                            return;
                        }
                        if (newPassword !== confirmPassword) {
                            $("#modifyPasswordMsg").text("两次输入的新密码不一致");
                            return;
                        }
                        $.ajax({
                            url: "change-password",
                            type: "post",
                            data: {
                                oldPassword: oldPassword,
                                newPassword: newPassword,
                                confirmPassword: confirmPassword
                            },
                            success: function(message) {
                                $("#modifyPasswordMsg").css("color", "green").text(message);
                                $("#modifyPasswordForm")[0].reset();
                                setTimeout(function(){ dialog.dialog("close"); }, 800);
                            },
                            error: function(xhr) {
                                $("#modifyPasswordMsg").text(xhr.responseText || "修改密码失败");
                            }
                        });
                    },
                    "取消":function(){$(this).dialog('close');}
                }
            });
         return false;
     });
    $('.menu').height($(window).height()-51-27-26-5);
    $('.sidebar').height($(window).height()-51-27-26-5);
    $('.page').height($(window).height()-51-27-26-5);
    $('.page iframe').width($(window).width()-15-168);
    $('.btn').click(function(){
        $('.menu').toggle();

        if($(".menu").is(":hidden")){
            $('.page iframe').width($(window).width()-15+5);
        }else{
            $('.page iframe').width($(window).width()-15-168);
        }
    });

    $('.subMenu a[href="#"]').click(function(){
        $(this).next('ul').toggle();
        return false;
    });
});
</script>
</head>
<body style="overflow-y:hidden">
<div id="wrap">
    <div id="header">
    <div class="logo fleft"></div>
    <div class="topright">
    <ul>
        <li><span><img src="images/index-logout.png" class="helpimg" height="16" width="16"/></span>
            <form method="post" action="logout" style="display:inline"><button type="submit" style="border:0;background:none;color:#fff;cursor:pointer;">注销</button></form>
        </li>
        <li><span><img src="images/t07.png" class="helpimg" height="16" width="16"/></span><a id="modifyPassword" href="#">当前用户：<%= loginUser == null ? "" : loginUser.getRealName() %></a></li>
    </ul>
    </div>
  <div class="clear"></div>
    <div class="subnav">
        <div class="subnavLeft fleft"></div>
        <div class="fleft"></div>
        <div class="subnavRight fright"></div>
    </div>
    </div>
    <div id="content">
    <div class="space"></div>
    <div class="menu fleft">
        <ul>
            <li class="subMenuTitle">菜单</li>
                <ul>
                   <% if (admin) { %>
                   <li><a href="patients" target="right">患者管理</a></li>
                   <li><a href="medicines" target="right">药品信息管理</a></li>
                   <li><a href="doctors" target="right">医生管理</a></li>
                   <li><a href="doctor-schedules" target="right">医生值班管理</a></li>
                   <li><a href="departments" target="right">科室管理</a></li>
                   <li><a href="registrations" target="right">挂号管理</a></li>
                   <li><a href="records" target="right">医生诊断管理</a></li>
                   <li><a href="charges" target="right">缴费明细查询</a></li>
                   <li><a href="members" target="right">会员管理</a></li>
                   <% } else if (patient) { %>
                   <li><a href="patient-appointment" target="right">预约挂号</a></li>
                   <li><a href="patient-registrations" target="right">我的挂号</a></li>
                   <li><a href="patient-records" target="right">我的诊断</a></li>
                   <li><a href="patient-charges" target="right">我的费用</a></li>
                   <% } else if (doctor) { %>
                   <li><a href="doctor-registrations" target="right">待诊挂号</a></li>
                   <li><a href="doctor-records" target="right">我的诊断</a></li>
                   <li><a href="doctor-schedule-my" target="right">我的值班</a></li>
                   <% } else if (pharmacist) { %>
                   <li><a href="medicines" target="right">药品信息管理</a></li>
                   <li><a href="dispenses" target="right">药品发放</a></li>
                   <% } else { %>
                   <li><a href="unauthorized.jsp" target="right">角色功能待开放</a></li>
                   <% } %>
            </ul>
        </ul>
    </div>
    <div class="sidebar fleft"><div class="btn"></div></div>
    <div class="page">
    <iframe width="100%" scrolling="auto" height="100%" frameborder="false" allowtransparency="true" style="border: medium none;" src="welcome.jsp" id="rightMain" name="right"></iframe>
    </div>
    </div>
    <div class="clear"></div>
    <div id="footer">CopyRight &copy; 2017-2018</div>
</div>
<div id="showModify" style="display:none">
    <form id="modifyPasswordForm">
        <table style="width:100%;margin-top:10px;">
            <tr>
                <td style="width:28%;text-align:right;padding:6px;">原密码</td>
                <td><input id="oldPassword" name="oldPassword" type="password" style="width:220px;" /></td>
            </tr>
            <tr>
                <td style="text-align:right;padding:6px;">新密码</td>
                <td><input id="newPassword" name="newPassword" type="password" style="width:220px;" /></td>
            </tr>
            <tr>
                <td style="text-align:right;padding:6px;">确认密码</td>
                <td><input id="confirmPassword" name="confirmPassword" type="password" style="width:220px;" /></td>
            </tr>
        </table>
        <div id="modifyPasswordMsg" style="margin-left:38px;margin-top:8px;color:red;"></div>
    </form>
</div>
</body>
</html>
