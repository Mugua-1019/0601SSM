package hospital.controller;

import hospital.model.Patient;
import hospital.service.PatientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping("/patients")
public class PatientController {

    @Autowired
    private PatientService patientService;

    @RequestMapping(method = RequestMethod.GET)
    public String list(HttpServletRequest req) {
        String action = req.getParameter("action");

        if ("new".equals(action)) {
            return "patient-form";
        }

        if ("edit".equals(action)) {
            return showEditForm(req);
        }

        if ("delete".equals(action)) {
            return deletePatient(req);
        }

        return listPatients(req);
    }

    @RequestMapping(method = RequestMethod.POST)
    public String save(HttpServletRequest req) {
        String action = req.getParameter("action");

        if ("add".equals(action)) {
            return savePatient(req, false);
        }

        if ("update".equals(action)) {
            return savePatient(req, true);
        }

        return "redirect:/patients";
    }

    private String listPatients(HttpServletRequest req) {
        patientService.syncUsersAsPatients();
        String keyword = req.getParameter("keyword");
        List<Patient> patients = patientService.findAll(keyword);
        req.setAttribute("patients", patients);
        req.setAttribute("keyword", keyword);
        return "patient-list";
    }

    private String showEditForm(HttpServletRequest req) {
        int id = parseId(req.getParameter("id"));
        Patient patient = patientService.findById(id);
        if (patient == null) {
            req.setAttribute("error", "患者不存在，无法编辑");
            return listPatients(req);
        }

        req.setAttribute("patient", patient);
        return "patient-form";
    }

    private String deletePatient(HttpServletRequest req) {
        int id = parseId(req.getParameter("id"));
        int count = patientService.deleteById(id);
        if (count == 0) {
            req.setAttribute("error", "患者不存在，删除失败");
            return listPatients(req);
        }
        return "redirect:/patients";
    }

    private String savePatient(HttpServletRequest req, boolean update) {
        Patient patient = readPatient(req);
        if (patient.getName() == null || patient.getName().trim().isEmpty()) {
            req.setAttribute("error", "患者姓名不能为空");
            req.setAttribute("patient", patient);
            return "patient-form";
        }

        if (update) {
            patient.setId(parseId(req.getParameter("id")));
            int count = patientService.update(patient);
            if (count == 0) {
                req.setAttribute("error", "患者不存在，修改失败");
                req.setAttribute("patient", patient);
                return "patient-form";
            }
        } else {
            patientService.insert(patient);
        }

        return "redirect:/patients";
    }

    private Patient readPatient(HttpServletRequest req) {
        Patient patient = new Patient();
        patient.setName(trim(req.getParameter("name")));
        patient.setGender(trim(req.getParameter("gender")));
        patient.setAge(parseAge(req.getParameter("age")));
        patient.setPhone(trim(req.getParameter("phone")));
        patient.setAddress(trim(req.getParameter("address")));
        return patient;
    }

    private int parseId(String value) {
        try {
            int id = Integer.parseInt(value);
            if (id > 0) {
                return id;
            }
        } catch (NumberFormatException ignored) {
            // Invalid id falls through to the explicit error below.
        }
        throw new IllegalArgumentException("无效的患者 ID：" + value);
    }

    private int parseAge(String value) {
        if (value == null || value.trim().isEmpty()) {
            return 0;
        }
        try {
            int age = Integer.parseInt(value.trim());
            if (age >= 0) {
                return age;
            }
        } catch (NumberFormatException ignored) {
            // Invalid age falls through to the explicit error below.
        }
        throw new IllegalArgumentException("年龄必须是非负整数：" + value);
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }
}
