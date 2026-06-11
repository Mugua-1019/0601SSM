package hospital.mapper;

import hospital.model.DoctorSchedule;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface DoctorScheduleMapper {
    List<DoctorSchedule> findAll();

    List<DoctorSchedule> findByDoctorName(@Param("doctorName") String doctorName);

    DoctorSchedule findById(@Param("id") int id);

    int insert(DoctorSchedule schedule);

    int update(DoctorSchedule schedule);

    int deleteById(@Param("id") int id);
}
