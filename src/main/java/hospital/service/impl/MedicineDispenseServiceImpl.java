package hospital.service.impl;

import hospital.mapper.MedicineDispenseMapper;
import hospital.model.Medicine;
import hospital.model.MedicineDispense;
import hospital.service.MedicineDispenseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class MedicineDispenseServiceImpl implements MedicineDispenseService {

    @Autowired
    private MedicineDispenseMapper dispenseMapper;

    @Override
    public List<MedicineDispense> findAll() {
        return dispenseMapper.findAll();
    }

    @Override
    public MedicineDispense findById(int id) {
        return dispenseMapper.findById(id);
    }

    @Override
    @Transactional
    public void prescribe(String patientName, Medicine medicine, int quantity) {
        dispenseMapper.insertDispense(patientName, medicine.getId(), medicine.getName(), quantity, "待发放");
    }

    @Override
    @Transactional
    public void dispense(String patientName, Medicine medicine, int quantity, String pharmacistName) {
        int updated = dispenseMapper.decreaseStock(medicine.getId(), quantity);
        if (updated == 0) {
            throw new IllegalStateException("药品库存不足");
        }
        dispenseMapper.insertDispense(patientName, medicine.getId(), medicine.getName(), quantity, pharmacistName);
    }

    @Override
    @Transactional
    public void dispensePrescription(int id, String pharmacistName) {
        MedicineDispense dispense = dispenseMapper.findById(id);
        if (dispense == null) {
            throw new IllegalStateException("处方不存在");
        }
        int updated = dispenseMapper.decreaseStock(dispense.getMedicineId(), dispense.getQuantity());
        if (updated == 0) {
            throw new IllegalStateException("药品库存不足");
        }
        dispenseMapper.markDispensed(id, pharmacistName);
    }
}
