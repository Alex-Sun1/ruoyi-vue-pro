package cn.iocoder.yudao.module.yms.dal.dataobject;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import java.util.Date;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("yms_yard_inventory_item")
public class YmsYardInventoryItemDO extends TenantBaseDO {

        @TableId(value = "id")
    private Long id;

    private Long inventoryId;
    /** CONTAINER / TRAILER */
    private String objectType;
    private String objectNo;

    private Long systemPositionId;
    private String systemPositionCode;
    private Long actualPositionId;
    private String actualPositionCode;

    /** PENDING / SCANNED / MISSING / EXTRA */
    private String scanStatus;
    /** MISSING / EXTRA / POSITION_MISMATCH / STATUS_MISMATCH */
    private String diffType;

    private String photoUrls;
    private String remark;
    private Date scanTime;
}
