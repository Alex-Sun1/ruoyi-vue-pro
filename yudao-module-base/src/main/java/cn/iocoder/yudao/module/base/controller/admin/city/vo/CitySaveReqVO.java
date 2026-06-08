package cn.iocoder.yudao.module.base.controller.admin.city.vo;

import cn.iocoder.yudao.module.base.controller.admin.common.vo.BaseTranslationItemVO;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;

@Schema(description = "管理后台 - 城市新增/修改 Request VO")
@Data
public class CitySaveReqVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "所属国家代码")
    @NotBlank(message = "国家代码不能为空")
    private String countryCode;

    @Schema(description = "所属州省代码")
    @NotBlank(message = "州省代码不能为空")
    private String stateCode;

    @Schema(description = "英文名称")
    @NotBlank(message = "英文名称不能为空")
    private String nameEn;

    @Schema(description = "状态：0=正常 1=停用")
    @NotNull(message = "状态不能为空")
    private Integer status;

    @Schema(description = "多语言名称")
    private List<BaseTranslationItemVO> translations;

}
