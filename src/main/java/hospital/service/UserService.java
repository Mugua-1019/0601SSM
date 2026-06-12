package hospital.service;

import hospital.model.User;

public interface UserService {
    void ensureDefaultUsers();

    User findByUsernameAndPassword(String username, String password);

    User findByUsername(String username);

    int registerPatient(User user);

    int updatePassword(int userId, String oldPassword, String newPassword);
}
