package cn.iocoder.yudao.module.oms.service.inboundplan;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanApplyRuleReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanSaveReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanItemUpdateReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanPageReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanSaveGroupReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanItemPreviewRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanRespVO;

import java.util.List;

/**
 * 入库计划 Service
 */
public interface InboundPlanService {

    /** 分页列表 */
    PageResult<InboundPlanRespVO> queryPageList(InboundPlanPageReqVO bo, PageParam pageQuery);

    /**
     * 获取或创建入库计划（从海柜订单入口进入时调用）
     * 若已有草稿/进行中计划则直接返回，否则自动创建并加载所有货件
     */
    InboundPlanRespVO getOrCreate(Long containerOrderId, Long warehouseId);

    /** 获取计划详情（含分组汇总 + 所有明细） */
    InboundPlanRespVO queryDetail(Long planId);

    // ====================== 业务动作 ======================

    // ====================== 预览（不写库）======================

    /** 预览自动分组结果，不写库 */
    List<InboundPlanItemPreviewRespVO> previewAutoGroup(Long planId);

    /** 预览快速配置规则结果，不写库；未命中的 proposedGroupCode 为 null */
    List<InboundPlanItemPreviewRespVO> previewApplyRule(Long planId, Long ruleId);

    /** 确认保存分组（前端审核后批量提交） */
    void saveGroupChanges(Long planId, List<InboundPlanSaveGroupReqVO> changes);

    /** 自动分组：对所有货件跑规则引擎，写入 group_code */
    void autoGroup(Long planId);

    /** 快速配置：对当前计划应用指定规则（覆盖已有分组） */
    void applyRule(Long planId, InboundPlanApplyRuleReqVO bo);

    /** 手动编辑单行 group_code / pre_location */
    void updateItem(InboundPlanItemUpdateReqVO bo);

    /** 开始作业：draft → in_progress */
    void startWork(Long planId);

    /** 完结计划：in_progress → completed */
    void complete(Long planId);

    /** 取消计划：→ cancelled */
    void cancel(Long planId);
}
