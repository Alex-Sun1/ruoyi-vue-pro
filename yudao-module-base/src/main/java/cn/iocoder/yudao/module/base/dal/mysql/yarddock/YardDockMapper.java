package cn.iocoder.yudao.module.base.dal.mysql.yarddock;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.controller.admin.yarddock.vo.YardDockPageReqVO;
import cn.iocoder.yudao.module.base.dal.dataobject.yarddock.YardDockDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface YardDockMapper extends BaseMapperX<YardDockDO> {

    default PageResult<YardDockDO> selectPage(YardDockPageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<YardDockDO>()
                .likeIfPresent(YardDockDO::getDockCode, reqVO.getDockCode())
                .likeIfPresent(YardDockDO::getDockName, reqVO.getDockName())
                .eqIfPresent(YardDockDO::getWarehouseId, reqVO.getWarehouseId())
                .eqIfPresent(YardDockDO::getZoneId, reqVO.getZoneId())
                .eqIfPresent(YardDockDO::getLocationType, reqVO.getLocationType())
                .eqIfPresent(YardDockDO::getBusinessTypeId, reqVO.getBusinessTypeId())
                .eqIfPresent(YardDockDO::getDockLocation, reqVO.getDockLocation())
                .eqIfPresent(YardDockDO::getDockStatus, reqVO.getDockStatus())
                .eqIfPresent(YardDockDO::getEnabledFlag, reqVO.getEnabledFlag())
                .orderByAsc(YardDockDO::getSortOrder, YardDockDO::getDockCode));
    }

    default List<YardDockDO> selectListByQuery(YardDockPageReqVO reqVO) {
        return selectList(new LambdaQueryWrapperX<YardDockDO>()
                .eqIfPresent(YardDockDO::getWarehouseId, reqVO.getWarehouseId())
                .eqIfPresent(YardDockDO::getLocationType, reqVO.getLocationType())
                .eqIfPresent(YardDockDO::getDockStatus, reqVO.getDockStatus())
                .eqIfPresent(YardDockDO::getEnabledFlag, reqVO.getEnabledFlag())
                .orderByAsc(YardDockDO::getDockCode));
    }

    default YardDockDO selectByUnique(String dockCode) {
        return selectOne(YardDockDO::getDockCode, dockCode);
    }

}
