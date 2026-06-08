package cn.iocoder.yudao.module.org.framework.datapermission.rule;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.enums.UserTypeEnum;
import cn.iocoder.yudao.framework.datapermission.core.rule.DataPermissionRule;
import cn.iocoder.yudao.framework.mybatis.core.util.MyBatisUtils;
import cn.iocoder.yudao.framework.security.core.LoginUser;
import cn.iocoder.yudao.framework.security.core.util.SecurityFrameworkUtils;
import cn.iocoder.yudao.module.org.framework.datapermission.aop.OrgDataScopeContext;
import cn.iocoder.yudao.module.org.framework.datapermission.aop.OrgDataScopeContextHolder;
import cn.iocoder.yudao.module.org.framework.web.OrgContextHolder;
import cn.iocoder.yudao.module.org.controller.admin.accessible.vo.OrgWarehouseAccessibleRespVO;
import cn.iocoder.yudao.module.org.service.permission.OrgPermissionService;
import cn.iocoder.yudao.module.org.service.permission.dto.OrgUserOrgPermissionDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jsqlparser.expression.Alias;
import net.sf.jsqlparser.expression.Expression;
import net.sf.jsqlparser.expression.LongValue;
import net.sf.jsqlparser.schema.Column;
import net.sf.jsqlparser.expression.operators.relational.EqualsTo;
import net.sf.jsqlparser.expression.operators.relational.ExpressionList;
import net.sf.jsqlparser.expression.operators.relational.InExpression;
import net.sf.jsqlparser.expression.operators.relational.ParenthesedExpressionList;
import org.springframework.stereotype.Component;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 仓库维度数据权限（仅在 {@link OrgDataScopeContextHolder} 有上下文时生效）
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class OrgWarehouseDataPermissionRule implements DataPermissionRule {

    private static final String CONTEXT_KEY = OrgWarehouseDataPermissionRule.class.getSimpleName();

    private final OrgPermissionService orgPermissionService;

    @Override
    public Set<String> getTableNames() {
        OrgDataScopeContext context = OrgDataScopeContextHolder.get();
        if (context == null || StrUtil.isBlank(context.getTableName())) {
            return Collections.emptySet();
        }
        return Set.of(context.getTableName());
    }

    @Override
    public Expression getExpression(String tableName, Alias tableAlias) {
        OrgDataScopeContext scopeContext = OrgDataScopeContextHolder.get();
        if (scopeContext == null || !StrUtil.equals(tableName, scopeContext.getTableName())) {
            return null;
        }
        LoginUser loginUser = SecurityFrameworkUtils.getLoginUser();
        if (loginUser == null || loginUser.getId() == null
                || !UserTypeEnum.ADMIN.getValue().equals(loginUser.getUserType())) {
            return null;
        }

        OrgUserOrgPermissionDTO permission = loginUser.getContext(CONTEXT_KEY, OrgUserOrgPermissionDTO.class);
        if (permission == null) {
            permission = orgPermissionService.getUserOrgPermission(loginUser.getId());
            loginUser.setContext(CONTEXT_KEY, permission);
        }

        Set<Long> warehouseIds = new HashSet<>(permission.getVisibleWarehouseIds());
        if (scopeContext.isRespectContext()) {
            Long headerCompanyId = OrgContextHolder.getCompanyId();
            Long headerWarehouseId = OrgContextHolder.getWarehouseId();
            if (headerWarehouseId != null) {
                if (warehouseIds.contains(headerWarehouseId)) {
                    warehouseIds = Set.of(headerWarehouseId);
                } else {
                    log.warn("[getExpression][用户({}) Header 仓库 {} 不在可见范围，忽略顶栏缩窄]",
                            loginUser.getId(), headerWarehouseId);
                }
            } else if (headerCompanyId != null) {
                Set<Long> companyWarehouseIds = orgPermissionService
                        .getAccessibleWarehouses(loginUser.getId(), headerCompanyId)
                        .stream()
                        .map(OrgWarehouseAccessibleRespVO::getId)
                        .collect(Collectors.toSet());
                warehouseIds.retainAll(companyWarehouseIds);
            }
        }

        Column column = MyBatisUtils.buildColumn(tableName, tableAlias, scopeContext.getWarehouseColumn());
        if (CollUtil.isEmpty(warehouseIds)) {
            return new EqualsTo(new LongValue(1L), new LongValue(0L));
        }
        if (warehouseIds.size() == 1) {
            return new EqualsTo(column, new LongValue(warehouseIds.iterator().next()));
        }
        return new InExpression(column,
                new ParenthesedExpressionList<>(new ExpressionList<>(warehouseIds.stream()
                        .map(LongValue::new)
                        .collect(Collectors.toList()))));
    }

}
