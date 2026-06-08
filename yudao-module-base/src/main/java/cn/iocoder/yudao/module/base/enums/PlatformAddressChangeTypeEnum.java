package cn.iocoder.yudao.module.base.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum PlatformAddressChangeTypeEnum {

    CREATE("CREATE"),
    UPDATE("UPDATE"),
    STATUS_CHANGE("STATUS_CHANGE"),
    IMPORT("IMPORT"),
    ;

    private final String type;

}
