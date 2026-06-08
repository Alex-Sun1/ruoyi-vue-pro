package cn.iocoder.yudao.module.base.service.warehouse;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.controller.admin.warehouse.vo.*;

import java.util.Collection;
import java.util.List;
import java.util.Set;

public interface WarehouseService {

    Long createWarehouse(WarehouseSaveReqVO createReqVO);

    void updateWarehouse(WarehouseSaveReqVO updateReqVO);

    void updateWarehouseStatus(WarehouseUpdateStatusReqVO reqVO);

    void deleteWarehouse(Long id);

    WarehouseRespVO getWarehouse(Long id);

    PageResult<WarehouseRespVO> getWarehousePage(WarehousePageReqVO pageReqVO);

    List<WarehouseRespVO> getWarehouseSimpleList(Integer status);

    List<WarehouseExportExcelVO> getWarehouseExportList(WarehousePageReqVO pageReqVO);

    /**
     * 租户内全部启用仓库 ID
     */
    Set<Long> getEnabledWarehouseIds();

    Set<Long> getEnabledWarehouseIdsByIds(Collection<Long> warehouseIds);

    Set<Long> getEnabledWarehouseIdsByCompanyIds(Collection<Long> companyIds);

}
