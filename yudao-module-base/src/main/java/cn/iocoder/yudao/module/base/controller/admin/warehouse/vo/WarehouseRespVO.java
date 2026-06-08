package cn.iocoder.yudao.module.base.controller.admin.warehouse.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Schema(description = "管理后台 - 仓库 Response VO")
@Data
public class WarehouseRespVO {

    private Long id;
    private String warehouseCode;
    private String warehouseName;
    private Long companyId;

    @Schema(description = "归属主体名称")
    private String companyName;

    private String timezoneCode;
    private String countryCode;
    private String address;
    private Integer status;
    private Integer sort;
    private String remark;

    @Schema(description = "仓库类型")
    private String warehouseType;

    @Schema(description = "州/省代码")
    private String stateCode;

    @Schema(description = "城市")
    private String city;

    @Schema(description = "邮编")
    private String zipCode;

    @Schema(description = "货币代码")
    private String currencyCode;

    @Schema(description = "联系人")
    private String contactName;

    @Schema(description = "联系电话")
    private String contactPhone;

    @Schema(description = "是否保税仓")
    private Integer isBonded;

    @Schema(description = "运营开始时间")
    private String operationStartTime;

    @Schema(description = "运营结束时间")
    private String operationEndTime;

    @Schema(description = "支持卸货")
    private Integer supportUnloading;

    @Schema(description = "支持一件代发")
    private Integer supportDropship;

    @Schema(description = "支持中转")
    private Integer supportTransit;

    @Schema(description = "支持转仓")
    private Integer supportTransfer;

    @Schema(description = "支持FBA")
    private Integer supportFba;

    @Schema(description = "支持自提")
    private Integer supportSelfPickup;

    @Schema(description = "支持预约")
    private Integer supportAppointment;

    @Schema(description = "最大容量CBM")
    private BigDecimal maxCapacityCbm;

    @Schema(description = "日卸货能力")
    private Integer dailyUnloadingCap;

    @Schema(description = "日出货能力")
    private Integer dailyOutboundCap;

    @Schema(description = "月台数")
    private Integer dockCount;

    @Schema(description = "门数")
    private Integer doorCount;

    @Schema(description = "叉车数")
    private Integer forkliftCount;

    @Schema(description = "PDA启用")
    private Integer pdaEnabled;

    @Schema(description = "API启用")
    private Integer apiEnabled;

    @Schema(description = "API配置（JSON）")
    private String apiConfig;

    private LocalDateTime createTime;

}
