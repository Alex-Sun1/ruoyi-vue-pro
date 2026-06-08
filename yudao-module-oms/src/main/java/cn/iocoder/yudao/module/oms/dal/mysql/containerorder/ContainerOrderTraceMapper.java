package cn.iocoder.yudao.module.oms.dal.mysql.containerorder;
import org.apache.ibatis.annotations.Mapper;

import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.module.oms.dal.dataobject.containerorder.ContainerOrderTraceDO;
import cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo.ContainerOrderTraceRespVO;

/**
 * 海柜订单轨迹Mapper
 */
@Mapper
public interface ContainerOrderTraceMapper extends BaseMapperX<ContainerOrderTraceDO> {
}
