package cn.iocoder.yudao.module.base.dal.dataobject.platformaddress;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@TableName("base_platform_address")
@KeySequence("base_platform_address_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PlatformAddressDO extends TenantBaseDO {

    @TableId
    private Long id;

    private Long platformId;

    private String addressCode;

    private Integer addressType;

    private String nameEn;

    private String countryCode;

    private String stateCode;

    private String city;

    private String addressLine1;

    private String addressLine2;

    private String zipCode;

    private String contactName;

    private String contactPhone;

    private LocalDateTime lastVerifiedAt;

    private String whProperty;

    private BigDecimal palletCbm;

    private Integer isWeighStation;

    private BigDecimal maxWeightTon;

    private Integer status;

    private String remark;

}
