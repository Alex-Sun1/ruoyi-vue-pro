package cn.iocoder.yudao.module.org.controller.admin.simple;

import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.base.controller.admin.company.vo.CompanyRespVO;
import cn.iocoder.yudao.module.base.controller.admin.warehouse.vo.WarehouseRespVO;
import cn.iocoder.yudao.module.base.dal.dataobject.company.CompanyDO;
import cn.iocoder.yudao.module.base.dal.dataobject.warehouse.WarehouseDO;
import cn.iocoder.yudao.module.base.dal.mysql.company.CompanyMapper;
import cn.iocoder.yudao.module.base.dal.mysql.warehouse.BaseWarehouseMapper;
import cn.iocoder.yudao.module.base.service.company.CompanyService;
import cn.iocoder.yudao.module.org.controller.admin.accessible.vo.OrgCompanyAccessibleRespVO;
import cn.iocoder.yudao.module.org.controller.admin.accessible.vo.OrgWarehouseAccessibleRespVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - 海外仓主数据精简列表（角色配置用）")
@RestController
@Validated
public class OrgMdmSimpleListController {

    @Resource
    private CompanyService companyService;
    @Resource
    private CompanyMapper companyMapper;
    @Resource
    private BaseWarehouseMapper baseWarehouseMapper;

    @GetMapping("/org/company/simple-list")
    @Operation(summary = "租户内启用主体精简列表")
    @PreAuthorize("@ss.hasPermission('system:role:update')")
    public CommonResult<List<OrgCompanyAccessibleRespVO>> getCompanySimpleList() {
        List<CompanyRespVO> list = companyService.getCompanySimpleList(CommonStatusEnum.ENABLE.getStatus());
        return success(BeanUtils.toBean(list, OrgCompanyAccessibleRespVO.class));
    }

    @GetMapping("/org/warehouse/simple-list")
    @Operation(summary = "租户内启用仓库精简列表")
    @Parameter(name = "companyId", description = "主体编号（可选）")
    @PreAuthorize("@ss.hasPermission('system:role:update')")
    public CommonResult<List<OrgWarehouseAccessibleRespVO>> getWarehouseSimpleList(
            @RequestParam(value = "companyId", required = false) Long companyId) {
        List<WarehouseDO> warehouses = companyId == null
                ? baseWarehouseMapper.selectAllEnabledList()
                : baseWarehouseMapper.selectEnabledListByCompanyIds(Set.of(companyId));
        Set<Long> companyIds = warehouses.stream().map(WarehouseDO::getCompanyId).filter(Objects::nonNull).collect(Collectors.toSet());
        Map<Long, CompanyDO> companyMap = companyIds.isEmpty() ? Map.of()
                : companyMapper.selectListByIds(companyIds).stream().collect(Collectors.toMap(CompanyDO::getId, c -> c));
        List<OrgWarehouseAccessibleRespVO> result = warehouses.stream().map(w -> {
            OrgWarehouseAccessibleRespVO vo = BeanUtils.toBean(w, OrgWarehouseAccessibleRespVO.class);
            CompanyDO company = w.getCompanyId() != null ? companyMap.get(w.getCompanyId()) : null;
            if (company != null) {
                vo.setCompanyName(company.getCompanyName());
            }
            return vo;
        }).collect(Collectors.toList());
        return success(result);
    }

}
