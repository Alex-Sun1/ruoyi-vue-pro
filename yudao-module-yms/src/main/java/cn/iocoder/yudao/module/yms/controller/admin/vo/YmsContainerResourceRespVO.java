package cn.iocoder.yudao.module.yms.controller.admin.vo;

import cn.idev.excel.annotation.ExcelIgnoreUnannotated;
import cn.idev.excel.annotation.ExcelProperty;
import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.util.Date;

@Data
@ExcelIgnoreUnannotated
public class YmsContainerResourceRespVO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private Long id;

    @ExcelProperty("主体ID")
    private Long companyId;

    @ExcelProperty("仓库ID")
    private Long warehouseId;

    @ExcelProperty("柜号")
    private String containerNo;

    @ExcelProperty("柜型")
    private String containerType;

    @ExcelProperty("船司")
    private String carrier;

    @ExcelProperty("封条号")
    private String sealNo;

    private Long relatedOrderId;

    @ExcelProperty("关联订单号")
    private String relatedOrderNo;

    private Long bizRootId;

    @ExcelProperty("柜状态")
    private String containerStatus;

    @ExcelProperty("重空状态")
    private String emptyStatus;

    private Long yardPositionId;
    private Long yardZoneId;
    private Long dockId;

    @ExcelProperty("Dock编号")
    private String dockCode;

    @ExcelProperty("预计到仓时间")
    private Date etaTime;

    @ExcelProperty("实际到达时间")
    private Date arrivedTime;

    @ExcelProperty("拆柜开始时间")
    private Date devanningStartTime;

    @ExcelProperty("拆柜完成时间")
    private Date devanningFinishTime;

    @ExcelProperty("离场时间")
    private Date leaveTime;

    @ExcelProperty("提柜LFD")
    private Date lfdPickup;

    @ExcelProperty("还柜LFD")
    private Date lfdReturn;

    @ExcelProperty("车头号")
    private String tractorNo;

    @ExcelProperty("车牌号")
    private String plateNo;

    @ExcelProperty("司机姓名")
    private String driverName;

    @ExcelProperty("司机电话")
    private String driverPhone;

    private Integer exceptionFlag;
    private String exceptionReason;

    @ExcelProperty("备注")
    private String remark;

    @ExcelProperty("创建时间")
    private Date createTime;

    /** 堆场位编码（关联查询冗余） */
    private String positionCode;
    /** 堆场区编码（关联查询冗余） */
    private String zoneCode;
    /** 堆场区名称 */
    private String zoneName;
}
