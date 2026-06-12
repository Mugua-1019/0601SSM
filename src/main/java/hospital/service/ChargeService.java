package hospital.service;

import hospital.model.Charge;

import java.util.List;

public interface ChargeService {
    List<Charge> findAll();

    List<Charge> findByPatientName(String patientName);

    List<Charge> findByCondition(String patientName, String itemName, String status);

    Charge findById(int id);

    boolean hasUnpaid(String patientName);

    int updateStatus(int id, String status);

    int insert(Charge charge);

    int update(Charge charge);

    int deleteById(int id);
}
