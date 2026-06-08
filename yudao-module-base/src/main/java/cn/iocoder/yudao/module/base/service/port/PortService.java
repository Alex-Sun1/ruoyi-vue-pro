package cn.iocoder.yudao.module.base.service.port;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.controller.admin.port.vo.*;

import java.util.List;

public interface PortService {

    Long createPort(PortSaveReqVO createReqVO);

    void updatePort(PortSaveReqVO updateReqVO);

    void updatePortStatus(PortUpdateStatusReqVO reqVO);

    PortRespVO getPort(Long id);

    PageResult<PortRespVO> getPortPage(PortPageReqVO pageReqVO);

    List<PortRespVO> getPortSimpleList(Integer status);

    PortImportRespVO importPortList(List<PortImportExcelVO> importList, boolean updateSupport);

}
