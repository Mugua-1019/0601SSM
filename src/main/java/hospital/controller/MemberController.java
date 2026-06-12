package hospital.controller;

import hospital.model.Member;
import hospital.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/members")
public class MemberController {

    @Autowired
    private MemberService memberService;

    @RequestMapping(method = RequestMethod.GET)
    public String list(HttpServletRequest req) {
        String action = req.getParameter("action");

        if ("new".equals(action)) {
            return "member-form";
        }

        if ("edit".equals(action)) {
            req.setAttribute("member", memberService.findById(parseId(req.getParameter("id"))));
            return "member-form";
        }

        if ("delete".equals(action)) {
            memberService.deleteById(parseId(req.getParameter("id")));
            return "redirect:/members";
        }

        memberService.insertUsersAsMembers();
        req.setAttribute("members", memberService.findAll());
        return "member-list";
    }

    @RequestMapping(method = RequestMethod.POST)
    public String save(HttpServletRequest req) {
        Member member = readMember(req);
        if (member.getName() == null || member.getName().trim().isEmpty()) {
            req.setAttribute("error", "会员姓名不能为空");
            req.setAttribute("member", member);
            return "member-form";
        }

        if ("update".equals(req.getParameter("action"))) {
            member.setId(parseId(req.getParameter("id")));
            memberService.update(member);
        } else {
            memberService.insert(member);
        }

        return "redirect:/members";
    }

    private Member readMember(HttpServletRequest req) {
        Member member = new Member();
        member.setName(trim(req.getParameter("name")));
        member.setGender(trim(req.getParameter("gender")));
        member.setPhone(trim(req.getParameter("phone")));
        member.setLevel(trim(req.getParameter("level")));
        member.setPoints(parseInt(req.getParameter("points")));
        member.setStatus(trim(req.getParameter("status")));
        return member;
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

    private String trim(String value) {
        return value == null ? null : value.trim();
    }
}
