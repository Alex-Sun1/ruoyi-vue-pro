package cn.iocoder.yudao.module.yms.controller.admin;

import org.springframework.security.access.prepost.PreAuthorize;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardMapRespVO;
import cn.iocoder.yudao.module.yms.service.YmsYardMapService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Validated

@RestController
@RequestMapping("/yms/yard-map")
public class YmsYardMapController {

    @Resource
    private YmsYardMapService yardMapService;

    @PreAuthorize("@ss.hasPermission('yms:yardMap:view')")
    @GetMapping
    public CommonResult<YmsYardMapRespVO> getMap(@RequestParam Long warehouseId) {
        return success(yardMapService.queryMap(warehouseId));
    }
}
