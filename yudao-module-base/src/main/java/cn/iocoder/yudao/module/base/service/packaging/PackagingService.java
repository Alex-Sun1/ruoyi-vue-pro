package cn.iocoder.yudao.module.base.service.packaging;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.controller.admin.packaging.vo.*;

import java.util.List;

public interface PackagingService {

    Long createPackaging(PackagingSaveReqVO createReqVO);

    void updatePackaging(PackagingSaveReqVO updateReqVO);

    void updatePackagingStatus(PackagingUpdateStatusReqVO reqVO);

    void deletePackaging(Long id);

    PackagingRespVO getPackaging(Long id);

    PageResult<PackagingRespVO> getPackagingPage(PackagingPageReqVO pageReqVO);

    List<PackagingRespVO> getPackagingSimpleList(Integer status);

    PackagingImportRespVO importPackagingList(List<PackagingImportExcelVO> importList, boolean updateSupport);

    List<PackagingExportExcelVO> getPackagingExportList(PackagingPageReqVO pageReqVO);

}
