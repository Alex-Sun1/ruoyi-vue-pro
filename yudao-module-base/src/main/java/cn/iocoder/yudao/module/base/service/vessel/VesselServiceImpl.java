package cn.iocoder.yudao.module.base.service.vessel;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.base.controller.admin.vessel.vo.*;
import cn.iocoder.yudao.module.base.dal.dataobject.shippingline.ShippingLineDO;
import cn.iocoder.yudao.module.base.dal.dataobject.vessel.VesselDO;
import cn.iocoder.yudao.module.base.dal.mysql.shippingline.ShippingLineMapper;
import cn.iocoder.yudao.module.base.dal.mysql.vessel.VesselMapper;
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
public class VesselServiceImpl implements VesselService {

    private static final String DEFAULT_VESSEL_TYPE = "CONTAINER";

    @Resource
    private VesselMapper vesselMapper;
    @Resource
    private ShippingLineMapper shippingLineMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createVessel(VesselSaveReqVO createReqVO) {
        normalize(createReqVO);
        validateUnique(null, createReqVO.getVesselCode());
        if (createReqVO.getStatus() == null) {
            createReqVO.setStatus(CommonStatusEnum.ENABLE.getStatus());
        }
        if (StrUtil.isBlank(createReqVO.getVesselType())) {
            createReqVO.setVesselType(DEFAULT_VESSEL_TYPE);
        }
        VesselDO row = BeanUtils.toBean(createReqVO, VesselDO.class);
        fillSnapshots(row);
        vesselMapper.insert(row);
        return row.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateVessel(VesselSaveReqVO updateReqVO) {
        VesselDO existing = validateExists(updateReqVO.getId());
        normalize(updateReqVO);
        if (!Objects.equals(existing.getVesselCode(), updateReqVO.getVesselCode())) {
            throw exception(VESSEL_CODE_NOT_MODIFIABLE);
        }
        updateReqVO.setVesselCode(existing.getVesselCode());
        VesselDO update = BeanUtils.toBean(updateReqVO, VesselDO.class);
        fillSnapshots(update);
        update.setStatus(existing.getStatus());
        vesselMapper.updateById(update);
    }

    @Override
    public void updateVesselStatus(VesselUpdateStatusReqVO reqVO) {
        validateExists(reqVO.getId());
        if (!CommonStatusEnum.ENABLE.getStatus().equals(reqVO.getStatus())
                && !CommonStatusEnum.DISABLE.getStatus().equals(reqVO.getStatus())) {
            throw exception(VESSEL_STATUS_INVALID);
        }
        VesselDO update = new VesselDO();
        update.setId(reqVO.getId());
        update.setStatus(reqVO.getStatus());
        vesselMapper.updateById(update);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteVessel(Long id) {
        VesselDO row = validateExists(id);
        if (CommonStatusEnum.ENABLE.getStatus().equals(row.getStatus())) {
            throw exception(VESSEL_DELETE_ENABLED);
        }
        vesselMapper.deleteById(id);
    }

    @Override
    public VesselRespVO getVessel(Long id) {
        return BeanUtils.toBean(validateExists(id), VesselRespVO.class);
    }

    @Override
    public PageResult<VesselRespVO> getVesselPage(VesselPageReqVO pageReqVO) {
        return BeanUtils.toBean(vesselMapper.selectPage(pageReqVO), VesselRespVO.class);
    }

    @Override
    public List<VesselRespVO> getVesselOptions(VesselPageReqVO reqVO) {
        reqVO.setStatus(CommonStatusEnum.ENABLE.getStatus());
        return BeanUtils.toBean(vesselMapper.selectOptionList(reqVO), VesselRespVO.class);
    }

    @Override
    public List<VesselRespVO> getVesselExportList(VesselPageReqVO pageReqVO) {
        pageReqVO.setPageSize(-1);
        return getVesselPage(pageReqVO).getList();
    }

    private void fillSnapshots(VesselDO vessel) {
        if (vessel.getShippingLineId() == null) {
            return;
        }
        ShippingLineDO line = shippingLineMapper.selectById(vessel.getShippingLineId());
        if (line == null) {
            throw exception(VESSEL_SHIPPING_LINE_NOT_EXISTS);
        }
        vessel.setShippingLineCode(line.getCode());
        vessel.setShippingLineName(StrUtil.isNotBlank(line.getNameAbbr()) ? line.getNameAbbr() : line.getNameEn());
    }

    private VesselDO validateExists(Long id) {
        VesselDO row = vesselMapper.selectById(id);
        if (row == null) {
            throw exception(VESSEL_NOT_EXISTS);
        }
        return row;
    }

    private void validateUnique(Long id, String vesselCode) {
        VesselDO exist = vesselMapper.selectByUnique(vesselCode);
        if (exist != null && (id == null || !exist.getId().equals(id))) {
            throw exception(VESSEL_DUPLICATE);
        }
    }

    private void normalize(VesselSaveReqVO reqVO) {
        if (reqVO.getVesselCode() != null) {
            reqVO.setVesselCode(reqVO.getVesselCode().trim().toUpperCase());
        }
        if (reqVO.getVesselName() != null) {
            reqVO.setVesselName(reqVO.getVesselName().trim());
        }
        if (reqVO.getVesselNameEn() != null) {
            reqVO.setVesselNameEn(reqVO.getVesselNameEn().trim());
        }
        if (reqVO.getVesselType() != null) {
            reqVO.setVesselType(reqVO.getVesselType().trim().toUpperCase());
        }
    }

}
