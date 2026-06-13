package hospital.service.impl;

import hospital.mapper.RegistrationMapper;
import hospital.model.Registration;
import hospital.service.RegistrationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class RegistrationServiceImpl implements RegistrationService {

    @Autowired
    private RegistrationMapper registrationMapper;

    @Override
    public List<Registration> findAll() {
        return registrationMapper.findAll();
    }

    @Override
    public List<Registration> findByPatientName(String patientName) {
        return registrationMapper.findByPatientName(patientName);
    }

    @Override
    public List<Registration> findByDoctorName(String doctorName) {
        return registrationMapper.findByDoctorName(doctorName);
    }

    @Override
    public List<Registration> findByCondition(String patientName, String departmentName) {
        return registrationMapper.findByCondition(blankToNull(patientName), blankToNull(departmentName));
    }

    @Override
    public Registration findById(int id) {
        return registrationMapper.findById(id);
    }

    @Override
    @Transactional
    public int insert(Registration registration) {
        return registrationMapper.insert(registration);
    }

    @Override
    @Transactional
    public int update(Registration registration) {
        return registrationMapper.update(registration);
    }

    @Override
    @Transactional
    public int deleteById(int id) {
        return registrationMapper.deleteById(id);
    }

    @Override
    @Transactional
    public int updateStatus(int id, String status) {
        return registrationMapper.updateStatus(id, status);
    }

    private String blankToNull(String value) {
        return value == null || value.trim().isEmpty() ? null : value.trim();
    }
}
