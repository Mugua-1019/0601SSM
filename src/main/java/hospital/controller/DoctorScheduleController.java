package hospital.controller;

import hospital.model.DoctorSchedule;
import hospital.service.DepartmentService;
import hospital.service.DoctorService;
import hospital.service.DoctorScheduleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import java.sql.Date;

@Controller
@RequestMapping("/doctor-schedules")
public class DoctorScheduleController {

    @Autowired
    private DoctorScheduleService scheduleService;

    @Autowired
    private DepartmentService departmentService;

    @Autowired
    private DoctorService doctorService;

    @RequestMapping(method = RequestMethod.GET)
    public String list(HttpServletRequest req) {
        String action = req.getParameter("action");

        if ("new".equals(action)) {
            setOptions(req);
            return "doctor-schedule-form";
        }

        if ("edit".equals(action)) {
            req.setAttribute("schedule", scheduleService.findById(parseId(req.getParameter("id"))));
            setOptions(req);
            return "doctor-schedule-form";
        }

        if ("delete".equals(action)) {
            scheduleService.deleteById(parseId(req.getParameter("id")));
            return "redirect:/doctor-schedules";
        }

        req.setAttribute("schedules", scheduleService.findAll());
        return "doctor-schedule-list";
    }

    @RequestMapping(method = RequestMethod.POST)
    public String save(HttpServletRequest req) {
        DoctorSchedule schedule = readSchedule(req);
        if (isBlank(schedule.getDoctorName()) || isBlank(schedule.getWorkDate())) {
            req.setAttribute("error", "医生姓名和值班日期不能为空");
            req.setAttribute("schedule", schedule);
            setOptions(req);
            return "doctor-schedule-form";
        }

        try {
            Date.valueOf(schedule.getWorkDate());
            if ("update".equals(req.getParameter("action"))) {
                schedule.setId(parseId(req.getParameter("id")));
                scheduleService.update(schedule);
            } else {
                scheduleService.insert(schedule);
            }
            return "redirect:/doctor-schedules";
        } catch (IllegalArgumentException e) {
            req.setAttribute("error", "值班日期格式必须为 yyyy-MM-dd");
            req.setAttribute("schedule", schedule);
            setOptions(req);
            return "doctor-schedule-form";
        }
    }

    private DoctorSchedule readSchedule(HttpServletRequest req) {
        DoctorSchedule schedule = new DoctorSchedule();
        schedule.setDoctorName(trim(req.getParameter("doctorName")));
        schedule.setDepartmentName(trim(req.getParameter("departmentName")));
        schedule.setWorkDate(trim(req.getParameter("workDate")));
        schedule.setTimeSlot(trim(req.getParameter("timeSlot")));
        schedule.setRoom(trim(req.getParameter("room")));
        schedule.setStatus(trim(req.getParameter("status")));
        return schedule;
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

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }
}
