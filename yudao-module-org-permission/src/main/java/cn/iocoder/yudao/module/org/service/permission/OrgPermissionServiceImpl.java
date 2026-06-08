package cn.iocoder.yudao.module.org.service.permission;

import cn.hutool.core.collection.CollUtil;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.framework.tenant.core.context.TenantContextHolder;
import cn.iocoder.yudao.module.base.dal.dataobject.company.CompanyDO;
import cn.iocoder.yudao.module.base.dal.dataobject.warehouse.WarehouseDO;
import cn.iocoder.yudao.module.base.dal.mysql.company.CompanyMapper;
import cn.iocoder.yudao.module.base.dal.mysql.warehouse.BaseWarehouseMapper;
import cn.iocoder.yudao.module.base.service.warehouse.WarehouseService;
import cn.iocoder.yudao.module.system.api.permission.PermissionApi;
import cn.iocoder.yudao.module.system.dal.dataobject.permission.RoleDO;
import cn.iocoder.yudao.module.system.service.permission.PermissionService;
import cn.iocoder.yudao.module.system.service.permission.RoleService;
import cn.iocoder.yudao.module.org.controller.admin.accessible.vo.OrgCompanyAccessibleRespVO;
import cn.iocoder.yudao.module.org.controller.admin.accessible.vo.OrgWarehouseAccessibleRespVO;
import cn.iocoder.yudao.module.org.dal.dataobject.permission.OrgRoleCompanyScopeDO;
import cn.iocoder.yudao.module.org.dal.dataobject.permission.OrgRoleOrgScopeDO;
import cn.iocoder.yudao.module.org.dal.dataobject.permission.OrgRoleWarehouseScopeDO;
import cn.iocoder.yudao.module.org.dal.mysql.permission.OrgRoleCompanyScopeMapper;
import cn.iocoder.yudao.module.org.dal.mysql.permission.OrgRoleOrgScopeMapper;
import cn.iocoder.yudao.module.org.dal.mysql.permission.OrgRoleWarehouseScopeMapper;
import cn.iocoder.yudao.module.org.enums.OrgScopeEnum;
import cn.iocoder.yudao.module.org.framework.config.OrgPermissionProperties;
import cn.iocoder.yudao.module.org.service.permission.dto.OrgUserOrgPermissionDTO;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.org.enums.ErrorCodeConstants.ORG_PERMISSION_DENIED;

@Service
public class OrgPermissionServiceImpl implements OrgPermissionService {

    @Resource
    private PermissionService permissionService;
    @Resource
    private PermissionApi permissionApi;
    @Resource
    private RoleService roleService;
    @Resource
    private OrgRoleOrgScopeMapper roleOrgScopeMapper;
    @Resource
    private OrgRoleCompanyScopeMapper roleCompanyScopeMapper;
    @Resource
    private OrgRoleWarehouseScopeMapper roleWarehouseScopeMapper;
    @Resource
    private WarehouseService warehouseService;
    @Resource
    private BaseWarehouseMapper baseWarehouseMapper;
    @Resource
    private CompanyMapper companyMapper;
    @Resource
    private OrgPermissionCacheService permissionCacheService;
    @Resource
    private OrgPermissionProperties orgPermissionProperties;

    @Override
    public OrgUserOrgPermissionDTO getUserOrgPermission(Long userId) {
        if (userId == null) {
            return emptyOrgPermission();
        }
        Long tenantId = TenantContextHolder.getRequiredTenantId();
        OrgUserOrgPermissionDTO cached = permissionCacheService.get(tenantId, userId);
        if (cached != null) {
            return cached;
        }
        OrgUserOrgPermissionDTO computed = computeUserOrgPermission(userId);
        permissionCacheService.set(tenantId, userId, computed);
        return computed;
    }

    @Override
    public Set<Long> getVisibleWarehouseIds(Long userId) {
        return getUserOrgPermission(userId).getVisibleWarehouseIds();
    }

    @Override
    public Set<Long> getVisibleCompanyIds(Long userId) {
        return getUserOrgPermission(userId).getVisibleCompanyIds();
    }

