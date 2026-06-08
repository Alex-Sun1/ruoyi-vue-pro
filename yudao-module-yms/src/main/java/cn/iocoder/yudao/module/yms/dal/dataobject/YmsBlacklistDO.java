package cn.iocoder.yudao.module.yms.dal.dataobject;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsBlacklistRespVO;

import java.util.Date;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("yms_blacklist")
public class YmsBlacklistDO extends TenantBaseDO {

        @TableId(value = "id")
    private Long id;

    /** 拦截类型：PLATE_NO / DRIVER_PHONE */
    private String targetType;
    /** 拦截值（车牌号或司机电话） */
    private String targetValue;
    private String reason;
    private Date blacklistTime;
    private Date expireTime;
    /** ACTIVE / EXPIRED / REMOVED */
    private String status;
    private Long operatorId;
    private String operatorName;
    private String remark;

    }
