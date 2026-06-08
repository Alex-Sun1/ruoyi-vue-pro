package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentAddReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentEditReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentBoardSlotRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentRespVO;

import java.util.List;

public interface YmsAppointmentService {
    PageResult<YmsAppointmentRespVO> queryPageList(YmsAppointmentQueryReqVO bo, PageParam pageParam);
    YmsAppointmentRespVO queryById(Long id);
    YmsAppointmentRespVO createAppointment(YmsAppointmentAddReqVO bo);
    Boolean updateByBo(YmsAppointmentEditReqVO bo);
    Boolean cancelAppointment(Long id, String reason);
    Boolean confirmAppointment(Long id);
    Boolean markNoShow(Long id);
    Boolean deleteByIds(List<Long> ids);

    /** 预约日历/时段看板 */
    List<YmsAppointmentBoardSlotRespVO> queryBoard(Long warehouseId, String aptDate, String businessType, String vehicleSource);
}
