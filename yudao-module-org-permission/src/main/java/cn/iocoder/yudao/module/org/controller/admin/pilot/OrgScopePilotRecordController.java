package cn.iocoder.yudao.module.org.controller.admin.pilot;

import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.org.controller.admin.pilot.vo.OrgScopePilotRecordPageReqVO;
import cn.iocoder.yudao.module.org.controller.admin.pilot.vo.OrgScopePilotRecordRespVO;
import cn.iocoder.yudao.module.org.service.pilot.OrgScopePilotRecordService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - 组织数据权限试点")
@RestController
@RequestMapping("/org/pilot/record")
@Validated
public class OrgScopePilotRecordController {

    @Resource
    private OrgScopePilotRecordService pilotRecordService;

    @GetMapping("/page")
    @Operation(summary = "试点单据分页（@OrgDataScope 过滤）")
    public CommonResult<PageResult<OrgScopePilotRecordRespVO>> getPilotRecordPage(@Valid OrgScopePilotRecordPageReqVO pageReqVO) {
        return success(pilotRecordService.getPilotRecordPage(pageReqVO));
    }

}
