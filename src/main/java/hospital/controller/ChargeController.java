package hospital.controller;

import hospital.model.Charge;
import hospital.service.ChargeService;
import hospital.service.SystemConfigService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;

@Controller
@RequestMapping("/charges")
public class ChargeController {

    @Autowired
    private ChargeService chargeService;

    @Autowired
    private SystemConfigService systemConfigService;

    @RequestMapping(method = RequestMethod.GET)
    public String list(HttpServletRequest req) {
        String action = req.getParameter("action");

        if ("fee-setting".equals(action)) {
            req.setAttribute("registrationFee", systemConfigService.getRegistrationFee());
            return "charge-fee-setting";
        }

        if ("new".equals(action)) {
            return "charge-form";
        }

        if ("edit".equals(action)) {
            req.setAttribute("charge", chargeService.findById(parseId(req.getParameter("id"))));
            return "charge-form";
        }

        if ("delete".equals(action)) {
            chargeService.deleteById(parseId(req.getParameter("id")));
            return "redirect:/charges";
        }

        String patientName = trim(req.getParameter("patientName"));
        String itemName = trim(req.getParameter("itemName"));
        String status = trim(req.getParameter("status"));
        req.setAttribute("patientName", patientName);
        req.setAttribute("itemName", itemName);
        req.setAttribute("status", status);
        if (notBlank(patientName) || notBlank(itemName) || notBlank(status)) {
            req.setAttribute("charges", chargeService.findByCondition(patientName, itemName, status));
        } else {
            req.setAttribute("charges", chargeService.findAll());
        }
        return "charge-list";
    }

    @RequestMapping(method = RequestMethod.POST)
    public String save(HttpServletRequest req) {
        if ("updateFee".equals(req.getParameter("action"))) {
            systemConfigService.updateRegistrationFee(parseMoney(req.getParameter("registrationFee")));
            return "redirect:/charges?action=fee-setting";
        }

        Charge charge = readCharge(req);
        if (charge.getPatientName() == null || charge.getPatientName().trim().isEmpty()) {
            req.setAttribute("error", "患者姓名不能为空");
            req.setAttribute("charge", charge);
            return "charge-form";
        }

        if ("update".equals(req.getParameter("action"))) {
            charge.setId(parseId(req.getParameter("id")));
            chargeService.update(charge);
        } else {
            chargeService.insert(charge);
        }

        return "redirect:/charges";
    }

    private Charge readCharge(HttpServletRequest req) {
        Charge charge = new Charge();
        charge.setPatientName(trim(req.getParameter("patientName")));
        charge.setItemName(trim(req.getParameter("itemName")));
        charge.setAmount(parseMoney(req.getParameter("amount")));
        charge.setStatus(trim(req.getParameter("status")));
        return charge;
    }

    private int parseId(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            throw new IllegalArgumentException("无效ID：" + value);
        }
    }

    private BigDecimal parseMoney(String value) {
        if (value == null || value.trim().isEmpty()) {
            return BigDecimal.ZERO;
        }
        return new BigDecimal(value.trim());
    }

    private boolean notBlank(String value) {
        return value != null && !value.trim().isEmpty();
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }
}
