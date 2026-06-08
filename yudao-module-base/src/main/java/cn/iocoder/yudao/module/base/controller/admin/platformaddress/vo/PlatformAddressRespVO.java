package cn.iocoder.yudao.module.base.controller.admin.platformaddress.vo;

import cn.iocoder.yudao.module.base.controller.admin.common.vo.BaseTranslationItemVO;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Schema(description = "管理后台 - 平台地址 Response VO")
@Data
public class PlatformAddressRespVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "平台 ID")
    private Long platformId;

    @Schema(description = "平台代码")
    private String platformCode;

    @Schema(description = "平台展示名")
    private String platformName;

    @Schema(description = "地址编码")
    private String addressCode;

    @Schema(description = "地址类型")
    private Integer addressType;

    @Schema(description = "英文名称")
    private String nameEn;

    @Schema(description = "当前语言名称")
    private String nameDisplay;

    @Schema(description = "国家代码")
    private String countryCode;

    @Schema(description = "国家展示名")
    private String countryName;

    @Schema(description = "州省代码")
    private String stateCode;

    @Schema(description = "州省展示名")
    private String stateName;

    @Schema(description = "城市")
    private String city;

    @Schema(description = "地址行1")
    private String addressLine1;

    @Schema(description = "地址行2")
    private String addressLine2;

    @Schema(description = "邮编")
    private String zipCode;

    @Schema(description = "仓库属性")
    private String whProperty;

    @Schema(description = "单托 CBM")
    private BigDecimal palletCbm;

    @Schema(description = "是否过磅站")
    private Integer isWeighStation;

    @Schema(description = "最高重量(吨)")
    private BigDecimal maxWeightTon;

    @Schema(description = "联系人")
    private String contactName;

    @Schema(description = "联系电话")
    private String contactPhone;

    @Schema(description = "最后核验时间")
    private LocalDateTime lastVerifiedAt;

    @Schema(description = "状态：0=正常 1=停用")
    private Integer status;

    @Schema(description = "备注")
    private String remark;

    @Schema(description = "多语言名称（详情）")
    private List<BaseTranslationItemVO> translations;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

}
