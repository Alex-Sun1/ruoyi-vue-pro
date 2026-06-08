package cn.iocoder.yudao.module.yms.dal.mysql;

import org.apache.ibatis.annotations.Mapper;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsYardTaskDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardTaskQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardTaskRespVO;

@Mapper
public interface YmsYardTaskMapper extends BaseMapperX<YmsYardTaskDO> {

    Page<YmsYardTaskRespVO> selectPageList(@Param("page") Page<YmsYardTaskDO> page,
                                       @Param("bo") YmsYardTaskQueryReqVO bo);
}

