package cn.iocoder.yudao.module.org.framework.web;

import cn.hutool.core.util.NumberUtil;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

/**
 * 解析顶栏 Header：X-Org-Company-Id、X-Org-Warehouse-Id
 */
public class OrgContextFilter extends OncePerRequestFilter {

    public static final String HEADER_COMPANY_ID = "X-Org-Company-Id";
    public static final String HEADER_WAREHOUSE_ID = "X-Org-Warehouse-Id";

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {
        try {
            String companyId = request.getHeader(HEADER_COMPANY_ID);
            if (NumberUtil.isNumber(companyId)) {
                OrgContextHolder.setCompanyId(Long.valueOf(companyId));
            }
            String warehouseId = request.getHeader(HEADER_WAREHOUSE_ID);
            if (NumberUtil.isNumber(warehouseId)) {
                OrgContextHolder.setWarehouseId(Long.valueOf(warehouseId));
            }
            chain.doFilter(request, response);
        } finally {
            OrgContextHolder.clear();
        }
    }

}
