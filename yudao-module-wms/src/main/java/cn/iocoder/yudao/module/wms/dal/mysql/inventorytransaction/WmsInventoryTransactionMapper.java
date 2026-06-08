package cn.iocoder.yudao.module.wms.dal.mysql.inventorytransaction;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.wms.controller.admin.inventory.vo.WmsInventoryTransactionPageReqVO;
import cn.iocoder.yudao.module.wms.dal.dataobject.inventorytransaction.WmsInventoryTransactionDO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface WmsInventoryTransactionMapper extends BaseMapperX<WmsInventoryTransactionDO> {

    default PageResult<WmsInventoryTransactionDO> selectPage(WmsInventoryTransactionPageReqVO pageReqVO) {
        return selectPage(pageReqVO, buildWrapper(pageReqVO));
    }

    default LambdaQueryWrapperX<WmsInventoryTransactionDO> buildWrapper(WmsInventoryTransactionPageReqVO pageReqVO) {
        LambdaQueryWrapperX<WmsInventoryTransactionDO> wrapper = new LambdaQueryWrapperX<WmsInventoryTransactionDO>()
                .eqIfPresent(WmsInventoryTransactionDO::getWarehouseId, pageReqVO.getWarehouseId())
                .eqIfPresent(WmsInventoryTransactionDO::getShipmentId, pageReqVO.getShipmentId())
                .eqIfPresent(WmsInventoryTransactionDO::getPalletId, pageReqVO.getPalletId())
                .eqIfPresent(WmsInventoryTransactionDO::getTransactionType, pageReqVO.getTransactionType())
                .eqIfPresent(WmsInventoryTransactionDO::getBizDocType, pageReqVO.getBizDocType());
        if (StrUtil.isNotBlank(pageReqVO.getKeyword())) {
            wrapper.and(w -> w.like(WmsInventoryTransactionDO::getTransactionNo, pageReqVO.getKeyword())
                    .or().like(WmsInventoryTransactionDO::getPalletNo, pageReqVO.getKeyword())
                    .or().like(WmsInventoryTransactionDO::getShipmentCode, pageReqVO.getKeyword()));
        }
        return wrapper.orderByDesc(WmsInventoryTransactionDO::getOperateTime);
    }

}
