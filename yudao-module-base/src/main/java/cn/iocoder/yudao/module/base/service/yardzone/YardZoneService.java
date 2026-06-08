package cn.iocoder.yudao.module.base.service.yardzone;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.controller.admin.yardzone.vo.*;

import java.util.List;

public interface YardZoneService {

    Long createYardZone(YardZoneSaveReqVO createReqVO);

    void updateYardZone(YardZoneSaveReqVO updateReqVO);

    void deleteYardZone(Long id);

    YardZoneRespVO getYardZone(Long id);

    PageResult<YardZoneRespVO> getYardZonePage(YardZonePageReqVO pageReqVO);

    List<YardZoneRespVO> getYardZoneListByWarehouse(Long warehouseId);

}
