package cn.iocoder.yudao.module.yms.dal.dataobject;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardPositionRespVO;

import java.util.Date;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("yms_yard_position")
public class YmsYardPositionDO extends TenantBaseDO {

        @TableId(value = "id")
    private Long id;

    private Long warehouseId;
    private Long zoneId;
    private String zoneCode;

    private String positionCode;
    private String positionName;
    /** CONTAINER_SLOT / EMPTY_CONTAINER_SLOT / TRAILER_SLOT / WAITING_SLOT / BLOCKED_SLOT */
    private String positionType;
    /** FREE / OCCUPIED / RESERVED / DISABLED */
    private String positionStatus;

    private Integer gridRow;
    private Integer gridCol;

    private String occupiedObjectType;
    private Long occupiedObjectId;
    private String occupiedObjectNo;
    private Date occupiedSince;

    private String remark;

    }
