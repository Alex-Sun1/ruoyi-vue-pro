package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsWaitingPoolQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsWaitingPoolResultRespVO;

public interface YmsWaitingPoolService {

    YmsWaitingPoolResultRespVO queryWaitingPool(YmsWaitingPoolQueryReqVO bo);
}
