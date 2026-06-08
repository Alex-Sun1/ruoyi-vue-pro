package cn.iocoder.yudao.module.base.controller.admin.terminal;

import cn.iocoder.yudao.framework.apilog.core.annotation.ApiAccessLog;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.excel.core.util.ExcelUtils;
import cn.iocoder.yudao.module.base.controller.admin.terminal.vo.*;
import cn.iocoder.yudao.module.base.service.terminal.TerminalService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;

import static cn.iocoder.yudao.framework.apilog.core.enums.OperateTypeEnum.*;
import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - 码头")
@RestController
@RequestMapping("/base/terminal")
@Validated
public class TerminalController {

    @Resource
    private TerminalService terminalService;

    @PostMapping("/create")
    @Operation(summary = "创建码头")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    @ApiAccessLog(operateType = CREATE)
    public CommonResult<Long> create(@Valid @RequestBody TerminalSaveReqVO createReqVO) {
        return success(terminalService.createTerminal(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新码头")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> update(@Valid @RequestBody TerminalSaveReqVO updateReqVO) {
        terminalService.updateTerminal(updateReqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除码头")
    @Parameter(name = "id", required = true)
    @PreAuthorize("@ss.hasPermission('base:data:delete')")
    @ApiAccessLog(operateType = DELETE)
    public CommonResult<Boolean> delete(@RequestParam("id") Long id) {
        terminalService.deleteTerminal(id);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得码头详情")
    @Parameter(name = "id", required = true)
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<TerminalRespVO> get(@RequestParam("id") Long id) {
        return success(terminalService.getTerminal(id));
    }

    @GetMapping("/page")
    @Operation(summary = "获得码头分页")
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<PageResult<TerminalRespVO>> page(@Valid TerminalPageReqVO pageReqVO) {
        return success(terminalService.getTerminalPage(pageReqVO));
    }

    @GetMapping("/simple-list")
    @Operation(summary = "获得码头精简列表", description = "默认 status=0（正常），供下拉选择")
    public CommonResult<List<TerminalRespVO>> getSimpleList(
            @RequestParam(value = "status", required = false) Integer status) {
        Integer queryStatus = status != null ? status : CommonStatusEnum.ENABLE.getStatus();
        return success(terminalService.getTerminalSimpleList(queryStatus));
    }

    @GetMapping("/export")
    @Operation(summary = "导出码头")
    @PreAuthorize("@ss.hasPermission('base:data:export')")
    @ApiAccessLog(operateType = EXPORT)
    public void export(@Valid TerminalPageReqVO pageReqVO, HttpServletResponse response) throws IOException {
        ExcelUtils.write(response, "terminal.xls", "码头", TerminalRespVO.class,
                terminalService.getTerminalExportList(pageReqVO));
    }

}
