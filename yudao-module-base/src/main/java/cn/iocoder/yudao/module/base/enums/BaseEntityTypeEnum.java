package cn.iocoder.yudao.module.base.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 多语言实体类型
 */
@Getter
@AllArgsConstructor
public enum BaseEntityTypeEnum {

    COUNTRY("country"),
    STATE_PROVINCE("state_province"),
    CITY("city"),
    CURRENCY("currency"),
    PLATFORM("platform"),
    PLATFORM_ADDRESS("platform_address"),
    PORT("port"),
    SHIPPING_LINE("shipping_line"),
    ;

    private final String type;

}
