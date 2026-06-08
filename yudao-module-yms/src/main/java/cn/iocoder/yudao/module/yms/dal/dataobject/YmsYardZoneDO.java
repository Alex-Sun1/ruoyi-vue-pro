package cn.iocoder.yudao.module.yms.dal.dataobject;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardZoneRespVO;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("yms_yard_zone")
public class YmsYardZoneDO extends TenantBaseDO {

        @TableId(value = "id")
    private Long id;

    private Long warehouseId;
    private String zoneCode;
    private String zoneName;
    /** CONTAINER / TRUCK / SELF_PICKUP / PARKING */
    private String zoneType;
    private Integer sortOrder;
    private String remark;

    }
