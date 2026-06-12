package hospital.controller;

import hospital.model.MedicalRecord;
import hospital.model.Medicine;
import hospital.model.Registration;
import hospital.model.User;
import hospital.model.Charge;
import hospital.service.ChargeService;
import hospital.service.DoctorScheduleService;
import hospital.service.MedicalRecordService;
import hospital.service.MedicineDispenseService;
import hospital.service.MedicineService;
import hospital.service.RegistrationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;

@Controller
public class DoctorPortalController {
    private static final String FINISHED_STATUS = "已就诊";

    @Autowired
    private RegistrationService registrationService;

    @Autowired
    private MedicalRecordService recordService;

    @Autowired
    private DoctorScheduleService scheduleService;

    @Autowired
    private MedicineService medicineService;

    @Autowired
    private MedicineDispenseService dispenseService;

    @Autowired
    private ChargeService chargeService;

    @RequestMapping(value = "/doctor-registrations", method = RequestMethod.GET)
    public String registrations(HttpServletRequest req) {
        String doctorName = currentDoctorName(currentUser(req));
        req.setAttribute("registrations", registrationService.findByDoctorName(doctorName));
        return "doctor-registration-list";
    }

    @RequestMapping(value = "/doctor-records", method = RequestMethod.GET)
    public String records(HttpServletRequest req) {
        String doctorName = currentDoctorName(currentUser(req));
        req.setAttribute("records", recordService.findByDoctorName(doctorName));
        return "doctor-record-list";
    }

    @RequestMapping(value = "/doctor-schedule-my", method = RequestMethod.GET)
    public String schedules(HttpServletRequest req) {
        String doctorName = currentDoctorName(currentUser(req));
        req.setAttribute("schedules", scheduleService.findByDoctorName(doctorName));
        return "doctor-schedule-my";
    }

    @RequestMapping(value = "/doctor-record-new", method = RequestMethod.GET)
    public String newRecord(HttpServletRequest req) {
        String doctorName = currentDoctorName(currentUser(req));
        req.setAttribute("doctorName", doctorName);
        req.setAttribute("patientName", trim(req.getParameter("patientName")));
        req.setAttribute("registrationId", trim(req.getParameter("registrationId")));
        setMedicines(req);
        return "doctor-record-form";
    }

    @RequestMapping(value = "/doctor-record-new", method = RequestMethod.POST)
    public String saveRecord(HttpServletRequest req) {
        String doctorName = currentDoctorName(currentUser(req));

        MedicalRecord record = new MedicalRecord();
        record.setPatientName(trim(req.getParameter("patientName")));
        record.setDoctorName(doctorName);
        record.setDiagnosis(trim(req.getParameter("diagnosis")));
        record.setTreatment(trim(req.getParameter("treatment")));

        if (record.getPatientName() == null || record.getPatientName().isEmpty()) {
            req.setAttribute("error", "患者姓名不能为空");
            req.setAttribute("doctorName", doctorName);
            req.setAttribute("patientName", record.getPatientName());
            req.setAttribute("registrationId", trim(req.getParameter("registrationId")));
            req.setAttribute("record", record);
            req.setAttribute("medicineId", trim(req.getParameter("medicineId")));
            req.setAttribute("quantity", trim(req.getParameter("quantity")));
            setMedicines(req);
            return "doctor-record-form";
        }

        Integer medicineId = parseOptionalId(req.getParameter("medicineId"));
        Medicine medicine = null;
        int quantity = 0;
        if (medicineId != null) {
            quantity = parseQuantity(req.getParameter("quantity"));
            medicine = medicineService.findById(medicineId);
            if (medicine == null) {
                req.setAttribute("error", "药品不存在");
                req.setAttribute("doctorName", doctorName);
                req.setAttribute("patientName", record.getPatientName());
                req.setAttribute("registrationId", trim(req.getParameter("registrationId")));
                req.setAttribute("record", record);
                req.setAttribute("medicineId", trim(req.getParameter("medicineId")));
                req.setAttribute("quantity", trim(req.getParameter("quantity")));
                setMedicines(req);
                return "doctor-record-form";
            }
            if (quantity <= 0) {
                req.setAttribute("error", "开药数量必须大于0");
                req.setAttribute("doctorName", doctorName);
                req.setAttribute("patientName", record.getPatientName());
                req.setAttribute("registrationId", trim(req.getParameter("registrationId")));
                req.setAttribute("record", record);
                req.setAttribute("medicineId", trim(req.getParameter("medicineId")));
                req.setAttribute("quantity", trim(req.getParameter("quantity")));
                setMedicines(req);
                return "doctor-record-form";
            }
        }

        recordService.insert(record);
        Integer registrationId = parseOptionalId(req.getParameter("registrationId"));
        if (registrationId != null) {
            Registration registration = registrationService.findById(registrationId);
            if (registration != null && registration.getFee() != null) {
                insertCharge(record.getPatientName(), "挂号费", registration.getFee());
            }
        }
        if (medicine != null) {
            dispenseService.prescribe(record.getPatientName(), medicine, quantity);
            BigDecimal amount = medicine.getPrice() == null ? BigDecimal.ZERO : medicine.getPrice().multiply(new BigDecimal(quantity));
            insertCharge(record.getPatientName(), medicine.getName(), amount);
        }
        if (registrationId != null) {
            registrationService.updateStatus(registrationId, FINISHED_STATUS);
        }
        return "redirect:/doctor-records";
    }

    private User currentUser(HttpServletRequest req) {
        return (User) req.getSession().getAttribute("loginUser");
    }

    private String currentDoctorName(User user) {
        if (user.getRealName() != null && !user.getRealName().trim().isEmpty()) {
            return user.getRealName().trim();
        }
        return user.getUsername();
    }

    private void setMedicines(HttpServletRequest req) {
        req.setAttribute("medicines", medicineService.findAll());
    }

    private void insertCharge(String patientName, String itemName, BigDecimal amount) {
        Charge charge = new Charge();
        charge.setPatientName(patientName);
        charge.setItemName(itemName);
        charge.setAmount(amount);
        charge.setStatus("未缴费");
        chargeService.insert(charge);
    }

    private Integer parseOptionalId(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        return Integer.valueOf(value.trim());
    }

    private int parseQuantity(String value) {
        if (value == null || value.trim().isEmpty()) {
            return 0;
        }
        return Integer.parseInt(value.trim());
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }
}
