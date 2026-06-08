package cn.iocoder.yudao.module.yms.controller.admin;

import org.springframework.security.access.prepost.PreAuthorize;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCheckInQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCheckOutReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsInYardQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsUnifiedCheckInReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCheckInReceiptRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCheckInRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCheckOutRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsInYardRespVO;
import cn.iocoder.yudao.module.yms.service.YmsGateService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@Validated

@RestController
@RequestMapping("/yms/gate")
public class YmsGateController  {

    @Resource
    private YmsGateService gateService;

    /** 进出流水列表 */
    @PreAuthorize("@ss.hasPermission('yms:gate:list')")
    @GetMapping("/list")
    public CommonResult<PageResult<YmsCheckInRespVO>> list(YmsCheckInQueryReqVO bo, PageParam pageParam) {
        return success(gateService.queryPageList(bo, pageParam));
    }

    /** 当前在场车辆/海柜/车厢 */
    @PreAuthorize("@ss.hasPermission('yms:gate:inYard')")
    @GetMapping("/in-yard")
    public CommonResult<PageResult<YmsInYardRespVO>> inYardList(YmsInYardQueryReqVO bo, PageParam pageParam) {
        return success(gateService.queryInYardList(bo, pageParam));
    }

    /**
     * 门岗统一 Check-in
     * 替代原海柜Check-in和装车Check-in两个分离入口，同一页面处理全部车辆类型。
     * 自动比对OMS推送数据，记录不一致字段（不影响放行流程）。
     */
    @PreAuthorize("@ss.hasPermission('yms:gate:checkIn')")
    @PostMapping("/unified-check-in")
    public CommonResult<YmsCheckInRespVO> unifiedCheckIn(@Valid @RequestBody YmsUnifiedCheckInReqVO bo) {
        return success(gateService.unifiedCheckIn(bo));
    }

    /** Check-out 匹配预览（不执行离场，仅返回匹配结果） */
    @PreAuthorize("@ss.hasPermission('yms:gate:checkout')")
    @GetMapping("/check-out/lookup")
    public CommonResult<YmsCheckOutRespVO> lookupCheckOut(@RequestParam Long warehouseId,
                                           @RequestParam String keyword) {
        return success(gateService.lookupCheckOut(warehouseId, keyword));
    }

    /** Check-out 离场确认 */
    @PreAuthorize("@ss.hasPermission('yms:gate:checkout')")
    @PostMapping("/check-out")
    public CommonResult<YmsCheckOutRespVO> checkOut(@Valid @RequestBody YmsCheckOutReqVO bo) {
        return success(gateService.checkOut(bo));
    }

    /** 手动放行（覆盖 REJECTED/PENDING 结果） */
    @PreAuthorize("@ss.hasPermission('yms:gate:checkIn')")
    @PostMapping("/{id}/manual-pass")
    public CommonResult<YmsCheckInRespVO> manualPass(@NotNull @PathVariable Long id,
                                      @RequestParam(required = false) String remark) {
        return success(gateService.manualPass(id, remark));
    }

    /** 入场小票数据（打印用） */
    @PreAuthorize("@ss.hasPermission('yms:gate:list')")
    @GetMapping("/{id}/receipt")
    public CommonResult<YmsCheckInReceiptRespVO> receipt(@NotNull @PathVariable Long id) {
        return success(gateService.queryReceipt(id));
    }
}
