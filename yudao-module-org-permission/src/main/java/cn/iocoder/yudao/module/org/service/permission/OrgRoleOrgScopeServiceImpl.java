package cn.iocoder.yudao.module.org.service.permission;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.json.JSONUtil;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.framework.security.core.util.SecurityFrameworkUtils;
import cn.iocoder.yudao.framework.tenant.core.context.TenantContextHolder;
import cn.iocoder.yudao.module.base.dal.dataobject.company.CompanyDO;
import cn.iocoder.yudao.module.base.dal.dataobject.warehouse.WarehouseDO;
import cn.iocoder.yudao.module.base.dal.mysql.company.CompanyMapper;
import cn.iocoder.yudao.module.base.dal.mysql.warehouse.BaseWarehouseMapper;
import cn.iocoder.yudao.module.system.api.permission.PermissionApi;
import cn.iocoder.yudao.module.system.dal.dataobject.permission.RoleDO;
import cn.iocoder.yudao.module.system.service.permission.RoleService;
import cn.iocoder.yudao.module.org.controller.admin.accessible.vo.OrgCompanyAccessibleRespVO;
import cn.iocoder.yudao.module.org.controller.admin.accessible.vo.OrgWarehouseAccessibleRespVO;
import cn.iocoder.yudao.module.org.controller.admin.role.vo.OrgRoleOrgScopeRespVO;
import cn.iocoder.yudao.module.org.controller.admin.role.vo.OrgRoleOrgScopeSaveReqVO;
import cn.iocoder.yudao.module.org.dal.dataobject.permission.OrgPermissionLogDO;
import cn.iocoder.yudao.module.org.dal.dataobject.permission.OrgRoleCompanyScopeDO;
import cn.iocoder.yudao.module.org.dal.dataobject.permission.OrgRoleOrgScopeDO;
import cn.iocoder.yudao.module.org.dal.dataobject.permission.OrgRoleWarehouseScopeDO;
import cn.iocoder.yudao.module.org.dal.mysql.permission.OrgPermissionLogMapper;
import cn.iocoder.yudao.module.org.dal.mysql.permission.OrgRoleCompanyScopeMapper;
import cn.iocoder.yudao.module.org.dal.mysql.permission.OrgRoleOrgScopeMapper;
import cn.iocoder.yudao.module.org.dal.mysql.permission.OrgRoleWarehouseScopeMapper;
import cn.iocoder.yudao.module.org.enums.OrgScopeEnum;
import cn.iocoder.yudao.module.org.enums.OrgPermissionLogActionEnum;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import java.util.*;
import java.util.stream.Collectors;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.org.enums.ErrorCodeConstants.ORG_ROLE_NOT_EXISTS;
import static cn.iocoder.yudao.module.org.enums.ErrorCodeConstants.ORG_ROLE_ORG_SCOPE_INVALID;

@Service
@Validated
public class OrgRoleOrgScopeServiceImpl implements OrgRoleOrgScopeService {

    @Resource
    private RoleService roleService;
    @Resource
    private OrgRoleOrgScopeMapper roleOrgScopeMapper;
    @Resource
    private OrgRoleCompanyScopeMapper roleCompanyScopeMapper;
    @Resource
    private OrgRoleWarehouseScopeMapper roleWarehouseScopeMapper;
    @Resource
    private OrgPermissionLogMapper permissionLogMapper;
    @Resource
    private PermissionApi permissionApi;
    @Resource
    private OrgPermissionCacheService permissionCacheService;
    @Resource
    private CompanyMapper companyMapper;
    @Resource
    private BaseWarehouseMapper baseWarehouseMapper;

