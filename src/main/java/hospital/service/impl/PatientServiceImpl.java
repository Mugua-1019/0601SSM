package hospital.service.impl;

import hospital.mapper.PatientMapper;
import hospital.model.Patient;
import hospital.service.PatientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class PatientServiceImpl implements PatientService {

    @Autowired
    private PatientMapper patientMapper;

    @Override
    @Transactional
    public int syncUsersAsPatients() {
        return patientMapper.insertUsersAsPatients();
    }

    @Override
    public List<Patient> findAll(String keyword) {
        String keywordValue = keyword == null || keyword.trim().isEmpty() ? null : keyword.trim();
        return patientMapper.findAll(keywordValue);
    }

    @Override
    public Patient findById(int id) {
        return patientMapper.findById(id);
    }

    @Override
    @Transactional
    public int insert(Patient patient) {
        return patientMapper.insert(patient);
    }

    @Override
    @Transactional
    public int update(Patient patient) {
        return patientMapper.update(patient);
    }

    @Override
    @Transactional
    public int deleteById(int id) {
        return patientMapper.deleteById(id);
    }
}
