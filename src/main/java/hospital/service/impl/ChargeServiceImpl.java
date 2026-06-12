package hospital.service.impl;

import hospital.mapper.ChargeMapper;
import hospital.model.Charge;
import hospital.service.ChargeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class ChargeServiceImpl implements ChargeService {

    @Autowired
    private ChargeMapper chargeMapper;

    @Override
    public List<Charge> findAll() {
        return chargeMapper.findAll();
    }

    @Override
    public List<Charge> findByPatientName(String patientName) {
        return chargeMapper.findByPatientName(patientName);
    }

    @Override
    public List<Charge> findByCondition(String patientName, String itemName, String status) {
        return chargeMapper.findByCondition(blankToNull(patientName), blankToNull(itemName), blankToNull(status));
    }

    @Override
    public Charge findById(int id) {
        return chargeMapper.findById(id);
    }

    @Override
    public boolean hasUnpaid(String patientName) {
        return chargeMapper.countUnpaidByPatientName(patientName) > 0;
    }

    @Override
    @Transactional
    public int updateStatus(int id, String status) {
        return chargeMapper.updateStatus(id, status);
    }

    @Override
    @Transactional
    public int insert(Charge charge) {
        return chargeMapper.insert(charge);
    }

    @Override
    @Transactional
    public int update(Charge charge) {
        return chargeMapper.update(charge);
    }

    @Override
    @Transactional
    public int deleteById(int id) {
        return chargeMapper.deleteById(id);
    }

    private String blankToNull(String value) {
        return value == null || value.trim().isEmpty() ? null : value.trim();
    }
}
