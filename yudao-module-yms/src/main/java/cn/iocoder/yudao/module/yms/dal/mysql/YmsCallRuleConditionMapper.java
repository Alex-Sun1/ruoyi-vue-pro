package cn.iocoder.yudao.module.yms.dal.mysql;

import org.apache.ibatis.annotations.Mapper;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;

import cn.iocoder.yudao.module.yms.dal.dataobject.YmsCallRuleConditionDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCallRuleConditionRespVO;

@Mapper
public interface YmsCallRuleConditionMapper extends BaseMapperX<YmsCallRuleConditionDO> {
}

