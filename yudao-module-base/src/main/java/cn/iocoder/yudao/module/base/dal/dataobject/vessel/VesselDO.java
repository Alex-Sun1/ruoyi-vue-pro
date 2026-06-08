package cn.iocoder.yudao.module.base.dal.dataobject.vessel;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;

import java.math.BigDecimal;

@TableName("base_vessel")
@KeySequence("base_vessel_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VesselDO extends TenantBaseDO {

    @TableId
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

}
