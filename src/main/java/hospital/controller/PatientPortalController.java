package hospital.controller;

import hospital.model.Registration;
import hospital.model.User;
import hospital.service.ChargeService;
import hospital.service.DepartmentService;
import hospital.service.DoctorService;
import hospital.service.MedicalRecordService;
import hospital.service.RegistrationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;

@Controller
public class PatientPortalController {
    private static final String WAITING_STATUS = "待就诊";

    @Autowired
    private RegistrationService registrationService;

    @Autowired
    private MedicalRecordService recordService;

    @Autowired
    private ChargeService chargeService;

    @Autowired
    private DepartmentService departmentService;

    @Autowired
    private DoctorService doctorService;

    @RequestMapping(value = "/patient-appointment", method = RequestMethod.GET)
    public String appointment(HttpServletRequest req) {
        req.setAttribute("patientName", currentPatientName(currentUser(req)));
        setOptions(req);
        return "patient-appointment";
    }

    @RequestMapping(value = "/patient-appointment", method = RequestMethod.POST)
    public String saveAppointment(HttpServletRequest req) {
        String patientName = currentPatientName(currentUser(req));

        Registration registration = new Registration();
        registration.setPatientName(patientName);
        registration.setDepartmentName(trim(req.getParameter("departmentName")));
        registration.setDoctorName(trim(req.getParameter("doctorName")));
        registration.setFee(parseMoney(req.getParameter("fee")));
        registration.setStatus(WAITING_STATUS);

        if (registration.getDepartmentName() == null || registration.getDepartmentName().isEmpty()) {
            req.setAttribute("error", "科室不能为空");
            req.setAttribute("registration", registration);
            req.setAttribute("patientName", patientName);
            setOptions(req);
            return "patient-appointment";
        }

        registrationService.insert(registration);
        return "redirect:/patient-registrations";
    }

    @RequestMapping(value = "/patient-registrations", method = RequestMethod.GET)
    public String registrations(HttpServletRequest req) {
        String patientName = currentPatientName(currentUser(req));
        req.setAttribute("registrations", registrationService.findByPatientName(patientName));
        return "patient-registration-list";
    }

    @RequestMapping(value = "/patient-records", method = RequestMethod.GET)
    public String records(HttpServletRequest req) {
        String patientName = currentPatientName(currentUser(req));
        req.setAttribute("records", recordService.findByPatientName(patientName));
        return "patient-record-list";
    }

    @RequestMapping(value = "/patient-charges", method = RequestMethod.GET)
    public String charges(HttpServletRequest req) {
        String patientName = currentPatientName(currentUser(req));
        req.setAttribute("charges", chargeService.findByPatientName(patientName));
        return "patient-charge-list";
    }

    private User currentUser(HttpServletRequest req) {
        return (User) req.getSession().getAttribute("loginUser");
    }

    private void setOptions(HttpServletRequest req) {
        req.setAttribute("departments", departmentService.findAll());
        req.setAttribute("doctors", doctorService.findAll());
    }

    private String currentPatientName(User user) {
        if (user.getRealName() != null && !user.getRealName().trim().isEmpty()) {
            return user.getRealName().trim();
        }
        return user.getUsername();
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
