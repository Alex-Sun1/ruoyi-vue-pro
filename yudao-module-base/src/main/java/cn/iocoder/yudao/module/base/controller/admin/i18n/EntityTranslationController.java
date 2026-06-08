package cn.iocoder.yudao.module.base.controller.admin.i18n;

import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.module.base.controller.admin.i18n.vo.EntityTranslationRespVO;
import cn.iocoder.yudao.module.base.controller.admin.i18n.vo.EntityTranslationSaveBatchReqVO;
import cn.iocoder.yudao.module.base.service.i18n.EntityTranslationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - 实体多语言")
@RestController
@RequestMapping("/base/entity-translation")
@Validated
public class EntityTranslationController {

    @Resource
    private EntityTranslationService entityTranslationService;

    @GetMapping("/list")
    @Operation(summary = "查询实体翻译列表")
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<List<EntityTranslationRespVO>> getList(
            @RequestParam("entityType") String entityType,
            @RequestParam("entityId") Long entityId,
            @RequestParam(value = "fieldName", required = false) String fieldName) {
        return success(entityTranslationService.getTranslationList(entityType, entityId, fieldName));
    }

    @PostMapping("/save-batch")
    @Operation(summary = "批量保存实体翻译")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    public CommonResult<Boolean> saveBatch(@Valid @RequestBody EntityTranslationSaveBatchReqVO reqVO) {
        entityTranslationService.saveTranslationBatch(reqVO);
        return success(true);
    }

}
