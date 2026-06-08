package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsExceptionQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsExceptionRespVO;

public interface YmsExceptionService {

    PageResult<YmsExceptionRespVO> queryPageList(YmsExceptionQueryReqVO bo, PageParam pageParam);

    Boolean resolve(String sourceType, Long refId, String remark);
}
