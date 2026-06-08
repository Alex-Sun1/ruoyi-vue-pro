package cn.iocoder.yudao.module.yms.integration;

import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsTrailerCheckinLookupRespVO;

import java.util.Collections;
import java.util.List;

/**
 * 装车派送明细查询集成接口（由 OMS 模块提供实现 Bean）。
 * <p>
 * YMS 通过此接口向 OMS 查询指定来源单据下的派送明细行（PC单列表）。
 * 若 OMS 模块未注入实现，则返回空列表，前端 "派送明细" 表格不展示数据。
 * </p>
 */
public interface YmsTrailerDispatchQueryHandler {

    /**
     * 查询来源单据的派送明细
     *
     * @param sourceOrderType 来源单据类型（如 OUTBOUND_ORDER）
     * @param sourceOrderId   来源单据 ID
     * @return 派送明细列表，不为 null
     */
    default List<YmsTrailerCheckinLookupRespVO.YmsTrailerCheckinDispatchItemRespVO> queryDispatchItems(
            String sourceOrderType, Long sourceOrderId) {
        return Collections.emptyList();
    }
}
