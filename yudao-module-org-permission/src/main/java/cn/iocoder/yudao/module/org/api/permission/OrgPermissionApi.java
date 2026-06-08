package cn.iocoder.yudao.module.org.api.permission;

import cn.iocoder.yudao.module.org.service.permission.dto.OrgUserOrgPermissionDTO;

import java.util.Set;

public interface OrgPermissionApi {

    OrgUserOrgPermissionDTO getUserOrgPermission(Long userId);

    Set<Long> getVisibleWarehouseIds(Long userId);

    void checkWarehousePermission(Long userId, Long warehouseId);

}
