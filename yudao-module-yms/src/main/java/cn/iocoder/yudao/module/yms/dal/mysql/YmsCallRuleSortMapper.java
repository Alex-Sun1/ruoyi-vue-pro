package cn.iocoder.yudao.module.yms.dal.mysql;

import org.apache.ibatis.annotations.Mapper;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;

import cn.iocoder.yudao.module.yms.dal.dataobject.YmsCallRuleSortDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCallRuleSortRespVO;

@Mapper
public interface YmsCallRuleSortMapper extends BaseMapperX<YmsCallRuleSortDO> {
}

