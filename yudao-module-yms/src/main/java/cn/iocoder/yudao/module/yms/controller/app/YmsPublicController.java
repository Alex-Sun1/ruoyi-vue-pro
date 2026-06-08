package cn.iocoder.yudao.module.yms.controller.app;

import jakarta.annotation.security.PermitAll;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;
import cn.iocoder.yudao.framework.tenant.core.util.TenantUtils;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsDriverSelfCheckInReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsTrailerCheckinReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsDriverSelfCheckInRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsParkingSlotRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsTrailerCheckinLookupRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsTrailerCheckinResultRespVO;
import cn.iocoder.yudao.module.yms.service.YmsGateService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * YMS 公开接口（无需登录，@PermitAll 跳过 Sa-Token 鉴权）
 * 供司机通过 H5 扫码页面直接调用。
 */
@PermitAll
@Validated

@RestController
@RequestMapping("/yms/public")
public class YmsPublicController {

    @Resource
    private YmsGateService gateService;

    /**
     * 司机自助 Check-in（H5 扫码入口）
     * 司机扫仓库二维码后填写：柜号/车厢号、堆场位、手机号，提交签到。
     * tenantId 由 QR 码链接携带，公开接口无登录态，此处手动切换租户上下文。
     */
    @PostMapping("/driver-checkin")
    public CommonResult<YmsDriverSelfCheckInRespVO> driverCheckIn(@Valid @RequestBody YmsDriverSelfCheckInReqVO bo) {
        return success(TenantUtils.execute(Long.valueOf(bo.getTenantId()), () -> gateService.driverSelfCheckIn(bo)));
    }

    /**
     * 查询仓库可用堆场位列表（供 H5 下拉选择使用）
     * tenantId 由 QR 码链接携带，公开接口无登录态，此处手动切换租户上下文。
     */
    @GetMapping("/parking-slots")
    public CommonResult<List<YmsParkingSlotRespVO>> listParkingSlots(@RequestParam Long warehouseId,
                                                       @RequestParam String tenantId) {
        return success(TenantUtils.execute(Long.valueOf(tenantId), () -> gateService.listAvailableParkingSlots(warehouseId)));
    }

    // ─── 装车司机 H5 预登记（无需登录） ──────────────────────────────────────

    /**
     * 按提货号查询派送信息（含派送明细）
     * 司机进入装车登记页面后，输入提货号查询本次派送安排。
     */
    @GetMapping("/trailer-checkin/lookup")
    public CommonResult<YmsTrailerCheckinLookupRespVO> trailerCheckinLookup(
            @NotBlank(message = "提货号不能为空") @RequestParam String pickupNo) {
        return success(gateService.lookupTrailerCheckin(pickupNo));
    }

    /**
     * 装车司机提交预登记
     * 司机填写手机号、驾照号、车厢号后提交，系统记录司机信息并推进任务至 PRE_ARRIVAL。
     */
    @PostMapping("/trailer-checkin")
    public CommonResult<YmsTrailerCheckinResultRespVO> trailerCheckin(@Valid @RequestBody YmsTrailerCheckinReqVO bo) {
        return success(gateService.trailerCheckin(bo));
    }
}
