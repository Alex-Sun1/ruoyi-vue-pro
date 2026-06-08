package cn.iocoder.yudao.module.wms.dal.mysql.zone;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.wms.controller.admin.zone.vo.WmsZonePageReqVO;
import cn.iocoder.yudao.module.wms.dal.dataobject.zone.WmsZoneDO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface WmsZoneMapper extends BaseMapperX<WmsZoneDO> {

    default PageResult<WmsZoneDO> selectPage(WmsZonePageReqVO pageReqVO) {
        return selectPage(pageReqVO, buildWrapper(pageReqVO));
    }

    default LambdaQueryWrapperX<WmsZoneDO> buildWrapper(WmsZonePageReqVO pageReqVO) {
        return new LambdaQueryWrapperX<WmsZoneDO>()
                .eqIfPresent(WmsZoneDO::getWarehouseId, pageReqVO.getWarehouseId())
                .likeIfPresent(WmsZoneDO::getZoneName, pageReqVO.getZoneName())
                .eqIfPresent(WmsZoneDO::getZoneType, pageReqVO.getZoneType())
                .eqIfPresent(WmsZoneDO::getStorageMethod, pageReqVO.getStorageMethod())
                .eqIfPresent(WmsZoneDO::getStatus, pageReqVO.getStatus())
                .orderByDesc(WmsZoneDO::getCreateTime);
    }

}
