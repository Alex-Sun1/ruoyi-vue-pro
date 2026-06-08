package cn.iocoder.yudao.module.oms.service.cargogroupingfieldmeta;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.oms.enums.ErrorCodeConstants.*;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargogroupingfieldmeta.CargoGroupingFieldMetaDO;
import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingfieldmeta.vo.CargoGroupingFieldMetaSaveReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingfieldmeta.vo.CargoGroupingFieldMetaPageReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingfieldmeta.vo.CargoGroupingFieldMetaRespVO;
import cn.iocoder.yudao.module.oms.dal.mysql.cargogroupingfieldmeta.CargoGroupingFieldMetaMapper;
import cn.iocoder.yudao.module.oms.service.cargogroupingfieldmeta.CargoGroupingFieldMetaService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class CargoGroupingFieldMetaServiceImpl implements CargoGroupingFieldMetaService {

    @Resource
    private CargoGroupingFieldMetaMapper baseMapper;

    @Override
    public List<CargoGroupingFieldMetaRespVO> queryList(CargoGroupingFieldMetaPageReqVO bo) {
        return BeanUtils.toBean(baseMapper.selectList(buildQueryWrapper(bo)), CargoGroupingFieldMetaRespVO.class);
    }

    @Override
    public CargoGroupingFieldMetaRespVO queryById(Long id) {
        return BeanUtils.toBean(baseMapper.selectById(id), CargoGroupingFieldMetaRespVO.class);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean insertByBo(CargoGroupingFieldMetaSaveReqVO bo) {
        validateUnique(null, bo.getTableAlias(), bo.getFieldName());
        CargoGroupingFieldMetaDO add = BeanUtils.toBean(bo, CargoGroupingFieldMetaDO.class);
        if (add == null) {
            throw exception(OMS_BIZ_ERROR, "字段元数据转换失败");
        }
        if (add.getCanBeCondition() == null) add.setCanBeCondition(1);
        if (add.getCanBeGroupKey() == null) add.setCanBeGroupKey(1);
        if (add.getEnabled() == null) add.setEnabled(1);
        if (add.getSortOrder() == null) add.setSortOrder(0);
        return baseMapper.insert(add) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean updateByBo(CargoGroupingFieldMetaSaveReqVO bo) {
        validateUnique(bo.getId(), bo.getTableAlias(), bo.getFieldName());
        CargoGroupingFieldMetaDO update = BeanUtils.toBean(bo, CargoGroupingFieldMetaDO.class);
        if (update == null) {
            throw exception(OMS_BIZ_ERROR, "字段元数据转换失败");
        }
        return baseMapper.updateById(update) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean enable(Long id) {
        CargoGroupingFieldMetaDO update = new CargoGroupingFieldMetaDO();
        update.setId(id);
        update.setEnabled(1);
        return baseMapper.updateById(update) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean disable(Long id) {
        CargoGroupingFieldMetaDO update = new CargoGroupingFieldMetaDO();
        update.setId(id);
        update.setEnabled(0);
        return baseMapper.updateById(update) > 0;
    }

    private void validateUnique(Long id, String tableAlias, String fieldName) {
        Long count = baseMapper.selectCount(Wrappers.<CargoGroupingFieldMetaDO>lambdaQuery()
            .eq(CargoGroupingFieldMetaDO::getTableAlias, tableAlias)
            .eq(CargoGroupingFieldMetaDO::getFieldName, fieldName)
            .ne(id != null, CargoGroupingFieldMetaDO::getId, id));
        if (count != null && count > 0) {
            throw exception(OMS_BIZ_ERROR, "字段元数据已存在");
        }
    }

    private LambdaQueryWrapper<CargoGroupingFieldMetaDO> buildQueryWrapper(CargoGroupingFieldMetaPageReqVO bo) {
        LambdaQueryWrapper<CargoGroupingFieldMetaDO> lqw = Wrappers.lambdaQuery();
        if (bo != null) {
            lqw.eq(StrUtil.isNotBlank(bo.getTableAlias()), CargoGroupingFieldMetaDO::getTableAlias, bo.getTableAlias());
            lqw.like(StrUtil.isNotBlank(bo.getFieldName()), CargoGroupingFieldMetaDO::getFieldName, bo.getFieldName());
            lqw.like(StrUtil.isNotBlank(bo.getDisplayName()), CargoGroupingFieldMetaDO::getDisplayName, bo.getDisplayName());
            lqw.eq(bo.getEnabled() != null, CargoGroupingFieldMetaDO::getEnabled, bo.getEnabled());
            lqw.eq(bo.getCanBeCondition() != null, CargoGroupingFieldMetaDO::getCanBeCondition, bo.getCanBeCondition());
            lqw.eq(bo.getCanBeGroupKey() != null, CargoGroupingFieldMetaDO::getCanBeGroupKey, bo.getCanBeGroupKey());
        }
        lqw.orderByAsc(CargoGroupingFieldMetaDO::getSortOrder).orderByAsc(CargoGroupingFieldMetaDO::getId);
        return lqw;
    }
}
