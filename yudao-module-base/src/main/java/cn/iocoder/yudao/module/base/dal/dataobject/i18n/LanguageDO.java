package cn.iocoder.yudao.module.base.dal.dataobject.i18n;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;

@TableName("base_language")
@KeySequence("base_language_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LanguageDO extends TenantBaseDO {

    @TableId
    private Long id;

    private String langCode;

    private String nameEn;

    private String nameNative;

    private Integer status;

    private Integer sortOrder;

}
