package cn.iocoder.yudao.module.base.controller.admin.client;

import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.base.controller.admin.client.vo.BaseClientSimpleRespVO;
import cn.iocoder.yudao.module.base.dal.dataobject.client.ClientDO;
import cn.iocoder.yudao.module.base.dal.mysql.client.BaseClientMapper;
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

@Tag(name = "管理后台 - 客户")
@RestController
@RequestMapping("/base/client")
@Validated
public class BaseClientController {

    @Resource
    private BaseClientMapper baseClientMapper;

    @GetMapping("/simple-list")
    @Operation(summary = "客户精简列表", description = "默认 status=0（正常）")
    public CommonResult<List<BaseClientSimpleRespVO>> getSimpleList(
            @RequestParam(value = "status", required = false) Integer status) {
        Integer queryStatus = status != null ? status : CommonStatusEnum.ENABLE.getStatus();
        List<ClientDO> list = baseClientMapper.selectSimpleList(queryStatus);
        return success(BeanUtils.toBean(list, BaseClientSimpleRespVO.class));
    }

}
