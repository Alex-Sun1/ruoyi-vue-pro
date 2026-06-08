package cn.iocoder.yudao.module.org.controller.admin.org;

import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.framework.security.core.util.SecurityFrameworkUtils;
import cn.iocoder.yudao.module.org.controller.admin.org.vo.OrgPermissionSelfRespVO;
import cn.iocoder.yudao.module.org.service.permission.OrgPermissionService;
import cn.iocoder.yudao.module.org.service.permission.dto.OrgUserOrgPermissionDTO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - 海外仓组织权限（当前用户）")
@RestController
@RequestMapping("/org/org-permission")
@Validated
public class OrgPermissionController {

    @Resource
    private OrgPermissionService orgPermissionService;

    @GetMapping("/self")
    @Operation(summary = "当前用户组织数据权限（登录预热，可选）")
    public CommonResult<OrgPermissionSelfRespVO> getSelfOrgPermission() {
        OrgUserOrgPermissionDTO dto = orgPermissionService.getUserOrgPermission(SecurityFrameworkUtils.getLoginUserId());
        return success(BeanUtils.toBean(dto, OrgPermissionSelfRespVO.class));
    }

}
