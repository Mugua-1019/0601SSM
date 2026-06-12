package hospital.mapper;

import hospital.model.MedicineDispense;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface MedicineDispenseMapper {
    List<MedicineDispense> findAll();

    MedicineDispense findById(@Param("id") int id);

    int decreaseStock(@Param("medicineId") int medicineId, @Param("quantity") int quantity);

    int markDispensed(@Param("id") int id, @Param("pharmacistName") String pharmacistName);

    int insertDispense(@Param("patientName") String patientName,
                       @Param("medicineId") int medicineId,
                       @Param("medicineName") String medicineName,
                       @Param("quantity") int quantity,
                       @Param("pharmacistName") String pharmacistName);
}
