package cn.iocoder.yudao.module.yms.dal.mysql;

import org.apache.ibatis.annotations.Mapper;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;

import org.apache.ibatis.annotations.Param;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsAppointmentRuleSlotDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentRuleSlotRespVO;

import java.util.List;

@Mapper
public interface YmsAppointmentRuleSlotMapper extends BaseMapperX<YmsAppointmentRuleSlotDO> {

    List<YmsAppointmentRuleSlotRespVO> selectByRuleId(@Param("ruleId") Long ruleId);

    int deleteByRuleId(@Param("ruleId") Long ruleId);
}

