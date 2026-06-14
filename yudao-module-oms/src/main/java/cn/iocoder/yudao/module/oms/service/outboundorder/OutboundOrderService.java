package cn.iocoder.yudao.module.oms.service.outboundorder;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.oms.dal.dataobject.outboundorder.OutboundOrderDO;
import cn.iocoder.yudao.module.oms.controller.admin.bizattachment.vo.BizAttachmentSaveReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.common.vo.OmsManualStatusReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo.OutboundOrderItemsReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo.OutboundOrderPageReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.bizattachment.vo.BizAttachmentRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo.OutboundOrderItemRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo.OutboundOrderRespVO;

import java.util.List;
import java.util.Map;

public interface OutboundOrderService {
    OutboundOrderRespVO queryById(Long id);
    PageResult<OutboundOrderRespVO> queryPageList(OutboundOrderPageReqVO bo, PageParam pageQuery);
    List<OutboundOrderRespVO> queryList(OutboundOrderPageReqVO bo);
    Map<String, Long> queryStatusCount(OutboundOrderPageReqVO bo);
    Boolean updateByBo(OutboundOrderDO bo);
    Boolean deleteWithValid(Long id);
    Boolean complete(Long id, String remark);
    Boolean confirmAppointment(Long id);
    Boolean confirmOutbounded(Long id);
    Boolean confirmSigned(Long id);
    Boolean manualAdjustStatus(Long id, OmsManualStatusReqVO bo);
    List<OutboundOrderItemRespVO> queryItems(Long id);
    Boolean addItems(Long id, OutboundOrderItemsReqVO bo);
    Boolean removeItem(Long id, Long itemId);
    List<BizAttachmentRespVO> queryAttachments(Long id);
    Boolean uploadAttachment(Long id, BizAttachmentSaveReqVO bo);
    Boolean removeAttachment(Long attachmentId);
}
