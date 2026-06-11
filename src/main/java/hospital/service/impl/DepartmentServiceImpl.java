package hospital.service.impl;

import hospital.mapper.DepartmentMapper;
import hospital.model.Department;
import hospital.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class DepartmentServiceImpl implements DepartmentService {

    @Autowired
    private DepartmentMapper departmentMapper;

    @Override
    public List<Department> findAll() {
        return departmentMapper.findAll();
    }

    @Override
    public Department findById(int id) {
        return departmentMapper.findById(id);
    }

    @Override
    @Transactional
    public int insert(Department department) {
        return departmentMapper.insert(department);
    }

    @Override
    @Transactional
    public int update(Department department) {
        return departmentMapper.update(department);
    }

    @Override
    @Transactional
    public int deleteById(int id) {
        return departmentMapper.deleteById(id);
    }
}
