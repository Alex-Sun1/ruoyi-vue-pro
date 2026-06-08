package cn.iocoder.yudao.module.base.controller.admin.timezone.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

@Schema(description = "管理后台 - 时区 Response VO")
@Data
public class TimezoneRespVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "时区代码")
    private String tzCode;

    @Schema(description = "英文名称")
    private String nameEn;

    @Schema(description = "UTC 偏移")
    private String utcOffset;

    @Schema(description = "所属国家代码")
    private String countryCode;

    @Schema(description = "国家展示名")
    private String countryName;

    @Schema(description = "是否有夏令时：1=有 0=无")
    private Integer isDst;

    @Schema(description = "状态：0=正常 1=停用")
    private Integer status;

    @Schema(description = "排序")
    private Integer sortOrder;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

}
