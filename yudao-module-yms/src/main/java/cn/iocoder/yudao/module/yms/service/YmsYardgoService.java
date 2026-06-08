package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsRobotCallbackReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardgoTaskQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardgoTaskRespVO;

public interface YmsYardgoService {

    PageResult<YmsYardgoTaskRespVO> queryPageList(YmsYardgoTaskQueryReqVO bo, PageParam pageParam);

    YmsYardgoTaskRespVO queryById(Long id);

    /** 从园区任务创建 YardGo 机器人任务（推送至机器人系统后回填 robotTaskId） */
    YmsYardgoTaskRespVO createFromYardTask(Long yardTaskId);

    /** 机器人状态回调 */
    Boolean robotCallback(YmsRobotCallbackReqVO bo);

    /** 取消机器人任务 */
    Boolean cancelRobotTask(Long id);
}
