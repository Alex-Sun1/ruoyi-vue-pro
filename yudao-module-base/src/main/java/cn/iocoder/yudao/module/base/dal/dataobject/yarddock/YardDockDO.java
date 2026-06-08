package cn.iocoder.yudao.module.base.dal.dataobject.yarddock;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

@TableName("yard_dock")
@Data
@EqualsAndHashCode(callSuper = true)
public class YardDockDO extends TenantBaseDO {

    @TableId
    private Long id;
    private String dockCode;
    private String dockName;
    private String locationType;
    private Long warehouseId;
    private String warehouseCode;
    private String warehouseName;
    private Long zoneId;
    private String zoneCode;
    private Long businessTypeId;
    private String businessTypeCode;
    private String businessTypeName;
    private String dockLocation;
    private Integer gridRow;
    private Integer gridCol;
    private String allowedVehicleTypes;
    private Integer appointmentSupported;
    private Integer maxConcurrent;
    private String dockStatus;
    private String occupiedObjectType;
    private Long occupiedObjectId;
    private String occupiedObjectNo;
    private LocalDateTime occupiedSince;
    private Integer enabledFlag;
    private Integer sortOrder;
    private Integer dispatchPriority;
    private String dockType;
    private Integer enableQueue;
    private Integer maxQueueCount;
    private String remark;
}
