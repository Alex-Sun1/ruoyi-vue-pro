package cn.iocoder.yudao.module.base.controller.admin.shippingline.vo;

import cn.iocoder.yudao.module.base.controller.admin.common.vo.BaseTranslationItemVO;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.util.List;

@Schema(description = "管理后台 - 船司新增/修改 Request VO")
@Data
public class ShippingLineSaveReqVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "船司代码")
    @NotBlank(message = "船司代码不能为空")
    private String code;

    @Schema(description = "英文名称")
    @NotBlank(message = "英文名称不能为空")
    private String nameEn;

    @Schema(description = "简称")
    private String nameAbbr;

    @Schema(description = "注册国家代码")
    private String countryCode;

    @Schema(description = "联系邮箱")
    private String contactEmail;

    @Schema(description = "联系电话")
    private String contactPhone;

    @Schema(description = "官网")
    private String website;

    @Schema(description = "货物追踪链接，须含 {container_no}")
    private String trackingUrl;

    @Schema(description = "状态：0=正常 1=停用（仅新增时可传）")
    private Integer status;

    @Schema(description = "排序")
    private Integer sort;

    @Schema(description = "备注")
    private String remark;

    @Schema(description = "多语言名称")
    private List<BaseTranslationItemVO> translations;

}
