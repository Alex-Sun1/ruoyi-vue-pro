package cn.iocoder.yudao.module.yms.dal.mysql;

import org.apache.ibatis.annotations.Mapper;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsContainerResourceDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsContainerResourceQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsContainerResourceRespVO;

@Mapper
public interface YmsContainerResourceMapper extends BaseMapperX<YmsContainerResourceDO> {

    Page<YmsContainerResourceRespVO> selectPageList(@Param("page") Page<YmsContainerResourceDO> page,
                                                @Param("bo") YmsContainerResourceQueryReqVO bo);
}

