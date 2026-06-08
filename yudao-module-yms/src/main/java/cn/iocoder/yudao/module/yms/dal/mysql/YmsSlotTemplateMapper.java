package cn.iocoder.yudao.module.yms.dal.mysql;

import org.apache.ibatis.annotations.Mapper;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsSlotTemplateDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsSlotTemplateQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsSlotTemplateRespVO;

import java.util.List;

@Mapper
public interface YmsSlotTemplateMapper extends BaseMapperX<YmsSlotTemplateDO> {

    Page<YmsSlotTemplateRespVO> selectPageList(@Param("page") Page<YmsSlotTemplateDO> page,
                                           @Param("bo") YmsSlotTemplateQueryReqVO bo);

    List<YmsSlotTemplateRespVO> selectEnabledByWarehouse(@Param("warehouseId") Long warehouseId,
                                                      @Param("taskType") String taskType);
}

