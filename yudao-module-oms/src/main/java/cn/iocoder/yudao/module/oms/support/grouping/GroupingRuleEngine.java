package cn.iocoder.yudao.module.oms.support.grouping;

import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder.CargoOrderDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder.CargoOrderShipmentDO;
import cn.iocoder.yudao.module.oms.dal.mysql.cargoorder.CargoOrderMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.cargoorder.CargoOrderShipmentMapper;
import cn.iocoder.yudao.module.oms.service.cargogroupingrule.CargoGroupingRuleService;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * 分组规则引擎
 *
 * 当前为骨架实现，规则数据来源依赖 oms_cargo_grouping_rule 表（见分组规则配置 PRD）。
 * 规则表建好后替换 TODO 处的实现即可，对外接口签名不变。
 */
@Slf4j
@Component
public class GroupingRuleEngine {

    @Resource
    private CargoOrderMapper cargoOrderMapper;
    @Resource
    private CargoOrderShipmentMapper shipmentMapper;
    @Lazy
    @Resource
    private CargoGroupingRuleService groupingRuleService;

    /**
     * 自动分组：按仓库加载规则，对指定 (cargoOrder, shipment) 计算 group_code
     *
     * @param warehouseId  当前仓库ID（规则按仓库隔离）
     * @param cargoOrderId 货物订单ID
     * @param shipmentId   货件ID
     * @return group_code，全部规则未命中时返回兜底 group_code
     */
    public String computeGroupCode(Long warehouseId, Long cargoOrderId, Long shipmentId) {
        String groupCode = groupingRuleService.computeGroupCode(warehouseId, cargoOrderId, shipmentId);
        if (groupCode != null) {
            return groupCode;
        }
        // 规则全部未命中时使用兜底：业务类型 + 平台仓库代码
        CargoOrderDO order = cargoOrderMapper.selectById(cargoOrderId);
        CargoOrderShipmentDO shipment = shipmentMapper.selectById(shipmentId);
        if (order == null || shipment == null) {
            log.warn("computeGroupCode fallback: order={} or shipment={} not found", cargoOrderId, shipmentId);
            return null;
        }
        String fallback = buildFallbackGroupCode(order, shipment);
        log.info("computeGroupCode fallback: cargoOrderId={}, shipmentId={}, groupCode={}", cargoOrderId, shipmentId, fallback);
        return fallback;
    }

    /**
     * 快速配置：按指定规则 ID 对 (cargoOrder, shipment) 计算 group_code
     *
     * @return group_code，规则条件未命中时返回 null（调用方跳过该行）
     */
    public String computeGroupCodeByRule(Long ruleId, Long cargoOrderId, Long shipmentId) {
        return groupingRuleService.computeGroupCodeByRule(ruleId, cargoOrderId, shipmentId);
    }

    /**
     * 计算预计打板数
     * unit_pallet_cbm 通过 group_code 中的仓库代码关联 platform_address 取出
     *
     * @param groupCode   分组值（如 Amazon-LAX9）
     * @param totalCbm    该分组总CBM
     * @return 预计打板数，无法计算时返回 null
     */
    public Integer calcExpectedPalletQty(String groupCode, BigDecimal totalCbm) {
        if (groupCode == null || totalCbm == null || totalCbm.compareTo(BigDecimal.ZERO) == 0) {
            return null;
        }
        // TODO: 根据 groupCode 解析仓库代码，关联 platform_address.unit_pallet_cbm
        // TODO: return Math.ceil(totalCbm / unitPalletCbm)
        return null;
    }

    /**
     * 同步回写货物订单的 group_code
     * 同一订单所有货件 group_code 相同 → 写入该值；不同 → 写入 MULTI
     */
    public void syncCargoOrderGroupCode(Long cargoOrderId) {
        List<CargoOrderShipmentDO> shipments = shipmentMapper.selectList(
            new com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<CargoOrderShipmentDO>()
                .eq(CargoOrderShipmentDO::getCargoOrderId, cargoOrderId)
                .eq(CargoOrderShipmentDO::getDeleted, 0)
        );

        List<String> codes = shipments.stream()
            .map(CargoOrderShipmentDO::getGroupCode)
            .filter(Objects::nonNull)
            .distinct()
            .collect(Collectors.toList());

        String orderGroupCode = codes.size() == 1 ? codes.get(0) : (codes.isEmpty() ? null : "MULTI");

        CargoOrderDO update = new CargoOrderDO();
        update.setId(cargoOrderId);
        update.setGroupCode(orderGroupCode);
        cargoOrderMapper.updateById(update);
    }

    private String buildFallbackGroupCode(CargoOrderDO order, CargoOrderShipmentDO shipment) {
        String part1 = order.getBusinessTypeName() != null ? order.getBusinessTypeName() : "UNKNOWN";
        String part2 = order.getPlatformWarehouseCode() != null ? order.getPlatformWarehouseCode() : "UNKNOWN";
        return part1 + "-" + part2;
    }
}
