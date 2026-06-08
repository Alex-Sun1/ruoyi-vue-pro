package cn.iocoder.yudao.module.yms.dal.mysql;

import org.apache.ibatis.annotations.Mapper;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsTrailerResourceDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsTrailerResourceQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsTrailerResourceRespVO;

@Mapper
public interface YmsTrailerResourceMapper extends BaseMapperX<YmsTrailerResourceDO> {

    Page<YmsTrailerResourceRespVO> selectPageList(@Param("page") Page<YmsTrailerResourceDO> page,
                                              @Param("bo") YmsTrailerResourceQueryReqVO bo);
}

