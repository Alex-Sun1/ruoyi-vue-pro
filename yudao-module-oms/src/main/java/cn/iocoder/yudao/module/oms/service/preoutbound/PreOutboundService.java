package cn.iocoder.yudao.module.oms.service.preoutbound;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.oms.controller.admin.common.vo.OmsManualStatusReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo.OutboundCreateReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.preoutbound.vo.PreOutboundItemsReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.preoutbound.vo.PreOutboundPageReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.preoutbound.vo.PreOutboundUpdateReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo.OutboundOrderRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.preoutbound.vo.PreOutboundItemRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.preoutbound.vo.PreOutboundRespVO;

import java.util.List;
import java.util.Map;

public interface PreOutboundService {
    PreOutboundRespVO createEmpty(OutboundCreateReqVO bo);
    PreOutboundRespVO queryById(Long id);
    List<PreOutboundItemRespVO> queryItems(Long id);
    Boolean addItems(Long id, PreOutboundItemsReqVO bo);
    Boolean removeItem(Long id, Long itemId);
    PageResult<PreOutboundRespVO> queryPageList(PreOutboundPageReqVO bo, PageParam pageQuery);
    List<PreOutboundRespVO> queryList(PreOutboundPageReqVO bo);
    Map<String, Long> queryStatusCount(PreOutboundPageReqVO bo);
    OutboundOrderRespVO convert(Long id, OutboundCreateReqVO bo);
    Boolean updateByBo(Long id, PreOutboundUpdateReqVO bo);
    Boolean manualAdjustStatus(Long id, OmsManualStatusReqVO bo);
    Boolean deleteWithValid(Long id);
}
