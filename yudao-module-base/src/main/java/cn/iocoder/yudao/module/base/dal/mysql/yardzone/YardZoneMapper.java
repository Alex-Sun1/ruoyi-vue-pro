package cn.iocoder.yudao.module.base.dal.mysql.yardzone;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.controller.admin.yardzone.vo.YardZonePageReqVO;
import cn.iocoder.yudao.module.base.dal.dataobject.yardzone.YardZoneDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface YardZoneMapper extends BaseMapperX<YardZoneDO> {

    default PageResult<YardZoneDO> selectPage(YardZonePageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<YardZoneDO>()
                .eqIfPresent(YardZoneDO::getWarehouseId, reqVO.getWarehouseId())
                .likeIfPresent(YardZoneDO::getZoneCode, reqVO.getZoneCode())
                .likeIfPresent(YardZoneDO::getZoneName, reqVO.getZoneName())
                .eqIfPresent(YardZoneDO::getZoneType, reqVO.getZoneType())
                .orderByAsc(YardZoneDO::getSortOrder, YardZoneDO::getZoneCode));
    }

    default List<YardZoneDO> selectListByWarehouseId(Long warehouseId) {
        return selectList(new LambdaQueryWrapperX<YardZoneDO>()
                .eq(YardZoneDO::getWarehouseId, warehouseId)
                .orderByAsc(YardZoneDO::getSortOrder, YardZoneDO::getZoneCode));
    }

    default YardZoneDO selectByUnique(String zoneCode) {
        return selectOne(YardZoneDO::getZoneCode, zoneCode);
    }

}
