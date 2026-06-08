package cn.iocoder.yudao.module.oms.service.cargogroupingrule;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule.vo.CargoGroupingRuleSaveReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule.vo.CargoGroupingRulePriorityReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule.vo.CargoGroupingRulePageReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule.vo.CargoGroupingRuleTestReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule.vo.CargoGroupingRuleTestRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule.vo.CargoGroupingRuleRespVO;

import java.util.List;

public interface CargoGroupingRuleService {

    PageResult<CargoGroupingRuleRespVO> queryPageList(CargoGroupingRulePageReqVO bo, PageParam pageQuery);

    List<CargoGroupingRuleRespVO> queryList(CargoGroupingRulePageReqVO bo);

    CargoGroupingRuleRespVO queryById(Long id);

    Boolean insertByBo(CargoGroupingRuleSaveReqVO bo);

    Boolean updateByBo(CargoGroupingRuleSaveReqVO bo);

    Boolean deleteWithValidByIds(List<Long> ids, Boolean isValid);

    Boolean enable(Long id);

    Boolean disable(Long id);

    Long copy(Long id);

    Boolean updatePriority(List<CargoGroupingRulePriorityReqVO> list);

    CargoGroupingRuleTestRespVO test(CargoGroupingRuleTestReqVO bo);

    /**
     * 对指定货件运行所有启用规则，返回命中的 group_code；无命中时返回 null
     */
    String computeGroupCode(Long warehouseId, Long cargoOrderId, Long shipmentId);

    /**
     * 对指定货件运行单条规则，条件未命中时返回 null
     */
    String computeGroupCodeByRule(Long ruleId, Long cargoOrderId, Long shipmentId);
}
