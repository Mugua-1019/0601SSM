package hospital.mapper;

import hospital.model.Charge;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ChargeMapper {
    List<Charge> findAll();

    List<Charge> findByPatientName(@Param("patientName") String patientName);

    List<Charge> findByCondition(@Param("patientName") String patientName,
                                 @Param("itemName") String itemName,
                                 @Param("status") String status);

    Charge findById(@Param("id") int id);

    int insert(Charge charge);

    int update(Charge charge);

    int deleteById(@Param("id") int id);
}
