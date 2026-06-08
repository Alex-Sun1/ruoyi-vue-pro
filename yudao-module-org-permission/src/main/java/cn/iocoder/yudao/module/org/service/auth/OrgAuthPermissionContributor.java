package cn.iocoder.yudao.module.org.service.auth;

import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.org.service.permission.OrgPermissionService;
import cn.iocoder.yudao.module.org.service.permission.dto.OrgUserOrgPermissionDTO;
import cn.iocoder.yudao.module.system.controller.admin.auth.vo.AuthOrgPermissionVO;
import cn.iocoder.yudao.module.system.service.auth.AuthPermissionOrgContributor;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Component;

@Component
public class OrgAuthPermissionContributor implements AuthPermissionOrgContributor {

    @Resource
    private OrgPermissionService orgPermissionService;

    @Override
    public AuthOrgPermissionVO buildOrgPermission(Long userId) {
        OrgUserOrgPermissionDTO dto = orgPermissionService.getUserOrgPermission(userId);
        return BeanUtils.toBean(dto, AuthOrgPermissionVO.class);
    }

}
