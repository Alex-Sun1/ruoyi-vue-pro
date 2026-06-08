package cn.iocoder.yudao.module.oms.controller.admin.cargogroupingfieldmeta.vo;

import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingfieldmeta.vo.CargoGroupingFieldMetaSaveReqVO;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargogroupingfieldmeta.CargoGroupingFieldMetaDO;

@Data
public class CargoGroupingFieldMetaSaveReqVO  {

    @NotNull(message = "主键不能为空")
    private Long id;

    @NotBlank(message = "表别名不能为空")
    private String tableAlias;

    @NotBlank(message = "字段名不能为空")
    private String fieldName;

    @NotBlank(message = "展示名称不能为空")
    private String displayName;

    @NotBlank(message = "数据类型不能为空")
    private String dataType;

    private String enumCode;
    private String refType;
    private Integer canBeCondition;
    private Integer canBeGroupKey;
    private Integer sortOrder;
    private Integer enabled;
    private String remark;
}
