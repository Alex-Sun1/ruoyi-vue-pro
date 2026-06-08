package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCallRuleAddReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCallRuleEditReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCallRuleQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCallRuleRespVO;

import java.util.List;

public interface YmsCallRuleService {

    PageResult<YmsCallRuleRespVO> queryPageList(YmsCallRuleQueryReqVO bo, PageParam pageParam);

    YmsCallRuleRespVO queryById(Long id);

    Boolean insertByBo(YmsCallRuleAddReqVO bo);

    Boolean updateByBo(YmsCallRuleEditReqVO bo);

    Boolean deleteByIds(List<Long> ids);

    Boolean toggle(Long id);
}
