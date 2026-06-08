package cn.iocoder.yudao.module.base.controller.admin.warehouse.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Schema(description = "管理后台 - 仓库分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class WarehousePageReqVO extends PageParam {

    @Schema(description = "关键字，模糊 warehouse_code / warehouse_name")
    private String keyword;

    @Schema(description = "归属主体 ID")
    private Long companyId;

    @Schema(description = "状态")
    private Integer status;

}
