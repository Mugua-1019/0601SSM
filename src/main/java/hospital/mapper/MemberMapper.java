package hospital.mapper;

import hospital.model.Member;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface MemberMapper {
    int insertUsersAsMembers();

    List<Member> findAll();

    Member findById(@Param("id") int id);

    int insert(Member member);

    int update(Member member);

    int deleteById(@Param("id") int id);
}
