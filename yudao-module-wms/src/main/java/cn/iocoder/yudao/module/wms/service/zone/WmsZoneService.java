package cn.iocoder.yudao.module.wms.service.zone;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.wms.controller.admin.zone.vo.WmsZonePageReqVO;
import cn.iocoder.yudao.module.wms.controller.admin.zone.vo.WmsZoneRespVO;
import cn.iocoder.yudao.module.wms.controller.admin.zone.vo.WmsZoneSaveReqVO;

import java.util.List;

public interface WmsZoneService {

    PageResult<WmsZoneRespVO> getZonePage(WmsZonePageReqVO pageReqVO);

    List<WmsZoneRespVO> getZoneList(WmsZonePageReqVO pageReqVO);

    WmsZoneRespVO getZone(Long id);

    Long createZone(WmsZoneSaveReqVO createReqVO);

    void updateZone(WmsZoneSaveReqVO updateReqVO);

    void changeZoneStatus(Long id, String status);

    void deleteZoneList(List<Long> ids);

}
