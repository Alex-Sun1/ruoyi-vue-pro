package cn.iocoder.yudao.module.yms.service;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.module.yms.util.YmsPageUtils;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.module.base.dal.dataobject.yarddock.YardDockDO;
import cn.iocoder.yudao.module.base.dal.dataobject.yardzone.YardZoneDO;
import cn.iocoder.yudao.module.base.dal.mysql.yarddock.YardDockMapper;
import cn.iocoder.yudao.framework.common.exception.ServiceException;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardPositionAddReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardPositionEditReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardPositionQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardPositionRespVO;
import cn.iocoder.yudao.module.yms.service.YmsYardPositionService;
import cn.iocoder.yudao.module.yms.support.YmsYardLocationConverter;
import cn.iocoder.yudao.module.yms.support.YmsYardLocationSupport;
import cn.iocoder.yudao.module.yms.support.YmsYardLocationTypes;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 堆场位服务（读写 BASE yard_dock，兼容原 YMS API）。
 */

@Service
public class YmsYardPositionServiceImpl implements YmsYardPositionService {

    @Resource
    private YardDockMapper yardDockMapper;
    @Resource
    private YmsYardLocationSupport locationSupport;

    @Override
    public PageResult<YmsYardPositionRespVO> queryPageList(YmsYardPositionQueryReqVO bo, PageParam pageParam) {
        Page<YardDockDO> page = YmsPageUtils.toPage(pageParam);
        yardDockMapper.selectPage(page, buildQueryWrapper(bo));
        List<YmsYardPositionRespVO> rows = page.getRecords().stream()
            .map(YmsYardLocationConverter::toPositionVo)
            .collect(Collectors.toList());
        Page<YmsYardPositionRespVO> voPage = new Page<>(page.getCurrent(), page.getSize(), page.getTotal());
        voPage.setRecords(rows);
        return YmsPageUtils.toPageResult(voPage);
    }

    @Override
    public YmsYardPositionRespVO queryById(Long id) {
        return YmsYardLocationConverter.toPositionVo(locationSupport.requireSlot(id));
    }

    @Override
    public List<YmsYardPositionRespVO> queryListByZone(Long zoneId) {
        return locationSupport.listSlotsByZone(zoneId).stream()
            .map(YmsYardLocationConverter::toPositionVo)
            .collect(Collectors.toList());
    }

