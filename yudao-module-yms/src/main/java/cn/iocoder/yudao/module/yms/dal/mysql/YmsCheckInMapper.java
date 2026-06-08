package cn.iocoder.yudao.module.yms.dal.mysql;

import org.apache.ibatis.annotations.Mapper;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsCheckInDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCheckInQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsInYardQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCheckInRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsInYardRespVO;

@Mapper
public interface YmsCheckInMapper extends BaseMapperX<YmsCheckInDO> {

    Page<YmsCheckInRespVO> selectPageList(@Param("page") Page<YmsCheckInDO> page,
                                      @Param("bo") YmsCheckInQueryReqVO bo);

    Page<YmsInYardRespVO> selectInYardPageList(@Param("page") Page<YmsInYardRespVO> page,
                                           @Param("bo") YmsInYardQueryReqVO bo);

    java.util.List<YmsInYardRespVO> selectInYardByKeyword(@Param("warehouseId") Long warehouseId,
                                                      @Param("keyword") String keyword);
}

