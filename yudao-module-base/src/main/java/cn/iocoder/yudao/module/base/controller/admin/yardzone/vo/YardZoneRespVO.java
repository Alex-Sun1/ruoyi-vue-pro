package cn.iocoder.yudao.module.base.controller.admin.yardzone.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

@Schema(description = "管理后台 - 堆场分区 Response VO")
@Data
public class YardZoneRespVO {

    private Long id;
    private Long warehouseId;
    private String zoneCode;
    private String zoneName;
    private String zoneType;
    private Integer sortOrder;
    private String remark;
    private LocalDateTime createTime;

}
