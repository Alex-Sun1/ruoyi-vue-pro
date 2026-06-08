package cn.iocoder.yudao.module.base.controller.admin.yardzone.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Schema(description = "管理后台 - 堆场分区创建/更新 Request VO")
@Data
public class YardZoneSaveReqVO {

    private Long id;

    @NotNull(message = "所属仓库不能为空")
    private Long warehouseId;

    @NotBlank(message = "分区编码不能为空")
    private String zoneCode;

    @NotBlank(message = "分区名称不能为空")
    private String zoneName;

    private String zoneType;
    private Integer sortOrder;
    private String remark;

}
