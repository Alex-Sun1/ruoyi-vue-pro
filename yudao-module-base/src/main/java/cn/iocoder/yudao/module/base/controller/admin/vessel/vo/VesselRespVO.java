package cn.iocoder.yudao.module.base.controller.admin.vessel.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Schema(description = "管理后台 - 船舶 Response VO")
@Data
public class VesselRespVO {

    private Long id;
    private String vesselCode;
    private String vesselName;
    private String vesselNameEn;
    private String imoNo;
    private String mmsi;
    private String callSign;
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
    private LocalDateTime createTime;

}
