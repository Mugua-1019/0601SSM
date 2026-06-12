package hospital.controller;

import hospital.model.MedicineDispense;
import hospital.model.Medicine;
import hospital.model.User;
import hospital.service.ChargeService;
import hospital.service.MedicineDispenseService;
import hospital.service.MedicineService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/dispenses")
public class MedicineDispenseController {

    @Autowired
    private MedicineService medicineService;

    @Autowired
    private MedicineDispenseService dispenseService;

    @Autowired
    private ChargeService chargeService;

    @RequestMapping(method = RequestMethod.GET)
    public String list(HttpServletRequest req) {
        String action = req.getParameter("action");
        if ("release".equals(action)) {
            User user = (User) req.getSession().getAttribute("loginUser");
            MedicineDispense dispense = dispenseService.findById(parseId(req.getParameter("id")));
            if (dispense == null) {
                req.setAttribute("error", "处方不存在");
            } else if (chargeService.hasUnpaid(dispense.getPatientName())) {
                req.setAttribute("error", "患者未完成缴费，不能发药");
            } else {
                try {
                    dispenseService.dispensePrescription(dispense.getId(), currentPharmacistName(user));
                } catch (IllegalStateException e) {
                    req.setAttribute("error", e.getMessage());
                }
            }
            req.setAttribute("dispenses", dispenseService.findAll());
            req.setAttribute("medicines", medicineService.findAll());
            return "dispense-list";
        }
        if ("new".equals(action)) {
            String medicineId = req.getParameter("medicineId");
            if (medicineId != null && !medicineId.trim().isEmpty()) {
                req.setAttribute("medicine", medicineService.findById(parseId(medicineId)));
            }
            req.setAttribute("medicines", medicineService.findAll());
            return "dispense-form";
        }

        req.setAttribute("dispenses", dispenseService.findAll());
        req.setAttribute("medicines", medicineService.findAll());
        return "dispense-list";
    }

    @RequestMapping(method = RequestMethod.POST)
    public String dispense(HttpServletRequest req) {
        String patientName = trim(req.getParameter("patientName"));
        int medicineId = parseId(req.getParameter("medicineId"));
        int quantity = parseQuantity(req.getParameter("quantity"));
        User user = (User) req.getSession().getAttribute("loginUser");
        String pharmacistName = currentPharmacistName(user);
        Medicine medicine = medicineService.findById(medicineId);

        if (patientName == null || patientName.isEmpty()) {
            return forwardFormWithError(req, medicine, "患者姓名不能为空");
        }
        if (medicine == null) {
            return forwardFormWithError(req, null, "药品不存在");
        }
        if (quantity <= 0) {
            return forwardFormWithError(req, medicine, "发放数量必须大于0");
        }

        try {
            dispenseService.dispense(patientName, medicine, quantity, pharmacistName);
            return "redirect:/dispenses";
        } catch (IllegalStateException e) {
            return forwardFormWithError(req, medicine, e.getMessage());
        }
    }

    private String forwardFormWithError(HttpServletRequest req, Medicine medicine, String error) {
        req.setAttribute("error", error);
        req.setAttribute("medicine", medicine);
        req.setAttribute("medicines", medicineService.findAll());
        return "dispense-form";
    }

    private String currentPharmacistName(User user) {
        if (user.getRealName() != null && !user.getRealName().trim().isEmpty()) {
            return user.getRealName().trim();
        }
        return user.getUsername();
    }

    private int parseId(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            throw new IllegalArgumentException("无效ID：" + value);
        }
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
