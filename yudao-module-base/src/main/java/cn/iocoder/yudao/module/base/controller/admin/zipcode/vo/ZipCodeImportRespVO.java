package cn.iocoder.yudao.module.base.controller.admin.zipcode.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

import java.util.List;
import java.util.Map;

@Data
@Builder
public class ZipCodeImportRespVO {

    @Schema(description = "创建成功的键 countryCode:zip")
    private List<String> createKeys;

    @Schema(description = "更新成功的键")
    private List<String> updateKeys;

    @Schema(description = "失败原因")
    private Map<String, String> failureKeys;

}
