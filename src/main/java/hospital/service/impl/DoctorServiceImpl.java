package hospital.service.impl;

import hospital.mapper.DoctorMapper;
import hospital.model.Doctor;
import hospital.service.DoctorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class DoctorServiceImpl implements DoctorService {

    @Autowired
    private DoctorMapper doctorMapper;

    @Override
    public List<Doctor> findAll() {
        return doctorMapper.findAll();
    }

    @Override
    public Doctor findById(int id) {
        return doctorMapper.findById(id);
    }

    @Override
    @Transactional
    public int insert(Doctor doctor) {
        return doctorMapper.insert(doctor);
    }

    @Override
    @Transactional
    public int update(Doctor doctor) {
        return doctorMapper.update(doctor);
    }

    @Override
    @Transactional
    public int deleteById(int id) {
        return doctorMapper.deleteById(id);
    }
}
