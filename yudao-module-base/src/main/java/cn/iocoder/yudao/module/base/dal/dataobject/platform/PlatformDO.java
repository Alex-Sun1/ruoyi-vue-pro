package cn.iocoder.yudao.module.base.dal.dataobject.platform;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;



@TableName("base_platform")
@KeySequence("base_platform_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PlatformDO extends TenantBaseDO {

    @TableId
    private Long id;

    private String code;

    private String nameEn;

    private String typeCode;

    private Long logoOssId;

    private String logoUrl;

    private Integer status;

    private Integer sortOrder;

}
