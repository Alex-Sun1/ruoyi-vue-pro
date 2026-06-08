package cn.iocoder.yudao.module.yms.controller.admin;

import org.springframework.security.access.prepost.PreAuthorize;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsWaitingPoolQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsWaitingPoolResultRespVO;
import cn.iocoder.yudao.module.yms.service.YmsWaitingPoolService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequestMapping("/yms/waiting-pool")
public class YmsWaitingPoolController  {

    @Resource
    private YmsWaitingPoolService waitingPoolService;

    /** 等待池列表（含统计） */
    @PreAuthorize("@ss.hasPermission('yms:waitingPool:view')")
    @GetMapping
    public CommonResult<YmsWaitingPoolResultRespVO> list(YmsWaitingPoolQueryReqVO bo) {
        return success(waitingPoolService.queryWaitingPool(bo));
    }
}
