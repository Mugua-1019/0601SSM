package hospital.mapper;

import hospital.model.Doctor;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface DoctorMapper {
    List<Doctor> findAll();

    List<Doctor> findByCondition(@Param("name") String name,
                                 @Param("department") String department);

    Doctor findById(@Param("id") int id);

    int insert(Doctor doctor);

    int update(Doctor doctor);

    int deleteById(@Param("id") int id);
}
