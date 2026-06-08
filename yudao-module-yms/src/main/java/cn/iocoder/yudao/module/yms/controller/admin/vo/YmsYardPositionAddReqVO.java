package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsYardPositionDO;

@Data
public class YmsYardPositionAddReqVO {

    @NotNull(message = "仓库不能为空")
    private Long warehouseId;

    @NotNull(message = "堆场区不能为空")
    private Long zoneId;

    @NotBlank(message = "位置编码不能为空")
    private String positionCode;

    private String positionName;

    @NotBlank(message = "位置类型不能为空")
    private String positionType;

    private String positionStatus;

    private Integer gridRow;
    private Integer gridCol;
    private String remark;
}
