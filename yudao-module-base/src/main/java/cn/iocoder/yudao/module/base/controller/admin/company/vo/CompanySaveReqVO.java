package cn.iocoder.yudao.module.base.controller.admin.company.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Schema(description = "管理后台 - 主体新增/修改 Request VO")
@Data
public class CompanySaveReqVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "主体编码")
    @NotBlank(message = "主体编码不能为空")
    private String companyCode;

    @Schema(description = "主体名称")
    @NotBlank(message = "主体名称不能为空")
    private String companyName;

    @Schema(description = "英文名称")
    private String companyNameEn;

    @Schema(description = "税号")
    private String taxNo;

    @Schema(description = "状态（仅新增时可传）")
    private Integer status;

    @Schema(description = "排序")
    @NotNull(message = "排序不能为空")
    private Integer sort;

    @Schema(description = "备注")
    private String remark;

    @Schema(description = "国家代码", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotBlank(message = "国家代码不能为空")
    private String countryCode;

    @Schema(description = "注册地址")
    private String registeredAddr;

    @Schema(description = "是否VAT注册（0否1是）")
    private Integer vatRegistered;

    @Schema(description = "开票抬头")
    private String invoiceTitle;

    @Schema(description = "开票税号")
    private String invoiceTaxNo;

    @Schema(description = "开票银行")
    private String invoiceBankName;

    @Schema(description = "银行账号（脱敏展示）")
    private String bankAccountMasked;

    @Schema(description = "银行名称")
    private String bankName;

    @Schema(description = "银行账号（加密存储）")
    private String bankAccountNo;

    @Schema(description = "SWIFT/BIC代码")
    private String swiftCode;

    @Schema(description = "收款人")
    private String beneficiary;

    @Schema(description = "结算货币代码", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotBlank(message = "结算货币代码不能为空")
    private String currencyCode;

    @Schema(description = "时区（IANA标准）", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotBlank(message = "时区不能为空")
    private String timezone;

    @Schema(description = "营业执照等附件（JSON数组）")
    private String licenseFiles;

}
