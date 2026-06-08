package cn.iocoder.yudao.module.org.framework.datapermission.aop;

import com.alibaba.ttl.TransmittableThreadLocal;

public class OrgDataScopeContextHolder {

    private static final ThreadLocal<OrgDataScopeContext> CONTEXT = new TransmittableThreadLocal<>();

    public static void set(OrgDataScopeContext context) {
        CONTEXT.set(context);
    }

    public static OrgDataScopeContext get() {
        return CONTEXT.get();
    }

    public static void clear() {
        CONTEXT.remove();
    }

}
