package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.controller.admin.vo.*;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsDockBoardRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsDispatchStatsRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardTaskLogRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardTaskRespVO;

import java.util.Date;
import java.util.List;

public interface YmsDispatchService {

    /** 分页查询园区任务列表 */
    PageResult<YmsYardTaskRespVO> queryPageList(YmsYardTaskQueryReqVO bo, PageParam pageParam);

    /** 查询单个任务详情 */
    YmsYardTaskRespVO queryById(Long id);

    /** OMS/TMS推送任务（幂等upsert） */
    YmsYardTaskRespVO pushTask(YmsPushTaskReqVO bo);

    /** 手动新建任务 */
    YmsYardTaskRespVO createTask(YmsYardTaskCreateReqVO bo);

    /** Dock看板（按dockLocation分组；taskGroup=DEVANNING/LOADING 时按 Dock 类型过滤） */
    List<YmsDockBoardRespVO> queryDockBoard(Long warehouseId, String taskGroup);

    /** 顶部统计 */
    YmsDispatchStatsRespVO queryStats(Long warehouseId, String taskGroup);

    /** 签到 */
    Boolean checkIn(Long taskId);

    /** 分配Dock（dockId为null时取消分配） */
    Boolean assignDock(YmsAssignDockReqVO bo);

    /** 开始Dock作业 */
    Boolean startDockWork(Long taskId);

    /** 暂停Dock作业 */
    Boolean pauseWork(Long taskId);

    /** 恢复Dock作业 */
    Boolean resumeWork(Long taskId);

    /** 完成Dock作业（生成下口 YardGo 任务；任务完成释放 Dock 后再推进队列） */
    Boolean finishDockWork(Long taskId, YmsFinishWorkReqVO bo);

    /** 调整任务优先级 */
    Boolean updatePriority(YmsUpdatePriorityReqVO bo);

    /** WMS 备货状态回写 */
    Boolean syncWmsReady(YmsSyncWmsReadyReqVO bo);

    /** 放行 */
    Boolean release(Long taskId);

    /** 离园 */
    Boolean leaveYard(Long taskId);

    /** 标记异常 */
    Boolean markException(Long taskId, String reason);

    /** 解除异常 */
    Boolean clearException(Long taskId);

    /** 取消任务 */
    Boolean cancelTask(Long taskId, String reason);

    /** 操作日志 */
    List<YmsYardTaskLogRespVO> queryLogs(Long taskId);

    /**
     * OMS 手动设置 ARRIVED_WAREHOUSE 时同步到仓时间到 YMS（不回调 OMS，避免循环）。
     * - 任务在 CREATED/PRE_ARRIVAL → 推进到 ARRIVED 并写入 gateInTime
     * - 任务已 ARRIVED 或更晚 → 仅更新 gateInTime（覆盖为 OMS 记录的实际到仓时间）
     * - 任务不存在 → 忽略（调用方应先 pushTask 确保任务已创建）
     */
    void syncOmsArrival(String sourceOrderType, Long sourceOrderId, Date arrivalTime);
}
