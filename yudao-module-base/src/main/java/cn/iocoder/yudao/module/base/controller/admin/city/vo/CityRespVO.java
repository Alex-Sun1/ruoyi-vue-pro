package cn.iocoder.yudao.module.base.controller.admin.city.vo;

import cn.iocoder.yudao.module.base.controller.admin.common.vo.BaseTranslationItemVO;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Schema(description = "管理后台 - 城市 Response VO")
@Data
public class CityRespVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "所属国家代码")
    private String countryCode;

    @Schema(description = "所属州省代码")
    private String stateCode;

    @Schema(description = "英文名称")
    private String nameEn;

    @Schema(description = "状态：0=正常 1=停用")
    private Integer status;

    @Schema(description = "国家展示名")
    private String countryName;

    @Schema(description = "州省展示名")
    private String stateName;

    @Schema(description = "当前语言城市名")
    private String nameDisplay;

    @Schema(description = "多语言名称（详情）")
    private List<BaseTranslationItemVO> translations;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

}
