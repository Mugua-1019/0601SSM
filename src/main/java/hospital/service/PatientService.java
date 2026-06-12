package hospital.service;

import hospital.model.Patient;

import java.util.List;

public interface PatientService {
    int syncUsersAsPatients();

    List<Patient> findAll(String keyword);

    Patient findById(int id);

    int insert(Patient patient);

    int update(Patient patient);

    int deleteById(int id);
}
