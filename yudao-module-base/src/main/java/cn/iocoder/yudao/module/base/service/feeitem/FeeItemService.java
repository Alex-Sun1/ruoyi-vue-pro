package cn.iocoder.yudao.module.base.service.feeitem;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.controller.admin.feeitem.vo.*;

import java.util.List;

public interface FeeItemService {

    Long createFeeItem(FeeItemSaveReqVO createReqVO);

    void updateFeeItem(FeeItemSaveReqVO updateReqVO);

    void updateFeeItemStatus(FeeItemUpdateStatusReqVO reqVO);

    void deleteFeeItem(Long id);

    FeeItemRespVO getFeeItem(Long id);

    PageResult<FeeItemRespVO> getFeeItemPage(FeeItemPageReqVO pageReqVO);

    List<FeeItemRespVO> getFeeItemSimpleList(Integer status, String feeCategory);

}
