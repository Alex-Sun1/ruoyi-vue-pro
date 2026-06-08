package cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule.vo;

import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule.vo.CargoGroupingRuleRespVO;

import cn.idev.excel.annotation.ExcelIgnoreUnannotated;
import cn.idev.excel.annotation.ExcelProperty;
import lombok.Data;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargogroupingrule.CargoGroupingRuleDO;

import java.io.Serializable;
import java.util.Date;

@Data
@ExcelIgnoreUnannotated
public class CargoGroupingRuleRespVO implements Serializable {
    private Long id;
    private String tenantId;
    @ExcelProperty("仓库")
    private String warehouseName;
    private String warehouseIds;
    @ExcelProperty("规则名称")
    private String ruleName;
    private String conditionConfig;
    private String groupKeyConfig;
    @ExcelProperty("优先级")
    private Integer priority;
    private Integer isDefault;
    @ExcelProperty("状态")
    private String status;
    private Integer version;
    private String remark;
    private Date createTime;
    private Date updateTime;
}
