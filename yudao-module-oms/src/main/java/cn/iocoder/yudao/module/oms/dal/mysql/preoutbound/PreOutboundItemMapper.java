package cn.iocoder.yudao.module.oms.dal.mysql.preoutbound;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Update;

import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.module.oms.dal.dataobject.preoutbound.PreOutboundItemDO;

@Mapper
public interface PreOutboundItemMapper extends BaseMapperX<PreOutboundItemDO> {

    @Update("UPDATE oms_pre_outbound_item SET deleted = 0, pre_outbound_no = #{preOutboundNo}, "
        + "cargo_order_no = #{cargoOrderNo}, update_time = NOW() "
        + "WHERE pre_outbound_id = #{preOutboundId} AND cargo_order_id = #{cargoOrderId} AND deleted = 1 "
        + "LIMIT 1")
    int restoreDeletedItem(@Param("preOutboundId") Long preOutboundId,
                           @Param("preOutboundNo") String preOutboundNo,
                           @Param("cargoOrderId") Long cargoOrderId,
                           @Param("cargoOrderNo") String cargoOrderNo);
}
