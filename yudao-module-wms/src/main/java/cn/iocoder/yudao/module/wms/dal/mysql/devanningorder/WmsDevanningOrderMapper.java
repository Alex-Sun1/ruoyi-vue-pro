package cn.iocoder.yudao.module.wms.dal.mysql.devanningorder;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.wms.controller.admin.devanningorder.vo.WmsDevanningOrderPageReqVO;
import cn.iocoder.yudao.module.wms.dal.dataobject.devanningorder.WmsDevanningOrderDO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface WmsDevanningOrderMapper extends BaseMapperX<WmsDevanningOrderDO> {

    default PageResult<WmsDevanningOrderDO> selectPage(WmsDevanningOrderPageReqVO pageReqVO) {
        return selectPage(pageReqVO, buildWrapper(pageReqVO));
    }

    default LambdaQueryWrapperX<WmsDevanningOrderDO> buildWrapper(WmsDevanningOrderPageReqVO pageReqVO) {
        LambdaQueryWrapperX<WmsDevanningOrderDO> wrapper = new LambdaQueryWrapperX<>();
        if (pageReqVO == null) {
            return wrapper.orderByDesc(WmsDevanningOrderDO::getCreateTime);
        }
        if (StrUtil.isNotBlank(pageReqVO.getKeyword())) {
            wrapper.and(w -> w.like(WmsDevanningOrderDO::getDevanningNo, pageReqVO.getKeyword())
                    .or().like(WmsDevanningOrderDO::getContainerNo, pageReqVO.getKeyword())
                    .or().like(WmsDevanningOrderDO::getSourceOrderNo, pageReqVO.getKeyword())
                    .or().like(WmsDevanningOrderDO::getCustomerName, pageReqVO.getKeyword()));
        }
        wrapper.likeIfPresent(WmsDevanningOrderDO::getDevanningNo, pageReqVO.getDevanningNo())
                .likeIfPresent(WmsDevanningOrderDO::getContainerNo, pageReqVO.getContainerNo())
                .eqIfPresent(WmsDevanningOrderDO::getStatus, pageReqVO.getStatus())
                .eqIfPresent(WmsDevanningOrderDO::getWarehouseId, pageReqVO.getWarehouseId())
                .eqIfPresent(WmsDevanningOrderDO::getChannelId, pageReqVO.getChannelId())
                .eqIfPresent(WmsDevanningOrderDO::getCustomerServiceId, pageReqVO.getCustomerServiceId())
                .geIfPresent(WmsDevanningOrderDO::getEtaWarehouseTime, pageReqVO.getEtaBegin())
                .leIfPresent(WmsDevanningOrderDO::getEtaWarehouseTime, pageReqVO.getEtaEnd())
                .geIfPresent(WmsDevanningOrderDO::getActualArrivalTime, pageReqVO.getArrivalBegin())
                .leIfPresent(WmsDevanningOrderDO::getActualArrivalTime, pageReqVO.getArrivalEnd())
                .geIfPresent(WmsDevanningOrderDO::getDevanningFinishTime, pageReqVO.getFinishBegin())
                .leIfPresent(WmsDevanningOrderDO::getDevanningFinishTime, pageReqVO.getFinishEnd());
        return wrapper.orderByDesc(WmsDevanningOrderDO::getCreateTime);
    }

}
