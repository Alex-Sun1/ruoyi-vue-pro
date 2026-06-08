package cn.iocoder.yudao.module.oms.dal.mysql.preoutbound;
import org.apache.ibatis.annotations.Mapper;

import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.module.oms.dal.dataobject.preoutbound.PreOutboundDO;
import cn.iocoder.yudao.module.oms.controller.admin.preoutbound.vo.PreOutboundRespVO;

@Mapper
public interface PreOutboundMapper extends BaseMapperX<PreOutboundDO> {
}
