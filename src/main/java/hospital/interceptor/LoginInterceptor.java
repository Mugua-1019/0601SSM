package hospital.interceptor;

import hospital.model.User;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginInterceptor implements HandlerInterceptor {
    private static final String ADMIN_ROLE = "admin";
    private static final String PATIENT_ROLE = "patient";
    private static final String DOCTOR_ROLE = "doctor";
    private static final String PHARMACIST_ROLE = "pharmacist";

    @Override
    public boolean preHandle(HttpServletRequest req, HttpServletResponse resp, Object handler) throws Exception {
        String path = req.getRequestURI().substring(req.getContextPath().length());

        if (isPublicPath(path)) {
            return true;
        }

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loginUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return false;
        }

        User loginUser = (User) session.getAttribute("loginUser");
        if (isAdminPath(path) && !ADMIN_ROLE.equals(loginUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/unauthorized.jsp");
            return false;
        }
        if (isMedicinePath(path) && !ADMIN_ROLE.equals(loginUser.getRole()) && !PHARMACIST_ROLE.equals(loginUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/unauthorized.jsp");
            return false;
        }
        if (isPatientPath(path) && !PATIENT_ROLE.equals(loginUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/unauthorized.jsp");
            return false;
        }
        if (isDoctorPath(path) && !DOCTOR_ROLE.equals(loginUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/unauthorized.jsp");
            return false;
        }
        if (isPharmacistPath(path) && !PHARMACIST_ROLE.equals(loginUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/unauthorized.jsp");
            return false;
        }

        return true;
    }

    private boolean isPublicPath(String path) {
        return "/".equals(path)
                || "/index.jsp".equals(path)
                || "/login.jsp".equals(path)
                || "/login".equals(path)
                || "/register.jsp".equals(path)
                || "/register".equals(path)
                || path.startsWith("/css/")
                || path.startsWith("/js/")
                || path.startsWith("/images/");
    }

    private boolean isAdminPath(String path) {
        return path.startsWith("/html/")
                || "/patients".equals(path)
                || "/doctors".equals(path)
                || "/departments".equals(path)
                || "/registrations".equals(path)
                || "/records".equals(path)
                || "/charges".equals(path);
    }

    private boolean isMedicinePath(String path) {
        return "/medicines".equals(path)
                || "/medicine-list.jsp".equals(path)
                || "/medicine-form.jsp".equals(path);
    }

    private boolean isPatientPath(String path) {
        return "/patient-appointment".equals(path)
                || "/patient-registrations".equals(path)
                || "/patient-records".equals(path)
                || "/patient-charges".equals(path)
                || "/patient-appointment.jsp".equals(path)
                || "/patient-registration-list.jsp".equals(path)
                || "/patient-record-list.jsp".equals(path)
                || "/patient-charge-list.jsp".equals(path);
    }

    private boolean isDoctorPath(String path) {
        return "/doctor-registrations".equals(path)
                || "/doctor-records".equals(path)
                || "/doctor-record-new".equals(path)
                || "/doctor-registration-list.jsp".equals(path)
                || "/doctor-record-list.jsp".equals(path)
                || "/doctor-record-form.jsp".equals(path);
    }

    private boolean isPharmacistPath(String path) {
        return "/dispenses".equals(path)
                || "/dispense-list.jsp".equals(path)
                || "/dispense-form.jsp".equals(path);
    }
}
