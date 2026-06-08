package cn.iocoder.yudao.module.base.controller.admin.feeitem.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Schema(description = "管理后台 - 费项新增/修改 Request VO")
@Data
public class FeeItemSaveReqVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "费项代码")
    @NotBlank(message = "费项代码不能为空")
    private String feeCode;

    @Schema(description = "费项名称")
    @NotBlank(message = "费项名称不能为空")
    private String feeName;

    @Schema(description = "费用分类，字典 FEE_CATEGORY")
    @NotBlank(message = "费用分类不能为空")
    private String feeCategory;

    @Schema(description = "业务阶段，字典 FEE_BUSINESS_STAGE")
    @NotBlank(message = "业务阶段不能为空")
    private String businessStage;

    @Schema(description = "适用业务类型，字典 FULFILLMENT_TYPE；空=通用")
    private String businessType;

    @Schema(description = "是否可计费：0否 1是")
    @NotNull(message = "是否可计费不能为空")
    private Integer isBillable;

    @Schema(description = "说明")
    private String description;

    @Schema(description = "状态：0=正常 1=停用（仅新增时可传）")
    private Integer status;

    @Schema(description = "排序")
    private Integer sortOrder;

    @Schema(description = "备注")
    private String remark;

}
