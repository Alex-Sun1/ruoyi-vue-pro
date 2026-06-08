package cn.iocoder.yudao.module.yms.controller.admin;

import org.springframework.security.access.prepost.PreAuthorize;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentAddReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentEditReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentBoardSlotRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentRespVO;
import cn.iocoder.yudao.module.yms.service.YmsAppointmentService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;

@Validated

@RestController
@RequestMapping("/yms/appointment")
public class YmsAppointmentController  {

    @Resource
    private YmsAppointmentService appointmentService;

    @PreAuthorize("@ss.hasPermission('yms:appointment:list')")
    @GetMapping("/list")
    public CommonResult<PageResult<YmsAppointmentRespVO>> list(YmsAppointmentQueryReqVO bo, PageParam pageParam) {
        return success(appointmentService.queryPageList(bo, pageParam));
    }

    @PreAuthorize("@ss.hasPermission('yms:appointment:list')")
    @GetMapping("/board")
    public CommonResult<List<YmsAppointmentBoardSlotRespVO>> board(
            @RequestParam Long warehouseId,
            @RequestParam String aptDate,
            @RequestParam(required = false) String businessType,
            @RequestParam(required = false) String vehicleSource) {
        return success(appointmentService.queryBoard(warehouseId, aptDate, businessType, vehicleSource));
    }

    @PreAuthorize("@ss.hasPermission('yms:appointment:query')")
    @GetMapping("/{id}")
    public CommonResult<YmsAppointmentRespVO> getInfo(@NotNull @PathVariable Long id) {
        return success(appointmentService.queryById(id));
    }

    @PreAuthorize("@ss.hasPermission('yms:appointment:add')")
    @PostMapping
    public CommonResult<YmsAppointmentRespVO> add(@Valid @RequestBody YmsAppointmentAddReqVO bo) {
        return success(appointmentService.createAppointment(bo));
    }

    @PreAuthorize("@ss.hasPermission('yms:appointment:edit')")
    @PutMapping
    public CommonResult<Boolean> edit(@Valid @RequestBody YmsAppointmentEditReqVO bo) {
        return success(appointmentService.updateByBo(bo));
    }

    @PreAuthorize("@ss.hasPermission('yms:appointment:edit')")
    @PostMapping("/{id}/confirm")
    public CommonResult<Boolean> confirm(@NotNull @PathVariable Long id) {
        return success(appointmentService.confirmAppointment(id));
    }

    @PreAuthorize("@ss.hasPermission('yms:appointment:edit')")
    @PostMapping("/{id}/cancel")
    public CommonResult<Boolean> cancel(@NotNull @PathVariable Long id,
                          @RequestParam(required = false) String reason) {
        return success(appointmentService.cancelAppointment(id, reason));
    }

    @PreAuthorize("@ss.hasPermission('yms:appointment:edit')")
    @PostMapping("/{id}/no-show")
    public CommonResult<Boolean> noShow(@NotNull @PathVariable Long id) {
        return success(appointmentService.markNoShow(id));
    }

    @PreAuthorize("@ss.hasPermission('yms:appointment:remove')")
    @DeleteMapping("/{ids}")
    public CommonResult<Boolean> remove(@NotEmpty @PathVariable Long[] ids) {
        return success(appointmentService.deleteByIds(Arrays.asList(ids)));
    }
}
