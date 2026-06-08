package cn.iocoder.yudao.module.oms.dal.mysql.outboundorder;
import org.apache.ibatis.annotations.Mapper;

import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.module.oms.dal.dataobject.outboundorder.OutboundOrderDO;
import cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo.OutboundOrderRespVO;

@Mapper
public interface OutboundOrderMapper extends BaseMapperX<OutboundOrderDO> {
}
