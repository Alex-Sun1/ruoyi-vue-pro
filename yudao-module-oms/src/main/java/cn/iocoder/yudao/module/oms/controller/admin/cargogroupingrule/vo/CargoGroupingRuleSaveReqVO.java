package cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule.vo;

import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule.vo.CargoGroupingRuleSaveReqVO;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargogroupingrule.CargoGroupingRuleDO;

@Data
public class CargoGroupingRuleSaveReqVO  {

    @NotNull(message = "主键不能为空")
    private Long id;

    /** 适用仓库 ID 列表，JSON 数组字符串，如 ["9001","9002"]，一条规则可绑定多仓 */
    @NotBlank(message = "仓库不能为空")
    private String warehouseIds;

    /** 仓库名称，逗号分隔，冗余展示用 */
    private String warehouseNames;

    @NotBlank(message = "规则名称不能为空")
    private String ruleName;

    @NotBlank(message = "匹配条件不能为空")
    private String conditionConfig;

    @NotBlank(message = "分组键不能为空")
    private String groupKeyConfig;

    private Integer priority;
    private Integer isDefault;
    private String status;
    private Integer version;
    private String remark;
}
