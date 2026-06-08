package cn.iocoder.yudao.module.base.controller.admin.businesstype.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class BusinessTypePageReqVO extends PageParam {

    private String keyword;
    private String businessCategory;
    private String operationFlowType;
    private Integer status;

}
