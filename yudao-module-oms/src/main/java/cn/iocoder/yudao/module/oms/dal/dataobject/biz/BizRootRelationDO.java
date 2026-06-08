package cn.iocoder.yudao.module.oms.dal.dataobject.biz;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("oms_biz_root_relation")
public class BizRootRelationDO extends TenantBaseDO {

    @TableId(type = IdType.ASSIGN_ID)
    private Long id;

    private Long bizRootId;
    private Long cargoOrderId;
    private String cargoOrderNo;

    private String targetModule;
    private String targetType;
    private Long targetId;
    private String targetNo;

    private String relationType;
    private String relationStatus;
}
