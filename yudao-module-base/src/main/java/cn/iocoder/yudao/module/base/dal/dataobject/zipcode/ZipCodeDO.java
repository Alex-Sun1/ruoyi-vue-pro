package cn.iocoder.yudao.module.base.dal.dataobject.zipcode;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;



@TableName("base_zip_code")
@KeySequence("base_zip_code_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ZipCodeDO extends TenantBaseDO {

    @TableId
    private Long id;

    private String countryCode;

    private String stateCode;

    private String cityName;

    private String zip;

}
