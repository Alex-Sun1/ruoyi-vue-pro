package cn.iocoder.yudao.module.base.controller.admin.vas.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class ValueAddedServicePageReqVO extends PageParam {

    private String keyword;
    private String serviceCategory;
    private Integer status;

}