    @Override
    public List<OrgCompanyAccessibleRespVO> getAccessibleCompanies(Long userId) {
        Set<Long> companyIds = getVisibleCompanyIds(userId);
        if (CollUtil.isEmpty(companyIds)) {
            return List.of();
        }
        return companyMapper.selectListByIds(companyIds).stream()
                .filter(c -> Objects.equals(c.getStatus(), CommonStatusEnum.ENABLE.getStatus()))
                .sorted(Comparator.comparing(CompanyDO::getSort, Comparator.nullsLast(Integer::compareTo))
                        .thenComparing(CompanyDO::getCompanyCode))
                .map(c -> BeanUtils.toBean(c, OrgCompanyAccessibleRespVO.class))
                .collect(Collectors.toList());
    }

    @Override
    public List<OrgWarehouseAccessibleRespVO> getAccessibleWarehouses(Long userId, Long companyId) {
        Set<Long> warehouseIds = getVisibleWarehouseIds(userId);
        if (CollUtil.isEmpty(warehouseIds)) {
            return List.of();
        }
        List<WarehouseDO> warehouses = baseWarehouseMapper.selectListByIds(warehouseIds).stream()
                .filter(w -> Objects.equals(w.getStatus(), CommonStatusEnum.ENABLE.getStatus()))
                .filter(w -> companyId == null || Objects.equals(w.getCompanyId(), companyId))
                .sorted(Comparator.comparing(WarehouseDO::getSort, Comparator.nullsLast(Integer::compareTo))
                        .thenComparing(WarehouseDO::getWarehouseCode))
                .collect(Collectors.toList());
        if (CollUtil.isEmpty(warehouses)) {
            return List.of();
        }
        Set<Long> companyIds = warehouses.stream().map(WarehouseDO::getCompanyId).filter(Objects::nonNull).collect(Collectors.toSet());
        Map<Long, CompanyDO> companyMap = companyIds.isEmpty() ? Map.of()
                : companyMapper.selectListByIds(companyIds).stream().collect(Collectors.toMap(CompanyDO::getId, c -> c));
        List<OrgWarehouseAccessibleRespVO> result = new ArrayList<>();
        for (WarehouseDO warehouse : warehouses) {
            OrgWarehouseAccessibleRespVO vo = BeanUtils.toBean(warehouse, OrgWarehouseAccessibleRespVO.class);
            CompanyDO company = warehouse.getCompanyId() != null ? companyMap.get(warehouse.getCompanyId()) : null;
            if (company != null) {
                vo.setCompanyName(company.getCompanyName());
            }
            result.add(vo);
        }
        return result;
    }

    @Override
    public void checkWarehousePermission(Long userId, Long warehouseId) {
        if (warehouseId == null) {
            return;
        }
        if (userId == null) {
            throw exception(ORG_PERMISSION_DENIED);
        }
        if (!getVisibleWarehouseIds(userId).contains(warehouseId)) {
            throw exception(ORG_PERMISSION_DENIED);
        }
    }

    @Override
    public void evictUserCache(Long userId) {
        permissionCacheService.evict(TenantContextHolder.getRequiredTenantId(), userId);
    }

    private static OrgUserOrgPermissionDTO emptyOrgPermission() {
        OrgUserOrgPermissionDTO dto = new OrgUserOrgPermissionDTO();
        dto.setBuiltAt(LocalDateTime.now());
        dto.setVisibleWarehouseIds(Set.of());
        dto.setVisibleCompanyIds(Set.of());
        dto.setOrgScopeSummary(null);
        return dto;
    }

