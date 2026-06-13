package hospital.mapper;

import hospital.model.Medicine;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface MedicineMapper {
    List<Medicine> findAll();

    List<Medicine> findByCondition(@Param("name") String name);

    Medicine findById(@Param("id") int id);

    int insert(Medicine medicine);

    int update(Medicine medicine);

    int deleteById(@Param("id") int id);
}
