package cn.iocoder.yudao.module.yms.dal.dataobject;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsSlotTemplateRespVO;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("yms_slot_template")
public class YmsSlotTemplateDO extends TenantBaseDO {

        @TableId(value = "id")
    private Long id;

    private Long warehouseId;
    /** 0=周日,1=周一,...,6=周六；多个用逗号 */
    private String weekdays;
    /** 时间段开始，格式 HH:mm */
    private String slotStart;
    /** 时间段结束，格式 HH:mm */
    private String slotEnd;
    /** 该时段最大预约数量 */
    private Integer capacity;
    /** CONTAINER / TRUCK / ALL */
    private String taskType;
    private Integer enabled;
    private String remark;

    }
