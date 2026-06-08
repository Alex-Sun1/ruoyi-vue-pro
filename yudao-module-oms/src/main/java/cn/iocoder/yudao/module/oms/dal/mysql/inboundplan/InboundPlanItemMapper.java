package cn.iocoder.yudao.module.oms.dal.mysql.inboundplan;
import org.apache.ibatis.annotations.Mapper;

import org.apache.ibatis.annotations.Param;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.module.oms.dal.dataobject.inboundplan.InboundPlanItemDO;
import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanGroupRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanItemRespVO;

import java.util.List;

/**
 * 入库计划明细 Mapper
 */
@Mapper
public interface InboundPlanItemMapper extends BaseMapperX<InboundPlanItemDO> {

    /** 查询计划下所有明细（JOIN 原表展示字段） */
    List<InboundPlanItemRespVO> selectItemsByPlanId(@Param("planId") Long planId);

    /** 按分组聚合统计（用于折叠行展示） */
    List<InboundPlanGroupRespVO> selectGroupSummaryByPlanId(@Param("planId") Long planId);
}
