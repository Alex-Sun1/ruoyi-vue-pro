package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.module.yms.dal.dto.YmsCallResourceCandidate;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCallRuleRespVO;

public interface YmsCallRuleEngineService {

    /** 解析仓库+任务类型下启用的叫号规则（按 sort_order 取第一条） */
    YmsCallRuleRespVO resolveRule(Long warehouseId, String taskType);

    /** 按排序规则选取下一候选（CONTAINER|TRAILER） */
    YmsCallResourceCandidate findNextCandidate(YmsCallRuleRespVO rule, String resourceType);

    /** 校验资源是否满足规则前置条件 */
    boolean validateConditions(YmsCallRuleRespVO rule, YmsCallResourceCandidate resource);

    /** 写入叫号记录 */
    void recordCall(YmsCallRuleRespVO rule, YmsCallResourceCandidate resource, Long dockId, String dockCode, String callType);

    YmsCallResourceCandidate buildCandidateFromContainer(cn.iocoder.yudao.module.yms.dal.dataobject.YmsContainerResourceDO container);

    YmsCallResourceCandidate buildCandidateFromTrailer(cn.iocoder.yudao.module.yms.dal.dataobject.YmsTrailerResourceDO trailer);
}
