package cn.iocoder.yudao.module.oms.dal.dataobject.cargogroupingfieldmeta;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingfieldmeta.vo.CargoGroupingFieldMetaRespVO;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("oms_cargo_grouping_field_meta")
public class CargoGroupingFieldMetaDO extends TenantBaseDO {

    @TableId
    private Long id;

    private String tableAlias;
    private String fieldName;
    private String displayName;
    private String dataType;
    private String enumCode;
    private String refType;
    private Integer canBeCondition;
    private Integer canBeGroupKey;
    private Integer sortOrder;
    private Integer enabled;
    private String remark;
}
