package cn.iocoder.yudao.module.base.service.zipcode;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.controller.admin.zipcode.vo.*;

import java.util.List;

public interface ZipCodeService {

    Long createZipCode(ZipCodeSaveReqVO createReqVO);

    void updateZipCode(ZipCodeSaveReqVO updateReqVO);

    void deleteZipCode(Long id);

    ZipCodeRespVO getZipCode(Long id);

    PageResult<ZipCodeRespVO> getZipCodePage(ZipCodePageReqVO pageReqVO);

    List<ZipCodeRespVO> getZipCodeSimpleList(String countryCode, String zip);

    /**
     * 邮编补全；无匹配时返回空对象字段，不抛业务异常
     */
    ZipCodeLookupRespVO lookupZipCode(String countryCode, String zip);

    ZipCodeImportRespVO importZipCodeList(List<ZipCodeImportExcelVO> importList, boolean updateSupport);

}
