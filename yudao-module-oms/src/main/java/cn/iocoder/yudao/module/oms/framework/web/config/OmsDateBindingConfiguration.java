package cn.iocoder.yudao.module.oms.framework.web.config;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.StrUtil;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.convert.converter.Converter;
import org.springframework.format.FormatterRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.util.Date;

/**
 * OMS 查询参数绑定：空字符串日期视为 null，避免高级筛选残留 "" 导致 BindException。
 */
@Configuration
public class OmsDateBindingConfiguration implements WebMvcConfigurer {

    @Override
    public void addFormatters(FormatterRegistry registry) {
        registry.addConverter(new Converter<String, Date>() {
            @Override
            public Date convert(String source) {
                if (StrUtil.isBlank(source)) {
                    return null;
                }
                String text = source.trim();
                if (text.length() <= 10) {
                    return DateUtil.parse(text, "yyyy-MM-dd");
                }
                if (text.length() <= 16) {
                    return DateUtil.parse(text, "yyyy-MM-dd HH:mm");
                }
                return DateUtil.parse(text, "yyyy-MM-dd HH:mm:ss");
            }
        });
    }
}
