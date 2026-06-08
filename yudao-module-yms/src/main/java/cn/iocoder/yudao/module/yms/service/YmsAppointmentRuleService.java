package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentRuleAddReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentRuleEditReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentRuleQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentRuleSlotRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentRuleRespVO;

import java.util.List;

public interface YmsAppointmentRuleService {

    PageResult<YmsAppointmentRuleRespVO> queryPageList(YmsAppointmentRuleQueryReqVO bo, PageParam pageParam);

    YmsAppointmentRuleRespVO queryById(Long id);

    Boolean insertByBo(YmsAppointmentRuleAddReqVO bo);

    Boolean updateByBo(YmsAppointmentRuleEditReqVO bo);

    Boolean deleteByIds(List<Long> ids);

    Boolean toggleEnabled(Long id, Integer enabled);

    /** 按仓库+业务类型+车辆来源匹配最优启用规则 */
    YmsAppointmentRuleRespVO matchRule(Long warehouseId, String businessType, String vehicleSource);

    /** 查找预约日期时段对应的规则时段配置 */
    YmsAppointmentRuleSlotRespVO findMatchingSlot(YmsAppointmentRuleRespVO rule, String aptDate, String aptSlot);
}
