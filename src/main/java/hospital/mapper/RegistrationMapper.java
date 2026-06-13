package hospital.mapper;

import hospital.model.Registration;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface RegistrationMapper {
    List<Registration> findAll();

    List<Registration> findByPatientName(@Param("patientName") String patientName);

    List<Registration> findByDoctorName(@Param("doctorName") String doctorName);

    List<Registration> findByCondition(@Param("patientName") String patientName,
                                       @Param("departmentName") String departmentName);

    Registration findById(@Param("id") int id);

    int insert(Registration registration);

    int update(Registration registration);

    int deleteById(@Param("id") int id);

    int updateStatus(@Param("id") int id, @Param("status") String status);
}
