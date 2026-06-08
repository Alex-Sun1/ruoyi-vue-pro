package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardInventoryScanReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardInventoryTaskCreateReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardInventoryTaskQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardInventoryItemRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardInventoryTaskRespVO;

public interface YmsYardInventoryService {

    PageResult<YmsYardInventoryTaskRespVO> queryPageList(YmsYardInventoryTaskQueryReqVO bo, PageParam pageParam);

    YmsYardInventoryTaskRespVO queryById(Long id);

    YmsYardInventoryTaskRespVO create(YmsYardInventoryTaskCreateReqVO bo);

    Boolean start(Long id);

    YmsYardInventoryItemRespVO scan(YmsYardInventoryScanReqVO bo);

    YmsYardInventoryTaskRespVO complete(Long id);

    Boolean confirmDiff(Long id);
}
