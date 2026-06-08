package cn.iocoder.yudao.module.base.controller.admin.yarddock.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;

@Schema(description = "管理后台 - 月台创建/更新 Request VO")
@Data
public class YardDockSaveReqVO {

    private Long id;

    @NotBlank(message = "月台编码不能为空")
    private String dockCode;

    @NotBlank(message = "月台名称不能为空")
    private String dockName;

    @NotBlank(message = "位置类型不能为空")
    private String locationType;

    @NotNull(message = "所属仓库不能为空")
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
