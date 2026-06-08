package cn.iocoder.yudao.module.base.service.state;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.controller.admin.state.vo.*;

import java.util.List;

public interface StateProvinceService {

    Long createStateProvince(StateProvinceSaveReqVO createReqVO);

    void updateStateProvince(StateProvinceSaveReqVO updateReqVO);

    void deleteStateProvince(Long id);

    void updateStateProvinceStatus(StateProvinceUpdateStatusReqVO reqVO);

    StateProvinceRespVO getStateProvince(Long id);

    PageResult<StateProvinceRespVO> getStateProvincePage(StateProvincePageReqVO pageReqVO);

    List<StateProvinceRespVO> getStateProvinceSimpleList(String countryCode, Integer status);

    StateProvinceImportRespVO importStateProvinceList(List<StateProvinceImportExcelVO> importList, boolean updateSupport);

}
