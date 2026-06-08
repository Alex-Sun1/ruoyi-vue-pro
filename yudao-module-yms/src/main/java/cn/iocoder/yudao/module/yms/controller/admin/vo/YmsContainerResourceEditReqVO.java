package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsContainerResourceDO;

import java.util.Date;

@Data
public class YmsContainerResourceEditReqVO {

    @NotNull(message = "ID不能为空")
    private Long id;

    private String containerType;
    private String carrier;
    private String sealNo;
    private String emptyStatus;

    private Date etaTime;
    private Date lfdPickup;
    private Date lfdReturn;

    private String tractorNo;
    private String plateNo;
    private String driverName;
    private String driverPhone;

    private Long relatedOrderId;
    private String relatedOrderNo;

    private String remark;
}
