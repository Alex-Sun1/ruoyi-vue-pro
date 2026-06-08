package cn.iocoder.yudao.module.yms.service;

import jakarta.annotation.Resource;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsWaitingPoolQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsWaitingPoolResultRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsWaitingPoolRespVO;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsWaitingPoolMapper;
import cn.iocoder.yudao.module.yms.service.YmsWaitingPoolService;
import org.springframework.stereotype.Service;

import java.util.List;


@Service
public class YmsWaitingPoolServiceImpl implements YmsWaitingPoolService {

    private static final int TIMEOUT_MINUTES = 120;

    @Resource
    private YmsWaitingPoolMapper waitingPoolMapper;

    @Override
    public YmsWaitingPoolResultRespVO queryWaitingPool(YmsWaitingPoolQueryReqVO bo) {
        List<YmsWaitingPoolRespVO> list = waitingPoolMapper.selectWaitingList(bo);
        for (YmsWaitingPoolRespVO row : list) {
            if (row.getCallable() == null) {
                row.setCallable(Boolean.FALSE);
            }
        }

        YmsWaitingPoolResultRespVO result = new YmsWaitingPoolResultRespVO();
        result.setList(list);
        result.setWaitContainerCount((int) list.stream().filter(r -> "CONTAINER".equals(r.getWaitType())).count());
        result.setWaitLoadingCount((int) list.stream()
            .filter(r -> "LOADING".equals(r.getWaitType())).count());
        result.setWaitRentedTrailerCount((int) list.stream()
            .filter(r -> "RENTED_TRAILER".equals(r.getWaitType())).count());
        result.setTimeoutCount((int) list.stream()
            .filter(r -> r.getWaitMinutes() != null && r.getWaitMinutes() >= TIMEOUT_MINUTES).count());
        return result;
    }
}
