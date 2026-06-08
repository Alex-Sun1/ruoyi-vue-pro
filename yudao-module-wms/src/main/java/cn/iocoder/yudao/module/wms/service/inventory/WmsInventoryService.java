package cn.iocoder.yudao.module.wms.service.inventory;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.wms.controller.admin.inventory.vo.*;

import java.util.List;

public interface WmsInventoryService {

    PageResult<WmsInventoryRespVO> getInventoryPage(WmsInventoryPageReqVO pageReqVO);

    WmsInventoryRespVO getInventory(Long id);

    WmsInventoryStatsRespVO getInventoryStats(WmsInventoryPageReqVO pageReqVO);

    PageResult<WmsPalletRespVO> getPalletPage(WmsPalletPageReqVO pageReqVO);

    List<WmsPalletItemRespVO> getPalletItems(Long palletId);

    void movePalletLocation(WmsPalletMoveReqVO reqVO);

    void outboundPallet(WmsPalletOutboundReqVO reqVO);

    PageResult<WmsInventoryLockRespVO> getLockPage(WmsInventoryLockPageReqVO pageReqVO);

    PageResult<WmsInventoryTransactionRespVO> getTransactionPage(WmsInventoryTransactionPageReqVO pageReqVO);

    void receive(WmsInventoryReceiveReqVO reqVO);

    void lock(WmsInventoryLockReqVO reqVO);

    void adjust(WmsInventoryAdjustReqVO reqVO);

    WmsInventoryVisualizationRespVO getVisualization(WmsInventoryVisualizationReqVO reqVO);

}
