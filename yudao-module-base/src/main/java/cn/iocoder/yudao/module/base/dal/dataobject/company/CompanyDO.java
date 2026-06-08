package cn.iocoder.yudao.module.base.dal.dataobject.company;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;



@TableName("mdm_company")
@KeySequence("mdm_company_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CompanyDO extends TenantBaseDO {

    @TableId
    private Long id;

    private String companyCode;

    private String companyName;

    private String companyNameEn;

    private String taxNo;

    private Integer status;

    private Integer sort;

    private String remark;

    /** 国家代码 */
    private String countryCode;

    /** 注册地址 */
    private String registeredAddr;

    /** 是否VAT注册（0否1是） */
    private Integer vatRegistered;

    /** 开票抬头 */
    private String invoiceTitle;

    /** 开票税号 */
    private String invoiceTaxNo;

    /** 开票银行 */
    private String invoiceBankName;

    /** 银行账号（脱敏展示） */
    private String bankAccountMasked;

    /** 银行名称 */
    private String bankName;

    /** 银行账号（加密存储） */
    private String bankAccountNo;

    /** SWIFT/BIC代码 */
    private String swiftCode;

    /** 收款人 */
    private String beneficiary;

    /** 结算货币代码 */
    private String currencyCode;

    /** 时区（IANA标准） */
    private String timezone;

    /** 营业执照等附件（JSON数组） */
    private String licenseFiles;

}
