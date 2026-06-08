package cn.iocoder.yudao.module.base.controller.admin.feeitem.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import java.time.LocalDateTime;


@Schema(description = "管理后台 - 费项 Response VO")
@Data
public class FeeItemRespVO {

    @Schema(description = "编号", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
    private Long id;

    @Schema(description = "fee_code")
    private String feeCode;

    @Schema(description = "fee_name")
    private String feeName;

    @Schema(description = "fee_category")
    private String feeCategory;

    @Schema(description = "business_stage")
    private String businessStage;

    @Schema(description = "business_type")
    private String businessType;

    @Schema(description = "is_system")
    private Integer isSystem;

    @Schema(description = "is_billable")
    private Integer isBillable;

    @Schema(description = "description")
    private String description;

    @Schema(description = "status")
    private Integer status;

    @Schema(description = "sort_order")
    private Integer sortOrder;

    @Schema(description = "remark")
    private String remark;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

}
