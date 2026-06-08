package cn.iocoder.yudao.module.wms.dal.mysql.pallet;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.wms.controller.admin.inventory.vo.WmsPalletPageReqVO;
import cn.iocoder.yudao.module.wms.dal.dataobject.pallet.WmsPalletDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.Arrays;
import java.util.List;

@Mapper
public interface WmsPalletMapper extends BaseMapperX<WmsPalletDO> {

    List<String> PALLET_ACTIVE = Arrays.asList("IN_STOCK", "PRE_OUTBOUND", "HOLD");

    default PageResult<WmsPalletDO> selectPage(WmsPalletPageReqVO pageReqVO) {
        return selectPage(pageReqVO, buildWrapper(pageReqVO));
    }

    default LambdaQueryWrapperX<WmsPalletDO> buildWrapper(WmsPalletPageReqVO pageReqVO) {
        LambdaQueryWrapperX<WmsPalletDO> wrapper = new LambdaQueryWrapperX<WmsPalletDO>()
                .eqIfPresent(WmsPalletDO::getWarehouseId, pageReqVO.getWarehouseId())
                .eqIfPresent(WmsPalletDO::getLocationId, pageReqVO.getLocationId())
                .eqIfPresent(WmsPalletDO::getCargoOrderId, pageReqVO.getCargoOrderId())
                .eqIfPresent(WmsPalletDO::getShipmentId, pageReqVO.getShipmentId());
        if (StrUtil.isNotBlank(pageReqVO.getPalletStatus())) {
            wrapper.eq(WmsPalletDO::getPalletStatus, pageReqVO.getPalletStatus());
        } else {
            applyPalletScope(wrapper, pageReqVO.getScope());
        }
        if (StrUtil.isNotBlank(pageReqVO.getKeyword())) {
            wrapper.and(w -> w.like(WmsPalletDO::getPalletNo, pageReqVO.getKeyword())
                    .or().like(WmsPalletDO::getCargoOrderNo, pageReqVO.getKeyword())
                    .or().like(WmsPalletDO::getShipmentCode, pageReqVO.getKeyword()));
        }
        wrapper.orderByDesc(WmsPalletDO::getUpdateTime);
        return wrapper;
    }

    static void applyPalletScope(LambdaQueryWrapperX<WmsPalletDO> wrapper, String scope) {
        if ("OUTBOUND".equalsIgnoreCase(scope)) {
            wrapper.eq(WmsPalletDO::getPalletStatus, "OUTBOUND");
            return;
        }
        if ("ALL".equalsIgnoreCase(scope)) {
            return;
        }
        wrapper.in(WmsPalletDO::getPalletStatus, PALLET_ACTIVE);
    }

}
