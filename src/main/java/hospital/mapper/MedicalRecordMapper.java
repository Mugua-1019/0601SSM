package hospital.mapper;

import hospital.model.MedicalRecord;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface MedicalRecordMapper {
    List<MedicalRecord> findAll();

    List<MedicalRecord> findByPatientName(@Param("patientName") String patientName);

    List<MedicalRecord> findByDoctorName(@Param("doctorName") String doctorName);

    List<MedicalRecord> findByCondition(@Param("patientName") String patientName,
                                        @Param("doctorName") String doctorName);

    MedicalRecord findById(@Param("id") int id);

    int insert(MedicalRecord record);

    int update(MedicalRecord record);

    int deleteById(@Param("id") int id);
}
