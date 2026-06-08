package cn.iocoder.yudao.module.base.service.vas;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.base.controller.admin.vas.vo.*;
import cn.iocoder.yudao.module.base.dal.dataobject.vas.ValueAddedServiceDO;
import cn.iocoder.yudao.module.base.dal.mysql.vas.ValueAddedServiceMapper;
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
public class ValueAddedServiceServiceImpl implements ValueAddedServiceService {

    @Resource
    private ValueAddedServiceMapper valueAddedServiceMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createValueAddedService(ValueAddedServiceSaveReqVO createReqVO) {
        normalize(createReqVO);
        validateUnique(null, createReqVO.getServiceCode());
        fillDefaults(createReqVO);
        ValueAddedServiceDO row = BeanUtils.toBean(createReqVO, ValueAddedServiceDO.class);
        valueAddedServiceMapper.insert(row);
        return row.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateValueAddedService(ValueAddedServiceSaveReqVO updateReqVO) {
        ValueAddedServiceDO existing = validateExists(updateReqVO.getId());
        normalize(updateReqVO);
        if (!Objects.equals(existing.getServiceCode(), updateReqVO.getServiceCode())) {
            throw exception(VAS_CODE_NOT_MODIFIABLE);
        }
        fillDefaults(updateReqVO);
        ValueAddedServiceDO update = BeanUtils.toBean(updateReqVO, ValueAddedServiceDO.class);
        update.setStatus(existing.getStatus());
        valueAddedServiceMapper.updateById(update);
    }

    @Override
    public void updateValueAddedServiceStatus(ValueAddedServiceUpdateStatusReqVO reqVO) {
        validateExists(reqVO.getId());
        ValueAddedServiceDO update = new ValueAddedServiceDO();
        update.setId(reqVO.getId());
        update.setStatus(reqVO.getStatus());
        valueAddedServiceMapper.updateById(update);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteValueAddedService(Long id) {
        ValueAddedServiceDO row = validateExists(id);
        if (CommonStatusEnum.ENABLE.getStatus().equals(row.getStatus())) {
            throw exception(VAS_DELETE_ENABLED);
        }
        valueAddedServiceMapper.deleteById(id);
    }

    @Override
    public ValueAddedServiceRespVO getValueAddedService(Long id) {
        return BeanUtils.toBean(validateExists(id), ValueAddedServiceRespVO.class);
    }

    @Override
    public PageResult<ValueAddedServiceRespVO> getValueAddedServicePage(ValueAddedServicePageReqVO pageReqVO) {
        return BeanUtils.toBean(valueAddedServiceMapper.selectPage(pageReqVO), ValueAddedServiceRespVO.class);
    }

    @Override
    public List<ValueAddedServiceRespVO> getValueAddedServiceSimpleList(Integer status, String serviceCategory) {
        return BeanUtils.toBean(valueAddedServiceMapper.selectSimpleList(status, serviceCategory),
                ValueAddedServiceRespVO.class);
    }

    @Override
    public List<ValueAddedServiceRespVO> getValueAddedServiceExportList(ValueAddedServicePageReqVO pageReqVO) {
        pageReqVO.setPageSize(-1);
        return getValueAddedServicePage(pageReqVO).getList();
    }

    private ValueAddedServiceDO validateExists(Long id) {
        ValueAddedServiceDO row = valueAddedServiceMapper.selectById(id);
        if (row == null) {
            throw exception(VAS_NOT_EXISTS);
        }
        return row;
    }

    private void validateUnique(Long id, String code) {
        ValueAddedServiceDO exist = valueAddedServiceMapper.selectByUnique(code);
        if (exist != null && (id == null || !exist.getId().equals(id))) {
            throw exception(VAS_DUPLICATE);
        }
    }

    private void fillDefaults(ValueAddedServiceSaveReqVO reqVO) {
        if (reqVO.getStatus() == null) reqVO.setStatus(CommonStatusEnum.ENABLE.getStatus());
        if (reqVO.getPriority() == null) reqVO.setPriority(0);
        if (reqVO.getSortOrder() == null) reqVO.setSortOrder(0);
        if (reqVO.getChargeableFlag() == null) reqVO.setChargeableFlag(true);
        if (reqVO.getOperationRequired() == null) reqVO.setOperationRequired(false);
        if (reqVO.getPdaOperationFlag() == null) reqVO.setPdaOperationFlag(false);
        if (reqVO.getPhotoRequired() == null) reqVO.setPhotoRequired(false);
        if (reqVO.getQcRequired() == null) reqVO.setQcRequired(false);
        if (reqVO.getSupportBatchOperation() == null) reqVO.setSupportBatchOperation(false);
        if (reqVO.getDefaultSelected() == null) reqVO.setDefaultSelected(false);
    }

    private void normalize(ValueAddedServiceSaveReqVO reqVO) {
        if (reqVO.getServiceCode() != null) reqVO.setServiceCode(reqVO.getServiceCode().trim().toUpperCase());
        if (reqVO.getServiceName() != null) reqVO.setServiceName(reqVO.getServiceName().trim());
        if (reqVO.getServiceCategory() != null) reqVO.setServiceCategory(reqVO.getServiceCategory().trim().toUpperCase());
        if (reqVO.getBillingMode() != null) reqVO.setBillingMode(StrUtil.blankToDefault(reqVO.getBillingMode().trim().toUpperCase(), null));
    }

}