    @Override
    public List<YmsYardPositionRespVO> queryFreeList(Long warehouseId, String positionType) {
        return locationSupport.listFreeSlots(warehouseId, positionType).stream()
            .map(YmsYardLocationConverter::toPositionVo)
            .collect(Collectors.toList());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean insertByBo(YmsYardPositionAddReqVO bo) {
        YardZoneDO zone = locationSupport.requireZone(bo.getZoneId());
        long cnt = yardDockMapper.selectCount(
            Wrappers.<YardDockDO>lambdaQuery()
                .eq(YardDockDO::getZoneId, bo.getZoneId())
                .eq(YardDockDO::getDockCode, bo.getPositionCode()));
        if (cnt > 0) {
            throw new ServiceException(500, "该分区下位置编码已存在");
        }

        YardDockDO add = new YardDockDO();
        add.setWarehouseId(zone.getWarehouseId());
        add.setZoneId(zone.getId());
        add.setZoneCode(zone.getZoneCode());
        add.setDockCode(bo.getPositionCode());
        add.setDockName(StrUtil.isNotBlank(bo.getPositionName()) ? bo.getPositionName() : bo.getPositionCode());
        add.setLocationType(StrUtil.isNotBlank(bo.getPositionType()) ? bo.getPositionType() : "CONTAINER_SLOT");
        add.setGridRow(bo.getGridRow());
        add.setGridCol(bo.getGridCol());
        add.setDockStatus(YmsYardLocationConverter.toDockStatus(
            StrUtil.isNotBlank(bo.getPositionStatus()) ? bo.getPositionStatus() : "FREE"));
        add.setEnabledFlag("DISABLED".equals(add.getDockStatus()) ? 0 : 1);
        add.setSortOrder(bo.getGridRow());
        add.setRemark(bo.getRemark());
        return yardDockMapper.insert(add) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean updateByBo(YmsYardPositionEditReqVO bo) {
        YardDockDO existing = locationSupport.requireSlot(bo.getId());
        if ("OCCUPIED".equals(existing.getDockStatus()) || "RESERVED".equals(existing.getDockStatus())) {
            throw new ServiceException(500, "占用中的堆场位不允许编辑");
        }
        YardZoneDO zone = locationSupport.requireZone(bo.getZoneId());

        YardDockDO update = new YardDockDO();
        update.setId(bo.getId());
        update.setWarehouseId(zone.getWarehouseId());
        update.setZoneId(zone.getId());
        update.setZoneCode(zone.getZoneCode());
        update.setDockCode(bo.getPositionCode());
        update.setDockName(StrUtil.isNotBlank(bo.getPositionName()) ? bo.getPositionName() : bo.getPositionCode());
        update.setLocationType(bo.getPositionType());
        update.setDockStatus(YmsYardLocationConverter.toDockStatus(bo.getPositionStatus()));
        update.setGridRow(bo.getGridRow());
        update.setGridCol(bo.getGridCol());
        update.setRemark(bo.getRemark());
        return yardDockMapper.updateById(update) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean deleteByIds(List<Long> ids) {
        for (Long id : ids) {
            YardDockDO pos = locationSupport.requireSlot(id);
            if (!YmsYardLocationConverter.isFree(pos) && !"DISABLED".equals(pos.getDockStatus())) {
                throw new ServiceException(500, "堆场位 " + pos.getDockCode() + " 非空闲，无法删除");
            }
        }
        return yardDockMapper.deleteByIds(ids) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean release(Long id) {
        YardDockDO pos = locationSupport.requireSlot(id);
        if (!"OCCUPIED".equals(pos.getDockStatus()) && !"RESERVED".equals(pos.getDockStatus())) {
            throw new ServiceException(500, "仅占用/预留状态可释放");
        }
        locationSupport.releaseSlot(id);
        return true;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean disable(Long id) {
        YardDockDO pos = locationSupport.requireSlot(id);
        if ("OCCUPIED".equals(pos.getDockStatus())) {
            throw new ServiceException(500, "占用中的堆场位不能停用");
        }
        YardDockDO patch = new YardDockDO();
        patch.setId(id);
        patch.setDockStatus("DISABLED");
        patch.setEnabledFlag(0);
        return yardDockMapper.updateById(patch) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean enable(Long id) {
        YardDockDO patch = new YardDockDO();
        patch.setId(id);
        patch.setDockStatus("IDLE");
        patch.setEnabledFlag(1);
        return yardDockMapper.updateById(patch) > 0;
    }

    private com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<YardDockDO> buildQueryWrapper(YmsYardPositionQueryReqVO bo) {
        return Wrappers.<YardDockDO>lambdaQuery()
            .eq(bo.getWarehouseId() != null, YardDockDO::getWarehouseId, bo.getWarehouseId())
            .eq(bo.getZoneId() != null, YardDockDO::getZoneId, bo.getZoneId())
            .like(StrUtil.isNotBlank(bo.getPositionCode()), YardDockDO::getDockCode, bo.getPositionCode())
            .eq(StrUtil.isNotBlank(bo.getPositionType()), YardDockDO::getLocationType, bo.getPositionType())
            .eq(StrUtil.isNotBlank(bo.getPositionStatus()),
                YardDockDO::getDockStatus, YmsYardLocationConverter.toDockStatus(bo.getPositionStatus()))
            .in(YardDockDO::getLocationType, YmsYardLocationTypes.SLOT_TYPES)
            .orderByAsc(YardDockDO::getZoneCode, YardDockDO::getGridRow, YardDockDO::getGridCol);
    }
}
