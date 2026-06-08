package cn.iocoder.yudao.module.base.dal.dataobject.terminal;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;

@TableName("base_terminal")
@KeySequence("base_terminal_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TerminalDO extends TenantBaseDO {

    @TableId
    private Long id;
    private String terminalCode;
    private String terminalName;
    private String terminalNameEn;
    private Long portId;
    private String portCode;
    private String portName;
    private String countryCode;
    private String stateCode;
    private String city;
    private String address;
    private String contactPhone;
    private String contactEmail;
    private String website;
    private Integer appointmentSupported;
    private String defaultAppointmentMethod;
    private String defaultReleaseMethod;
    private String timezone;
    private Integer status;
    private String remark;

}
