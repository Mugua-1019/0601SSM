package hospital.service;

import hospital.model.Medicine;
import hospital.model.MedicineDispense;

import java.util.List;

public interface MedicineDispenseService {
    List<MedicineDispense> findAll();

    void prescribe(String patientName, Medicine medicine, int quantity);

    void dispense(String patientName, Medicine medicine, int quantity, String pharmacistName);
}
