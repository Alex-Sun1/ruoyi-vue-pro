package cn.iocoder.yudao.module.base.controller.admin.platform.vo;

import cn.iocoder.yudao.module.base.controller.admin.common.vo.BaseTranslationItemVO;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Schema(description = "管理后台 - 平台 Response VO")
@Data
public class PlatformRespVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "平台代码")
    private String code;

    @Schema(description = "英文名称")
    private String nameEn;

    @Schema(description = "当前语言名称")
    private String nameDisplay;

    @Schema(description = "平台类型，字典 PLATFORM_TYPE")
    private String typeCode;

    @Schema(description = "Logo OSS 编号")
    private Long logoOssId;

    @Schema(description = "Logo 访问地址")
    private String logoUrl;

    @Schema(description = "状态：0=正常 1=停用")
    private Integer status;

    @Schema(description = "排序")
    private Integer sortOrder;

    @Schema(description = "下属地址数量")
    private Long addressCount;

    @Schema(description = "多语言名称（详情）")
    private List<BaseTranslationItemVO> translations;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

}
