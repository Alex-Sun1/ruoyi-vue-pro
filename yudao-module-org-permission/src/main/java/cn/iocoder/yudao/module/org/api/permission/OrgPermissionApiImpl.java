package cn.iocoder.yudao.module.org.api.permission;

import cn.iocoder.yudao.module.org.service.permission.OrgPermissionService;
import cn.iocoder.yudao.module.org.service.permission.dto.OrgUserOrgPermissionDTO;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.util.Set;

@Service
public class OrgPermissionApiImpl implements OrgPermissionApi {

    @Resource
    private OrgPermissionService orgPermissionService;

    @Override
    public OrgUserOrgPermissionDTO getUserOrgPermission(Long userId) {
        return orgPermissionService.getUserOrgPermission(userId);
    }

    @Override
    public Set<Long> getVisibleWarehouseIds(Long userId) {
        return orgPermissionService.getVisibleWarehouseIds(userId);
    }

    @Override
    public void checkWarehousePermission(Long userId, Long warehouseId) {
        orgPermissionService.checkWarehousePermission(userId, warehouseId);
    }

}
