package cn.iocoder.yudao.module.wms.dal.mysql.location;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.wms.controller.admin.location.vo.WmsLocationPageReqVO;
import cn.iocoder.yudao.module.wms.dal.dataobject.location.WmsLocationDO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface WmsLocationMapper extends BaseMapperX<WmsLocationDO> {

    default PageResult<WmsLocationDO> selectPage(WmsLocationPageReqVO pageReqVO) {
        return selectPage(pageReqVO, buildWrapper(pageReqVO));
    }

    default LambdaQueryWrapperX<WmsLocationDO> buildWrapper(WmsLocationPageReqVO pageReqVO) {
        LambdaQueryWrapperX<WmsLocationDO> wrapper = new LambdaQueryWrapperX<WmsLocationDO>()
                .eqIfPresent(WmsLocationDO::getWarehouseId, pageReqVO.getWarehouseId())
                .eqIfPresent(WmsLocationDO::getZoneId, pageReqVO.getZoneId())
                .likeIfPresent(WmsLocationDO::getZoneName, pageReqVO.getZoneName())
                .likeIfPresent(WmsLocationDO::getLocationCode, pageReqVO.getLocationCode())
                .eqIfPresent(WmsLocationDO::getStatus, pageReqVO.getStatus());
        wrapper.orderByAsc(WmsLocationDO::getZoneName).orderByAsc(WmsLocationDO::getLocationCode);
        return wrapper;
    }

}
