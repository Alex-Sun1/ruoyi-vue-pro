package cn.iocoder.yudao.module.oms.service.omsbizlifecycle;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.oms.enums.ErrorCodeConstants.*;

import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.security.core.util.SecurityFrameworkUtils;
import cn.iocoder.yudao.module.oms.dal.dataobject.biz.BizRootDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder.CargoOrderDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder.CargoOrderNodeTraceDO;
import cn.iocoder.yudao.module.oms.dal.mysql.biz.BizRootMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.cargoorder.CargoOrderMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.cargoorder.CargoOrderNodeTraceMapper;
import cn.iocoder.yudao.module.oms.service.omsbizlifecycle.OmsBizLifecycleService;
import cn.iocoder.yudao.module.oms.support.OmsStatusTransitionGuard;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.Map;

@Service
public class OmsBizLifecycleServiceImpl implements OmsBizLifecycleService {

    @Resource
    private CargoOrderMapper cargoOrderMapper;
    @Resource
    private BizRootMapper bizRootMapper;
    @Resource
    private CargoOrderNodeTraceMapper nodeTraceMapper;

    private static final Map<String, String> NODE_NAMES = Map.ofEntries(
        Map.entry("PENDING_ACCEPT", "待受理"),
        Map.entry("ACCEPTED", "已受理"),
        Map.entry("IN_TRANSIT", "在途"),
        Map.entry("ARRIVED_PORT", "已到港"),
        Map.entry("PICKED_UP", "已提柜"),
        Map.entry("ARRIVED_WAREHOUSE", "已到仓"),
        Map.entry("DEVANNING", "拆柜中"),
        Map.entry("DEVANNED", "拆柜完成"),
        Map.entry("INBOUNDED", "已入库"),
        Map.entry("OUTBOUND_ORDERED", "已出单"),
        Map.entry("DELIVERY_APPOINTED", "已预约"),
        Map.entry("OUTBOUNDED", "已出库"),
        Map.entry("DELIVERING", "派送中"),
        Map.entry("DELIVERED", "已签收"),
        Map.entry("POD_UPLOADED", "POD回传"),
        Map.entry("BILLED", "已出账"),
        Map.entry("COMPLETED", "已完成"),
        Map.entry("CANCELLED", "已取消")
    );

    @Override
    public Boolean transitionCargo(Long cargoOrderId, String nextNode, String action, String remark) {
        return transitionCargo(cargoOrderId, nextNode, action, remark, new Date());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean transitionCargo(Long cargoOrderId, String nextNode, String action, String remark, Date nodeTime) {
        CargoOrderDO order = cargoOrderMapper.selectById(cargoOrderId);
        if (order == null) {
            throw exception(OMS_BIZ_ERROR, "货物订单不存在");
        }
        Date actualTime = nodeTime == null ? new Date() : nodeTime;
        String fromNode = resolveCurrentNode(order);
        if (!isControlledRollbackAction(action)) {
            OmsStatusTransitionGuard.requireAllowed("cargo order", OmsStatusTransitionGuard.CARGO_ALLOWED,
                fromNode, nextNode);
        } else {
            OmsStatusTransitionGuard.requireKnown("cargo order", OmsStatusTransitionGuard.CARGO_FLOW, nextNode);
        }

        updateBizRoot(order, nextNode, actualTime);
        updateCargoOrder(order, nextNode, actualTime);
        saveTrace(order, fromNode, nextNode, action, remark, actualTime);
        return Boolean.TRUE;
    }

    private String resolveCurrentNode(CargoOrderDO order) {
        if (order.getBizRootId() != null) {
            BizRootDO root = bizRootMapper.selectById(order.getBizRootId());
            if (root != null && root.getCurrentNode() != null) {
                return root.getCurrentNode();
            }
        }
        return order.getFulfillmentStatus();
    }

    private boolean isControlledRollbackAction(String action) {
        return "manualAdjustStatus".equals(action)
            || "removeOutboundItem".equals(action)
            || "deleteOutboundOrder".equals(action);
    }

    private void updateBizRoot(CargoOrderDO order, String nextNode, Date actualTime) {
        if (order.getBizRootId() == null) {
            return;
        }
        BizRootDO root = new BizRootDO();
        root.setId(order.getBizRootId());
        root.setCurrentModule("OMS");
        root.setCurrentNode(nextNode);
        root.setCurrentNodeName(nodeName(nextNode));
        root.setCurrentNodeTime(actualTime);
        if ("COMPLETED".equals(nextNode)) {
            root.setRootStatus("DONE");
            root.setCompleteTime(actualTime);
        } else if ("CANCELLED".equals(nextNode)) {
            root.setRootStatus("CANCELLED");
            root.setCancelTime(actualTime);
        } else {
            root.setRootStatus("RUNNING");
        }
        bizRootMapper.updateById(root);
    }

    private void updateCargoOrder(CargoOrderDO order, String nextNode, Date actualTime) {
        CargoOrderDO update = new CargoOrderDO();
        update.setId(order.getId());
        update.setFulfillmentStatus(nextNode);
        switch (nextNode) {
            case "ARRIVED_PORT" -> update.setAta(actualTime);
            case "PICKED_UP" -> update.setActualPickupTime(actualTime);
            case "ARRIVED_WAREHOUSE" -> update.setActualArrivalTime(actualTime);
            case "DEVANNED" -> update.setDevanningFinishTime(actualTime);
            case "INBOUNDED" -> update.setActualInboundTime(actualTime);
            case "OUTBOUND_ORDERED" -> update.setOutboundOrderTime(actualTime);
            case "DELIVERY_APPOINTED" -> {
                update.setDeliveryAppointmentTime(actualTime);
                update.setAppointmentStatus("APPOINTED");
            }
            case "OUTBOUNDED" -> update.setActualOutboundTime(actualTime);
            case "DELIVERED" -> update.setSignedTime(actualTime);
            case "POD_UPLOADED" -> {
                update.setPodStatus("UPLOADED");
                update.setPodUploadTime(actualTime);
            }
            case "BILLED" -> {
                update.setBillingStatus("BILLED");
                update.setBillingTime(actualTime);
            }
            case "COMPLETED" -> update.setCompletedTime(actualTime);
            case "CANCELLED" -> update.setOrderStatus("CANCELLED");
            default -> {
            }
        }
        cargoOrderMapper.updateById(update);
    }

    private void saveTrace(CargoOrderDO order, String fromNode, String nextNode, String action, String remark, Date actualTime) {
        CargoOrderNodeTraceDO trace = new CargoOrderNodeTraceDO();
        trace.setCargoOrderId(order.getId());
        trace.setBizRootId(order.getBizRootId());
        trace.setNodeCode(nextNode);
        trace.setNodeName(nodeName(nextNode));
        trace.setNodeStatus("DONE");
        trace.setStatusFrom(fromNode);
        trace.setStatusTo(nextNode);
        trace.setAction(action);
        trace.setActualTime(actualTime);
        trace.setSourceType("OMS");
        trace.setOperatorId(SecurityFrameworkUtils.getLoginUserId());
        trace.setOperatorName(SecurityFrameworkUtils.getLoginUserNickname());
        trace.setRemark(remark);
        trace.setCreateTime(new Date());
        nodeTraceMapper.insert(trace);
    }

    private String nodeName(String node) {
        return NODE_NAMES.getOrDefault(node, node);
    }
}
