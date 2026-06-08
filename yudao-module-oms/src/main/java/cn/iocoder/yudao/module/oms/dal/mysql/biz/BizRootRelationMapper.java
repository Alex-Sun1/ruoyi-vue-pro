package cn.iocoder.yudao.module.oms.dal.mysql.biz;

import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.module.oms.dal.dataobject.biz.BizRootRelationDO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface BizRootRelationMapper extends BaseMapperX<BizRootRelationDO> {

    @Update("UPDATE oms_biz_root_relation SET relation_status = 'INACTIVE', deleted = 1, update_time = NOW() "
        + "WHERE target_type = #{targetType} AND target_id = #{targetId} AND deleted = 0")
    int deactivateByTarget(@Param("targetType") String targetType, @Param("targetId") Long targetId);

    @Update("UPDATE oms_biz_root_relation SET relation_status = 'INACTIVE', deleted = 1, update_time = NOW() "
        + "WHERE target_type = #{targetType} AND target_id = #{targetId} AND cargo_order_id = #{cargoOrderId} AND deleted = 0")
    int deactivateByTargetAndCargo(@Param("targetType") String targetType,
                                   @Param("targetId") Long targetId,
                                   @Param("cargoOrderId") Long cargoOrderId);
}
