package cn.iocoder.yudao.module.oms.dal.dataobject.cargogroupingrule;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.Version;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule.vo.CargoGroupingRuleRespVO;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("oms_cargo_grouping_rule")
public class CargoGroupingRuleDO extends TenantBaseDO {

    @TableId
    private Long id;

    private String warehouseName;
    private String warehouseIds;
    private String ruleName;
    private String conditionConfig;
    private String groupKeyConfig;
    private Integer priority;
    private Integer isDefault;
    private String status;
    @Version
    private Integer version;
    private String remark;}
