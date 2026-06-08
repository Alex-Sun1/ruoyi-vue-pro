package cn.iocoder.yudao.module.base.service.yardzone;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.base.controller.admin.yardzone.vo.*;
import cn.iocoder.yudao.module.base.dal.dataobject.yardzone.YardZoneDO;
import cn.iocoder.yudao.module.base.dal.mysql.yardzone.YardZoneMapper;
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
public class YardZoneServiceImpl implements YardZoneService {

    @Resource
    private YardZoneMapper yardZoneMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createYardZone(YardZoneSaveReqVO createReqVO) {
        normalize(createReqVO);
        validateUnique(null, createReqVO.getZoneCode());
        YardZoneDO row = BeanUtils.toBean(createReqVO, YardZoneDO.class);
        yardZoneMapper.insert(row);
        return row.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateYardZone(YardZoneSaveReqVO updateReqVO) {
        YardZoneDO existing = validateExists(updateReqVO.getId());
        normalize(updateReqVO);
        if (!Objects.equals(existing.getZoneCode(), updateReqVO.getZoneCode())) {
            throw exception(YARD_ZONE_CODE_NOT_MODIFIABLE);
        }
        updateReqVO.setZoneCode(existing.getZoneCode());
        YardZoneDO update = BeanUtils.toBean(updateReqVO, YardZoneDO.class);
        yardZoneMapper.updateById(update);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteYardZone(Long id) {
        validateExists(id);
        yardZoneMapper.deleteById(id);
    }

    @Override
    public YardZoneRespVO getYardZone(Long id) {
        return BeanUtils.toBean(validateExists(id), YardZoneRespVO.class);
    }

    @Override
    public PageResult<YardZoneRespVO> getYardZonePage(YardZonePageReqVO pageReqVO) {
        return BeanUtils.toBean(yardZoneMapper.selectPage(pageReqVO), YardZoneRespVO.class);
    }

    @Override
    public List<YardZoneRespVO> getYardZoneListByWarehouse(Long warehouseId) {
        return BeanUtils.toBean(yardZoneMapper.selectListByWarehouseId(warehouseId), YardZoneRespVO.class);
    }

    private YardZoneDO validateExists(Long id) {
        YardZoneDO row = yardZoneMapper.selectById(id);
        if (row == null) {
            throw exception(YARD_ZONE_NOT_EXISTS);
        }
        return row;
    }

    private void validateUnique(Long id, String zoneCode) {
        YardZoneDO exist = yardZoneMapper.selectByUnique(zoneCode);
        if (exist != null && (id == null || !exist.getId().equals(id))) {
            throw exception(YARD_ZONE_DUPLICATE);
        }
    }

    private void normalize(YardZoneSaveReqVO reqVO) {
        if (reqVO.getZoneCode() != null) {
            reqVO.setZoneCode(reqVO.getZoneCode().trim().toUpperCase());
        }
        if (reqVO.getZoneName() != null) {
            reqVO.setZoneName(reqVO.getZoneName().trim());
        }
        if (reqVO.getZoneType() != null) {
            reqVO.setZoneType(reqVO.getZoneType().trim().toUpperCase());
        }
    }

}
