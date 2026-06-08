package cn.iocoder.yudao.module.base.controller.admin.country.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

import java.util.List;
import java.util.Map;

@Schema(description = "管理后台 - 国家导入 Response VO")
@Data
@Builder
public class CountryImportRespVO {

    @Schema(description = "创建成功的国家代码")
    private List<String> createCodes;

    @Schema(description = "更新成功的国家代码")
    private List<String> updateCodes;

    @Schema(description = "失败集合，key 为国家代码或行号")
    private Map<String, String> failureCodes;

}
