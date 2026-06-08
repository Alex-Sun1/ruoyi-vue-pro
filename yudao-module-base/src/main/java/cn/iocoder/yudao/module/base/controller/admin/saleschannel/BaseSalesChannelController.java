package cn.iocoder.yudao.module.base.controller.admin.saleschannel;

import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.base.controller.admin.saleschannel.vo.BaseSalesChannelSimpleRespVO;
import cn.iocoder.yudao.module.base.dal.mysql.saleschannel.BaseSalesChannelMapper;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - 销售渠道")
@RestController
@RequestMapping("/base/sales-channel")
@Validated
public class BaseSalesChannelController {

    @Resource
    private BaseSalesChannelMapper salesChannelMapper;

    @GetMapping("/simple-list")
    @Operation(summary = "销售渠道精简列表")
    public CommonResult<List<BaseSalesChannelSimpleRespVO>> simpleList(
            @RequestParam(value = "status", required = false) Integer status) {
        Integer queryStatus = status != null ? status : CommonStatusEnum.ENABLE.getStatus();
        return success(BeanUtils.toBean(salesChannelMapper.selectSimpleList(queryStatus), BaseSalesChannelSimpleRespVO.class));
    }

}
