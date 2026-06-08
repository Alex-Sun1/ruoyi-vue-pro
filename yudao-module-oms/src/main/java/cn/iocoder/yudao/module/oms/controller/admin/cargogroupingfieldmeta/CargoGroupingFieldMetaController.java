package cn.iocoder.yudao.module.oms.controller.admin.cargogroupingfieldmeta;

import jakarta.validation.Valid;

import static cn.iocoder.yudao.framework.apilog.core.enums.OperateTypeEnum.*;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

import org.springframework.security.access.prepost.PreAuthorize;
import jakarta.validation.constraints.NotNull;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.apilog.core.annotation.ApiAccessLog;
import cn.iocoder.yudao.framework.apilog.core.enums.OperateTypeEnum;
import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingfieldmeta.vo.CargoGroupingFieldMetaSaveReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingfieldmeta.vo.CargoGroupingFieldMetaPageReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingfieldmeta.vo.CargoGroupingFieldMetaRespVO;
import cn.iocoder.yudao.module.oms.service.cargogroupingfieldmeta.CargoGroupingFieldMetaService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Validated
@RestController
@RequestMapping("/oms/cargoGroupingFieldMeta")
public class CargoGroupingFieldMetaController  {

    @Resource
    private CargoGroupingFieldMetaService cargoGroupingFieldMetaService;

    @PreAuthorize("@ss.hasPermission('oms:cargoGroupingFieldMeta:list')")
    @GetMapping({"/list", "/page"})
    public CommonResult<List<CargoGroupingFieldMetaRespVO>> list(CargoGroupingFieldMetaPageReqVO bo) {
        bo.setEnabled(1);
        return success(cargoGroupingFieldMetaService.queryList(bo));
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoGroupingFieldMeta:list')")
    @GetMapping("/admin/list")
    public CommonResult<List<CargoGroupingFieldMetaRespVO>> adminList(CargoGroupingFieldMetaPageReqVO bo) {
        return success(cargoGroupingFieldMetaService.queryList(bo));
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoGroupingFieldMeta:query')")
    @GetMapping("/{id}")
    public CommonResult<CargoGroupingFieldMetaRespVO> getInfo(@NotNull(message = "id is required") @PathVariable Long id) {
        return success(cargoGroupingFieldMetaService.queryById(id));
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoGroupingFieldMeta:add')")
    @ApiAccessLog(operateType = CREATE)
        @PostMapping
    public CommonResult<Void> add(@Valid @RequestBody CargoGroupingFieldMetaSaveReqVO bo) {
        cargoGroupingFieldMetaService.insertByBo(bo);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoGroupingFieldMeta:edit')")
    @ApiAccessLog(operateType = UPDATE)
        @PutMapping
    public CommonResult<Void> edit(@Valid @RequestBody CargoGroupingFieldMetaSaveReqVO bo) {
        cargoGroupingFieldMetaService.updateByBo(bo);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoGroupingFieldMeta:edit')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{id}/enable")
    public CommonResult<Void> enable(@PathVariable Long id) {
        cargoGroupingFieldMetaService.enable(id);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoGroupingFieldMeta:edit')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{id}/disable")
    public CommonResult<Void> disable(@PathVariable Long id) {
        cargoGroupingFieldMetaService.disable(id);
        return success(null);
    }
}
