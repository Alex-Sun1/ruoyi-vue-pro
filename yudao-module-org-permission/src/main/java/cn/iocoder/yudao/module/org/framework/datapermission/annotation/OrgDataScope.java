package cn.iocoder.yudao.module.org.framework.datapermission.annotation;

import java.lang.annotation.*;

/**
 * 海外仓仓库维度数据权限（仅在与 {@link cn.iocoder.yudao.module.org.framework.datapermission.aop.EnableOrgWarehouseDataPermission} 联动时生效）
 */
@Target({ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface OrgDataScope {

    /**
     * 仓库字段名
     */
    String warehouseColumn() default "warehouse_id";

    /**
     * SQL 表别名，如 t
     */
    String tableAlias() default "";

    /**
     * 物理表名；为空时从 {@link #tableClass()} 解析
     */
    String tableName() default "";

    /**
     * 实体类，用于解析表名
     */
    Class<?> tableClass() default Void.class;

    /**
     * 是否尊重顶栏 X-Org-Warehouse-Id（在可见范围内时缩窄为单仓）
     */
    boolean respectContext() default true;

}
