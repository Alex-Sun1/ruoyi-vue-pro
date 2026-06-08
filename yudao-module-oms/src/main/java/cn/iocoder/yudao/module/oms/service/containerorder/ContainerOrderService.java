package cn.iocoder.yudao.module.oms.service.containerorder;

import cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo.ContainerCargoOrderImportExcelVO;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderSaveReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo.ContainerOrderSaveReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo.ContainerOrderPageReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo.ContainerOrderStatusReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.bizattachment.vo.BizAttachmentSaveReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.bizattachment.vo.BizAttachmentRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo.ContainerOrderRespVO;

import java.util.List;
import java.util.Map;

/**
 * 海柜订单服务
 */
public interface ContainerOrderService {

    PageResult<ContainerOrderRespVO> queryPageList(ContainerOrderPageReqVO bo, PageParam pageQuery);

    List<ContainerOrderRespVO> queryList(ContainerOrderPageReqVO bo);

    Map<String, Long> queryStatusCount(ContainerOrderPageReqVO bo);

    ContainerOrderRespVO queryById(Long id);

    Boolean insertByBo(ContainerOrderSaveReqVO bo, boolean draft);

    Boolean updateByBo(ContainerOrderSaveReqVO bo);

    /**
     * 向已存在的海柜订单追加关联货物订单
     */
    Boolean addCargoOrders(Long containerOrderId, List<CargoOrderSaveReqVO> cargoOrders);

    String importCargoOrders(Long containerOrderId, List<cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo.ContainerCargoOrderImportExcelVO> rows);

    /**
     * 解析 Excel 为货物订单 BO 列表（不落库，供新增海柜时预览导入）
     */
    List<CargoOrderSaveReqVO> parseImportCargoOrders(List<cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo.ContainerCargoOrderImportExcelVO> rows);

    Boolean updateStatus(Long id, ContainerOrderStatusReqVO bo);

    List<BizAttachmentRespVO> queryAttachments(Long id);

    Boolean uploadAttachment(Long id, BizAttachmentSaveReqVO bo, boolean doFile);

    Boolean removeAttachment(Long attachmentId);

    Boolean deleteWithValidByIds(List<Long> ids);
}
