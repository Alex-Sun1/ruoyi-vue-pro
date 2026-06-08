package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.util.Date;

@Data
public class YmsExceptionRespVO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    /** 来源类型：CHECK_IN / TASK / CONTAINER / TRAILER */
    private String sourceType;

    /** 关联记录ID */
    private Long refId;

    /** 异常类型编码 */
    private String exceptionType;

    /** 关联对象展示 */
    private String objectLabel;

    /** 异常描述 */
    private String message;

    /** 状态：OPEN / PROCESSING / RESOLVED */
    private String status;

    /** 仓库ID */
    private Long warehouseId;

    private Date createTime;
}
