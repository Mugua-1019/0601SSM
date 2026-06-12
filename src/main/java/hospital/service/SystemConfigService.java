package hospital.service;

import java.math.BigDecimal;

public interface SystemConfigService {
    BigDecimal getRegistrationFee();

    int updateRegistrationFee(BigDecimal fee);
}
