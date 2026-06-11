package hospital.service;

import hospital.model.Medicine;

import java.util.List;

public interface MedicineService {
    List<Medicine> findAll();

    Medicine findById(int id);

    int insert(Medicine medicine);

    int update(Medicine medicine);

    int deleteById(int id);
}
