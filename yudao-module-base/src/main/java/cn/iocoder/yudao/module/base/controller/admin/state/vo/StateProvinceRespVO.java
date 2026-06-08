package cn.iocoder.yudao.module.base.controller.admin.state.vo;

import cn.iocoder.yudao.module.base.controller.admin.common.vo.BaseTranslationItemVO;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Schema(description = "管理后台 - 州/省 Response VO")
@Data
public class StateProvinceRespVO {

    private Long id;

    private String countryCode;

    @Schema(description = "国家展示名")
    private String countryName;

    private String code;

    private String nameEn;

    @Schema(description = "当前语言展示名")
    private String nameDisplay;

    private Integer sortOrder;

    private Integer status;

    @Schema(description = "城市数量")
    private Long cityCount;

    @Schema(description = "邮编数量")
    private Long zipCodeCount;

    private LocalDateTime createTime;

    private List<BaseTranslationItemVO> translations;

}
