package cn.iocoder.yudao.module.org.framework.datapermission.aop;

import cn.iocoder.yudao.framework.datapermission.core.annotation.DataPermission;
import cn.iocoder.yudao.framework.datapermission.core.aop.DataPermissionContextHolder;
import cn.iocoder.yudao.module.org.framework.datapermission.annotation.OrgDataScope;
import com.baomidou.mybatisplus.core.metadata.TableInfoHelper;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

@Aspect
@Component
public class OrgDataScopeAspect {

    private static final DataPermission ORG_DATA_PERMISSION = EnableOrgWarehouseDataPermission.class
            .getAnnotation(DataPermission.class);

    @Around("@annotation(orgDataScope)")
    public Object around(ProceedingJoinPoint joinPoint, OrgDataScope orgDataScope) throws Throwable {
        OrgDataScopeContextHolder.set(buildContext(orgDataScope));
        DataPermissionContextHolder.add(ORG_DATA_PERMISSION);
        try {
            return joinPoint.proceed();
        } finally {
            DataPermissionContextHolder.remove();
            OrgDataScopeContextHolder.clear();
        }
    }

    private OrgDataScopeContext buildContext(OrgDataScope orgDataScope) {
        OrgDataScopeContext context = new OrgDataScopeContext();
        context.setWarehouseColumn(orgDataScope.warehouseColumn());
        context.setTableAlias(orgDataScope.tableAlias());
        context.setRespectContext(orgDataScope.respectContext());
        String tableName = orgDataScope.tableName();
        if (!StringUtils.hasText(tableName) && orgDataScope.tableClass() != Void.class) {
            tableName = TableInfoHelper.getTableInfo(orgDataScope.tableClass()).getTableName();
        }
        context.setTableName(tableName);
        return context;
    }

}
