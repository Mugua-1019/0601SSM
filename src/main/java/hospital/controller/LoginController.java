package hospital.controller;

import hospital.model.User;
import hospital.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
public class LoginController {

    @Autowired
    private UserService userService;

    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public String loginPage() {
        return "login";
    }

    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public String login(HttpServletRequest req) {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        if (isBlank(username) || isBlank(password)) {
            req.setAttribute("error", "账号和密码不能为空");
            return "login";
        }

        userService.ensureDefaultUsers();
        User user = userService.findByUsernameAndPassword(username.trim(), password);
        if (user != null) {
            req.getSession().setAttribute("loginUser", user);
            return "redirect:/main.jsp";
        }

        req.setAttribute("error", "账号或密码错误");
        return "login";
    }

    @RequestMapping(value = "/logout", method = RequestMethod.POST)
    public String logout(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        return "redirect:/login.jsp";
    }

    @ResponseBody
    @RequestMapping(value = "/change-password", method = RequestMethod.POST, produces = "text/plain;charset=UTF-8")
    public ResponseEntity<String> changePassword(HttpServletRequest req) {
        User loginUser = (User) req.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            return new ResponseEntity<>("请先登录", HttpStatus.UNAUTHORIZED);
        }

        String oldPassword = trim(req.getParameter("oldPassword"));
        String newPassword = trim(req.getParameter("newPassword"));
        String confirmPassword = trim(req.getParameter("confirmPassword"));

        if (isBlank(oldPassword) || isBlank(newPassword) || isBlank(confirmPassword)) {
            return new ResponseEntity<>("原密码、新密码和确认密码不能为空", HttpStatus.BAD_REQUEST);
        }
        if (!newPassword.equals(confirmPassword)) {
            return new ResponseEntity<>("两次输入的新密码不一致", HttpStatus.BAD_REQUEST);
        }
        if (newPassword.length() < 6) {
            return new ResponseEntity<>("新密码长度不能少于6位", HttpStatus.BAD_REQUEST);
        }

        int updated = userService.updatePassword(loginUser.getId(), oldPassword, newPassword);
        if (updated == 0) {
            return new ResponseEntity<>("原密码不正确", HttpStatus.BAD_REQUEST);
        }

        loginUser.setPassword(newPassword);
        req.getSession().setAttribute("loginUser", loginUser);
        return ResponseEntity.ok("密码修改成功");
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }
}
