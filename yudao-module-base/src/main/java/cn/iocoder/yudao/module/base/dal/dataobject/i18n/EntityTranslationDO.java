package cn.iocoder.yudao.module.base.dal.dataobject.i18n;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;

@TableName("base_entity_translation")
@KeySequence("base_entity_translation_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class EntityTranslationDO extends TenantBaseDO {

    @TableId
    private Long id;

    private String entityType;

    private Long entityId;

    private String fieldName;

    private String langCode;

    private String value;

}
