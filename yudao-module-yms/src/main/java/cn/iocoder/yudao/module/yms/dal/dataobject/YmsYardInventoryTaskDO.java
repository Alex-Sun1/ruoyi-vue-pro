package cn.iocoder.yudao.module.yms.dal.dataobject;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardInventoryTaskRespVO;

import java.util.Date;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("yms_yard_inventory_task")
public class YmsYardInventoryTaskDO extends TenantBaseDO {

        @TableId(value = "id")
    private Long id;

    private Long warehouseId;
    private String inventoryNo;
    /** ZONE / FULL / CONTAINER_LIST */
    private String inventoryType;
    private Long zoneId;
    private String zoneCode;

    private Integer expectedCount;
    private Integer actualCount;
    private Integer diffCount;
    /** PENDING / IN_PROGRESS / COMPLETED / DIFF_FOUND */
    private String status;

    private Date startTime;
    private Date finishTime;
    private Long operatorId;
    private String operatorName;
    private String remark;

    }
