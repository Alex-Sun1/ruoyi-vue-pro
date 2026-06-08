package cn.iocoder.yudao.module.oms.dal.mysql.outboundorder;
import org.apache.ibatis.annotations.Mapper;

import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.module.oms.dal.dataobject.outboundorder.OutboundOrderItemDO;
import cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo.OutboundOrderItemRespVO;

@Mapper
public interface OutboundOrderItemMapper extends BaseMapperX<OutboundOrderItemDO> {
}
