package cn.iocoder.yudao.module.base.service.feeitem;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.base.controller.admin.feeitem.vo.*;
import cn.iocoder.yudao.module.base.dal.dataobject.feeitem.FeeItemDO;
import cn.iocoder.yudao.module.base.dal.mysql.feeitem.FeeItemMapper;
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
public class FeeItemServiceImpl implements FeeItemService {

    private static final int IS_SYSTEM_YES = 1;

    @Resource
    private FeeItemMapper feeItemMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createFeeItem(FeeItemSaveReqVO createReqVO) {
        normalizeFields(createReqVO);
        validateUnique(null, createReqVO.getFeeCode());
        if (createReqVO.getStatus() == null) {
            createReqVO.setStatus(CommonStatusEnum.ENABLE.getStatus());
        }
        if (createReqVO.getSortOrder() == null) {
            createReqVO.setSortOrder(0);
        }
        if (createReqVO.getIsBillable() == null) {
            createReqVO.setIsBillable(1);
        }
        FeeItemDO row = BeanUtils.toBean(createReqVO, FeeItemDO.class);
        row.setIsSystem(0);
        feeItemMapper.insert(row);
        return row.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateFeeItem(FeeItemSaveReqVO updateReqVO) {
        FeeItemDO existing = validateExists(updateReqVO.getId());
        normalizeFields(updateReqVO);
        if (!Objects.equals(existing.getFeeCode(), updateReqVO.getFeeCode())) {
            throw exception(FEE_ITEM_CODE_NOT_MODIFIABLE);
        }
        updateReqVO.setFeeCode(existing.getFeeCode());
        FeeItemDO updateObj = BeanUtils.toBean(updateReqVO, FeeItemDO.class);
        updateObj.setStatus(existing.getStatus());
        updateObj.setIsSystem(existing.getIsSystem());
        if (updateReqVO.getSortOrder() == null) {
            updateObj.setSortOrder(existing.getSortOrder());
        }
        feeItemMapper.updateById(updateObj);
    }

    @Override
    public void updateFeeItemStatus(FeeItemUpdateStatusReqVO reqVO) {
        validateExists(reqVO.getId());
        FeeItemDO update = new FeeItemDO();
        update.setId(reqVO.getId());
        update.setStatus(reqVO.getStatus());
        feeItemMapper.updateById(update);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteFeeItem(Long id) {
        FeeItemDO row = validateExists(id);
        if (Objects.equals(row.getIsSystem(), IS_SYSTEM_YES)) {
            throw exception(FEE_ITEM_DELETE_SYSTEM);
        }
        feeItemMapper.deleteById(id);
    }

    @Override
    public FeeItemRespVO getFeeItem(Long id) {
        FeeItemDO row = validateExists(id);
        return BeanUtils.toBean(row, FeeItemRespVO.class);
    }

    @Override
    public PageResult<FeeItemRespVO> getFeeItemPage(FeeItemPageReqVO pageReqVO) {
        PageResult<FeeItemDO> pageResult = feeItemMapper.selectPage(pageReqVO);
        List<FeeItemRespVO> list = pageResult.getList().stream()
                .map(row -> BeanUtils.toBean(row, FeeItemRespVO.class))
                .collect(Collectors.toList());
        return new PageResult<>(list, pageResult.getTotal());
    }

    @Override
    public List<FeeItemRespVO> getFeeItemSimpleList(Integer status, String feeCategory) {
        List<FeeItemDO> list = feeItemMapper.selectSimpleList(status, feeCategory);
        return list.stream()
                .map(row -> BeanUtils.toBean(row, FeeItemRespVO.class))
                .collect(Collectors.toList());
    }

    private void normalizeFields(FeeItemSaveReqVO reqVO) {
        if (reqVO.getFeeCode() != null) {
            reqVO.setFeeCode(reqVO.getFeeCode().trim().toUpperCase());
        }
        if (reqVO.getFeeName() != null) {
            reqVO.setFeeName(reqVO.getFeeName().trim());
        }
        if (reqVO.getFeeCategory() != null) {
            reqVO.setFeeCategory(reqVO.getFeeCategory().trim());
        }
        if (reqVO.getBusinessStage() != null) {
            reqVO.setBusinessStage(reqVO.getBusinessStage().trim());
        }
        if (reqVO.getBusinessType() != null) {
            String businessType = reqVO.getBusinessType().trim();
            reqVO.setBusinessType(StrUtil.isBlank(businessType) ? null : businessType);
        }
        if (reqVO.getDescription() != null) {
            reqVO.setDescription(reqVO.getDescription().trim());
        }
        if (reqVO.getRemark() != null) {
            reqVO.setRemark(reqVO.getRemark().trim());
        }
    }

    private FeeItemDO validateExists(Long id) {
        FeeItemDO row = feeItemMapper.selectById(id);
        if (row == null) {
            throw exception(FEE_ITEM_NOT_EXISTS);
        }
        return row;
    }

    private void validateUnique(Long id, String feeCode) {
        FeeItemDO exist = feeItemMapper.selectByUnique(feeCode);
        if (exist != null && (id == null || !exist.getId().equals(id))) {
            throw exception(FEE_ITEM_DUPLICATE);
        }
    }

}
