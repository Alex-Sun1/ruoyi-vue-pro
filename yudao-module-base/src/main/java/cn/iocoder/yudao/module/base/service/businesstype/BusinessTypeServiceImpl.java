package cn.iocoder.yudao.module.base.service.businesstype;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.base.controller.admin.businesstype.vo.*;
import cn.iocoder.yudao.module.base.dal.dataobject.businesstype.BusinessTypeDO;
import cn.iocoder.yudao.module.base.dal.mysql.businesstype.BusinessTypeMapper;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import java.util.List;
import java.util.Objects;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.base.enums.ErrorCodeConstants.*;

@Service
@Validated
public class BusinessTypeServiceImpl implements BusinessTypeService {

    @Resource
    private BusinessTypeMapper businessTypeMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createBusinessType(BusinessTypeSaveReqVO createReqVO) {
        normalize(createReqVO);
        validateSorting(createReqVO);
        validateUnique(null, createReqVO.getBusinessTypeCode());
        fillDefaults(createReqVO);
        BusinessTypeDO row = BeanUtils.toBean(createReqVO, BusinessTypeDO.class);
        businessTypeMapper.insert(row);
        return row.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateBusinessType(BusinessTypeSaveReqVO updateReqVO) {
        BusinessTypeDO existing = validateExists(updateReqVO.getId());
        normalize(updateReqVO);
        validateSorting(updateReqVO);
        if (!Objects.equals(existing.getBusinessTypeCode(), updateReqVO.getBusinessTypeCode())) {
            throw exception(BUSINESS_TYPE_CODE_NOT_MODIFIABLE);
        }
        fillDefaults(updateReqVO);
        BusinessTypeDO update = BeanUtils.toBean(updateReqVO, BusinessTypeDO.class);
        update.setStatus(existing.getStatus());
        businessTypeMapper.updateById(update);
    }

    @Override
    public void updateBusinessTypeStatus(BusinessTypeUpdateStatusReqVO reqVO) {
        validateExists(reqVO.getId());
        BusinessTypeDO update = new BusinessTypeDO();
        update.setId(reqVO.getId());
        update.setStatus(reqVO.getStatus());
        businessTypeMapper.updateById(update);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteBusinessType(Long id) {
        BusinessTypeDO row = validateExists(id);
        if (CommonStatusEnum.ENABLE.getStatus().equals(row.getStatus())) {
            throw exception(BUSINESS_TYPE_DELETE_ENABLED);
        }
        businessTypeMapper.deleteById(id);
    }

    @Override
    public BusinessTypeRespVO getBusinessType(Long id) {
        return BeanUtils.toBean(validateExists(id), BusinessTypeRespVO.class);
    }

    @Override
    public PageResult<BusinessTypeRespVO> getBusinessTypePage(BusinessTypePageReqVO pageReqVO) {
        return BeanUtils.toBean(businessTypeMapper.selectPage(pageReqVO), BusinessTypeRespVO.class);
    }

    @Override
    public List<BusinessTypeRespVO> getBusinessTypeSimpleList(Integer status, String businessCategory, String operationFlowType) {
        return BeanUtils.toBean(businessTypeMapper.selectSimpleList(status, businessCategory, operationFlowType),
                BusinessTypeRespVO.class);
    }

    @Override
    public List<BusinessTypeRespVO> getBusinessTypeExportList(BusinessTypePageReqVO pageReqVO) {
        pageReqVO.setPageSize(-1);
        return getBusinessTypePage(pageReqVO).getList();
    }

    private BusinessTypeDO validateExists(Long id) {
        BusinessTypeDO row = businessTypeMapper.selectById(id);
        if (row == null) {
            throw exception(BUSINESS_TYPE_NOT_EXISTS);
        }
        return row;
    }

    private void validateUnique(Long id, String code) {
        BusinessTypeDO exist = businessTypeMapper.selectByUnique(code);
        if (exist != null && (id == null || !exist.getId().equals(id))) {
            throw exception(BUSINESS_TYPE_DUPLICATE);
        }
    }

    private void validateSorting(BusinessTypeSaveReqVO reqVO) {
        if ("FIELD_BASED".equalsIgnoreCase(reqVO.getSortingStrategy()) && StrUtil.isBlank(reqVO.getSortingField())) {
            throw exception(BUSINESS_TYPE_SORTING_FIELD_REQUIRED);
        }
    }

    private void fillDefaults(BusinessTypeSaveReqVO reqVO) {
        if (reqVO.getStatus() == null) {
            reqVO.setStatus(CommonStatusEnum.ENABLE.getStatus());
        }
        if (reqVO.getSortOrder() == null) {
            reqVO.setSortOrder(0);
        }
        if (reqVO.getReceiveRequired() == null) reqVO.setReceiveRequired(false);
        if (reqVO.getInboundRequired() == null) reqVO.setInboundRequired(false);
        if (reqVO.getPutawayRequired() == null) reqVO.setPutawayRequired(false);
        if (reqVO.getStorageRequired() == null) reqVO.setStorageRequired(false);
        if (reqVO.getPickingRequired() == null) reqVO.setPickingRequired(false);
        if (reqVO.getOutboundRequired() == null) reqVO.setOutboundRequired(false);
        if (reqVO.getDeliveryRequired() == null) reqVO.setDeliveryRequired(false);
        if (reqVO.getAppointmentRequired() == null) reqVO.setAppointmentRequired(false);
        if (reqVO.getVasSupported() == null) reqVO.setVasSupported(false);
    }

    private void normalize(BusinessTypeSaveReqVO reqVO) {
        if (reqVO.getBusinessTypeCode() != null) reqVO.setBusinessTypeCode(reqVO.getBusinessTypeCode().trim().toUpperCase());
        if (reqVO.getBusinessTypeName() != null) reqVO.setBusinessTypeName(reqVO.getBusinessTypeName().trim());
        if (reqVO.getBusinessCategory() != null) reqVO.setBusinessCategory(reqVO.getBusinessCategory().trim().toUpperCase());
        if (reqVO.getOperationFlowType() != null) reqVO.setOperationFlowType(reqVO.getOperationFlowType().trim().toUpperCase());
        if (reqVO.getSortingStrategy() != null) reqVO.setSortingStrategy(reqVO.getSortingStrategy().trim().toUpperCase());
        if (reqVO.getSortingField() != null) reqVO.setSortingField(StrUtil.blankToDefault(reqVO.getSortingField().trim(), null));
    }

}
