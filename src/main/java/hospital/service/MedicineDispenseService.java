package hospital.service;

import hospital.model.Medicine;
import hospital.model.MedicineDispense;

import java.util.List;

public interface MedicineDispenseService {
    List<MedicineDispense> findAll();

    MedicineDispense findById(int id);

    void prescribe(String patientName, Medicine medicine, int quantity);

    void dispense(String patientName, Medicine medicine, int quantity, String pharmacistName);

    void dispensePrescription(int id, String pharmacistName);
}
