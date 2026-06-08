package cn.iocoder.yudao.module.org.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum OrgPermissionLogActionEnum {

    ORG_ROLE_ORG_SCOPE_UPDATE("org_ROLE_ORG_SCOPE_UPDATE"),
    ORG_ROLE_ORG_SCOPE_DELETE("org_ROLE_ORG_SCOPE_DELETE"),
    ;

    private final String action;

}
