package hospital.service;

import hospital.model.Charge;

import java.util.List;

public interface ChargeService {
    List<Charge> findAll();

    List<Charge> findByPatientName(String patientName);

    List<Charge> findByCondition(String patientName, String itemName, String status);

    Charge findById(int id);

    int insert(Charge charge);

    int update(Charge charge);

    int deleteById(int id);
}
