package cn.iocoder.yudao.module.base.controller.admin.yarddock.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

@Schema(description = "管理后台 - 月台 Response VO")
@Data
public class YardDockRespVO {

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
    private LocalDateTime createTime;

}
