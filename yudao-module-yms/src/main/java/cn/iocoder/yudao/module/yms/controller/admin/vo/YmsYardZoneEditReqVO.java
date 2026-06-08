package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsYardZoneDO;

@Data
public class YmsYardZoneEditReqVO {

    @NotNull(message = "ID不能为空")
    private Long id;

    private Long warehouseId;
    private String zoneCode;
    private String zoneName;
    private String zoneType;
    private Integer sortOrder;
    private String remark;
}
