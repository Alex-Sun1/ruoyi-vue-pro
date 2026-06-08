package cn.iocoder.yudao.module.base.service.yarddock;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.base.controller.admin.yarddock.vo.*;
import cn.iocoder.yudao.module.base.dal.dataobject.businesstype.BusinessTypeDO;
import cn.iocoder.yudao.module.base.dal.dataobject.warehouse.WarehouseDO;
import cn.iocoder.yudao.module.base.dal.dataobject.yarddock.YardDockDO;
import cn.iocoder.yudao.module.base.dal.dataobject.yardzone.YardZoneDO;
import cn.iocoder.yudao.module.base.dal.mysql.businesstype.BusinessTypeMapper;
import cn.iocoder.yudao.module.base.dal.mysql.warehouse.BaseWarehouseMapper;
import cn.iocoder.yudao.module.base.dal.mysql.yarddock.YardDockMapper;
import cn.iocoder.yudao.module.base.dal.mysql.yardzone.YardZoneMapper;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import java.util.List;
import java.util.Objects;
import java.util.Set;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.base.enums.ErrorCodeConstants.*;

@Service
@Validated
public class YardDockServiceImpl implements YardDockService {

    private static final Set<String> SLOT_LOCATION_TYPES = Set.of(
            "PARKING", "CONTAINER_SLOT", "EMPTY_CONTAINER_SLOT", "TRAILER_SLOT", "WAITING_SLOT", "BLOCKED_SLOT");
    private static final String LOCATION_TYPE_DOCK = "DOCK";
    private static final String DOCK_STATUS_IDLE = "IDLE";

