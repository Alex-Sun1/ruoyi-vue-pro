package cn.iocoder.yudao.module.oms.service.cargoorder;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderSaveReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.bizattachment.vo.BizAttachmentSaveReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.common.vo.OmsManualStatusReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderHoldReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderMergeBackReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderPageReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderReleaseReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderShipmentSaveReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderSplitReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderSkuItemSaveReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.bizattachment.vo.BizAttachmentRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderNodeTraceRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderShipmentRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderSkuItemRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderRespVO;

import java.util.List;
import java.util.Map;

public interface CargoOrderService {

    // =================== 主单 CRUD ===================

    PageResult<CargoOrderRespVO> queryPageList(CargoOrderPageReqVO bo, PageParam pageQuery);

    List<CargoOrderRespVO> queryList(CargoOrderPageReqVO bo);

    CargoOrderRespVO queryById(Long id);

    Map<String, Long> queryStatusCount(CargoOrderPageReqVO bo);

    Boolean insertByBo(CargoOrderSaveReqVO bo);

    Boolean updateByBo(CargoOrderSaveReqVO bo);

    Boolean deleteByIds(List<Long> ids);

    // =================== 货件 CRUD ===================

    List<CargoOrderShipmentRespVO> queryShipmentList(Long cargoOrderId);

    Boolean saveShipment(Long cargoOrderId, CargoOrderShipmentSaveReqVO bo);

    Boolean deleteShipment(Long shipmentId);

    // =================== SKU CRUD ===================

    List<CargoOrderSkuItemRespVO> querySkuItemList(Long cargoOrderId);

    Boolean saveSkuItem(Long cargoOrderId, CargoOrderSkuItemSaveReqVO bo);

    Boolean deleteSkuItem(Long skuItemId);

    // =================== 节点轨迹 ===================

    List<CargoOrderNodeTraceRespVO> queryNodeTraceList(Long cargoOrderId);

    // =================== 业务动作（状态机）===================

    /** 受理订单 PENDING_ACCEPT → ACCEPTED */
    Boolean accept(Long id, String remark);

    /** 标记在途 ACCEPTED → IN_TRANSIT */
    Boolean markInTransit(Long id, String remark);

    /** 到港 → ARRIVED_PORT */
    Boolean confirmArrivedPort(Long id, String remark);

    /** 提柜 → PICKED_UP */
    Boolean confirmPickedUp(Long id, String remark);

    /** 到仓 → ARRIVED_WAREHOUSE */
    Boolean confirmArrivedWarehouse(Long id, String remark);

    /** 拆柜开始 → DEVANNING */
    Boolean startDevanning(Long id, String remark);

    /** 拆柜完成 → DEVANNED */
    Boolean finishDevanning(Long id, String remark);

    /** 入库完成 → INBOUNDED */
    Boolean confirmInbounded(Long id, String remark);

    /** 出单 → OUTBOUND_ORDERED */
    Boolean createOutboundOrder(Long id, String outboundBatchNo, String remark);

    /** 预约派送 → DELIVERY_APPOINTED */
    Boolean appointDelivery(Long id, String remark);

    /** 出库 → OUTBOUNDED */
    Boolean confirmOutbounded(Long id, String remark);

    /** 派送中 → DELIVERING */
    Boolean markDelivering(Long id, String remark);

    /** 签收 → DELIVERED */
    Boolean confirmDelivered(Long id, String remark);

    /** POD 回传 → POD_UPLOADED */
    Boolean uploadPod(Long id, String remark);

    /** 出账单 → BILLED */
    Boolean confirmBilled(Long id, String remark);

    /** 完成 → COMPLETED */
    Boolean complete(Long id, String remark);

    /** 取消订单 → CANCELLED */
    Boolean cancel(Long id, String remark);

    Boolean manualAdjustStatus(Long id, OmsManualStatusReqVO bo);

    // =================== 预出单（并行状态）===================

    /** 创建预出单（只改 pre_outbound_status，不影响主状态）*/
    Boolean createPreOutbound(Long id, String preOutboundNo, String remark);

    /** 转正式出单（生成 outbound_batch_no）*/
    Boolean convertPreOutbound(Long id, String outboundBatchNo, String remark);

    /** 取消预出单 */
    Boolean cancelPreOutbound(Long id, String remark);

    // =================== 入库仓修改（特殊权限）===================

    Boolean changeInboundWarehouse(Long id, Long warehouseId, String warehouseName, String remark);

    /** 取消转仓 */
    Boolean cancelTransfer(Long id, String remark);

    /** 修改转仓 */
    Boolean modifyTransfer(Long id, String transferWarehouseCode, String remark);

    List<BizAttachmentRespVO> queryAttachments(Long id, boolean includeContainerAttachments);

    Boolean uploadAttachment(Long id, BizAttachmentSaveReqVO bo);

    Boolean removeAttachment(Long attachmentId);

    Boolean hold(Long id, CargoOrderHoldReqVO bo);

    Boolean releaseHold(Long id, CargoOrderReleaseReqVO bo);

    Boolean split(Long id, CargoOrderSplitReqVO bo);

    Boolean mergeBack(CargoOrderMergeBackReqVO bo);
}
