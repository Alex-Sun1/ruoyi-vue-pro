package cn.iocoder.yudao.module.base.controller.admin.client.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Schema(description = "管理后台 - 客户精简 Response VO（占位，待客户模块上线）")
@Data
public class BaseClientSimpleRespVO {

    @Schema(description = "客户编号")
    private Long id;

    @Schema(description = "客户编码")
    private String clientCode;

    @Schema(description = "客户名称")
    private String clientName;

}
