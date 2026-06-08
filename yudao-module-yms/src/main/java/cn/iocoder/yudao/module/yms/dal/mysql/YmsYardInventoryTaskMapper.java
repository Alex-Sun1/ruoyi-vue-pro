package cn.iocoder.yudao.module.yms.dal.mysql;

import org.apache.ibatis.annotations.Mapper;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsYardInventoryTaskDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardInventoryTaskQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardInventoryTaskRespVO;

@Mapper
public interface YmsYardInventoryTaskMapper extends BaseMapperX<YmsYardInventoryTaskDO> {

    Page<YmsYardInventoryTaskRespVO> selectPageList(@Param("page") Page<YmsYardInventoryTaskDO> page,
                                                @Param("bo") YmsYardInventoryTaskQueryReqVO bo);

    YmsYardInventoryTaskRespVO selectDetailById(@Param("id") Long id);
}

