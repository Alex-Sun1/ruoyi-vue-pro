package cn.iocoder.yudao.module.wms.dal.mysql.inventorylock;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.wms.controller.admin.inventory.vo.WmsInventoryLockPageReqVO;
import cn.iocoder.yudao.module.wms.dal.dataobject.inventorylock.WmsInventoryLockDO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface WmsInventoryLockMapper extends BaseMapperX<WmsInventoryLockDO> {

    default PageResult<WmsInventoryLockDO> selectPage(WmsInventoryLockPageReqVO pageReqVO) {
        return selectPage(pageReqVO, buildWrapper(pageReqVO));
    }

    default LambdaQueryWrapperX<WmsInventoryLockDO> buildWrapper(WmsInventoryLockPageReqVO pageReqVO) {
        LambdaQueryWrapperX<WmsInventoryLockDO> wrapper = new LambdaQueryWrapperX<WmsInventoryLockDO>()
                .eqIfPresent(WmsInventoryLockDO::getWarehouseId, pageReqVO.getWarehouseId())
                .eqIfPresent(WmsInventoryLockDO::getShipmentId, pageReqVO.getShipmentId())
                .eqIfPresent(WmsInventoryLockDO::getPalletId, pageReqVO.getPalletId())
                .eqIfPresent(WmsInventoryLockDO::getBizDocType, pageReqVO.getBizDocType())
                .eqIfPresent(WmsInventoryLockDO::getLockStatus, pageReqVO.getLockStatus());
        if (StrUtil.isNotBlank(pageReqVO.getKeyword())) {
            wrapper.and(w -> w.like(WmsInventoryLockDO::getPalletNo, pageReqVO.getKeyword())
                    .or().like(WmsInventoryLockDO::getShipmentCode, pageReqVO.getKeyword()));
        }
        return wrapper.orderByDesc(WmsInventoryLockDO::getLockTime);
    }

}
