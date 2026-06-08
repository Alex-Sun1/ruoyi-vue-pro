package cn.iocoder.yudao.module.yms.dal.mysql;

import org.apache.ibatis.annotations.Mapper;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsExceptionQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsExceptionRespVO;

@Mapper
public interface YmsExceptionMapper {

    Page<YmsExceptionRespVO> selectPageList(@Param("page") Page<YmsExceptionRespVO> page,
                                        @Param("bo") YmsExceptionQueryReqVO bo);
}

