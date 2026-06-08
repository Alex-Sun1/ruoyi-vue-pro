package cn.iocoder.yudao.module.base.controller.admin.port.vo;

import cn.iocoder.yudao.module.base.controller.admin.common.vo.BaseTranslationItemVO;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Schema(description = "管理后台 - 港口 Response VO")
@Data
public class PortRespVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "港口代码")
    private String portCode;

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

    @Schema(description = "港口类型")
    private Integer portType;

    @Schema(description = "时区代码")
    private String timezone;

    @Schema(description = "海柜查询链接")
    private String containerQueryUrl;

    @Schema(description = "状态")
    private Integer status;

    @Schema(description = "备注")
    private String remark;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

    @Schema(description = "多语言名称（详情）")
    private List<BaseTranslationItemVO> translations;

}
