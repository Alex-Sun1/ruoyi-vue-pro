package cn.iocoder.yudao.module.base.service.company;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.controller.admin.company.vo.*;

import java.util.List;

public interface CompanyService {

    Long createCompany(CompanySaveReqVO createReqVO);

    void updateCompany(CompanySaveReqVO updateReqVO);

    void updateCompanyStatus(CompanyUpdateStatusReqVO reqVO);

    void deleteCompany(Long id);

    CompanyRespVO getCompany(Long id);

    PageResult<CompanyRespVO> getCompanyPage(CompanyPageReqVO pageReqVO);

    List<CompanyRespVO> getCompanySimpleList(Integer status);

    List<CompanyExportExcelVO> getCompanyExportList(CompanyPageReqVO pageReqVO);

}
