package cn.iocoder.yudao.module.yms.controller.admin.vo;

import cn.idev.excel.annotation.ExcelIgnoreUnannotated;
import cn.idev.excel.annotation.ExcelProperty;
import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.util.Date;

@Data
@ExcelIgnoreUnannotated
public class YmsTrailerResourceRespVO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long companyId;
    private Long warehouseId;

    @ExcelProperty("车厢号")
    private String trailerNo;

    @ExcelProperty("车头号")
    private String tractorNo;

    @ExcelProperty("车牌号")
    private String plateNo;

    @ExcelProperty("司机姓名")
    private String driverName;

    @ExcelProperty("司机电话")
    private String driverPhone;

    @ExcelProperty("车辆来源")
    private String vehicleSource;

    private Long supplierId;

    @ExcelProperty("供应商名称")
    private String supplierName;

    private Long relatedLoadingTaskId;

    @ExcelProperty("关联单号")
    private String relatedOrderNo;

    private Long bizRootId;

    @ExcelProperty("车厢状态")
    private String trailerStatus;

    private Long yardPositionId;
    private Long yardZoneId;
    private Long dockId;

    @ExcelProperty("Dock编号")
    private String dockCode;

    @ExcelProperty("到仓时间")
    private Date arriveTime;

    @ExcelProperty("装车开始时间")
    private Date loadingStartTime;

    @ExcelProperty("装车完成时间")
    private Date loadingFinishTime;

    @ExcelProperty("离场时间")
    private Date leaveTime;

    @ExcelProperty("WMS备货状态")
    private String wmsReadyStatus;

    private Date wmsReadyTime;

    private Integer exceptionFlag;
    private String exceptionReason;

    @ExcelProperty("备注")
    private String remark;

    @ExcelProperty("创建时间")
    private Date createTime;

    /** 堆场位编码（JOIN） */
    private String positionCode;
    /** 堆场区编码（JOIN） */
    private String zoneCode;
    private String zoneName;
}
