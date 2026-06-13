package hospital.service;

import hospital.model.Department;

import java.util.List;

public interface DepartmentService {
    List<Department> findAll();

    List<Department> findByCondition(String name);

    Department findById(int id);

    int insert(Department department);

    int update(Department department);

    int deleteById(int id);
}
