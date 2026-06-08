package cn.iocoder.yudao.module.yms.dal.dataobject;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsTrailerResourceRespVO;

import java.util.Date;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("yms_trailer_resource")
public class YmsTrailerResourceDO extends TenantBaseDO {

        @TableId(value = "id", type = IdType.ASSIGN_ID)
    private Long id;

    private Long companyId;
    private Long warehouseId;

    private String trailerNo;
    private String tractorNo;
    private String plateNo;
    private String driverName;
    private String driverPhone;
    private String driverIdNo;

    private String vehicleSource;
    private Long supplierId;
    private String supplierName;

    private Long relatedLoadingTaskId;
    private String relatedOrderNo;
    private Long bizRootId;

    private String trailerStatus;

    private Long yardPositionId;
    private Long yardZoneId;
    private Long dockId;
    private String dockCode;

    private Date arriveTime;
    private Date loadingStartTime;
    private Date loadingFinishTime;
    private Date leaveTime;

    private String wmsReadyStatus;
    private Date wmsReadyTime;

    private Integer exceptionFlag;
    private String exceptionReason;
    private String remark;

    }
