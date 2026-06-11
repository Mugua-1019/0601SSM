package hospital.service;

import hospital.model.Registration;

import java.util.List;

public interface RegistrationService {
    List<Registration> findAll();

    List<Registration> findByPatientName(String patientName);

    List<Registration> findByDoctorName(String doctorName);

    Registration findById(int id);

    int insert(Registration registration);

    int update(Registration registration);

    int deleteById(int id);

    int updateStatus(int id, String status);
}
