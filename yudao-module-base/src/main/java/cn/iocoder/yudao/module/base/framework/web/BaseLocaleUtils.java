package cn.iocoder.yudao.module.base.framework.web;

import cn.hutool.core.util.StrUtil;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

/**
 * 从请求头解析界面语言（与前端 Accept-Language 一致）
 */
public final class BaseLocaleUtils {

    private BaseLocaleUtils() {
    }

    public static String getLangCode() {
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attributes == null) {
            return "en";
        }
        return resolveLangCode(attributes.getRequest().getHeader("Accept-Language"));
    }

    public static String resolveLangCode(String acceptLanguage) {
        if (StrUtil.isBlank(acceptLanguage)) {
            return "en";
        }
        String first = acceptLanguage.split(",")[0].trim();
        int semicolon = first.indexOf(';');
        if (semicolon > 0) {
            first = first.substring(0, semicolon).trim();
        }
        int dash = first.indexOf('-');
        if (dash > 0) {
            first = first.substring(0, dash);
        }
        return first.toLowerCase();
    }

}
