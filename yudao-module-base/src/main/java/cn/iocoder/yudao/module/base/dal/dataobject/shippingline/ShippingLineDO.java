package cn.iocoder.yudao.module.base.dal.dataobject.shippingline;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;



@TableName("base_shipping_line")
@KeySequence("base_shipping_line_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ShippingLineDO extends TenantBaseDO {

    @TableId
    private Long id;

    private String code;

    private String nameEn;

    private String nameAbbr;

    private String countryCode;

    private String contactEmail;

    private String contactPhone;

    private String website;

    private String trackingUrl;

    private Integer status;

    private Integer sort;

    private String remark;

}
