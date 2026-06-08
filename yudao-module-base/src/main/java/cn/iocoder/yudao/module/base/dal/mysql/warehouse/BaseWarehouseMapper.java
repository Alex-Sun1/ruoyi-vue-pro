package cn.iocoder.yudao.module.base.dal.mysql.warehouse;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.controller.admin.warehouse.vo.WarehousePageReqVO;
import cn.iocoder.yudao.module.base.dal.dataobject.warehouse.WarehouseDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.Collection;
import java.util.List;

/**
 * 海外仓组织资料-仓库 Mapper。
 * 勿命名为 WarehouseMapper：Bean 名 warehouseMapper 与 MES {@code MesWmWarehouseMapper} 注入字段冲突。
 */
@Mapper
public interface BaseWarehouseMapper extends BaseMapperX<WarehouseDO> {

    default PageResult<WarehouseDO> selectPage(WarehousePageReqVO reqVO) {
        LambdaQueryWrapperX<WarehouseDO> wrapper = new LambdaQueryWrapperX<>();
        wrapper.and(StrUtil.isNotBlank(reqVO.getKeyword()), w -> w
                .like(WarehouseDO::getWarehouseCode, reqVO.getKeyword())
                .or()
                .like(WarehouseDO::getWarehouseName, reqVO.getKeyword()));
        wrapper.eqIfPresent(WarehouseDO::getCompanyId, reqVO.getCompanyId());
        wrapper.eqIfPresent(WarehouseDO::getStatus, reqVO.getStatus());
        wrapper.orderByAsc(WarehouseDO::getSort).orderByDesc(WarehouseDO::getId);
        return selectPage(reqVO, wrapper);
    }

    default WarehouseDO selectByUnique(String warehouseCode) {
        return selectOne(new LambdaQueryWrapperX<WarehouseDO>()
                .eq(WarehouseDO::getWarehouseCode, warehouseCode));
    }

    default List<WarehouseDO> selectListByIds(Collection<Long> ids) {
        if (CollUtil.isEmpty(ids)) {
            return List.of();
        }
        return selectList(new LambdaQueryWrapperX<WarehouseDO>().in(WarehouseDO::getId, ids));
    }

    default List<WarehouseDO> selectSimpleList(Integer status, Collection<Long> warehouseIds) {
        LambdaQueryWrapperX<WarehouseDO> wrapper = new LambdaQueryWrapperX<>();
        if (status != null) {
            wrapper.eq(WarehouseDO::getStatus, status);
        }
        if (CollUtil.isNotEmpty(warehouseIds)) {
            wrapper.in(WarehouseDO::getId, warehouseIds);
        }
        return selectList(wrapper.orderByAsc(WarehouseDO::getSort).orderByAsc(WarehouseDO::getWarehouseCode));
    }

    default Long selectCountByTimezoneCode(String timezoneCode) {
        return selectCount(new LambdaQueryWrapperX<WarehouseDO>()
                .eq(WarehouseDO::getTimezoneCode, timezoneCode));
    }

    default Long selectCountByCompanyId(Long companyId) {
        return selectCount(new LambdaQueryWrapperX<WarehouseDO>()
                .eq(WarehouseDO::getCompanyId, companyId));
    }

    default List<WarehouseDO> selectEnabledListByCompanyIds(Collection<Long> companyIds) {
        if (CollUtil.isEmpty(companyIds)) {
            return List.of();
        }
        return selectList(new LambdaQueryWrapperX<WarehouseDO>()
                .eq(WarehouseDO::getStatus, 0)
                .in(WarehouseDO::getCompanyId, companyIds)
                .orderByAsc(WarehouseDO::getSort).orderByAsc(WarehouseDO::getWarehouseCode));
    }

    default List<WarehouseDO> selectAllEnabledList() {
        return selectList(new LambdaQueryWrapperX<WarehouseDO>()
                .eq(WarehouseDO::getStatus, 0)
                .orderByAsc(WarehouseDO::getSort).orderByAsc(WarehouseDO::getWarehouseCode));
    }

}
