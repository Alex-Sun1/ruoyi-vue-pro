package cn.iocoder.yudao.module.base.controller.admin.shippingline.vo;

import cn.iocoder.yudao.module.base.controller.admin.common.vo.BaseTranslationItemVO;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Schema(description = "管理后台 - 船司 Response VO")
@Data
public class ShippingLineRespVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "船司代码")
    private String code;

    @Schema(description = "英文名称")
    private String nameEn;

    @Schema(description = "当前语言名称")
    private String nameDisplay;

    @Schema(description = "简称")
    private String nameAbbr;

    @Schema(description = "注册国家代码")
    private String countryCode;

    @Schema(description = "国家展示名")
    private String countryName;

    @Schema(description = "联系邮箱")
    private String contactEmail;

    @Schema(description = "联系电话")
    private String contactPhone;

    @Schema(description = "官网")
    private String website;

    @Schema(description = "货物追踪链接")
    private String trackingUrl;

    @Schema(description = "状态")
    private Integer status;

    @Schema(description = "排序")
    private Integer sort;

    @Schema(description = "备注")
    private String remark;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

    @Schema(description = "多语言名称（详情）")
    private List<BaseTranslationItemVO> translations;

}
