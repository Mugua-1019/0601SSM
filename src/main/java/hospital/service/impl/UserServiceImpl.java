package hospital.service.impl;

import hospital.mapper.UserMapper;
import hospital.model.User;
import hospital.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    @Transactional
    public void ensureDefaultUsers() {
        userMapper.ensureUser("admin", "123456", "系统管理员", "admin");
        userMapper.ensureUser("patient", "123456", "测试患者", "patient");
        userMapper.ensureUser("doctor", "123456", "测试医生", "doctor");
        userMapper.ensureUser("pharmacist", "123456", "测试药剂师", "pharmacist");
    }

    @Override
    public User findByUsernameAndPassword(String username, String password) {
        return userMapper.findByUsernameAndPassword(username, password);
    }

    @Override
    @Transactional
    public int updatePassword(int userId, String oldPassword, String newPassword) {
        return userMapper.updatePassword(userId, oldPassword, newPassword);
    }
}
