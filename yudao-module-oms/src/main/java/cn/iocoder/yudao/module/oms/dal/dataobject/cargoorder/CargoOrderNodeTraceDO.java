package cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.util.Date;

@Data
@TableName("oms_cargo_order_node_trace")
public class CargoOrderNodeTraceDO {

    @TableId(type = IdType.ASSIGN_ID)
    private Long id;

    private Long cargoOrderId;
    private Long bizRootId;

    private String nodeCode;
    private String nodeName;
    private String nodeStatus;
    private String statusFrom;
    private String statusTo;
    private String action;
    private Date actualTime;
    private String sourceType;
    private String sourceOrderNo;
    private Long operatorId;
    private String operatorName;
    private String remark;

    private Date createTime;
}
