package hospital.controller;

import hospital.model.MedicalRecord;
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

    @RequestMapping(method = RequestMethod.GET)
    public String list(HttpServletRequest req) {
        String action = req.getParameter("action");

        if ("new".equals(action)) {
            return "record-form";
        }

        if ("edit".equals(action)) {
            req.setAttribute("record", recordService.findById(parseId(req.getParameter("id"))));
            return "record-form";
        }

        if ("delete".equals(action)) {
            recordService.deleteById(parseId(req.getParameter("id")));
            return "redirect:/records";
        }

        req.setAttribute("records", recordService.findAll());
        return "record-list";
    }

    @RequestMapping(method = RequestMethod.POST)
    public String save(HttpServletRequest req) {
        MedicalRecord record = readRecord(req);
        if (record.getPatientName() == null || record.getPatientName().trim().isEmpty()) {
            req.setAttribute("error", "患者姓名不能为空");
            req.setAttribute("record", record);
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
}