    @Override
    public OrgRoleOrgScopeRespVO getRoleOrgScope(Long roleId) {
        RoleDO role = validateRole(roleId);
        OrgRoleOrgScopeRespVO resp = new OrgRoleOrgScopeRespVO();
        resp.setRoleId(roleId);
        resp.setRoleName(role.getName());
        OrgRoleOrgScopeDO scope = roleOrgScopeMapper.selectByRoleId(roleId);
        if (scope == null) {
            resp.setOrgScope(null);
            resp.setCompanyIds(List.of());
            resp.setWarehouseIds(List.of());
            resp.setCompanies(List.of());
            resp.setWarehouses(List.of());
            return resp;
        }
        resp.setOrgScope(scope.getOrgScope());
        if (OrgScopeEnum.COMPANY.getScope().equals(scope.getOrgScope())) {
            List<Long> companyIds = roleCompanyScopeMapper.selectListByRoleId(roleId).stream()
                    .map(OrgRoleCompanyScopeDO::getCompanyId).collect(Collectors.toList());
            resp.setCompanyIds(companyIds);
            resp.setCompanies(buildCompanyVOs(companyIds));
            resp.setWarehouseIds(List.of());
            resp.setWarehouses(List.of());
        } else if (OrgScopeEnum.WAREHOUSE.getScope().equals(scope.getOrgScope())) {
            List<Long> warehouseIds = roleWarehouseScopeMapper.selectListByRoleId(roleId).stream()
                    .map(OrgRoleWarehouseScopeDO::getWarehouseId).collect(Collectors.toList());
            resp.setWarehouseIds(warehouseIds);
            resp.setWarehouses(buildWarehouseVOs(warehouseIds));
            resp.setCompanyIds(List.of());
            resp.setCompanies(List.of());
        } else {
            resp.setCompanyIds(List.of());
            resp.setWarehouseIds(List.of());
            resp.setCompanies(List.of());
            resp.setWarehouses(List.of());
        }
        return resp;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void saveRoleOrgScope(OrgRoleOrgScopeSaveReqVO reqVO) {
        validateRole(reqVO.getRoleId());
        validateSaveReq(reqVO);
        OrgRoleOrgScopeRespVO before = getRoleOrgScope(reqVO.getRoleId());

        roleOrgScopeMapper.deleteByRoleId(reqVO.getRoleId());
        roleCompanyScopeMapper.deleteByRoleId(reqVO.getRoleId());
        roleWarehouseScopeMapper.deleteByRoleId(reqVO.getRoleId());

        OrgRoleOrgScopeDO scope = OrgRoleOrgScopeDO.builder()
                .roleId(reqVO.getRoleId())
                .orgScope(reqVO.getOrgScope())
                .build();
        roleOrgScopeMapper.insert(scope);

        if (OrgScopeEnum.COMPANY.getScope().equals(reqVO.getOrgScope())) {
            for (Long companyId : reqVO.getCompanyIds()) {
                roleCompanyScopeMapper.insert(OrgRoleCompanyScopeDO.builder()
                        .roleId(reqVO.getRoleId()).companyId(companyId).build());
            }
        } else if (OrgScopeEnum.WAREHOUSE.getScope().equals(reqVO.getOrgScope())) {
            for (Long warehouseId : reqVO.getWarehouseIds()) {
                roleWarehouseScopeMapper.insert(OrgRoleWarehouseScopeDO.builder()
                        .roleId(reqVO.getRoleId()).warehouseId(warehouseId).build());
            }
        }

        OrgRoleOrgScopeRespVO after = getRoleOrgScope(reqVO.getRoleId());
        insertLog(reqVO.getRoleId(), OrgPermissionLogActionEnum.ORG_ROLE_ORG_SCOPE_UPDATE.getAction(),
                JSONUtil.toJsonStr(before), JSONUtil.toJsonStr(after));
        evictRoleUsersCache(reqVO.getRoleId());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteRoleOrgScope(Long roleId) {
        validateRole(roleId);
        OrgRoleOrgScopeRespVO before = getRoleOrgScope(roleId);
        roleOrgScopeMapper.deleteByRoleId(roleId);
        roleCompanyScopeMapper.deleteByRoleId(roleId);
        roleWarehouseScopeMapper.deleteByRoleId(roleId);
        insertLog(roleId, OrgPermissionLogActionEnum.ORG_ROLE_ORG_SCOPE_DELETE.getAction(),
                JSONUtil.toJsonStr(before), null);
        evictRoleUsersCache(roleId);
    }

    private void validateSaveReq(OrgRoleOrgScopeSaveReqVO reqVO) {
        OrgScopeEnum scopeEnum = OrgScopeEnum.of(reqVO.getOrgScope());
        if (scopeEnum == null) {
            throw exception(ORG_ROLE_ORG_SCOPE_INVALID, "组织范围无效");
        }
        if (scopeEnum == OrgScopeEnum.COMPANY) {
            if (CollUtil.isEmpty(reqVO.getCompanyIds())) {
                throw exception(ORG_ROLE_ORG_SCOPE_INVALID, "COMPANY 类型须选择主体");
            }
            return;
        }
        if (scopeEnum == OrgScopeEnum.WAREHOUSE) {
            if (CollUtil.isEmpty(reqVO.getWarehouseIds())) {
                throw exception(ORG_ROLE_ORG_SCOPE_INVALID, "WAREHOUSE 类型须选择仓库");
            }
            return;
        }
        if (CollUtil.isNotEmpty(reqVO.getCompanyIds()) || CollUtil.isNotEmpty(reqVO.getWarehouseIds())) {
            throw exception(ORG_ROLE_ORG_SCOPE_INVALID, "ALL 类型不应选择主体或仓库");
        }
    }

    private RoleDO validateRole(Long roleId) {
        RoleDO role = roleService.getRole(roleId);
        if (role == null) {
            throw exception(ORG_ROLE_NOT_EXISTS);
        }
        return role;
    }

    private void insertLog(Long roleId, String action, String before, String after) {
        OrgPermissionLogDO log = OrgPermissionLogDO.builder()
                .roleId(roleId)
                .action(action)
                .beforeValue(before)
                .afterValue(after)
                .operatorUserId(SecurityFrameworkUtils.getLoginUserId())
                .operatorName(SecurityFrameworkUtils.getLoginUserNickname())
                .build();
        permissionLogMapper.insert(log);
    }

    private void evictRoleUsersCache(Long roleId) {
        Long tenantId = TenantContextHolder.getRequiredTenantId();
        Set<Long> userIds = permissionApi.getUserRoleIdListByRoleIds(Set.of(roleId));
        permissionCacheService.evictUsers(tenantId, userIds);
    }

    private List<OrgCompanyAccessibleRespVO> buildCompanyVOs(List<Long> companyIds) {
        if (CollUtil.isEmpty(companyIds)) {
            return List.of();
        }
        return companyMapper.selectListByIds(companyIds).stream()
                .map(c -> BeanUtils.toBean(c, OrgCompanyAccessibleRespVO.class))
                .collect(Collectors.toList());
    }

    private List<OrgWarehouseAccessibleRespVO> buildWarehouseVOs(List<Long> warehouseIds) {
        if (CollUtil.isEmpty(warehouseIds)) {
            return List.of();
        }
        List<WarehouseDO> warehouses = baseWarehouseMapper.selectListByIds(warehouseIds);
        Set<Long> companyIds = warehouses.stream().map(WarehouseDO::getCompanyId).filter(Objects::nonNull).collect(Collectors.toSet());
        Map<Long, CompanyDO> companyMap = companyIds.isEmpty() ? Map.of()
                : companyMapper.selectListByIds(companyIds).stream().collect(Collectors.toMap(CompanyDO::getId, c -> c));
        List<OrgWarehouseAccessibleRespVO> list = new ArrayList<>();
        for (WarehouseDO warehouse : warehouses) {
            OrgWarehouseAccessibleRespVO vo = BeanUtils.toBean(warehouse, OrgWarehouseAccessibleRespVO.class);
            CompanyDO company = warehouse.getCompanyId() != null ? companyMap.get(warehouse.getCompanyId()) : null;
            if (company != null) {
                vo.setCompanyName(company.getCompanyName());
            }
            list.add(vo);
        }
        return list;
    }

}
