package cn.iocoder.yudao.module.yms.controller.admin;

import org.springframework.security.access.prepost.PreAuthorize;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsOverviewRespVO;
import cn.iocoder.yudao.module.yms.service.YmsOverviewService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequestMapping("/yms/overview")
public class YmsOverviewController  {

    @Resource
    private YmsOverviewService overviewService;

    @PreAuthorize("@ss.hasPermission('yms:dashboard:view')")
    @GetMapping
    public CommonResult<YmsOverviewRespVO> overview(@RequestParam(required = false) Long warehouseId) {
        return success(overviewService.queryOverview(warehouseId));
    }
}
