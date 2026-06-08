package cn.iocoder.yudao.module.org.controller.admin.accessible;

import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.security.core.util.SecurityFrameworkUtils;
import cn.iocoder.yudao.module.org.controller.admin.accessible.vo.OrgCompanyAccessibleRespVO;
import cn.iocoder.yudao.module.org.service.permission.OrgPermissionService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - 海外仓可见主体")
@RestController
@RequestMapping("/org/company")
@Validated
public class OrgCompanyAccessibleController {

    @Resource
    private OrgPermissionService orgPermissionService;

    @GetMapping("/accessible")
    @Operation(summary = "当前用户可见主体列表")
    public CommonResult<List<OrgCompanyAccessibleRespVO>> getAccessibleCompanies() {
        return success(orgPermissionService.getAccessibleCompanies(SecurityFrameworkUtils.getLoginUserId()));
    }

}
