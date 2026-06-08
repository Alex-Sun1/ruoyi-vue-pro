package cn.iocoder.yudao.module.wms.service.no;

import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.ThreadLocalRandom;

@Service
public class WmsNoGenerateServiceImpl implements WmsNoGenerateService {

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyyMMdd");

    @Override
    public String generateDevanningNo() {
        int random = ThreadLocalRandom.current().nextInt(100000, 1000000);
        return "DN" + LocalDate.now().format(DATE_FORMATTER) + "-" + random;
    }

}
