package cn.iocoder.yudao.module.base.service.yarddock;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.controller.admin.yarddock.vo.*;

import java.util.List;

public interface YardDockService {

    Long createYardDock(YardDockSaveReqVO createReqVO);

    void updateYardDock(YardDockSaveReqVO updateReqVO);

    void deleteYardDock(Long id);

    YardDockRespVO getYardDock(Long id);

    PageResult<YardDockRespVO> getYardDockPage(YardDockPageReqVO pageReqVO);

    List<YardDockRespVO> getYardDockFreeList(Long warehouseId);

    List<YardDockRespVO> getYardDockExportList(YardDockPageReqVO pageReqVO);

}
