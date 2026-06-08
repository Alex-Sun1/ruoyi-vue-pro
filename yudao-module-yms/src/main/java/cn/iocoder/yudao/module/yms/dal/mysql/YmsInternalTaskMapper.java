package cn.iocoder.yudao.module.yms.dal.mysql;

import org.apache.ibatis.annotations.Mapper;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsInternalTaskDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsInternalTaskQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsInternalTaskRespVO;

import java.util.List;

@Mapper
public interface YmsInternalTaskMapper extends BaseMapperX<YmsInternalTaskDO> {

    Page<YmsInternalTaskRespVO> selectPageList(@Param("page") Page<YmsInternalTaskDO> page,
                                           @Param("bo") YmsInternalTaskQueryReqVO bo);

    List<YmsInternalTaskRespVO> selectBoardList(@Param("warehouseId") Long warehouseId,
                                            @Param("internalTaskType") String internalTaskType);
}

