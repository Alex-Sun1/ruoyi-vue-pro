package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsInternalTaskAssignReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsInternalTaskCompleteReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsInternalTaskCreateReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsInternalTaskQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsInternalTaskBoardRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsInternalTaskRespVO;

import java.util.List;

public interface YmsInternalTaskService {

    PageResult<YmsInternalTaskRespVO> queryPageList(YmsInternalTaskQueryReqVO bo, PageParam pageParam);

    YmsInternalTaskRespVO queryById(Long id);

    List<YmsInternalTaskBoardRespVO> queryBoard(Long warehouseId, String internalTaskType);

    YmsInternalTaskRespVO createByBo(YmsInternalTaskCreateReqVO bo);

    /** 从海柜/车厢叫号自动创建上口任务 */
    YmsInternalTaskRespVO createToDockTask(YmsInternalTaskCreateReqVO bo);

    Boolean assign(YmsInternalTaskAssignReqVO bo);

    Boolean accept(Long id);

    Boolean start(Long id);

    Boolean complete(Long id, YmsInternalTaskCompleteReqVO bo);

    Boolean fail(Long id, String reason);

    Boolean cancel(Long id, String reason);
}
