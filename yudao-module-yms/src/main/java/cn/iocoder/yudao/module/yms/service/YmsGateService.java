package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCheckInReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCheckInQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCheckOutReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsDriverSelfCheckInReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsInYardQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsTrailerCheckinReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsUnifiedCheckInReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCheckInReceiptRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCheckInRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCheckOutRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsDriverSelfCheckInRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsInYardRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsParkingSlotRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsTrailerCheckinLookupRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsTrailerCheckinResultRespVO;

import java.util.List;

public interface YmsGateService {

    PageResult<YmsCheckInRespVO> queryPageList(YmsCheckInQueryReqVO bo, PageParam pageParam);

    /** 当前在场车辆/海柜/车厢列表 */
    PageResult<YmsInYardRespVO> queryInYardList(YmsInYardQueryReqVO bo, PageParam pageParam);

    /** 门岗统一 Check-in（替代原海柜/装车两个入口） */
    YmsCheckInRespVO unifiedCheckIn(YmsUnifiedCheckInReqVO bo);

    /** 司机自助 Check-in（H5 公开接口，无需登录） */
    YmsDriverSelfCheckInRespVO driverSelfCheckIn(YmsDriverSelfCheckInReqVO bo);

    /** Check-out 查询匹配（预览，不执行离场） */
    YmsCheckOutRespVO lookupCheckOut(Long warehouseId, String keyword);

    /** Check-out 离场确认 */
    YmsCheckOutRespVO checkOut(YmsCheckOutReqVO bo);

    /** 手动放行（门卫覆盖） */
    YmsCheckInRespVO manualPass(Long checkInId, String remark);

    /** 入场小票打印数据 */
    YmsCheckInReceiptRespVO queryReceipt(Long checkInId);

    /** 查询仓库可用堆场位列表（H5 公开接口使用） */
    List<YmsParkingSlotRespVO> listAvailableParkingSlots(Long warehouseId);

    // ─── 装车司机 H5 预登记（公开接口） ──────────────────────────────────────

    /** 按提货号查询派送信息（含派送明细） */
    YmsTrailerCheckinLookupRespVO lookupTrailerCheckin(String pickupNo);

    /** 装车司机提交预登记（补录手机号/驾照号/车厢号，推进任务至 PRE_ARRIVAL） */
    YmsTrailerCheckinResultRespVO trailerCheckin(YmsTrailerCheckinReqVO bo);
}
