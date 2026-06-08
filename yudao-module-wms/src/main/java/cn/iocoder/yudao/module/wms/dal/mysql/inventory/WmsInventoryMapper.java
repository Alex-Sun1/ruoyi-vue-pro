package cn.iocoder.yudao.module.wms.dal.mysql.inventory;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.wms.controller.admin.inventory.vo.WmsInventoryPageReqVO;
import cn.iocoder.yudao.module.wms.dal.dataobject.inventory.WmsInventoryDO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface WmsInventoryMapper extends BaseMapperX<WmsInventoryDO> {

    default PageResult<WmsInventoryDO> selectPage(WmsInventoryPageReqVO pageReqVO) {
        return selectPage(pageReqVO, buildWrapper(pageReqVO));
    }

    default LambdaQueryWrapperX<WmsInventoryDO> buildWrapper(WmsInventoryPageReqVO pageReqVO) {
        LambdaQueryWrapperX<WmsInventoryDO> wrapper = new LambdaQueryWrapperX<WmsInventoryDO>()
                .eqIfPresent(WmsInventoryDO::getWarehouseId, pageReqVO.getWarehouseId())
                .eqIfPresent(WmsInventoryDO::getCustomerId, pageReqVO.getCustomerId())
                .eqIfPresent(WmsInventoryDO::getCargoOrderId, pageReqVO.getCargoOrderId())
                .eqIfPresent(WmsInventoryDO::getShipmentId, pageReqVO.getShipmentId())
                .eqIfPresent(WmsInventoryDO::getInventoryStatus, pageReqVO.getInventoryStatus());
        if (!Boolean.TRUE.equals(pageReqVO.getIncludeDepleted())) {
            wrapper.gt(WmsInventoryDO::getTotalBoxQty, 0);
        }
        if (pageReqVO.getKeyword() != null) {
            wrapper.and(w -> w.like(WmsInventoryDO::getCargoOrderNo, pageReqVO.getKeyword())
                    .or().like(WmsInventoryDO::getShipmentCode, pageReqVO.getKeyword())
                    .or().like(WmsInventoryDO::getCustomerName, pageReqVO.getKeyword()));
        }
        wrapper.orderByDesc(WmsInventoryDO::getUpdateTime);
        return wrapper;
    }

}
