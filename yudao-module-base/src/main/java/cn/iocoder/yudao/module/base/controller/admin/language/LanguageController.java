package cn.iocoder.yudao.module.base.controller.admin.language;

import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.module.base.controller.admin.language.vo.LanguageSimpleRespVO;
import cn.iocoder.yudao.module.base.service.language.LanguageService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - 启用语言")
@RestController
@RequestMapping("/base/language")
@Validated
public class LanguageController {

    @Resource
    private LanguageService languageService;

    @GetMapping("/simple-list")
    @Operation(summary = "获得启用语言精简列表")
    public CommonResult<List<LanguageSimpleRespVO>> getSimpleList(
            @Parameter(description = "0=启用，不传则仅启用")
            @RequestParam(value = "status", required = false) Integer status) {
        Integer queryStatus = status != null ? status : CommonStatusEnum.ENABLE.getStatus();
        return success(languageService.getLanguageSimpleList(queryStatus));
    }

}
