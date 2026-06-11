package hospital.service.impl;

import hospital.mapper.DoctorScheduleMapper;
import hospital.model.DoctorSchedule;
import hospital.service.DoctorScheduleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class DoctorScheduleServiceImpl implements DoctorScheduleService {

    @Autowired
    private DoctorScheduleMapper scheduleMapper;

    @Override
    public List<DoctorSchedule> findAll() {
        return scheduleMapper.findAll();
    }

    @Override
    public List<DoctorSchedule> findByDoctorName(String doctorName) {
        return scheduleMapper.findByDoctorName(doctorName);
    }

    @Override
    public DoctorSchedule findById(int id) {
        return scheduleMapper.findById(id);
    }

    @Override
    @Transactional
    public int insert(DoctorSchedule schedule) {
        return scheduleMapper.insert(schedule);
    }

    @Override
    @Transactional
    public int update(DoctorSchedule schedule) {
        return scheduleMapper.update(schedule);
    }

    @Override
    @Transactional
    public int deleteById(int id) {
        return scheduleMapper.deleteById(id);
    }
}
