package cn.iocoder.yudao.module.base.service.country;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.controller.admin.country.vo.*;

import java.util.List;

public interface CountryService {

    Long createCountry(CountrySaveReqVO createReqVO);

    void updateCountry(CountrySaveReqVO updateReqVO);

    void deleteCountry(Long id);

    void updateCountryActive(CountryUpdateActiveReqVO reqVO);

    CountryRespVO getCountry(Long id);

    PageResult<CountryRespVO> getCountryPage(CountryPageReqVO pageReqVO);

    List<CountryRespVO> getCountrySimpleList(Integer isActive);

    CountryImportRespVO importCountryList(List<CountryImportExcelVO> importList, boolean updateSupport);

}
