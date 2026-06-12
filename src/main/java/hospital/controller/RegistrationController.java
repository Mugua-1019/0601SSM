package hospital.controller;

import hospital.model.Registration;
import hospital.service.DepartmentService;
import hospital.service.DoctorService;
import hospital.service.RegistrationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;

@Controller
@RequestMapping("/registrations")
public class RegistrationController {

    @Autowired
    private RegistrationService registrationService;

    @Autowired
    private DepartmentService departmentService;

    @Autowired
    private DoctorService doctorService;

    @RequestMapping(method = RequestMethod.GET)
    public String list(HttpServletRequest req) {
        String action = req.getParameter("action");

        if ("new".equals(action)) {
            setOptions(req);
            return "registration-form";
        }

        if ("edit".equals(action)) {
            req.setAttribute("registration", registrationService.findById(parseId(req.getParameter("id"))));
            setOptions(req);
            return "registration-form";
        }

        if ("delete".equals(action)) {
            registrationService.deleteById(parseId(req.getParameter("id")));
            return "redirect:/registrations";
        }

        req.setAttribute("registrations", registrationService.findAll());
        return "registration-list";
    }

    @RequestMapping(method = RequestMethod.POST)
    public String save(HttpServletRequest req) {
        Registration registration = readRegistration(req);
        if (registration.getPatientName() == null || registration.getPatientName().trim().isEmpty()) {
            req.setAttribute("error", "患者姓名不能为空");
            req.setAttribute("registration", registration);
            setOptions(req);
            return "registration-form";
        }

        if ("update".equals(req.getParameter("action"))) {
            registration.setId(parseId(req.getParameter("id")));
            registrationService.update(registration);
        } else {
            registrationService.insert(registration);
        }

        return "redirect:/registrations";
    }

    private Registration readRegistration(HttpServletRequest req) {
        Registration registration = new Registration();
        registration.setPatientName(trim(req.getParameter("patientName")));
        registration.setDepartmentName(trim(req.getParameter("departmentName")));
        registration.setDoctorName(trim(req.getParameter("doctorName")));
        registration.setFee(parseMoney(req.getParameter("fee")));
        registration.setStatus(trim(req.getParameter("status")));
        return registration;
    }

    private void setOptions(HttpServletRequest req) {
        req.setAttribute("departments", departmentService.findAll());
        req.setAttribute("doctors", doctorService.findAll());
    }

    private int parseId(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            throw new IllegalArgumentException("无效ID：" + value);
        }
    }

    private BigDecimal parseMoney(String value) {
        if (value == null || value.trim().isEmpty()) {
            return BigDecimal.ZERO;
        }
        return new BigDecimal(value.trim());
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }
}
