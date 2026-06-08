package cn.iocoder.yudao.module.base.controller.admin.vessel.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;

@Schema(description = "管理后台 - 船舶创建/更新 Request VO")
@Data
public class VesselSaveReqVO {

    private Long id;

    @NotBlank(message = "船舶代码不能为空")
    private String vesselCode;

    @NotBlank(message = "船舶名称不能为空")
    private String vesselName;

    private String vesselNameEn;
    private String imoNo;
    private String mmsi;
    private String callSign;

    @NotNull(message = "所属船司不能为空")
    private Long shippingLineId;

    private String shippingLineCode;
    private String shippingLineName;
    private String vesselType;
    private Integer capacityTeu;
    private BigDecimal lengthM;
    private BigDecimal widthM;
    private Integer buildYear;
    private String flagCountry;
    private Integer status;
    private String remark;

}
