package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsSlotTemplateAddReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsSlotTemplateEditReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsSlotTemplateQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsSlotTemplateRespVO;

import java.util.List;

public interface YmsSlotTemplateService {
    PageResult<YmsSlotTemplateRespVO> queryPageList(YmsSlotTemplateQueryReqVO bo, PageParam pageParam);
    List<YmsSlotTemplateRespVO> queryEnabledByWarehouse(Long warehouseId, String taskType);
    YmsSlotTemplateRespVO queryById(Long id);
    Boolean insertByBo(YmsSlotTemplateAddReqVO bo);
    Boolean updateByBo(YmsSlotTemplateEditReqVO bo);
    Boolean deleteByIds(List<Long> ids);
}
