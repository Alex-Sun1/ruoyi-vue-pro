package cn.iocoder.yudao.module.yms.dal.mysql;

import org.apache.ibatis.annotations.Mapper;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsYardPositionDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardPositionQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardPositionRespVO;

import java.util.List;

@Mapper
public interface YmsYardPositionMapper extends BaseMapperX<YmsYardPositionDO> {

    Page<YmsYardPositionRespVO> selectPageList(@Param("page") Page<YmsYardPositionDO> page,
                                           @Param("bo") YmsYardPositionQueryReqVO bo);

    List<YmsYardPositionRespVO> selectListByZone(@Param("zoneId") Long zoneId);

    List<YmsYardPositionRespVO> selectFreeList(@Param("warehouseId") Long warehouseId,
                                           @Param("positionType") String positionType);
}

