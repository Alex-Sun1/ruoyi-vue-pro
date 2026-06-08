package cn.iocoder.yudao.module.org.framework.web;

import com.alibaba.ttl.TransmittableThreadLocal;

/**
 * 顶栏组织上下文（来自 HTTP Header，非权限本身）
 */
public class OrgContextHolder {

    private static final ThreadLocal<Long> COMPANY_ID = new TransmittableThreadLocal<>();
    private static final ThreadLocal<Long> WAREHOUSE_ID = new TransmittableThreadLocal<>();

    public static void setCompanyId(Long companyId) {
        COMPANY_ID.set(companyId);
    }

    public static Long getCompanyId() {
        return COMPANY_ID.get();
    }

    public static void setWarehouseId(Long warehouseId) {
        WAREHOUSE_ID.set(warehouseId);
    }

    public static Long getWarehouseId() {
        return WAREHOUSE_ID.get();
    }

    public static void clear() {
        COMPANY_ID.remove();
        WAREHOUSE_ID.remove();
    }

}
