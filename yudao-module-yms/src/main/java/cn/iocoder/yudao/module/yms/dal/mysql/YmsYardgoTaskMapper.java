package cn.iocoder.yudao.module.yms.dal.mysql;

import org.apache.ibatis.annotations.Mapper;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsYardgoTaskDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardgoTaskQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardgoTaskRespVO;

@Mapper
public interface YmsYardgoTaskMapper extends BaseMapperX<YmsYardgoTaskDO> {

    Page<YmsYardgoTaskRespVO> selectPageList(@Param("page") Page<YmsYardgoTaskDO> page,
                                         @Param("bo") YmsYardgoTaskQueryReqVO bo);
}

