package cn.iocoder.yudao.module.base.controller.admin.yardzone.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Schema(description = "管理后台 - 堆场分区分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class YardZonePageReqVO extends PageParam {

    private Long warehouseId;
    private String zoneCode;
    private String zoneName;
    private String zoneType;

}
