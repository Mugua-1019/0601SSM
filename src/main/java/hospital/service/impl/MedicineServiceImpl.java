package hospital.service.impl;

import hospital.mapper.MedicineMapper;
import hospital.model.Medicine;
import hospital.service.MedicineService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class MedicineServiceImpl implements MedicineService {

    @Autowired
    private MedicineMapper medicineMapper;

    @Override
    public List<Medicine> findAll() {
        return medicineMapper.findAll();
    }

    @Override
    public Medicine findById(int id) {
        return medicineMapper.findById(id);
    }

    @Override
    @Transactional
    public int insert(Medicine medicine) {
        return medicineMapper.insert(medicine);
    }

    @Override
    @Transactional
    public int update(Medicine medicine) {
        return medicineMapper.update(medicine);
    }

    @Override
    @Transactional
    public int deleteById(int id) {
        return medicineMapper.deleteById(id);
    }
}
