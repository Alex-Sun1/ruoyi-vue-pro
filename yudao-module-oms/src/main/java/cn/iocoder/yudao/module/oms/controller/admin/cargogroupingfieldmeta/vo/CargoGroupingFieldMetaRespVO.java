package cn.iocoder.yudao.module.oms.controller.admin.cargogroupingfieldmeta.vo;

import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingfieldmeta.vo.CargoGroupingFieldMetaRespVO;

import cn.idev.excel.annotation.ExcelIgnoreUnannotated;
import cn.idev.excel.annotation.ExcelProperty;
import lombok.Data;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargogroupingfieldmeta.CargoGroupingFieldMetaDO;

import java.io.Serializable;
import java.util.Date;

@Data
@ExcelIgnoreUnannotated
public class CargoGroupingFieldMetaRespVO implements Serializable {
    private Long id;
    @ExcelProperty("表别名")
    private String tableAlias;
    @ExcelProperty("字段名")
    private String fieldName;
    @ExcelProperty("展示名称")
    private String displayName;
    private String dataType;
    private String enumCode;
    private String refType;
    private Integer canBeCondition;
    private Integer canBeGroupKey;
    private Integer sortOrder;
    private Integer enabled;
    private String remark;
    private Date createTime;
    private Date updateTime;
}
