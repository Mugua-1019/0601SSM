package hospital.service;

import hospital.model.Member;

import java.util.List;

public interface MemberService {
    List<Member> findAll();

    Member findById(int id);

    int insert(Member member);

    int update(Member member);

    int deleteById(int id);
}
