package cn.iocoder.yudao.module.base.service.businesstype;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.controller.admin.businesstype.vo.*;

import java.util.List;

public interface BusinessTypeService {

    Long createBusinessType(BusinessTypeSaveReqVO createReqVO);

    void updateBusinessType(BusinessTypeSaveReqVO updateReqVO);

    void updateBusinessTypeStatus(BusinessTypeUpdateStatusReqVO reqVO);

    void deleteBusinessType(Long id);

    BusinessTypeRespVO getBusinessType(Long id);

    PageResult<BusinessTypeRespVO> getBusinessTypePage(BusinessTypePageReqVO pageReqVO);

    List<BusinessTypeRespVO> getBusinessTypeSimpleList(Integer status, String businessCategory, String operationFlowType);

    List<BusinessTypeRespVO> getBusinessTypeExportList(BusinessTypePageReqVO pageReqVO);

}
