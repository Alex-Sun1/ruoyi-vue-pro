package cn.iocoder.yudao.module.base.service.city;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.controller.admin.city.vo.*;

import java.util.List;

public interface CityService {

    Long createCity(CitySaveReqVO createReqVO);

    void updateCity(CitySaveReqVO updateReqVO);

    void deleteCity(Long id);

    void updateCityStatus(CityUpdateStatusReqVO reqVO);

    CityRespVO getCity(Long id);

    PageResult<CityRespVO> getCityPage(CityPageReqVO pageReqVO);

    List<CityRespVO> getCitySimpleList(String countryCode, String stateCode, Integer status);

    CityImportRespVO importCityList(List<CityImportExcelVO> importList, boolean updateSupport);

}
