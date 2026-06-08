package cn.iocoder.yudao.module.base.service.vas;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.controller.admin.vas.vo.*;

import java.util.List;

public interface ValueAddedServiceService {

    Long createValueAddedService(ValueAddedServiceSaveReqVO createReqVO);

    void updateValueAddedService(ValueAddedServiceSaveReqVO updateReqVO);

    void updateValueAddedServiceStatus(ValueAddedServiceUpdateStatusReqVO reqVO);

    void deleteValueAddedService(Long id);

    ValueAddedServiceRespVO getValueAddedService(Long id);

    PageResult<ValueAddedServiceRespVO> getValueAddedServicePage(ValueAddedServicePageReqVO pageReqVO);

    List<ValueAddedServiceRespVO> getValueAddedServiceSimpleList(Integer status, String serviceCategory);

    List<ValueAddedServiceRespVO> getValueAddedServiceExportList(ValueAddedServicePageReqVO pageReqVO);

}
