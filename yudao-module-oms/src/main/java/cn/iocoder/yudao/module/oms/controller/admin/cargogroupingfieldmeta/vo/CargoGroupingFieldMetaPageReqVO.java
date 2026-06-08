package cn.iocoder.yudao.module.oms.controller.admin.cargogroupingfieldmeta.vo;

import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingfieldmeta.vo.CargoGroupingFieldMetaPageReqVO;

import lombok.Data;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import lombok.EqualsAndHashCode;
import lombok.ToString;
import lombok.EqualsAndHashCode;
@Data
public class CargoGroupingFieldMetaPageReqVO  {
    private String tableAlias;
    private String fieldName;
    private String displayName;
    private Integer canBeCondition;
    private Integer canBeGroupKey;
    private Integer enabled;
}
