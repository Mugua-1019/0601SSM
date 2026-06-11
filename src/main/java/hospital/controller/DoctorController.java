package hospital.controller;

import hospital.model.Doctor;
import hospital.service.DoctorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/doctors")
public class DoctorController {

    @Autowired
    private DoctorService doctorService;

    @RequestMapping(method = RequestMethod.GET)
    public String list(HttpServletRequest req) {
        String action = req.getParameter("action");

        if ("new".equals(action)) {
            return "doctor-form";
        }

        if ("edit".equals(action)) {
            Doctor doctor = doctorService.findById(parseId(req.getParameter("id")));
            req.setAttribute("doctor", doctor);
            return "doctor-form";
        }

        if ("delete".equals(action)) {
            doctorService.deleteById(parseId(req.getParameter("id")));
            return "redirect:/doctors";
        }

        req.setAttribute("doctors", doctorService.findAll());
        return "doctor-list";
    }

    @RequestMapping(method = RequestMethod.POST)
    public String save(HttpServletRequest req) {
        Doctor doctor = readDoctor(req);
        if (doctor.getName() == null || doctor.getName().trim().isEmpty()) {
            req.setAttribute("error", "医生姓名不能为空");
            req.setAttribute("doctor", doctor);
            return "doctor-form";
        }

        if ("update".equals(req.getParameter("action"))) {
            doctor.setId(parseId(req.getParameter("id")));
            doctorService.update(doctor);
        } else {
            doctorService.insert(doctor);
        }

        return "redirect:/doctors";
    }

    private Doctor readDoctor(HttpServletRequest req) {
        Doctor doctor = new Doctor();
        doctor.setName(trim(req.getParameter("name")));
        doctor.setDepartment(trim(req.getParameter("department")));
        doctor.setTitle(trim(req.getParameter("title")));
        doctor.setPhone(trim(req.getParameter("phone")));
        doctor.setEmail(trim(req.getParameter("email")));
        return doctor;
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
