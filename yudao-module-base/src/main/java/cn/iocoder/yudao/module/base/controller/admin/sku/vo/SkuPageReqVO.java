package cn.iocoder.yudao.module.base.controller.admin.sku.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Schema(description = "管理后台 - SKU 分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class SkuPageReqVO extends PageParam {

    @Schema(description = "客户 ID")
    private Long clientId;

    @Schema(description = "关键字，模糊 sku_code / sku_name / barcode")
    private String keyword;

    @Schema(description = "状态")
    private Integer status;

    @Schema(description = "易碎 1=是")
    private Integer isFragile;

    @Schema(description = "液体 1=是")
    private Integer isLiquid;

    @Schema(description = "带电 1=是")
    private Integer isBattery;

    @Schema(description = "带磁 1=是")
    private Integer isMagnetic;

    @Schema(description = "危险品 1=是")
    private Integer isDangerous;

    @Schema(description = "超大件 1=是")
    private Integer isOversize;

}
