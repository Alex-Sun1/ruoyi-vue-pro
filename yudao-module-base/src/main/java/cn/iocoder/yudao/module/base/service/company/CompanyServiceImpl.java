package cn.iocoder.yudao.module.base.service.company;

import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.base.controller.admin.company.vo.*;
import cn.iocoder.yudao.module.base.dal.dataobject.company.CompanyDO;
import cn.iocoder.yudao.module.base.dal.mysql.company.CompanyMapper;
import cn.iocoder.yudao.module.base.dal.mysql.warehouse.BaseWarehouseMapper;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.base.enums.ErrorCodeConstants.*;

@Service
@Validated
public class CompanyServiceImpl implements CompanyService {

    @Resource
    private CompanyMapper companyMapper;
    @Resource
    private BaseWarehouseMapper baseWarehouseMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createCompany(CompanySaveReqVO createReqVO) {
        normalizeFields(createReqVO);
        validateUnique(null, createReqVO.getCompanyCode());
        if (createReqVO.getStatus() == null) {
            createReqVO.setStatus(CommonStatusEnum.ENABLE.getStatus());
        }
        CompanyDO row = BeanUtils.toBean(createReqVO, CompanyDO.class);
        companyMapper.insert(row);
        return row.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateCompany(CompanySaveReqVO updateReqVO) {
        CompanyDO existing = validateExists(updateReqVO.getId());
        normalizeFields(updateReqVO);
        if (!Objects.equals(existing.getCompanyCode(), updateReqVO.getCompanyCode())) {
            throw exception(COMPANY_CODE_NOT_MODIFIABLE);
        }
        updateReqVO.setCompanyCode(existing.getCompanyCode());
        CompanyDO updateObj = BeanUtils.toBean(updateReqVO, CompanyDO.class);
        updateObj.setStatus(existing.getStatus());
        companyMapper.updateById(updateObj);
    }

    @Override
    public void updateCompanyStatus(CompanyUpdateStatusReqVO reqVO) {
        validateExists(reqVO.getId());
        CompanyDO update = new CompanyDO();
        update.setId(reqVO.getId());
        update.setStatus(reqVO.getStatus());
        companyMapper.updateById(update);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteCompany(Long id) {
        validateExists(id);
        if (baseWarehouseMapper.selectCountByCompanyId(id) > 0) {
            throw exception(COMPANY_DELETE_HAS_WAREHOUSE);
        }
        companyMapper.deleteById(id);
    }

    @Override
    public CompanyRespVO getCompany(Long id) {
        CompanyDO row = validateExists(id);
        return BeanUtils.toBean(row, CompanyRespVO.class);
    }

    @Override
    public PageResult<CompanyRespVO> getCompanyPage(CompanyPageReqVO pageReqVO) {
        PageResult<CompanyDO> pageResult = companyMapper.selectPage(pageReqVO);
        List<CompanyRespVO> list = pageResult.getList().stream()
                .map(row -> BeanUtils.toBean(row, CompanyRespVO.class))
                .collect(Collectors.toList());
        return new PageResult<>(list, pageResult.getTotal());
    }

    @Override
    public List<CompanyRespVO> getCompanySimpleList(Integer status) {
        List<CompanyDO> list = companyMapper.selectSimpleList(status);
        return BeanUtils.toBean(list, CompanyRespVO.class);
    }

    @Override
    public List<CompanyExportExcelVO> getCompanyExportList(CompanyPageReqVO pageReqVO) {
        pageReqVO.setPageSize(PageParam.PAGE_SIZE_NONE);
        return getCompanyPage(pageReqVO).getList().stream()
                .map(row -> BeanUtils.toBean(row, CompanyExportExcelVO.class))
                .collect(Collectors.toList());
    }

    private void normalizeFields(CompanySaveReqVO reqVO) {
        if (reqVO.getCompanyCode() != null) {
            reqVO.setCompanyCode(reqVO.getCompanyCode().trim().toUpperCase());
        }
        if (reqVO.getCompanyName() != null) {
            reqVO.setCompanyName(reqVO.getCompanyName().trim());
        }
        if (reqVO.getCompanyNameEn() != null) {
            reqVO.setCompanyNameEn(reqVO.getCompanyNameEn().trim());
        }
        if (reqVO.getTaxNo() != null) {
            reqVO.setTaxNo(reqVO.getTaxNo().trim());
        }
        if (reqVO.getRemark() != null) {
            reqVO.setRemark(reqVO.getRemark().trim());
        }
        if (reqVO.getCountryCode() != null) {
            reqVO.setCountryCode(reqVO.getCountryCode().trim().toUpperCase());
        }
        if (reqVO.getCurrencyCode() != null) {
            reqVO.setCurrencyCode(reqVO.getCurrencyCode().trim().toUpperCase());
        }
        if (reqVO.getTimezone() != null) {
            reqVO.setTimezone(reqVO.getTimezone().trim());
        }
    }

    private CompanyDO validateExists(Long id) {
        CompanyDO row = companyMapper.selectById(id);
        if (row == null) {
            throw exception(COMPANY_NOT_EXISTS);
        }
        return row;
    }

    private void validateUnique(Long id, String companyCode) {
        CompanyDO exist = companyMapper.selectByUnique(companyCode);
        if (exist != null && (id == null || !exist.getId().equals(id))) {
            throw exception(COMPANY_DUPLICATE);
        }
    }

}
