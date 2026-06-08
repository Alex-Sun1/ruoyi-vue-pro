package cn.iocoder.yudao.module.wms.controller.admin.devanningorder.vo;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

@Data
public class WmsDevanningOrderSaveReqVO {

    private Long id;
    @NotNull(message = "仓库不能为空")
    private Long warehouseId;
    private Long companyId;
    private Long bizRootId;
    private Long sourceOrderId;
    private String sourceOrderNo;
    private String sourceOrderType;
    @NotBlank(message = "柜号不能为空")
    private String containerNo;
    private Long customerId;
    private String customerName;
    private Long channelId;
    private String channelName;
    private Long customerServiceId;
    private String customerServiceName;
    private Date etaWarehouseTime;
    private Date plannedDevanningTime;
    private String devanningMethod;
    private String devanningRemark;
    private Integer plannedTruckQty;
    private BigDecimal plannedCbm;
    private BigDecimal totalBoxQty;
    private BigDecimal totalWeight;
    private BigDecimal totalCbm;
    private Long dockId;
    private String dockCode;
    private String remark;
    private Integer version;

}
