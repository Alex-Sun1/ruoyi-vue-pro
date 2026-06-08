package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsOverviewRespVO;

public interface YmsOverviewService {

    /** 园区总览 Dashboard 数据 */
    YmsOverviewRespVO queryOverview(Long warehouseId);
}
