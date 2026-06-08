package cn.iocoder.yudao.module.base.controller.admin.vessel.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Schema(description = "管理后台 - 船舶分页/选项 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class VesselPageReqVO extends PageParam {

    private String vesselCode;
    private String vesselName;
    private String vesselNameEn;
    private String imoNo;
    private Long shippingLineId;
    private String vesselType;
    private Integer status;
    private String keyword;

}
