package cn.iocoder.yudao.module.yms.dal.mysql;

import org.apache.ibatis.annotations.Mapper;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsCallRuleDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCallRuleQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCallRuleRespVO;

@Mapper
public interface YmsCallRuleMapper extends BaseMapperX<YmsCallRuleDO> {

    Page<YmsCallRuleRespVO> selectPageList(@Param("page") Page<YmsCallRuleDO> page,
                                       @Param("bo") YmsCallRuleQueryReqVO bo);
}

