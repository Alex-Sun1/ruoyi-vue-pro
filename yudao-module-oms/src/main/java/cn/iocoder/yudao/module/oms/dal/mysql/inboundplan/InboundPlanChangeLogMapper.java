package cn.iocoder.yudao.module.oms.dal.mysql.inboundplan;
import org.apache.ibatis.annotations.Mapper;

import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.module.oms.dal.dataobject.inboundplan.InboundPlanChangeLogDO;

/**
 * 入库计划变更日志 Mapper
 */
@Mapper
public interface InboundPlanChangeLogMapper extends BaseMapperX<InboundPlanChangeLogDO> {
}
