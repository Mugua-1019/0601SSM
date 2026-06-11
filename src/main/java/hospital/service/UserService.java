package hospital.service;

import hospital.model.User;

public interface UserService {
    void ensureDefaultUsers();

    User findByUsernameAndPassword(String username, String password);

    int updatePassword(int userId, String oldPassword, String newPassword);
}
