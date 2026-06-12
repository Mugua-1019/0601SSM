package hospital.mapper;

import hospital.model.Patient;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface PatientMapper {
    int insertUsersAsPatients();

    List<Patient> findAll(@Param("keyword") String keyword);

    Patient findById(@Param("id") int id);

    int insert(Patient patient);

    int update(Patient patient);

    int deleteById(@Param("id") int id);
}
