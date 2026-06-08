package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsContainerResourceDO;

import java.util.Date;

@Data
public class YmsContainerResourceAddReqVO {

    @NotNull(message = "仓库ID不能为空")
    private Long warehouseId;

    private Long companyId;

    @NotBlank(message = "柜号不能为空")
    private String containerNo;

    private String containerType;
    private String carrier;
    private String sealNo;

    private Long relatedOrderId;
    private String relatedOrderNo;
    private Long bizRootId;

    private String emptyStatus;

    private Date etaTime;
    private Date lfdPickup;
    private Date lfdReturn;

    private String tractorNo;
    private String plateNo;
    private String driverName;
    private String driverPhone;

    private String remark;
}
