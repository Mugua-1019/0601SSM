package hospital.mapper;

import hospital.model.Department;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface DepartmentMapper {
    List<Department> findAll();

    List<Department> findByCondition(@Param("name") String name);

    Department findById(@Param("id") int id);

    int insert(Department department);

    int update(Department department);

    int deleteById(@Param("id") int id);
}
