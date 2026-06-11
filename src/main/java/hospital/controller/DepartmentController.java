package hospital.controller;

import hospital.model.Department;
import hospital.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping("/departments")
public class DepartmentController {

    @Autowired
    private DepartmentService departmentService;

    @RequestMapping(method = RequestMethod.GET)
    public String list(HttpServletRequest req) {
        String action = req.getParameter("action");

        if ("new".equals(action)) {
            return "department-form";
        }

        if ("edit".equals(action)) {
            return showEditForm(req);
        }

        if ("delete".equals(action)) {
            departmentService.deleteById(parseId(req.getParameter("id")));
            return "redirect:/departments";
        }

        return listDepartments(req);
    }

    @RequestMapping(method = RequestMethod.POST)
    public String save(HttpServletRequest req) {
        String name = req.getParameter("name");
        String description = req.getParameter("description");

        if (name == null || name.trim().isEmpty()) {
            req.setAttribute("error", "科室名称不能为空");
            return "department-form";
        }

        Department department = readDepartment(name, description);
        if ("update".equals(req.getParameter("action"))) {
            department.setId(parseId(req.getParameter("id")));
            departmentService.update(department);
        } else {
            departmentService.insert(department);
        }

        return "redirect:/departments";
    }

    private String listDepartments(HttpServletRequest req) {
        List<Department> departments = departmentService.findAll();
        req.setAttribute("departments", departments);
        return "department-list";
    }

    private String showEditForm(HttpServletRequest req) {
        Department department = departmentService.findById(parseId(req.getParameter("id")));
        if (department == null) {
            req.setAttribute("error", "科室不存在，无法编辑");
            return listDepartments(req);
        }
        req.setAttribute("department", department);
        return "department-form";
    }

    private Department readDepartment(String name, String description) {
        Department department = new Department();
        department.setName(name.trim());
        department.setDescription(description == null ? null : description.trim());
        return department;
    }

    private int parseId(String value) {
        try {
            int id = Integer.parseInt(value);
            if (id > 0) {
                return id;
            }
        } catch (NumberFormatException ignored) {
        }
        throw new IllegalArgumentException("无效的科室 ID：" + value);
    }
}
