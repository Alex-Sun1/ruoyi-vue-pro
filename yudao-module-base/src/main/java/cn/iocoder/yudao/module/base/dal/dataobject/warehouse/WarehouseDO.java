package cn.iocoder.yudao.module.base.dal.dataobject.warehouse;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;

import java.math.BigDecimal;


@TableName("mdm_warehouse")
@KeySequence("mdm_warehouse_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WarehouseDO extends TenantBaseDO {

    @TableId
    private Long id;

    private String warehouseCode;

    private String warehouseName;

    private Long companyId;

    private String timezoneCode;

    private String countryCode;

    private String address;

    private Integer status;

    private Integer sort;

    private String remark;

    /** 仓库类型 */
    private String warehouseType;

    /** 州/省代码 */
    private String stateCode;

    /** 城市 */
    private String city;

    /** 邮编 */
    private String zipCode;

    /** 货币代码 */
    private String currencyCode;

    /** 联系人 */
    private String contactName;

    /** 联系电话 */
    private String contactPhone;

    /** 是否保税仓 */
    private Integer isBonded;

    /** 运营开始时间 */
    private String operationStartTime;

    /** 运营结束时间 */
    private String operationEndTime;

    /** 支持卸货 */
    private Integer supportUnloading;

    /** 支持一件代发 */
    private Integer supportDropship;

    /** 支持中转 */
    private Integer supportTransit;

    /** 支持转仓 */
    private Integer supportTransfer;

    /** 支持FBA */
    private Integer supportFba;

    /** 支持自提 */
    private Integer supportSelfPickup;

    /** 支持预约 */
    private Integer supportAppointment;

    /** 最大容量CBM */
    private BigDecimal maxCapacityCbm;

    /** 日卸货能力 */
    private Integer dailyUnloadingCap;

    /** 日出货能力 */
    private Integer dailyOutboundCap;

    /** 月台数 */
    private Integer dockCount;

    /** 门数 */
    private Integer doorCount;

    /** 叉车数 */
    private Integer forkliftCount;

    /** PDA启用 */
    private Integer pdaEnabled;

    /** API启用 */
    private Integer apiEnabled;

    /** API配置（JSON） */
    private String apiConfig;

}
