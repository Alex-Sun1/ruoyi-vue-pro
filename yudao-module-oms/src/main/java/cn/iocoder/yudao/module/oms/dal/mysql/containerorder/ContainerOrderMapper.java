package cn.iocoder.yudao.module.oms.dal.mysql.containerorder;
import org.apache.ibatis.annotations.Mapper;

import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.module.oms.dal.dataobject.containerorder.ContainerOrderDO;
import cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo.ContainerOrderRespVO;

/**
 * 海柜订单Mapper
 */
@Mapper
public interface ContainerOrderMapper extends BaseMapperX<ContainerOrderDO> {
}
