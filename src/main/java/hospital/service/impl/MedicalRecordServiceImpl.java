package hospital.service.impl;

import hospital.mapper.MedicalRecordMapper;
import hospital.model.MedicalRecord;
import hospital.service.MedicalRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class MedicalRecordServiceImpl implements MedicalRecordService {

    @Autowired
    private MedicalRecordMapper recordMapper;

    @Override
    public List<MedicalRecord> findAll() {
        return recordMapper.findAll();
    }

    @Override
    public List<MedicalRecord> findByPatientName(String patientName) {
        return recordMapper.findByPatientName(patientName);
    }

    @Override
    public List<MedicalRecord> findByDoctorName(String doctorName) {
        return recordMapper.findByDoctorName(doctorName);
    }

    @Override
    public MedicalRecord findById(int id) {
        return recordMapper.findById(id);
    }

    @Override
    @Transactional
    public int insert(MedicalRecord record) {
        return recordMapper.insert(record);
    }

    @Override
    @Transactional
    public int update(MedicalRecord record) {
        return recordMapper.update(record);
    }

    @Override
    @Transactional
    public int deleteById(int id) {
        return recordMapper.deleteById(id);
    }
}
