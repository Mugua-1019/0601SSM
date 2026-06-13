package hospital.controller;

import hospital.model.Medicine;
import hospital.service.MedicineService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;

@Controller
@RequestMapping("/medicines")
public class MedicineController {

    @Autowired
    private MedicineService medicineService;

    @RequestMapping(method = RequestMethod.GET)
    public String list(HttpServletRequest req) {
        String action = req.getParameter("action");

        if ("new".equals(action)) {
            return "medicine-form";
        }

        if ("edit".equals(action)) {
            req.setAttribute("medicine", medicineService.findById(parseId(req.getParameter("id"))));
            return "medicine-form";
        }

        if ("delete".equals(action)) {
            medicineService.deleteById(parseId(req.getParameter("id")));
            return "redirect:/medicines";
        }

        String name = trim(req.getParameter("name"));
        req.setAttribute("name", name);
        if (notBlank(name)) {
            req.setAttribute("medicines", medicineService.findByCondition(name));
        } else {
            req.setAttribute("medicines", medicineService.findAll());
        }
        return "medicine-list";
    }

    @RequestMapping(method = RequestMethod.POST)
    public String save(HttpServletRequest req) {
        Medicine medicine = readMedicine(req);
        if (medicine.getName() == null || medicine.getName().trim().isEmpty()) {
            req.setAttribute("error", "药品名称不能为空");
            req.setAttribute("medicine", medicine);
            return "medicine-form";
        }

        if ("update".equals(req.getParameter("action"))) {
            medicine.setId(parseId(req.getParameter("id")));
            medicineService.update(medicine);
        } else {
            medicineService.insert(medicine);
        }

        return "redirect:/medicines";
    }

    private Medicine readMedicine(HttpServletRequest req) {
        Medicine medicine = new Medicine();
        medicine.setName(trim(req.getParameter("name")));
        medicine.setSpecification(trim(req.getParameter("specification")));
        medicine.setStock(parseInt(req.getParameter("stock")));
        medicine.setPrice(parseMoney(req.getParameter("price")));
        return medicine;
    }

    private int parseId(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            throw new IllegalArgumentException("无效ID：" + value);
        }
    }

    private int parseInt(String value) {
        if (value == null || value.trim().isEmpty()) {
            return 0;
        }
        return Integer.parseInt(value.trim());
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

    private boolean notBlank(String value) {
        return value != null && !value.trim().isEmpty();
    }
}
