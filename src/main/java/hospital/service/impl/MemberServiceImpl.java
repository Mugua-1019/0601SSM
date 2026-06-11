package hospital.service.impl;

import hospital.mapper.MemberMapper;
import hospital.model.Member;
import hospital.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class MemberServiceImpl implements MemberService {

    @Autowired
    private MemberMapper memberMapper;

    @Override
    public List<Member> findAll() {
        return memberMapper.findAll();
    }

    @Override
    public Member findById(int id) {
        return memberMapper.findById(id);
    }

    @Override
    @Transactional
    public int insert(Member member) {
        return memberMapper.insert(member);
    }

    @Override
    @Transactional
    public int update(Member member) {
        return memberMapper.update(member);
    }

    @Override
    @Transactional
    public int deleteById(int id) {
        return memberMapper.deleteById(id);
    }
}
