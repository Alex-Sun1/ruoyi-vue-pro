package cn.iocoder.yudao.module.oms.dal.dataobject.biz;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;

import java.util.Date;

/**
 * 业务主线根。由货物订单创建，供 OMS/WMS/TMS/BMS 跨模块串联。
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("biz_root")
public class BizRootDO extends TenantBaseDO {

    @TableId(value = "id")
    private Long id;

    private Long companyId;
    private Long warehouseId;
    private String rootNo;
    private String rootType;
    private String sourceModule;
    private Long sourceOrderId;
    private String sourceOrderNo;
    private Long customerId;
    private String customerName;
    private Long channelId;
    private Long businessTypeId;
    private String currentModule;
    private String currentNode;
    private String currentNodeName;
    private Date currentNodeTime;
    private String rootStatus;
    private Integer exceptionFlag;
    private Integer exceptionCount;
    private Date startTime;
    private Date completeTime;
    private Date cancelTime;
    private String remark;}
