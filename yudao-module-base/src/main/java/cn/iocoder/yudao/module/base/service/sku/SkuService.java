package cn.iocoder.yudao.module.base.service.sku;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.controller.admin.sku.vo.*;

import java.util.List;

public interface SkuService {

    Long createSku(SkuSaveReqVO createReqVO);

    void updateSku(SkuSaveReqVO updateReqVO);

    void updateSkuStatus(SkuUpdateStatusReqVO reqVO);

    void deleteSku(Long id);

    SkuRespVO getSku(Long id);

    PageResult<SkuRespVO> getSkuPage(SkuPageReqVO pageReqVO);

    List<SkuRespVO> getSkuSimpleList(Long clientId, Integer status);

    SkuImportRespVO importSkuList(List<SkuImportExcelVO> importList, boolean updateSupport);

    List<SkuExportExcelVO> getSkuExportList(SkuPageReqVO pageReqVO);

}
