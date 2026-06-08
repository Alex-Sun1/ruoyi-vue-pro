package cn.iocoder.yudao.module.base.controller.admin.company.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import java.time.LocalDateTime;


@Schema(description = "管理后台 - 主体 Response VO")
@Data
public class CompanyRespVO {

    @Schema(description = "编号", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
    private Long id;

    @Schema(description = "company_code")
    private String companyCode;

    @Schema(description = "company_name")
    private String companyName;

    @Schema(description = "company_name_en")
    private String companyNameEn;

    @Schema(description = "tax_no")
    private String taxNo;

    @Schema(description = "status")
    private Integer status;

    @Schema(description = "sort")
    private Integer sort;

    @Schema(description = "remark")
    private String remark;

    @Schema(description = "国家代码")
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

    @Schema(description = "结算货币代码")
    private String currencyCode;

    @Schema(description = "时区（IANA标准）")
    private String timezone;

    @Schema(description = "营业执照等附件（JSON数组）")
    private String licenseFiles;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

}
