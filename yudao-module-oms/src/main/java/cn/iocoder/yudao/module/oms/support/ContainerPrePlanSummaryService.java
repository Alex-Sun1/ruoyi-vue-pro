package cn.iocoder.yudao.module.oms.support;

import cn.hutool.core.collection.CollUtil;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder.CargoOrderDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.containerorder.ContainerOrderDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.preoutbound.PreOutboundDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.preoutbound.PreOutboundItemDO;
import cn.iocoder.yudao.module.oms.dal.mysql.cargoorder.CargoOrderMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.containerorder.ContainerOrderMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.preoutbound.PreOutboundItemMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.preoutbound.PreOutboundMapper;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.HashSet;
import java.util.List;
import java.util.Objects;
import java.util.Set;

/**
 * 海柜预排车数 / 预排方数：按关联预出单（非已取消）汇总回写海柜订单。
 */
@Service
public class ContainerPrePlanSummaryService {

    @Resource
    private ContainerOrderMapper containerOrderMapper;
    @Resource
    private CargoOrderMapper cargoOrderMapper;
    @Resource
    private PreOutboundMapper preOutboundMapper;
    @Resource
    private PreOutboundItemMapper preOutboundItemMapper;

    public void refreshByCargoOrderId(Long cargoOrderId) {
        if (cargoOrderId == null) {
            return;
        }
        CargoOrderDO cargoOrder = cargoOrderMapper.selectById(cargoOrderId);
        if (cargoOrder == null || cargoOrder.getContainerOrderId() == null) {
            return;
        }
        refreshByContainerOrderId(cargoOrder.getContainerOrderId());
    }

    public void refreshByPreOutboundId(Long preOutboundId) {
        if (preOutboundId == null) {
            return;
        }
        Set<Long> containerOrderIds = new HashSet<>();
        PreOutboundDO preOutbound = preOutboundMapper.selectById(preOutboundId);
        if (preOutbound != null && preOutbound.getCargoOrderId() != null) {
            addContainerOrderId(containerOrderIds, preOutbound.getCargoOrderId());
        }
        List<PreOutboundItemDO> items = preOutboundItemMapper.selectList(Wrappers.<PreOutboundItemDO>lambdaQuery()
            .eq(PreOutboundItemDO::getPreOutboundId, preOutboundId)
            .select(PreOutboundItemDO::getCargoOrderId));
        for (PreOutboundItemDO item : items) {
            addContainerOrderId(containerOrderIds, item.getCargoOrderId());
        }
        containerOrderIds.forEach(this::refreshByContainerOrderId);
    }

    public void refreshByContainerOrderId(Long containerOrderId) {
        if (containerOrderId == null) {
            return;
        }
        List<Long> cargoOrderIds = cargoOrderMapper.selectList(Wrappers.<CargoOrderDO>lambdaQuery()
                .eq(CargoOrderDO::getContainerOrderId, containerOrderId)
                .select(CargoOrderDO::getId))
            .stream()
            .map(CargoOrderDO::getId)
            .filter(Objects::nonNull)
            .toList();

        BigDecimal truckQty = BigDecimal.ZERO;
        BigDecimal cbm = BigDecimal.ZERO;
        if (CollUtil.isNotEmpty(cargoOrderIds)) {
            Set<Long> preOutboundIds = collectActivePreOutboundIds(cargoOrderIds);
            if (CollUtil.isNotEmpty(preOutboundIds)) {
                List<PreOutboundDO> preOutbounds = preOutboundMapper.selectList(Wrappers.<PreOutboundDO>lambdaQuery()
                    .in(PreOutboundDO::getId, preOutboundIds)
                    .ne(PreOutboundDO::getPreOutboundStatus, "CANCELLED")
                    .select(PreOutboundDO::getId, PreOutboundDO::getActualCbm, PreOutboundDO::getDeclaredCbm));
                truckQty = BigDecimal.valueOf(preOutbounds.size());
                cbm = preOutbounds.stream()
                    .map(this::resolvePreOutboundCbm)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);
            }
        }

        ContainerOrderDO update = new ContainerOrderDO();
        update.setId(containerOrderId);
        update.setPrePlanTruckQty(truckQty);
        update.setPrePlanPalletQty(truckQty);
        update.setPrePlanCbm(cbm);
        containerOrderMapper.updateById(update);
    }

    private Set<Long> collectActivePreOutboundIds(List<Long> cargoOrderIds) {
        Set<Long> preOutboundIds = new HashSet<>();
        preOutboundMapper.selectList(Wrappers.<PreOutboundDO>lambdaQuery()
                .in(PreOutboundDO::getCargoOrderId, cargoOrderIds)
                .ne(PreOutboundDO::getPreOutboundStatus, "CANCELLED")
                .select(PreOutboundDO::getId))
            .forEach(item -> preOutboundIds.add(item.getId()));
        preOutboundItemMapper.selectList(Wrappers.<PreOutboundItemDO>lambdaQuery()
                .in(PreOutboundItemDO::getCargoOrderId, cargoOrderIds)
                .select(PreOutboundItemDO::getPreOutboundId))
            .forEach(item -> preOutboundIds.add(item.getPreOutboundId()));
        return preOutboundIds;
    }

    private void addContainerOrderId(Set<Long> containerOrderIds, Long cargoOrderId) {
        CargoOrderDO cargoOrder = cargoOrderMapper.selectById(cargoOrderId);
        if (cargoOrder != null && cargoOrder.getContainerOrderId() != null) {
            containerOrderIds.add(cargoOrder.getContainerOrderId());
        }
    }

    private BigDecimal resolvePreOutboundCbm(PreOutboundDO preOutbound) {
        BigDecimal actual = nvl(preOutbound.getActualCbm());
        if (actual.compareTo(BigDecimal.ZERO) > 0) {
            return actual;
        }
        return nvl(preOutbound.getDeclaredCbm());
    }

    private BigDecimal nvl(BigDecimal value) {
        return value == null ? BigDecimal.ZERO : value;
    }
}
