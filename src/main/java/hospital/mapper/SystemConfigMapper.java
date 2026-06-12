package hospital.mapper;

import org.apache.ibatis.annotations.Param;

public interface SystemConfigMapper {
    String findValue(@Param("configKey") String configKey);

    int upsert(@Param("configKey") String configKey, @Param("configValue") String configValue);
}
