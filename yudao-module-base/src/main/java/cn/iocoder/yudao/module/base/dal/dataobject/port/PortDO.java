package cn.iocoder.yudao.module.base.dal.dataobject.port;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;



@TableName("base_port")
@KeySequence("base_port_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PortDO extends TenantBaseDO {

    @TableId
    private Long id;

    private String portCode;

    private String nameEn;

    private String countryCode;

    private String stateCode;

    private String city;

    private Integer portType;

    private String timezone;

    private String containerQueryUrl;

    private Integer status;

    private String remark;

}
