package hospital.mapper;

import hospital.model.User;
import org.apache.ibatis.annotations.Param;

public interface UserMapper {
    void ensureUser(@Param("username") String username,
                    @Param("password") String password,
                    @Param("realName") String realName,
                    @Param("role") String role);

    User findByUsernameAndPassword(@Param("username") String username,
                                   @Param("password") String password);

    int updatePassword(@Param("userId") int userId,
                       @Param("oldPassword") String oldPassword,
                       @Param("newPassword") String newPassword);
}
