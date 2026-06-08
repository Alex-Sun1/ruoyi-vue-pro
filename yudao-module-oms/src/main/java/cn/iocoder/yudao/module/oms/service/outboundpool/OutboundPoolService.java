package cn.iocoder.yudao.module.oms.service.outboundpool;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo.OutboundCreateReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.outboundpool.vo.OutboundPoolQueryReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo.OutboundOrderRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.outboundpool.vo.OutboundPoolStatsRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.preoutbound.vo.PreOutboundRespVO;

public interface OutboundPoolService {
    PageResult<CargoOrderRespVO> queryPageList(OutboundPoolQueryReqVO bo, PageParam pageQuery);
    OutboundPoolStatsRespVO queryStats(OutboundPoolQueryReqVO bo);
    PreOutboundRespVO createPreOutbound(OutboundCreateReqVO bo);
    OutboundOrderRespVO createOutboundOrder(OutboundCreateReqVO bo);
    Boolean batchCreatePreOutbound(OutboundCreateReqVO bo);
    Boolean batchCreateOutboundOrder(OutboundCreateReqVO bo);

    /** 出单工作台查看货物订单详情（含货件层），使用 outboundPool:list 权限 */
    CargoOrderRespVO queryCargoOrderDetail(Long cargoOrderId);
}
