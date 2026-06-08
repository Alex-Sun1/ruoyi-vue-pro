package cn.iocoder.yudao.module.base.controller.admin.platformaddress.vo;

import cn.iocoder.yudao.module.base.controller.admin.common.vo.BaseTranslationItemVO;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Schema(description = "管理后台 - 平台地址新增/修改 Request VO")
@Data
public class PlatformAddressSaveReqVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "平台 ID")
    @NotNull(message = "平台不能为空")
    private Long platformId;

    @Schema(description = "地址编码")
    @NotBlank(message = "地址编码不能为空")
    private String addressCode;

    @Schema(description = "地址类型：1 FBA / 2 门店 / 3 配送中心 / 4 其他")
    @NotNull(message = "地址类型不能为空")
    private Integer addressType;

    @Schema(description = "英文名称")
    @NotBlank(message = "英文名称不能为空")
    private String nameEn;

    @Schema(description = "国家代码")
    @NotBlank(message = "国家代码不能为空")
    private String countryCode;

    @Schema(description = "州省代码")
    private String stateCode;

    @Schema(description = "城市")
    private String city;

    @Schema(description = "地址行1")
    @NotBlank(message = "地址行1不能为空")
    private String addressLine1;

    @Schema(description = "地址行2")
    private String addressLine2;

    @Schema(description = "邮编")
    private String zipCode;

    @Schema(description = "仓库属性，字典 MDM_WH_PROPERTY")
    private String whProperty;

    @Schema(description = "单托 CBM")
    private BigDecimal palletCbm;

    @Schema(description = "是否过磅站：0=否 1=是")
    private Integer isWeighStation;

    @Schema(description = "最高重量(吨)，过磅站=1 时必填")
    private BigDecimal maxWeightTon;

    @Schema(description = "联系人")
    private String contactName;

    @Schema(description = "联系电话")
    private String contactPhone;

    @Schema(description = "备注")
    private String remark;

    @Schema(description = "多语言名称")
    private List<BaseTranslationItemVO> translations;

}
