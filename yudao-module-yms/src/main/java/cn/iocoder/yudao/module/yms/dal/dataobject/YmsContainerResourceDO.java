package cn.iocoder.yudao.module.yms.dal.dataobject;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsContainerResourceRespVO;

import java.util.Date;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("yms_container_resource")
public class YmsContainerResourceDO extends TenantBaseDO {

        @TableId(value = "id", type = IdType.ASSIGN_ID)
    private Long id;

    private Long companyId;
    private Long warehouseId;

    private String containerNo;
    private String containerType;
    private String carrier;
    private String sealNo;

    private Long relatedOrderId;
    private String relatedOrderNo;
    private Long bizRootId;

    private String containerStatus;
    private String emptyStatus;

    private Long yardPositionId;
    private Long yardZoneId;
    private Long dockId;
    private String dockCode;

    private Date etaTime;
    private Date arrivedTime;
    private Date devanningStartTime;
    private Date devanningFinishTime;
    private Date leaveTime;

    private Date lfdPickup;
    private Date lfdReturn;

    private String tractorNo;
    private String plateNo;
    private String driverName;
    private String driverPhone;

    private Integer exceptionFlag;
    private String exceptionReason;
    private String remark;

    }
