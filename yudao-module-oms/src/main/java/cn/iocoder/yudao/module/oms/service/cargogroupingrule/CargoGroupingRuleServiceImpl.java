package cn.iocoder.yudao.module.oms.service.cargogroupingrule;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.oms.enums.ErrorCodeConstants.*;

import cn.hutool.core.collection.CollUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.fasterxml.jackson.core.type.TypeReference;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.util.json.JsonUtils;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargogroupingrule.CargoGroupingRuleDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder.CargoOrderDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder.CargoOrderShipmentDO;
import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule.vo.CargoGroupingRuleSaveReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule.vo.CargoGroupingRulePriorityReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule.vo.CargoGroupingRulePageReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule.vo.CargoGroupingRuleTestReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule.vo.CargoGroupingRuleTestRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule.vo.CargoGroupingRuleRespVO;
import cn.iocoder.yudao.module.oms.dal.mysql.cargogroupingrule.CargoGroupingRuleMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.cargoorder.CargoOrderMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.cargoorder.CargoOrderShipmentMapper;
import cn.iocoder.yudao.module.oms.service.cargogroupingrule.CargoGroupingRuleService;
import cn.iocoder.yudao.module.oms.support.OmsLambdaQueryHelper;
import cn.iocoder.yudao.module.oms.support.OmsQueryCsvUtils;
import cn.iocoder.yudao.module.org.framework.web.OrgContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class CargoGroupingRuleServiceImpl implements CargoGroupingRuleService {

    private static final String ENABLED = "enabled";
    private static final String DISABLED = "disabled";
    private static final Pattern SIMPLE_EXPRESSION_PATTERN =
        Pattern.compile("\\s*([a-zA-Z0-9_.]+)\\s*(==|!=)\\s*['\"]?([^'\"&|]+)['\"]?\\s*");

    @Resource
    private CargoGroupingRuleMapper baseMapper;
    @Resource
    private CargoOrderMapper cargoOrderMapper;
    @Resource
    private CargoOrderShipmentMapper cargoOrderShipmentMapper;

    @Override
    public PageResult<CargoGroupingRuleRespVO> queryPageList(CargoGroupingRulePageReqVO bo, PageParam pageQuery) {
        PageResult<CargoGroupingRuleDO> page = baseMapper.selectPage(pageQuery, buildQueryWrapper(bo));
        return new PageResult<>(BeanUtils.toBean(page.getList(), CargoGroupingRuleRespVO.class), page.getTotal());
    }

    @Override
    public List<CargoGroupingRuleRespVO> queryList(CargoGroupingRulePageReqVO bo) {
        return BeanUtils.toBean(baseMapper.selectList(buildQueryWrapper(bo)), CargoGroupingRuleRespVO.class);
    }

    @Override
    public CargoGroupingRuleRespVO queryById(Long id) {
        return BeanUtils.toBean(baseMapper.selectById(id), CargoGroupingRuleRespVO.class);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean insertByBo(CargoGroupingRuleSaveReqVO bo) {
        validateJsonConfig(bo);
        CargoGroupingRuleDO add = BeanUtils.toBean(bo, CargoGroupingRuleDO.class);
        if (add == null) {
            throw exception(OMS_BIZ_ERROR, "分组规则转换失败");
        }
        applyWarehouseFields(add, bo.getWarehouseIds(), bo.getWarehouseNames());
        if (StrUtil.isBlank(add.getStatus())) add.setStatus(ENABLED);
        if (add.getPriority() == null) add.setPriority(0);
        if (add.getIsDefault() == null) add.setIsDefault(0);
        return baseMapper.insert(add) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean updateByBo(CargoGroupingRuleSaveReqVO bo) {
        CargoGroupingRuleDO exists = baseMapper.selectById(bo.getId());
        if (exists == null) {
            throw exception(OMS_BIZ_ERROR, "分组规则不存在");
        }
        CargoGroupingRuleDO update = new CargoGroupingRuleDO();
        update.setId(bo.getId());
        update.setVersion(bo.getVersion());
        update.setStatus(StrUtil.isBlank(bo.getStatus()) ? exists.getStatus() : bo.getStatus());
        update.setRemark(bo.getRemark());
        update.setPriority(bo.getPriority());
        if (!Objects.equals(exists.getIsDefault(), 1)) {
            validateJsonConfig(bo);
            applyWarehouseFields(update, bo.getWarehouseIds(), bo.getWarehouseNames());
            update.setRuleName(bo.getRuleName());
            update.setConditionConfig(bo.getConditionConfig());
            update.setGroupKeyConfig(bo.getGroupKeyConfig());
            update.setIsDefault(bo.getIsDefault() == null ? 0 : bo.getIsDefault());
        }
        return baseMapper.updateById(update) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean deleteWithValidByIds(List<Long> ids, Boolean isValid) {
        if (CollUtil.isEmpty(ids)) {
            return Boolean.TRUE;
        }
        if (Boolean.TRUE.equals(isValid)) {
            Long count = baseMapper.selectCount(Wrappers.<CargoGroupingRuleDO>lambdaQuery()
                .in(CargoGroupingRuleDO::getId, ids)
                .eq(CargoGroupingRuleDO::getIsDefault, 1));
            if (count != null && count > 0) {
                throw exception(OMS_BIZ_ERROR, "内置分组规则不可删除");
            }
        }
        return baseMapper.deleteByIds(ids) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean enable(Long id) {
        return changeStatus(id, ENABLED);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean disable(Long id) {
        return changeStatus(id, DISABLED);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long copy(Long id) {
        CargoGroupingRuleDO source = baseMapper.selectById(id);
        if (source == null) {
            throw exception(OMS_BIZ_ERROR, "分组规则不存在");
        }
        CargoGroupingRuleDO copy = new CargoGroupingRuleDO();
        copy.setWarehouseName(source.getWarehouseName());
        copy.setWarehouseIds(source.getWarehouseIds());
        copy.setRuleName(source.getRuleName() + " 副本");
        copy.setConditionConfig(source.getConditionConfig());
        copy.setGroupKeyConfig(source.getGroupKeyConfig());
        copy.setPriority(source.getPriority() == null ? 0 : source.getPriority());
        copy.setIsDefault(0);
        copy.setStatus(DISABLED);
        copy.setRemark(source.getRemark());
        baseMapper.insert(copy);
        return copy.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean updatePriority(List<CargoGroupingRulePriorityReqVO> list) {
        if (CollUtil.isEmpty(list)) {
            return Boolean.TRUE;
        }
        for (CargoGroupingRulePriorityReqVO item : list) {
            CargoGroupingRuleDO update = new CargoGroupingRuleDO();
            update.setId(item.getId());
            update.setPriority(item.getPriority());
            baseMapper.updateById(update);
        }
        return Boolean.TRUE;
    }

    @Override
    public String computeGroupCode(Long warehouseId, Long cargoOrderId, Long shipmentId) {
        CargoGroupingRuleTestReqVO bo = new CargoGroupingRuleTestReqVO();
        bo.setWarehouseId(warehouseId);
        bo.setCargoOrderId(cargoOrderId);
        bo.setShipmentId(shipmentId);
        CargoGroupingRuleTestRespVO result = test(bo);
        return Boolean.TRUE.equals(result.getMatched()) ? result.getGroupKey() : null;
    }

    @Override
    public String computeGroupCodeByRule(Long ruleId, Long cargoOrderId, Long shipmentId) {
        CargoGroupingRuleDO rule = baseMapper.selectById(ruleId);
        if (rule == null || !ENABLED.equals(rule.getStatus())) return null;
        CargoOrderDO order = cargoOrderMapper.selectById(cargoOrderId);
        if (order == null) return null;
        CargoOrderShipmentDO shipment = cargoOrderShipmentMapper.selectById(shipmentId);
        if (shipment == null) return null;
        Map<String, Object> orderContext = toMap(order);
        Map<String, Object> shipmentContext = toMap(shipment);
        if (!shipmentContext.containsKey("warehouseCode")) {
            Object warehouseCode = firstNotBlank(orderContext.get("platformWarehouseCode"), orderContext.get("inboundWarehouseName"));
            if (warehouseCode != null) shipmentContext.put("warehouseCode", warehouseCode);
        }
        CargoGroupingRuleTestRespVO result = evalRule(rule, orderContext, shipmentContext);
        return Boolean.TRUE.equals(result.getMatched()) ? result.getGroupKey() : null;
    }

    @Override
    public CargoGroupingRuleTestRespVO test(CargoGroupingRuleTestReqVO bo) {
        Map<String, Object> orderContext = buildOrderContext(bo);
        Map<String, Object> shipmentContext = buildShipmentContext(bo, orderContext);
        List<CargoGroupingRuleDO> rules = baseMapper.selectList(Wrappers.<CargoGroupingRuleDO>lambdaQuery()
            .eq(CargoGroupingRuleDO::getStatus, ENABLED)
            .orderByDesc(CargoGroupingRuleDO::getPriority)
            .orderByDesc(CargoGroupingRuleDO::getUpdateTime))
            .stream()
            .filter(rule -> ruleMatchesWarehouse(rule, bo.getWarehouseId()))
            .collect(java.util.stream.Collectors.toList());

        List<CargoGroupingRuleTestRespVO> misses = new ArrayList<>();
        for (CargoGroupingRuleDO rule : rules) {
            CargoGroupingRuleTestRespVO result = evalRule(rule, orderContext, shipmentContext);
            if (Boolean.TRUE.equals(result.getMatched())) {
                return result;
            }
            misses.add(result);
        }

        CargoGroupingRuleTestRespVO result = new CargoGroupingRuleTestRespVO();
        result.setMatched(false);
        result.setMessage(misses.isEmpty() ? "没有可用规则" : "没有命中规则");
        if (!misses.isEmpty()) {
            result.setConditionDetails(misses.get(0).getConditionDetails());
        }
        return result;
    }

    private Boolean changeStatus(Long id, String status) {
        CargoGroupingRuleDO update = new CargoGroupingRuleDO();
        update.setId(id);
        update.setStatus(status);
        return baseMapper.updateById(update) > 0;
    }

    private void validateJsonConfig(CargoGroupingRuleSaveReqVO bo) {
        if (CollUtil.isEmpty(parseJsonList(bo.getWarehouseIds()))) {
            throw exception(OMS_BIZ_ERROR, "适用仓库必须是 JSON 数组，如 [\"9001\",\"9002\"]");
        }
        if (!JsonUtils.isJsonObject(bo.getConditionConfig())) {
            throw exception(OMS_BIZ_ERROR, "匹配条件必须是 JSON 对象");
        }
        if (!JsonUtils.isJsonObject(bo.getGroupKeyConfig())) {
            throw exception(OMS_BIZ_ERROR, "分组键必须是 JSON 对象");
        }
    }

    private CargoGroupingRuleTestRespVO evalRule(CargoGroupingRuleDO rule, Map<String, Object> orderContext,
                                             Map<String, Object> shipmentContext) {
        Map<String, Object> conditionConfig = parseJsonMap(rule.getConditionConfig());
        CargoGroupingRuleTestRespVO result = new CargoGroupingRuleTestRespVO();
        result.setRuleId(rule.getId());
        result.setRuleName(rule.getRuleName());
        result.setPriority(rule.getPriority());
        result.setIsDefault(rule.getIsDefault());

        boolean matched = matchConfig(conditionConfig, orderContext, shipmentContext, result);
        result.setMatched(matched);
        result.setGroupKey(matched ? renderGroupKey(rule.getGroupKeyConfig(), orderContext, shipmentContext) : null);
        result.setMessage(matched ? "命中规则" : "规则未命中");
        return result;
    }

    @SuppressWarnings("unchecked")
    private boolean matchConfig(Map<String, Object> config, Map<String, Object> orderContext,
                                Map<String, Object> shipmentContext, CargoGroupingRuleTestRespVO result) {
        if (config == null || config.isEmpty()) {
            return true;
        }
        String mode = Objects.toString(config.getOrDefault("mode", "VALUE_MATCH"), "VALUE_MATCH");
        if ("EXPRESSION".equalsIgnoreCase(mode)) {
            return matchExpression(Objects.toString(config.get("expression"), ""), orderContext, shipmentContext);
        }
        Object conditionsObj = config.get("conditions");
        if (!(conditionsObj instanceof Collection<?> conditions) || conditions.isEmpty()) {
            return true;
        }
        String logic = Objects.toString(config.getOrDefault("logic", "AND"), "AND");
        boolean anyHit = false;
        for (Object item : conditions) {
            if (!(item instanceof Map<?, ?> raw)) {
                continue;
            }
            Map<String, Object> condition = (Map<String, Object>) raw;
            String field = Objects.toString(condition.get("field"), "");
            String op = Objects.toString(condition.getOrDefault("op", "EQ"), "EQ");
            Object expected = condition.get("value");
            Object actual = resolveFieldValue(field, orderContext, shipmentContext);
            boolean hit = compare(actual, op, expected);
            addConditionDetail(result, field, actual, op, expected, hit);
            if ("OR".equalsIgnoreCase(logic)) {
                anyHit = anyHit || hit;
            } else if (!hit) {
                return false;
            }
        }
        return "OR".equalsIgnoreCase(logic) ? anyHit : true;
    }

    private boolean matchExpression(String expression, Map<String, Object> orderContext, Map<String, Object> shipmentContext) {
        if (StrUtil.isBlank(expression)) {
            return true;
        }
        String[] orParts = expression.split("\\|\\|");
        for (String orPart : orParts) {
            boolean andHit = true;
            for (String andPart : orPart.split("&&")) {
                Matcher matcher = SIMPLE_EXPRESSION_PATTERN.matcher(andPart);
                if (!matcher.matches()) {
                    andHit = false;
                    break;
                }
                Object actual = resolveFieldValue(matcher.group(1), orderContext, shipmentContext);
                boolean eq = Objects.toString(actual, "").equals(matcher.group(3).trim());
                boolean hit = "==".equals(matcher.group(2)) ? eq : !eq;
                if (!hit) {
                    andHit = false;
                    break;
                }
            }
            if (andHit) {
                return true;
            }
        }
        return false;
    }

    @SuppressWarnings("unchecked")
    private String renderGroupKey(String groupKeyConfig, Map<String, Object> orderContext, Map<String, Object> shipmentContext) {
        Map<String, Object> config = parseJsonMap(groupKeyConfig);
        if (config == null) {
            return "--";
        }
        String separator = Objects.toString(config.getOrDefault("separator", "-"), "-");
        Object fieldsObj = config.get("fields");
        if (!(fieldsObj instanceof Collection<?> fields) || fields.isEmpty()) {
            return "--";
        }
        List<String> values = new ArrayList<>();
        for (Object item : fields) {
            String field;
            if (item instanceof Map<?, ?> map) {
                field = Objects.toString(((Map<String, Object>) map).get("field"), "");
            } else {
                field = Objects.toString(item, "");
            }
            Object value = resolveFieldValueForDisplay(field, orderContext, shipmentContext);
            if (value != null && StrUtil.isNotBlank(value.toString())) {
                values.add(value.toString());
            }
        }
        return values.isEmpty() ? "--" : String.join(separator, values);
    }

    /** 用于 group_code 渲染：ID 类字段解析为名称，不用数字 ID */
    private Object resolveFieldValueForDisplay(String field, Map<String, Object> orderContext, Map<String, Object> shipmentContext) {
        if (StrUtil.isBlank(field)) return null;
        if (field.startsWith("order.")) {
            return resolveOrderFieldForDisplay(field.substring("order.".length()), orderContext);
        }
        if (field.startsWith("shipment.")) {
            return resolveShipmentField(field.substring("shipment.".length()), shipmentContext, orderContext);
        }
        return firstNotBlank(orderContext.get(field), shipmentContext.get(field));
    }

    private Object resolveOrderFieldForDisplay(String fieldName, Map<String, Object> orderContext) {
        // hold_flag：值为 1 时渲染为字面量 "HOLD"，否则不参与分组键
        if ("hold_flag".equals(fieldName)) {
            Object raw = firstNotBlank(orderContext.get("hold_flag"), orderContext.get("holdFlag"));
            return "1".equals(Objects.toString(raw, "")) ? "HOLD" : null;
        }
        // transfer_warehouse_code：直接取转仓目标仓库代码
        if ("transfer_warehouse_code".equals(fieldName)) {
            return firstNotBlank(orderContext.get("transfer_warehouse_code"), orderContext.get("transferWarehouseCode"));
        }
        String mapped = switch (fieldName) {
            case "order_no"           -> "cargoOrderNo";
            case "order_type"         -> "businessTypeName";
            case "address_type"       -> "addressType";
            case "platform_id"        -> "platformName";
            case "platform_code"      -> "platformWarehouseCode";
            case "channel_id"         -> "channelName";
            case "customer_id"        -> "customerName";
            case "parcel_carrier_name"-> "parcelCarrierName";
            case "transfer_flag"      -> "transferFlag";
            default                   -> snakeToCamel(fieldName);
        };
        Object value = firstNotBlank(orderContext.get(fieldName), orderContext.get(mapped));
        if ("platform_id".equals(fieldName) && value == null) {
            value = firstNotBlank(orderContext.get("platformCode"), orderContext.get("platformWarehouseCode"));
        }
        return value;
    }

    private void addConditionDetail(CargoGroupingRuleTestRespVO result, String field, Object actual, String op, Object expected, boolean hit) {
        CargoGroupingRuleTestRespVO.ConditionDetail detail = new CargoGroupingRuleTestRespVO.ConditionDetail();
        detail.setField(field);
        detail.setFieldValue(actual);
        detail.setOp(op);
        detail.setExpectedValue(expected);
        detail.setHit(hit);
        result.getConditionDetails().add(detail);
    }

    private boolean compare(Object actual, String op, Object expected) {
        String upperOp = StrUtil.isBlank(op) ? "EQ" : op.toUpperCase();
        if ("IS_NULL".equals(upperOp)) return actual == null || StrUtil.isBlank(actual.toString());
        if ("IS_NOT_NULL".equals(upperOp)) return actual != null && StrUtil.isNotBlank(actual.toString());
        if (actual == null) return "NEQ".equals(upperOp) || "NOT_IN".equals(upperOp);
        String actualText = actual.toString();
        return switch (upperOp) {
            case "NEQ" -> !actualText.equals(Objects.toString(expected, ""));
            case "IN" -> containsExpected(expected, actualText);
            case "NOT_IN" -> !containsExpected(expected, actualText);
            case "GT" -> toDecimal(actual).compareTo(toDecimal(expected)) > 0;
            case "GTE" -> toDecimal(actual).compareTo(toDecimal(expected)) >= 0;
            case "LT" -> toDecimal(actual).compareTo(toDecimal(expected)) < 0;
            case "LTE" -> toDecimal(actual).compareTo(toDecimal(expected)) <= 0;
            default -> actualText.equals(Objects.toString(expected, ""));
        };
    }

    private boolean containsExpected(Object expected, String actualText) {
        if (expected instanceof Collection<?> collection) {
            return collection.stream().map(Objects::toString).anyMatch(actualText::equals);
        }
        return List.of(Objects.toString(expected, "").split(",")).stream()
            .map(String::trim)
            .anyMatch(actualText::equals);
    }

    private BigDecimal toDecimal(Object value) {
        try {
            return new BigDecimal(Objects.toString(value, "0"));
        } catch (Exception e) {
            return BigDecimal.ZERO;
        }
    }

    private Map<String, Object> buildOrderContext(CargoGroupingRuleTestReqVO bo) {
        if (bo.getCargoOrderId() != null) {
            CargoOrderDO order = cargoOrderMapper.selectById(bo.getCargoOrderId());
            if (order == null) {
                throw exception(OMS_BIZ_ERROR, "货物订单不存在");
            }
            return toMap(order);
        }
        return parseJsonMap(bo.getOrderContext());
    }

    private Map<String, Object> buildShipmentContext(CargoGroupingRuleTestReqVO bo, Map<String, Object> orderContext) {
        Map<String, Object> shipmentContext;
        if (bo.getShipmentId() != null) {
            CargoOrderShipmentDO shipment = cargoOrderShipmentMapper.selectById(bo.getShipmentId());
            if (shipment == null) {
                throw exception(OMS_BIZ_ERROR, "货件不存在");
            }
            shipmentContext = toMap(shipment);
        } else {
            shipmentContext = parseJsonMap(bo.getShipmentContext());
        }
        if (!shipmentContext.containsKey("warehouseCode")) {
            Object warehouseCode = firstNotBlank(orderContext.get("platformWarehouseCode"), orderContext.get("inboundWarehouseName"));
            if (warehouseCode != null) {
                shipmentContext.put("warehouseCode", warehouseCode);
            }
        }
        return shipmentContext;
    }

    private Object resolveFieldValue(String field, Map<String, Object> orderContext, Map<String, Object> shipmentContext) {
        if (StrUtil.isBlank(field)) {
            return null;
        }
        if (field.startsWith("order.")) {
            return resolveOrderField(field.substring("order.".length()), orderContext);
        }
        if (field.startsWith("shipment.")) {
            return resolveShipmentField(field.substring("shipment.".length()), shipmentContext, orderContext);
        }
        return firstNotBlank(orderContext.get(field), shipmentContext.get(field));
    }

    private Object resolveOrderField(String fieldName, Map<String, Object> orderContext) {
        String mapped = switch (fieldName) {
            case "order_no"                -> "cargoOrderNo";
            case "order_type"              -> "businessTypeName";
            case "address_type"            -> "addressType";
            case "platform_id"             -> "platformId";
            case "platform_code"           -> "platformWarehouseCode";
            case "parcel_carrier_name"     -> "parcelCarrierName";
            case "customer_id"             -> "customerId";
            case "channel_id"              -> "channelId";
            case "hold_flag"               -> "holdFlag";
            case "transfer_flag"           -> "transferFlag";
            case "transfer_warehouse_code" -> "transferWarehouseCode";
            default -> snakeToCamel(fieldName);
        };
        Object value = firstNotBlank(orderContext.get(fieldName), orderContext.get(mapped));
        if ("platform_id".equals(fieldName) && value == null) {
            value = firstNotBlank(orderContext.get("platformName"), orderContext.get("platformCode"));
        }
        if ("platform_code".equals(fieldName) && value == null) {
            value = firstNotBlank(orderContext.get("platformName"), orderContext.get("platformId"));
        }
        return value;
    }

    private Object resolveShipmentField(String fieldName, Map<String, Object> shipmentContext, Map<String, Object> orderContext) {
        String mapped = switch (fieldName) {
            case "shipment_no" -> "shipmentNo";
            case "warehouse_code" -> "warehouseCode";
            case "shipment_type" -> "shipmentType";
            default -> snakeToCamel(fieldName);
        };
        Object value = firstNotBlank(shipmentContext.get(fieldName), shipmentContext.get(mapped));
        if ("warehouse_code".equals(fieldName) && value == null) {
            value = firstNotBlank(orderContext.get("platformWarehouseCode"), orderContext.get("inboundWarehouseName"));
        }
        return value;
    }

    private Object firstNotBlank(Object... values) {
        for (Object value : values) {
            if (value != null && StrUtil.isNotBlank(value.toString())) {
                return value;
            }
        }
        return null;
    }

    private String snakeToCamel(String value) {
        StringBuilder builder = new StringBuilder();
        boolean upperNext = false;
        for (char c : value.toCharArray()) {
            if (c == '_') {
                upperNext = true;
                continue;
            }
            builder.append(upperNext ? Character.toUpperCase(c) : c);
            upperNext = false;
        }
        return builder.toString();
    }

    /** 适用仓库：warehouse_ids 为 JSON 数组，一条规则可绑定多个仓库 */
    private void applyWarehouseFields(CargoGroupingRuleDO entity, String warehouseIds, String warehouseNames) {
        entity.setWarehouseIds(warehouseIds);
        entity.setWarehouseName(StrUtil.isNotBlank(warehouseNames) ? warehouseNames : entity.getWarehouseName());
    }

    /** 判断规则 JSON 仓库列表是否包含指定仓库 */
    private boolean ruleMatchesWarehouse(CargoGroupingRuleDO rule, Long warehouseId) {
        if (warehouseId == null) return false;
        return parseJsonList(rule.getWarehouseIds()).contains(String.valueOf(warehouseId));
    }

    /**
     * 按仓库筛选：查询参数为逗号分隔的仓库 ID，匹配规则 warehouse_ids JSON 数组是否包含其中任一 ID。
     * 例：规则 ["9001","9002"]，筛选 9001 → 命中。
     */
    private void applyWarehouseFilter(LambdaQueryWrapper<CargoGroupingRuleDO> lqw, String filterWarehouseIdsCsv) {
        List<Long> filterIds = OmsQueryCsvUtils.toLongList(filterWarehouseIdsCsv);
        if (filterIds == null) {
            return;
        }
        lqw.and(wrapper -> {
            for (Long warehouseId : filterIds) {
                String idStr = String.valueOf(warehouseId);
                wrapper.or().apply("JSON_CONTAINS(warehouse_ids, JSON_QUOTE({0}))", idStr);
            }
        });
    }

    private List<String> parseJsonList(String json) {
        if (StrUtil.isBlank(json)) return List.of();
        List<String> list = JsonUtils.parseObject(json, new TypeReference<List<String>>() {});
        return list == null ? List.of() : list;
    }

    private Map<String, Object> parseJsonMap(String json) {
        if (StrUtil.isBlank(json)) {
            return new LinkedHashMap<>();
        }
        Map<String, Object> map = JsonUtils.parseObject(json, new TypeReference<Map<String, Object>>() {});
        return map == null ? new LinkedHashMap<>() : map;
    }

    private Map<String, Object> toMap(Object value) {
        Map<String, Object> map = JsonUtils.parseObject(JsonUtils.toJsonString(value), new TypeReference<Map<String, Object>>() {});
        return map == null ? new LinkedHashMap<>() : map;
    }

    private LambdaQueryWrapper<CargoGroupingRuleDO> buildQueryWrapper(CargoGroupingRulePageReqVO bo) {
        LambdaQueryWrapper<CargoGroupingRuleDO> lqw = Wrappers.lambdaQuery();
        String warehouseFilter = null;
        if (bo != null) {
            lqw.like(StrUtil.isNotBlank(bo.getWarehouseName()), CargoGroupingRuleDO::getWarehouseName, bo.getWarehouseName());
            lqw.like(StrUtil.isNotBlank(bo.getRuleName()), CargoGroupingRuleDO::getRuleName, bo.getRuleName());
            OmsLambdaQueryHelper.inStringCsv(lqw, CargoGroupingRuleDO::getStatus, bo.getStatus());
            OmsLambdaQueryHelper.inIntegerCsv(lqw, CargoGroupingRuleDO::getIsDefault, bo.getIsDefault());
            warehouseFilter = StrUtil.isNotBlank(bo.getWarehouseIds()) ? bo.getWarehouseIds() : bo.getWarehouseId();
        }
        Long contextWarehouseId = OrgContextHolder.getWarehouseId();
        if (contextWarehouseId != null) {
            warehouseFilter = String.valueOf(contextWarehouseId);
        }
        if (StrUtil.isNotBlank(warehouseFilter)) {
            applyWarehouseFilter(lqw, warehouseFilter);
        }
        lqw.orderByDesc(CargoGroupingRuleDO::getPriority)
            .orderByDesc(CargoGroupingRuleDO::getUpdateTime)
            .orderByDesc(CargoGroupingRuleDO::getCreateTime);
        return lqw;
    }
}
