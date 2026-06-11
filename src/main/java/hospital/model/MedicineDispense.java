package hospital.model;

import java.sql.Timestamp;

public class MedicineDispense {
    private int id;
    private String patientName;
    private int medicineId;
    private String medicineName;
    private int quantity;
    private String pharmacistName;
    private Timestamp dispensedAt;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }
    public int getMedicineId() { return medicineId; }
    public void setMedicineId(int medicineId) { this.medicineId = medicineId; }
    public String getMedicineName() { return medicineName; }
    public void setMedicineName(String medicineName) { this.medicineName = medicineName; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public String getPharmacistName() { return pharmacistName; }
    public void setPharmacistName(String pharmacistName) { this.pharmacistName = pharmacistName; }
    public Timestamp getDispensedAt() { return dispensedAt; }
    public void setDispensedAt(Timestamp dispensedAt) { this.dispensedAt = dispensedAt; }
}
