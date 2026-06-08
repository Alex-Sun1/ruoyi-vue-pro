package cn.iocoder.yudao.module.wms.service.location;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.wms.controller.admin.location.vo.WmsLocationBatchStatusReqVO;
import cn.iocoder.yudao.module.wms.controller.admin.location.vo.WmsLocationImportExcelVO;
import cn.iocoder.yudao.module.wms.controller.admin.location.vo.WmsLocationPageReqVO;
import cn.iocoder.yudao.module.wms.controller.admin.location.vo.WmsLocationRespVO;
import cn.iocoder.yudao.module.wms.controller.admin.location.vo.WmsLocationSaveReqVO;

import java.util.List;

public interface WmsLocationService {

    PageResult<WmsLocationRespVO> getLocationPage(WmsLocationPageReqVO pageReqVO);

    List<WmsLocationRespVO> getLocationList(WmsLocationPageReqVO pageReqVO);

    WmsLocationRespVO getLocation(Long id);

    Long createLocation(WmsLocationSaveReqVO createReqVO);

    void updateLocation(WmsLocationSaveReqVO updateReqVO);

    void changeLocationStatus(WmsLocationBatchStatusReqVO reqVO);

    void deleteLocationList(List<Long> ids);

    String importLocationData(List<WmsLocationImportExcelVO> list, Long warehouseId, Long companyId);

}
