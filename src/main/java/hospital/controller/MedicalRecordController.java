package hospital.controller;

import hospital.model.MedicalRecord;
import hospital.service.DoctorService;
import hospital.service.MedicalRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/records")
public class MedicalRecordController {

    @Autowired
    private MedicalRecordService recordService;

    @Autowired
    private DoctorService doctorService;

    @RequestMapping(method = RequestMethod.GET)
    public String list(HttpServletRequest req) {
        String action = req.getParameter("action");

        if ("new".equals(action)) {
            setOptions(req);
            return "record-form";
        }

        if ("edit".equals(action)) {
            req.setAttribute("record", recordService.findById(parseId(req.getParameter("id"))));
            setOptions(req);
            return "record-form";
        }

        if ("delete".equals(action)) {
            recordService.deleteById(parseId(req.getParameter("id")));
            return "redirect:/records";
        }

        String patientName = trim(req.getParameter("patientName"));
        String doctorName = trim(req.getParameter("doctorName"));
        req.setAttribute("patientName", patientName);
        req.setAttribute("doctorName", doctorName);
        if (notBlank(patientName) || notBlank(doctorName)) {
            req.setAttribute("records", recordService.findByCondition(patientName, doctorName));
        } else {
            req.setAttribute("records", recordService.findAll());
        }
        return "record-list";
    }

    @RequestMapping(method = RequestMethod.POST)
    public String save(HttpServletRequest req) {
        MedicalRecord record = readRecord(req);
        if (record.getPatientName() == null || record.getPatientName().trim().isEmpty()) {
            req.setAttribute("error", "患者姓名不能为空");
            req.setAttribute("record", record);
            setOptions(req);
            return "record-form";
        }

        if ("update".equals(req.getParameter("action"))) {
            record.setId(parseId(req.getParameter("id")));
            recordService.update(record);
        } else {
            recordService.insert(record);
        }

        return "redirect:/records";
    }

    private MedicalRecord readRecord(HttpServletRequest req) {
        MedicalRecord record = new MedicalRecord();
        record.setPatientName(trim(req.getParameter("patientName")));
        record.setDoctorName(trim(req.getParameter("doctorName")));
        record.setDiagnosis(trim(req.getParameter("diagnosis")));
        record.setTreatment(trim(req.getParameter("treatment")));
        return record;
    }

    private void setOptions(HttpServletRequest req) {
        req.setAttribute("doctors", doctorService.findAll());
    }

    private int parseId(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            throw new IllegalArgumentException("无效ID：" + value);
        }
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }

    private boolean notBlank(String value) {
        return value != null && !value.trim().isEmpty();
    }
}
