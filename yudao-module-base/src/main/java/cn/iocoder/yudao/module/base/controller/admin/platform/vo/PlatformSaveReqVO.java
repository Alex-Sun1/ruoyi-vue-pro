package cn.iocoder.yudao.module.base.controller.admin.platform.vo;

import cn.iocoder.yudao.module.base.controller.admin.common.vo.BaseTranslationItemVO;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.util.List;

@Schema(description = "管理后台 - 平台新增/修改 Request VO")
@Data
public class PlatformSaveReqVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "平台代码")
    @NotBlank(message = "平台代码不能为空")
    private String code;

    @Schema(description = "英文名称")
    @NotBlank(message = "英文名称不能为空")
    private String nameEn;

    @Schema(description = "平台类型，字典 PLATFORM_TYPE")
    @NotBlank(message = "平台类型不能为空")
    private String typeCode;

    @Schema(description = "Logo OSS 编号（上传回写，编辑可保留原值）")
    private Long logoOssId;

    @Schema(description = "Logo 访问地址")
    private String logoUrl;

    @Schema(description = "状态：0=正常 1=停用（仅新增时可传）")
    private Integer status;

    @Schema(description = "排序")
    private Integer sortOrder;

    @Schema(description = "多语言名称")
    private List<BaseTranslationItemVO> translations;

}
