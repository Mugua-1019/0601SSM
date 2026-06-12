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
        userMapper.ensureUser("doctor", "123456", "张明", "doctor");
        userMapper.ensureUser("doctor_lihua", "123456", "李华", "doctor");
        userMapper.ensureUser("doctor_wangqiang", "123456", "王强", "doctor");
        userMapper.ensureUser("doctor_zhaolei", "123456", "赵磊", "doctor");
        userMapper.ensureUser("doctor_chenjing", "123456", "陈静", "doctor");
        userMapper.ensureUser("doctor_liumin", "123456", "刘敏", "doctor");
        userMapper.ensureUser("doctor_zhoufang", "123456", "周芳", "doctor");
        userMapper.ensureUser("doctor_sunli", "123456", "孙丽", "doctor");
        userMapper.ensureUser("doctor_wubin", "123456", "吴斌", "doctor");
        userMapper.ensureUser("doctor_zhengwei", "123456", "郑伟", "doctor");
        userMapper.ensureUser("pharmacist", "123456", "药剂师李娜", "pharmacist");
    }

    @Override
    public User findByUsernameAndPassword(String username, String password) {
        return userMapper.findByUsernameAndPassword(username, password);
    }

    @Override
    public User findByUsername(String username) {
        return userMapper.findByUsername(username);
    }

    @Override
    @Transactional
    public int registerPatient(User user) {
        user.setRole("patient");
        return userMapper.insert(user);
    }

    @Override
    @Transactional
    public int updatePassword(int userId, String oldPassword, String newPassword) {
        return userMapper.updatePassword(userId, oldPassword, newPassword);
    }
}
