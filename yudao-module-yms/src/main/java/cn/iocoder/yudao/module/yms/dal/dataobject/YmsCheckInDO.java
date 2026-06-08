package cn.iocoder.yudao.module.yms.dal.dataobject;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCheckInRespVO;

import java.util.Date;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("yms_check_in")
public class YmsCheckInDO extends TenantBaseDO {

        @TableId(value = "id")
    private Long id;

    private Long warehouseId;
    /** 签到类型：CONTAINER/TRUCK_TRAILER */
    private String checkInType;
    /** 关联预约单 */
    private Long aptId;
    /** 预约编号（快照） */
    private String aptNo;
    /** 关联园区任务 */
    private Long yardTaskId;
    /** 园区任务号（快照） */
    private String yardTaskNo;
    /** 生成/关联的海柜资源ID */
    private Long containerResourceId;
    /** 生成/关联的车厢资源ID */
    private Long trailerResourceId;

    private String plateNo;
    private String driverName;
    private String driverPhone;
    private String idCardNo;
    private String containerNo;
    private String trailerNo;
    /** 车辆来源（装车签到专用） */
    private String vehicleSource;
    private String taskType;

    /** PENDING / PASSED / REJECTED / BLACKLISTED */
    private String checkResult;
    private String rejectReason;
    /** 匹配方式：APT_MATCH / WALK_IN / MANUAL */
    private String matchType;

    private Date checkInTime;
    /** 离场时间 */
    private Date checkOutTime;
    /** 在场时长（分钟，离场时计算） */
    private Integer stayMinutes;
    /** 离场车牌（可与入场不同，如空柜提走） */
    private String checkOutPlateNo;
    private String checkOutDriverName;
    private String checkOutDriverPhone;
    private String checkOutIdCardNo;
    /** 离场现场照片 URL（JSON 数组） */
    private String checkOutPhotoUrls;
    private Long operatorId;
    private String operatorName;
    private String remark;
    /** 现场照片 URL（JSON 数组） */
    private String photoUrls;
    /** 入场小票号 */
    private String receiptNo;

    /** 登记来源：GATE=门岗操作 / DRIVER_SELF=司机自助 H5 */
    private String checkinSource;
    /** 堆场位或道口ID（门岗分配或司机自报） */
    private Long positionId;
    /** 堆场位或道口编码（快照） */
    private String positionCode;
    /** 与OMS数据不符标记（0=一致 1=不符） */
    private Integer omsMismatchFlag;
    /** 不符字段列表（JSON数组，如["plate_no","driver_name"]） */
    private String omsMismatchFields;

    }
