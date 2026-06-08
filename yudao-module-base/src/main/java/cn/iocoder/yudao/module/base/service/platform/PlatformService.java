package cn.iocoder.yudao.module.base.service.platform;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.controller.admin.platform.vo.*;

import java.util.List;

public interface PlatformService {

    Long createPlatform(PlatformSaveReqVO createReqVO);

    void updatePlatform(PlatformSaveReqVO updateReqVO);

    void updatePlatformStatus(PlatformUpdateStatusReqVO reqVO);

    PlatformRespVO getPlatform(Long id);

    PageResult<PlatformRespVO> getPlatformPage(PlatformPageReqVO pageReqVO);

    List<PlatformRespVO> getPlatformSimpleList(Integer status);

}
