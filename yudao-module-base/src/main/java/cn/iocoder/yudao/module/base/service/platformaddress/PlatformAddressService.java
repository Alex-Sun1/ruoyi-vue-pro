package cn.iocoder.yudao.module.base.service.platformaddress;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.controller.admin.platformaddress.vo.*;

import java.util.List;

public interface PlatformAddressService {

    Long createPlatformAddress(PlatformAddressSaveReqVO createReqVO);

    void updatePlatformAddress(PlatformAddressSaveReqVO updateReqVO);

    void updatePlatformAddressStatus(PlatformAddressUpdateStatusReqVO reqVO);

    PlatformAddressRespVO getPlatformAddress(Long id);

    PageResult<PlatformAddressRespVO> getPlatformAddressPage(PlatformAddressPageReqVO pageReqVO);

    List<PlatformAddressRespVO> getPlatformAddressSimpleList(Long platformId, String platformCode, Integer status);

    List<PlatformAddressChangeLogRespVO> getPlatformAddressChangeLog(Long platformAddressId);

    PlatformAddressImportRespVO importPlatformAddressList(List<PlatformAddressImportExcelVO> importList,
                                                          boolean updateSupport);

}
