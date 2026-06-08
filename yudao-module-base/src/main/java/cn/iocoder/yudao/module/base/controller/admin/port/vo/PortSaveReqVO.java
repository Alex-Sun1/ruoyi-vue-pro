package cn.iocoder.yudao.module.base.controller.admin.port.vo;

import cn.iocoder.yudao.module.base.controller.admin.common.vo.BaseTranslationItemVO;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;

@Schema(description = "管理后台 - 港口新增/修改 Request VO")
@Data
public class PortSaveReqVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "港口代码 UN/LOCODE")
    @NotBlank(message = "港口代码不能为空")
    private String portCode;

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

    @Schema(description = "港口类型：1海港 2空港 3内陆港")
    @NotNull(message = "港口类型不能为空")
    private Integer portType;

    @Schema(description = "时区代码")
    private String timezone;

    @Schema(description = "海柜查询链接，须含 {container_no}")
    private String containerQueryUrl;

    @Schema(description = "状态：0=正常 1=停用（仅新增时可传）")
    private Integer status;

    @Schema(description = "备注")
    private String remark;

    @Schema(description = "多语言名称")
    private List<BaseTranslationItemVO> translations;

}
