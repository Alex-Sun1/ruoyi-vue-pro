package cn.iocoder.yudao.module.yms.dal.mysql;

import org.apache.ibatis.annotations.Mapper;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsYardZoneDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardZoneQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardZoneRespVO;

import java.util.List;

@Mapper
public interface YmsYardZoneMapper extends BaseMapperX<YmsYardZoneDO> {

    Page<YmsYardZoneRespVO> selectPageList(@Param("page") Page<YmsYardZoneDO> page,
                                       @Param("bo") YmsYardZoneQueryReqVO bo);

    List<YmsYardZoneRespVO> selectListByWarehouse(@Param("warehouseId") Long warehouseId);
}

