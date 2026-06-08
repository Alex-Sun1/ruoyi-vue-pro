package cn.iocoder.yudao.module.org.framework.web.config;

import cn.iocoder.yudao.framework.common.enums.WebFilterOrderEnum;
import cn.iocoder.yudao.module.org.framework.web.OrgContextFilter;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration(proxyBeanMethods = false)
public class OrgWebConfiguration {

    @Bean
    public FilterRegistrationBean<OrgContextFilter> orgContextFilter() {
        FilterRegistrationBean<OrgContextFilter> bean = new FilterRegistrationBean<>();
        bean.setFilter(new OrgContextFilter());
        bean.setOrder(WebFilterOrderEnum.ORG_CONTEXT_FILTER);
        return bean;
    }

}
