package cn.iocoder.yudao.module.org.enums;

import cn.hutool.core.util.StrUtil;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.Arrays;

@Getter
@AllArgsConstructor
public enum OrgScopeEnum {

    ALL("ALL"),
    COMPANY("COMPANY"),
    WAREHOUSE("WAREHOUSE"),
    ;

    private final String scope;

    public static OrgScopeEnum of(String scope) {
        if (StrUtil.isBlank(scope)) {
            return null;
        }
        return Arrays.stream(values())
                .filter(item -> item.scope.equals(scope))
                .findFirst()
                .orElse(null);
    }

}
