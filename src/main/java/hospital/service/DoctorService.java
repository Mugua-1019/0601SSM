package hospital.service;

import hospital.model.Doctor;

import java.util.List;

public interface DoctorService {
    List<Doctor> findAll();

    List<Doctor> findByCondition(String name, String department);

    Doctor findById(int id);

    int insert(Doctor doctor);

    int update(Doctor doctor);

    int deleteById(int id);
}
