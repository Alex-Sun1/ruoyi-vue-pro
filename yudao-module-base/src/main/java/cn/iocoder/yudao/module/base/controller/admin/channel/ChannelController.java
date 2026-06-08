package cn.iocoder.yudao.module.base.controller.admin.channel;

import cn.iocoder.yudao.framework.apilog.core.annotation.ApiAccessLog;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.excel.core.util.ExcelUtils;
import cn.iocoder.yudao.module.base.controller.admin.channel.vo.*;
import cn.iocoder.yudao.module.base.service.channel.ChannelService;
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

@Tag(name = "Admin - Channel")
@RestController
@RequestMapping("/base/channel")
@Validated
public class ChannelController {

    @Resource
    private ChannelService channelService;

    @PostMapping("/create")
    @Operation(summary = "Create channel")
    @PreAuthorize("@ss.hasPermission('base:channel:add')")
    @ApiAccessLog(operateType = CREATE)
    public CommonResult<Long> create(@Valid @RequestBody ChannelSaveReqVO createReqVO) {
        return success(channelService.createChannel(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "Update channel")
    @PreAuthorize("@ss.hasPermission('base:channel:edit')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> update(@Valid @RequestBody ChannelSaveReqVO updateReqVO) {
        channelService.updateChannel(updateReqVO);
        return success(true);
    }

    @PutMapping("/update-status")
    @Operation(summary = "Update channel status")
    @PreAuthorize("@ss.hasPermission('base:channel:edit')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> updateStatus(@Valid @RequestBody ChannelUpdateStatusReqVO reqVO) {
        channelService.updateChannelStatus(reqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "Delete channel")
    @Parameter(name = "id", required = true)
    @PreAuthorize("@ss.hasPermission('base:channel:remove')")
    @ApiAccessLog(operateType = DELETE)
    public CommonResult<Boolean> delete(@RequestParam("id") Long id) {
        channelService.deleteChannel(id);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "Get channel")
    @Parameter(name = "id", required = true)
    @PreAuthorize("@ss.hasPermission('base:channel:list')")
    public CommonResult<ChannelRespVO> get(@RequestParam("id") Long id) {
        return success(channelService.getChannel(id));
    }

    @GetMapping("/page")
    @Operation(summary = "Get channel page")
    @PreAuthorize("@ss.hasPermission('base:channel:list')")
    public CommonResult<PageResult<ChannelRespVO>> page(@Valid ChannelPageReqVO pageReqVO) {
        return success(channelService.getChannelPage(pageReqVO));
    }

    @GetMapping("/simple-list")
    @Operation(summary = "Get channel simple list")
    public CommonResult<List<ChannelRespVO>> simpleList(
            @RequestParam(value = "status", required = false) Integer status,
            @RequestParam(value = "channelType", required = false) String channelType,
            @RequestParam(value = "containerMode", required = false) String containerMode) {
        Integer queryStatus = status != null ? status : CommonStatusEnum.ENABLE.getStatus();
        return success(channelService.getChannelSimpleList(queryStatus, channelType, containerMode));
    }

    @GetMapping("/export")
    @Operation(summary = "Export channel")
    @PreAuthorize("@ss.hasPermission('base:channel:export')")
    @ApiAccessLog(operateType = EXPORT)
    public void export(@Valid ChannelPageReqVO pageReqVO, HttpServletResponse response) throws IOException {
        ExcelUtils.write(response, "channel-list.xls", "channel", ChannelRespVO.class,
                channelService.getChannelExportList(pageReqVO));
    }

}
