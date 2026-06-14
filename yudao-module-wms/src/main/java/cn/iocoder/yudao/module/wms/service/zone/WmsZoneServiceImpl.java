package cn.iocoder.yudao.module.wms.service.zone;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.wms.controller.admin.zone.vo.WmsZonePageReqVO;
import cn.iocoder.yudao.module.wms.controller.admin.zone.vo.WmsZoneRespVO;
import cn.iocoder.yudao.module.wms.controller.admin.zone.vo.WmsZoneSaveReqVO;
import cn.iocoder.yudao.module.wms.dal.dataobject.location.WmsLocationDO;
import cn.iocoder.yudao.module.wms.dal.dataobject.zone.WmsZoneDO;
import cn.iocoder.yudao.module.wms.dal.mysql.location.WmsLocationMapper;
import cn.iocoder.yudao.module.wms.dal.mysql.zone.WmsZoneMapper;
import cn.iocoder.yudao.module.org.framework.datapermission.annotation.OrgDataScope;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import java.util.List;
import java.util.stream.Collectors;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.wms.enums.ErrorCodeConstants.*;

@Service
@Validated
public class WmsZoneServiceImpl implements WmsZoneService {

    @Resource
    private WmsZoneMapper zoneMapper;
    @Resource
    private WmsLocationMapper locationMapper;

    @Override
    @OrgDataScope(tableClass = WmsZoneDO.class, warehouseColumn = "warehouse_id")
    public PageResult<WmsZoneRespVO> getZonePage(WmsZonePageReqVO pageReqVO) {
        PageResult<WmsZoneDO> page = zoneMapper.selectPage(pageReqVO);
        return new PageResult<>(toRespList(page.getList()), page.getTotal());
    }

    @Override
    @OrgDataScope(tableClass = WmsZoneDO.class, warehouseColumn = "warehouse_id")
    public List<WmsZoneRespVO> getZoneList(WmsZonePageReqVO pageReqVO) {
        return toRespList(zoneMapper.selectList(zoneMapper.buildWrapper(pageReqVO)));
    }

    @Override
    @OrgDataScope(tableClass = WmsZoneDO.class, warehouseColumn = "warehouse_id")
    public WmsZoneRespVO getZone(Long id) {
        WmsZoneDO row = zoneMapper.selectById(id);
        return row == null ? null : BeanUtils.toBean(row, WmsZoneRespVO.class);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createZone(WmsZoneSaveReqVO createReqVO) {
        WmsZoneDO entity = BeanUtils.toBean(createReqVO, WmsZoneDO.class);
        validateZone(entity, null);
        if (StrUtil.isBlank(entity.getStatus())) {
            entity.setStatus("ENABLED");
        }
        if (entity.getAllowMixedStorage() == null) {
            entity.setAllowMixedStorage(0);
        }
        if (entity.getAllowMixedStorage() == 0) {
            entity.setMaxMixedQty(null);
        }
        zoneMapper.insert(entity);
        return entity.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    @OrgDataScope(tableClass = WmsZoneDO.class, warehouseColumn = "warehouse_id")
    public void updateZone(WmsZoneSaveReqVO updateReqVO) {
        WmsZoneDO entity = BeanUtils.toBean(updateReqVO, WmsZoneDO.class);
        validateZone(entity, entity.getId());
        if (entity.getAllowMixedStorage() != null && entity.getAllowMixedStorage() == 0) {
            entity.setMaxMixedQty(null);
        }
        zoneMapper.updateById(entity);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    @OrgDataScope(tableClass = WmsZoneDO.class, warehouseColumn = "warehouse_id")
    public void changeZoneStatus(Long id, String status) {
        if (id == null || StrUtil.isBlank(status)) {
            throw exception(WMS_PARAM_INVALID);
        }
        WmsZoneDO zone = new WmsZoneDO();
        zone.setId(id);
        zone.setStatus(status);
        zoneMapper.updateById(zone);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    @OrgDataScope(tableClass = WmsZoneDO.class, warehouseColumn = "warehouse_id")
    public void deleteZoneList(List<Long> ids) {
        for (Long id : ids) {
            long count = locationMapper.selectCount(Wrappers.<WmsLocationDO>lambdaQuery()
                    .eq(WmsLocationDO::getZoneId, id));
            if (count > 0) {
                throw exception(WMS_ZONE_HAS_LOCATIONS);
            }
        }
        zoneMapper.deleteByIds(ids);
    }

    private void validateZone(WmsZoneDO entity, Long excludeId) {
        if (entity.getWarehouseId() == null || StrUtil.isBlank(entity.getZoneName())) {
            throw exception(WMS_PARAM_INVALID, "仓库与区域名称不能为空");
        }
        if (StrUtil.isBlank(entity.getStorageMethod())) {
            throw exception(WMS_PARAM_INVALID, "存放方式不能为空");
        }
        if (entity.getAllowMixedStorage() != null && entity.getAllowMixedStorage() == 1) {
            if (entity.getMaxMixedQty() == null || entity.getMaxMixedQty() <= 0) {
                throw exception(WMS_PARAM_INVALID, "开启混合存储时，最大混合数量须为正整数");
            }
        }
        long count = zoneMapper.selectCount(Wrappers.<WmsZoneDO>lambdaQuery()
                .eq(WmsZoneDO::getWarehouseId, entity.getWarehouseId())
                .eq(WmsZoneDO::getZoneName, entity.getZoneName())
                .ne(excludeId != null, WmsZoneDO::getId, excludeId));
        if (count > 0) {
            throw exception(WMS_ZONE_NAME_DUPLICATE);
        }
    }

    private List<WmsZoneRespVO> toRespList(List<WmsZoneDO> list) {
        return list.stream().map(r -> BeanUtils.toBean(r, WmsZoneRespVO.class)).collect(Collectors.toList());
    }

}
