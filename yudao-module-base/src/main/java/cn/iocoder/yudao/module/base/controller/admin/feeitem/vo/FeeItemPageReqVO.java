package cn.iocoder.yudao.module.base.controller.admin.feeitem.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Schema(description = "管理后台 - 费项分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class FeeItemPageReqVO extends PageParam {

    @Schema(description = "关键字，模糊 fee_code / fee_name")
    private String keyword;

    @Schema(description = "费用分类，字典 FEE_CATEGORY")
    private String feeCategory;

    @Schema(description = "业务阶段，字典 FEE_BUSINESS_STAGE")
    private String businessStage;

    @Schema(description = "适用业务类型，字典 FULFILLMENT_TYPE；空字符串表示通用")
    private String businessType;

    @Schema(description = "状态：0正常 1停用")
    private Integer status;

}
