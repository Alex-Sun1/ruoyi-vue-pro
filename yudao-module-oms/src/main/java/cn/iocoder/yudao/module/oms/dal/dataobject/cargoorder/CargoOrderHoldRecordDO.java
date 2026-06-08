package cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;

import java.util.Date;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("oms_cargo_order_hold_record")
public class CargoOrderHoldRecordDO extends TenantBaseDO {

    @TableId
    private Long id;

    private Long cargoOrderId;
    private String cargoOrderNo;
    private Long bizRootId;
    private String holdType;
    private String holdReason;
    private String holdStatus;
    private Date holdTime;
    private Long holdUserId;
    private String holdUserName;
    private String releaseReason;
    private Date releaseTime;
    private Long releaseUserId;
    private String releaseUserName;
    private String remark;
}
