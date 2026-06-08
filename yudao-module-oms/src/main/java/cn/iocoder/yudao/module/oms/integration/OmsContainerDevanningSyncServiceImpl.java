package cn.iocoder.yudao.module.oms.integration;

import cn.iocoder.yudao.module.oms.api.devanning.OmsContainerDevanningSyncService;

import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.module.oms.dal.dataobject.containerorder.ContainerOrderDO;
import cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo.ContainerOrderStatusReqVO;
import cn.iocoder.yudao.module.oms.dal.mysql.containerorder.ContainerOrderMapper;
import cn.iocoder.yudao.module.oms.service.containerorder.ContainerOrderService;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.Date;

@Slf4j
@Service
public class OmsContainerDevanningSyncServiceImpl implements OmsContainerDevanningSyncService {

    @Resource
    private ContainerOrderMapper containerOrderMapper;
    @Lazy
    @Resource
    private ContainerOrderService containerOrderService;

    @Override
    public void assignDevanningOrderNo(Long containerOrderId, String devanningNo) {
        if (containerOrderId == null || StrUtil.isBlank(devanningNo)) {
            return;
        }
        ContainerOrderDO patch = new ContainerOrderDO();
        patch.setId(containerOrderId);
        patch.setDevanningOrderNo(devanningNo);
        containerOrderMapper.updateById(patch);
    }

    @Override
    public void syncArrival(Long containerOrderId, Date actualArrivalTime) {
        if (containerOrderId == null) {
            return;
        }
        ContainerOrderStatusReqVO bo = new ContainerOrderStatusReqVO();
        bo.setTargetStatus("ARRIVED_WAREHOUSE");
        bo.setActualArrivalTime(actualArrivalTime != null ? actualArrivalTime : new Date());
        bo.setRemark("WMS拆柜到仓登记回写");
        try {
            containerOrderService.updateStatus(containerOrderId, bo);
        } catch (Exception ex) {
            log.warn("WMS→OMS arrival sync failed: id={} err={}", containerOrderId, ex.getMessage());
        }
    }

    @Override
    public void syncPlannedDevanningTime(Long containerOrderId, Date plannedDevanningTime) {
        if (containerOrderId == null) {
            return;
        }
        ContainerOrderDO patch = new ContainerOrderDO();
        patch.setId(containerOrderId);
        patch.setDevanningAppointmentTime(plannedDevanningTime);
        patch.setExpectedDevanningTime(plannedDevanningTime);
        containerOrderMapper.updateById(patch);
    }

    @Override
    public void syncDevanningStart(Long containerOrderId, Date devanningStartTime) {
        if (containerOrderId == null) {
            return;
        }
        ContainerOrderStatusReqVO bo = new ContainerOrderStatusReqVO();
        bo.setTargetStatus("DEVANNING");
        bo.setDevanningStartTime(devanningStartTime != null ? devanningStartTime : new Date());
        bo.setRemark("WMS拆柜开始回写");
        try {
            containerOrderService.updateStatus(containerOrderId, bo);
        } catch (Exception ex) {
            log.warn("WMS→OMS devanning start sync failed: id={} err={}", containerOrderId, ex.getMessage());
        }
    }

    @Override
    public void syncDevanningFinish(Long containerOrderId, Date devanningFinishTime, BigDecimal actualBoxQty) {
        if (containerOrderId == null) {
            return;
        }
        ContainerOrderStatusReqVO bo = new ContainerOrderStatusReqVO();
        bo.setTargetStatus("DEVANNED");
        bo.setDevanningFinishTime(devanningFinishTime != null ? devanningFinishTime : new Date());
        bo.setRemark("WMS拆柜完成回写");
        try {
            containerOrderService.updateStatus(containerOrderId, bo);
        } catch (Exception ex) {
            log.warn("WMS→OMS devanning finish sync failed: id={} err={}", containerOrderId, ex.getMessage());
        }
        if (actualBoxQty != null) {
            ContainerOrderDO patch = new ContainerOrderDO();
            patch.setId(containerOrderId);
            patch.setTotalCartonQty(actualBoxQty);
            containerOrderMapper.updateById(patch);
        }
    }

    @Override
    public void syncCancel(Long containerOrderId, String reason) {
        if (containerOrderId == null) {
            return;
        }
        ContainerOrderStatusReqVO bo = new ContainerOrderStatusReqVO();
        bo.setTargetStatus("CANCELLED");
        bo.setRemark(StrUtil.blankToDefault(reason, "WMS拆柜订单取消"));
        try {
            containerOrderService.updateStatus(containerOrderId, bo);
        } catch (Exception ex) {
            log.warn("WMS→OMS cancel sync failed: id={} err={}", containerOrderId, ex.getMessage());
        }
    }
}
