package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.base.controller.admin.yardzone.vo.YardZonePageReqVO;
import cn.iocoder.yudao.module.base.controller.admin.yardzone.vo.YardZoneRespVO;
import cn.iocoder.yudao.module.base.controller.admin.yardzone.vo.YardZoneSaveReqVO;
import cn.iocoder.yudao.module.base.service.yardzone.YardZoneService;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardZoneAddReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardZoneEditReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardZoneQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardZoneRespVO;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 堆场分区服务（委托 BASE yard_zone，兼容原 YMS API）。
 */
@Service
public class YmsYardZoneServiceImpl implements YmsYardZoneService {

    @Resource
    private YardZoneService yardZoneService;

    @Override
    public PageResult<YmsYardZoneRespVO> queryPageList(YmsYardZoneQueryReqVO bo) {
        YardZonePageReqVO pageReqVO = BeanUtils.toBean(bo, YardZonePageReqVO.class);
        PageResult<YardZoneRespVO> page = yardZoneService.getYardZonePage(pageReqVO);
        List<YmsYardZoneRespVO> list = page.getList().stream().map(this::toVo).collect(Collectors.toList());
        return new PageResult<>(list, page.getTotal());
    }

    @Override
    public List<YmsYardZoneRespVO> queryListByWarehouse(Long warehouseId) {
        return yardZoneService.getYardZoneListByWarehouse(warehouseId).stream()
                .map(this::toVo)
                .collect(Collectors.toList());
    }

    @Override
    public YmsYardZoneRespVO queryById(Long id) {
        return toVo(yardZoneService.getYardZone(id));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean insertByBo(YmsYardZoneAddReqVO bo) {
        yardZoneService.createYardZone(toSaveReq(bo, null));
        return true;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean updateByBo(YmsYardZoneEditReqVO bo) {
        yardZoneService.updateYardZone(toSaveReq(bo, bo.getId()));
        return true;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean deleteByIds(List<Long> ids) {
        for (Long id : ids) {
            yardZoneService.deleteYardZone(id);
        }
        return true;
    }

    private YardZoneSaveReqVO toSaveReq(YmsYardZoneAddReqVO bo, Long id) {
        YardZoneSaveReqVO req = BeanUtils.toBean(bo, YardZoneSaveReqVO.class);
        req.setId(id);
        return req;
    }

    private YardZoneSaveReqVO toSaveReq(YmsYardZoneEditReqVO bo, Long id) {
        YardZoneSaveReqVO req = BeanUtils.toBean(bo, YardZoneSaveReqVO.class);
        req.setId(id);
        return req;
    }

    private YmsYardZoneRespVO toVo(YardZoneRespVO source) {
        return source == null ? null : BeanUtils.toBean(source, YmsYardZoneRespVO.class);
    }

}
