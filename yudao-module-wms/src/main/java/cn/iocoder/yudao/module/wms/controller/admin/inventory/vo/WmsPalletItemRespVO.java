package cn.iocoder.yudao.module.wms.controller.admin.inventory.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class WmsPalletItemRespVO {

    private Long id;
    private Long companyId;
    private Long warehouseId;
    private Long palletId;
    private String palletNo;
    private Long cargoOrderId;
    private String cargoOrderNo;
    private String businessTypeName;
    private String containerNo;
    private String groupDestination;
    private String platformName;
    private String platformWarehouseCode;
    private String addressType;
    private Integer holdFlag;
    private Long shipmentId;
    private String shipmentCode;
    private String poNo;
    private String shippingMark;
    private Integer boxQty;
    private Integer availableBoxQty;
    private Integer lockedBoxQty;
    private Integer exceptionBoxQty;
    private BigDecimal weight;
    private BigDecimal cbm;
    private String remark;
    private LocalDateTime createTime;

}
