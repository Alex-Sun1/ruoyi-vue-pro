package cn.iocoder.yudao.module.base.service.vessel;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.controller.admin.vessel.vo.*;

import java.util.List;

public interface VesselService {

    Long createVessel(VesselSaveReqVO createReqVO);

    void updateVessel(VesselSaveReqVO updateReqVO);

    void updateVesselStatus(VesselUpdateStatusReqVO reqVO);

    void deleteVessel(Long id);

    VesselRespVO getVessel(Long id);

    PageResult<VesselRespVO> getVesselPage(VesselPageReqVO pageReqVO);

    List<VesselRespVO> getVesselOptions(VesselPageReqVO reqVO);

    List<VesselRespVO> getVesselExportList(VesselPageReqVO pageReqVO);

}
