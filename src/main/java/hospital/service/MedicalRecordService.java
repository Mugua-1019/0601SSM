package hospital.service;

import hospital.model.MedicalRecord;

import java.util.List;

public interface MedicalRecordService {
    List<MedicalRecord> findAll();

    List<MedicalRecord> findByPatientName(String patientName);

    List<MedicalRecord> findByDoctorName(String doctorName);

    MedicalRecord findById(int id);

    int insert(MedicalRecord record);

    int update(MedicalRecord record);

    int deleteById(int id);
}
