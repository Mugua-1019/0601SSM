package hospital.service.impl;

import hospital.mapper.SystemConfigMapper;
import hospital.service.SystemConfigService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;

@Service
public class SystemConfigServiceImpl implements SystemConfigService {
    private static final String REGISTRATION_FEE = "registration_fee";

    @Autowired
    private SystemConfigMapper systemConfigMapper;

    @Override
    public BigDecimal getRegistrationFee() {
        String value = systemConfigMapper.findValue(REGISTRATION_FEE);
        if (value == null || value.trim().isEmpty()) {
            return BigDecimal.ZERO;
        }
        return new BigDecimal(value.trim());
    }

    @Override
    @Transactional
    public int updateRegistrationFee(BigDecimal fee) {
        return systemConfigMapper.upsert(REGISTRATION_FEE, fee.toPlainString());
    }
}
