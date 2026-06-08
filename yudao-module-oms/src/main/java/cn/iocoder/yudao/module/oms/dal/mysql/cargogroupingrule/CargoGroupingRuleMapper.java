package cn.iocoder.yudao.module.oms.dal.mysql.cargogroupingrule;
import org.apache.ibatis.annotations.Mapper;

import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargogroupingrule.CargoGroupingRuleDO;
import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule.vo.CargoGroupingRuleRespVO;

@Mapper
public interface CargoGroupingRuleMapper extends BaseMapperX<CargoGroupingRuleDO> {
}
