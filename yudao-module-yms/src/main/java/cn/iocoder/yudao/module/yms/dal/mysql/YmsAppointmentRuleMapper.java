package cn.iocoder.yudao.module.yms.dal.mysql;

import org.apache.ibatis.annotations.Mapper;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsAppointmentRuleDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentRuleQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentRuleRespVO;

@Mapper
public interface YmsAppointmentRuleMapper extends BaseMapperX<YmsAppointmentRuleDO> {

    Page<YmsAppointmentRuleRespVO> selectPageList(@Param("page") Page<YmsAppointmentRuleDO> page,
                                              @Param("bo") YmsAppointmentRuleQueryReqVO bo);

    YmsAppointmentRuleRespVO selectVoDetailById(@Param("id") Long id);

    YmsAppointmentRuleRespVO selectMatchRule(@Param("warehouseId") Long warehouseId,
                                         @Param("businessType") String businessType,
                                         @Param("vehicleSource") String vehicleSource);
}