    @Resource
    private YardDockMapper yardDockMapper;
    @Resource
    private BaseWarehouseMapper baseWarehouseMapper;
    @Resource
    private BusinessTypeMapper businessTypeMapper;
    @Resource
    private YardZoneMapper yardZoneMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createYardDock(YardDockSaveReqVO createReqVO) {
        normalize(createReqVO);
        validateUnique(null, createReqVO.getDockCode());
        applyDefaults(createReqVO);
        YardDockDO row = BeanUtils.toBean(createReqVO, YardDockDO.class);
        fillWarehouseSnapshot(row);
        fillZoneSnapshot(row);
        fillBusinessTypeSnapshot(row);
        validateLocationConfig(row);
        yardDockMapper.insert(row);
        return row.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateYardDock(YardDockSaveReqVO updateReqVO) {
        YardDockDO existing = validateExists(updateReqVO.getId());
        normalize(updateReqVO);
        if (!Objects.equals(existing.getDockCode(), updateReqVO.getDockCode())) {
            throw exception(YARD_DOCK_CODE_NOT_MODIFIABLE);
        }
        updateReqVO.setDockCode(existing.getDockCode());
        YardDockDO update = BeanUtils.toBean(updateReqVO, YardDockDO.class);
        fillWarehouseSnapshot(update);
        fillZoneSnapshot(update);
        fillBusinessTypeSnapshot(update);
        validateLocationConfig(update);
        yardDockMapper.updateById(update);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteYardDock(Long id) {
        YardDockDO row = validateExists(id);
        if (Integer.valueOf(1).equals(row.getEnabledFlag())) {
            throw exception(YARD_DOCK_DELETE_ENABLED);
        }
        yardDockMapper.deleteById(id);
    }

    @Override
    public YardDockRespVO getYardDock(Long id) {
        return BeanUtils.toBean(validateExists(id), YardDockRespVO.class);
    }

    @Override
    public PageResult<YardDockRespVO> getYardDockPage(YardDockPageReqVO pageReqVO) {
        return BeanUtils.toBean(yardDockMapper.selectPage(pageReqVO), YardDockRespVO.class);
    }

    @Override
    public List<YardDockRespVO> getYardDockFreeList(Long warehouseId) {
        YardDockPageReqVO reqVO = new YardDockPageReqVO();
        reqVO.setWarehouseId(warehouseId);
        reqVO.setLocationType(LOCATION_TYPE_DOCK);
        reqVO.setDockStatus(DOCK_STATUS_IDLE);
        reqVO.setEnabledFlag(1);
        return BeanUtils.toBean(yardDockMapper.selectListByQuery(reqVO), YardDockRespVO.class);
    }

    @Override
    public List<YardDockRespVO> getYardDockExportList(YardDockPageReqVO pageReqVO) {
        pageReqVO.setPageSize(-1);
        return getYardDockPage(pageReqVO).getList();
    }

    private void fillWarehouseSnapshot(YardDockDO dock) {
        if (dock == null || dock.getWarehouseId() == null) {
            return;
        }
        WarehouseDO warehouse = baseWarehouseMapper.selectById(dock.getWarehouseId());
        if (warehouse == null) {
            throw exception(YARD_DOCK_WAREHOUSE_NOT_EXISTS);
        }
        dock.setWarehouseCode(warehouse.getWarehouseCode());
        dock.setWarehouseName(warehouse.getWarehouseName());
    }

    private void fillBusinessTypeSnapshot(YardDockDO dock) {
        if (dock == null || dock.getBusinessTypeId() == null) {
            return;
        }
        BusinessTypeDO businessType = businessTypeMapper.selectById(dock.getBusinessTypeId());
        if (businessType == null) {
            throw exception(YARD_DOCK_BUSINESS_TYPE_NOT_EXISTS);
        }
        dock.setBusinessTypeCode(businessType.getBusinessTypeCode());
        dock.setBusinessTypeName(businessType.getBusinessTypeName());
    }

    private void fillZoneSnapshot(YardDockDO dock) {
        if (dock == null || dock.getZoneId() == null) {
            return;
        }
        YardZoneDO zone = yardZoneMapper.selectById(dock.getZoneId());
        if (zone == null) {
            throw exception(YARD_DOCK_ZONE_NOT_EXISTS);
        }
        dock.setZoneCode(zone.getZoneCode());
        if (dock.getWarehouseId() == null) {
            dock.setWarehouseId(zone.getWarehouseId());
        }
    }

    private void validateLocationConfig(YardDockDO dock) {
        if (dock == null || LOCATION_TYPE_DOCK.equals(dock.getLocationType())) {
            return;
        }
        if (SLOT_LOCATION_TYPES.contains(dock.getLocationType()) && dock.getZoneId() == null) {
            throw exception(YARD_DOCK_ZONE_REQUIRED);
        }
    }

    private void applyDefaults(YardDockSaveReqVO reqVO) {
        if (reqVO.getAppointmentSupported() == null) {
            reqVO.setAppointmentSupported(1);
        }
        if (reqVO.getMaxConcurrent() == null) {
            reqVO.setMaxConcurrent(1);
        }
        if (reqVO.getEnabledFlag() == null) {
            reqVO.setEnabledFlag(1);
        }
        if (reqVO.getSortOrder() == null) {
            reqVO.setSortOrder(0);
        }
        if (reqVO.getDispatchPriority() == null) {
            reqVO.setDispatchPriority(1);
        }
        if (StrUtil.isBlank(reqVO.getDockStatus())) {
            reqVO.setDockStatus(DOCK_STATUS_IDLE);
        }
        if (StrUtil.isBlank(reqVO.getLocationType())) {
            reqVO.setLocationType(LOCATION_TYPE_DOCK);
        }
    }

    private YardDockDO validateExists(Long id) {
        YardDockDO row = yardDockMapper.selectById(id);
        if (row == null) {
            throw exception(YARD_DOCK_NOT_EXISTS);
        }
        return row;
    }

    private void validateUnique(Long id, String dockCode) {
        YardDockDO exist = yardDockMapper.selectByUnique(dockCode);
        if (exist != null && (id == null || !exist.getId().equals(id))) {
            throw exception(YARD_DOCK_DUPLICATE);
        }
    }

    private void normalize(YardDockSaveReqVO reqVO) {
        if (reqVO.getDockCode() != null) {
            reqVO.setDockCode(reqVO.getDockCode().trim().toUpperCase());
        }
        if (reqVO.getDockName() != null) {
            reqVO.setDockName(reqVO.getDockName().trim());
        }
        if (reqVO.getLocationType() != null) {
            reqVO.setLocationType(reqVO.getLocationType().trim().toUpperCase());
        }
    }

}
