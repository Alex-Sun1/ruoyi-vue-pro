package cn.iocoder.yudao.module.org.service.permission;

import cn.iocoder.yudao.module.org.controller.admin.accessible.vo.OrgCompanyAccessibleRespVO;
import cn.iocoder.yudao.module.org.controller.admin.accessible.vo.OrgWarehouseAccessibleRespVO;
import cn.iocoder.yudao.module.org.service.permission.dto.OrgUserOrgPermissionDTO;

import java.util.List;
import java.util.Set;

public interface OrgPermissionService {

    OrgUserOrgPermissionDTO getUserOrgPermission(Long userId);

    Set<Long> getVisibleWarehouseIds(Long userId);

    Set<Long> getVisibleCompanyIds(Long userId);

    List<OrgCompanyAccessibleRespVO> getAccessibleCompanies(Long userId);

    List<OrgWarehouseAccessibleRespVO> getAccessibleWarehouses(Long userId, Long companyId);

    void checkWarehousePermission(Long userId, Long warehouseId);

    void evictUserCache(Long userId);

}
