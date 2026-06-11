package hospital.service;

import hospital.model.DoctorSchedule;

import java.util.List;

public interface DoctorScheduleService {
    List<DoctorSchedule> findAll();

    List<DoctorSchedule> findByDoctorName(String doctorName);

    DoctorSchedule findById(int id);

    int insert(DoctorSchedule schedule);

    int update(DoctorSchedule schedule);

    int deleteById(int id);
}
