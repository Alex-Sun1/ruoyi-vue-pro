package cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo;

import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderShipmentSaveReqVO;

import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderSaveReqVO;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder.CargoOrderDO;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Data
public class CargoOrderSaveReqVO {

    @NotNull(message = "ID不能为空")
    private Long id;

    private String cargoOrderNo;
    private String externalOrderNo;
    private String orderSource;

    @NotNull(message = "客户不能为空")
    private Long customerId;

    @NotBlank(message = "客户名称不能为空")
    private String customerName;

    private Long businessTypeId;
    private String businessTypeName;
    private Long channelId;
    private String channelName;
    private Long platformId;
    private String platformName;
    private Long customerServiceId;
    private String customerServiceName;

    private Long inboundWarehouseId;
    private String inboundWarehouseName;

    private String addressType;
    private String platformWarehouseCode;
    private String consigneeName;
    private String addressLine1;
    private String addressLine2;
    private String city;
    private String state;
    private String zipCode;
    private String country;
    private String contactName;
    private String contactPhone;
    private String contactEmail;

    private String parcelCarrierName;
    private String parcelTrackingNo;

    private Integer transferFlag;
    private String transferWarehouseCode;
    private String forecastQtyUnit;

    private BigDecimal declaredCartonQty;
    private BigDecimal declaredPalletQty;
    private BigDecimal declaredPieceQty;
    private BigDecimal declaredWeight;
    private BigDecimal declaredCbm;

    private String weightUnit;
    private String volumeUnit;

    private Date eta;
    private Date ata;

    private String customerRemark;
    private String internalRemark;
    private String operationRemark;

    @Valid
    private List<CargoOrderShipmentSaveReqVO> shipments = new ArrayList<>();
}
