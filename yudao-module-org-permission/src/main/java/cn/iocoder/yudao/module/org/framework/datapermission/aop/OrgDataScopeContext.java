package cn.iocoder.yudao.module.org.framework.datapermission.aop;

import lombok.Data;

@Data
public class OrgDataScopeContext {

    private String tableName;

    private String warehouseColumn;

    private String tableAlias;

    private boolean respectContext;

}