    private OrgUserOrgPermissionDTO computeUserOrgPermission(Long userId) {
        OrgUserOrgPermissionDTO dto = new OrgUserOrgPermissionDTO();
        dto.setBuiltAt(LocalDateTime.now());

        Set<Long> roleIds = permissionService.getUserRoleIdListByUserIdFromCache(userId);
        if (CollUtil.isEmpty(roleIds)) {
            dto.setVisibleWarehouseIds(Set.of());
            dto.setVisibleCompanyIds(Set.of());
            dto.setOrgScopeSummary(null);
            return dto;
        }
        List<RoleDO> roles = roleService.getRoleList(roleIds).stream()
                .filter(r -> Objects.equals(r.getStatus(), CommonStatusEnum.ENABLE.getStatus()))
                .collect(Collectors.toList());
        if (CollUtil.isEmpty(roles)) {
            dto.setVisibleWarehouseIds(Set.of());
            dto.setVisibleCompanyIds(Set.of());
            dto.setOrgScopeSummary(null);
            return dto;
        }

        String[] adminCodes = orgPermissionProperties.getPlatformAdminRoleCodes()
                .toArray(new String[0]);
        if (permissionApi.hasAnyRoles(userId, adminCodes)) {
            Set<Long> allWarehouseIds = warehouseService.getEnabledWarehouseIds();
            dto.setVisibleWarehouseIds(allWarehouseIds);
            dto.setVisibleCompanyIds(resolveCompanyIdsFromWarehouses(allWarehouseIds));
            dto.setOrgScopeSummary(OrgScopeEnum.ALL.getScope());
            return dto;
        }

        Set<Long> enabledRoleIds = roles.stream().map(RoleDO::getId).collect(Collectors.toSet());
        List<OrgRoleOrgScopeDO> orgScopes = roleOrgScopeMapper.selectListByRoleIds(enabledRoleIds);
        if (CollUtil.isEmpty(orgScopes)) {
            dto.setVisibleWarehouseIds(Set.of());
            dto.setVisibleCompanyIds(Set.of());
            dto.setOrgScopeSummary(null);
            return dto;
        }

        if (orgScopes.stream().anyMatch(s -> OrgScopeEnum.ALL.getScope().equals(s.getOrgScope()))) {
            Set<Long> allWarehouseIds = warehouseService.getEnabledWarehouseIds();
            dto.setVisibleWarehouseIds(allWarehouseIds);
            dto.setVisibleCompanyIds(resolveCompanyIdsFromWarehouses(allWarehouseIds));
            dto.setOrgScopeSummary(OrgScopeEnum.ALL.getScope());
            return dto;
        }

        Set<Long> warehouseIds = new HashSet<>();
        for (OrgRoleOrgScopeDO scope : orgScopes) {
            if (OrgScopeEnum.COMPANY.getScope().equals(scope.getOrgScope())) {
                List<OrgRoleCompanyScopeDO> companyScopes = roleCompanyScopeMapper.selectListByRoleId(scope.getRoleId());
                Set<Long> companyIds = companyScopes.stream().map(OrgRoleCompanyScopeDO::getCompanyId).collect(Collectors.toSet());
                warehouseIds.addAll(warehouseService.getEnabledWarehouseIdsByCompanyIds(companyIds));
            } else if (OrgScopeEnum.WAREHOUSE.getScope().equals(scope.getOrgScope())) {
                List<OrgRoleWarehouseScopeDO> whScopes = roleWarehouseScopeMapper.selectListByRoleId(scope.getRoleId());
                Set<Long> whIds = whScopes.stream().map(OrgRoleWarehouseScopeDO::getWarehouseId).collect(Collectors.toSet());
                warehouseIds.addAll(warehouseService.getEnabledWarehouseIdsByIds(whIds));
            }
        }
        dto.setVisibleWarehouseIds(warehouseIds);
        dto.setVisibleCompanyIds(resolveCompanyIdsFromWarehouses(warehouseIds));
        dto.setOrgScopeSummary(resolveScopeSummary(orgScopes));
        return dto;
    }

    private Set<Long> resolveCompanyIdsFromWarehouses(Set<Long> warehouseIds) {
        if (CollUtil.isEmpty(warehouseIds)) {
            return Set.of();
        }
        return baseWarehouseMapper.selectListByIds(warehouseIds).stream()
                .map(WarehouseDO::getCompanyId)
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());
    }

    private String resolveScopeSummary(List<OrgRoleOrgScopeDO> orgScopes) {
        if (orgScopes.stream().anyMatch(s -> OrgScopeEnum.ALL.getScope().equals(s.getOrgScope()))) {
            return OrgScopeEnum.ALL.getScope();
        }
        if (orgScopes.stream().anyMatch(s -> OrgScopeEnum.WAREHOUSE.getScope().equals(s.getOrgScope()))) {
            return OrgScopeEnum.WAREHOUSE.getScope();
        }
        if (orgScopes.stream().anyMatch(s -> OrgScopeEnum.COMPANY.getScope().equals(s.getOrgScope()))) {
            return OrgScopeEnum.COMPANY.getScope();
        }
        return null;
    }

}
