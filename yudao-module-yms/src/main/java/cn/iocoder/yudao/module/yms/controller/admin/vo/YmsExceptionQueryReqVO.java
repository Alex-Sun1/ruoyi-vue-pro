package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.common.pojo.PageParam;

@Data
@EqualsAndHashCode(callSuper = true)
public class YmsExceptionQueryReqVO extends PageParam {

    private Long warehouseId;

    /** CHECK_IN / TASK / CONTAINER / TRAILER */
    private String sourceType;

    /** 异常类型 */
    private String exceptionType;

    /** OPEN / PROCESSING / RESOLVED */
    private String status;

    private String keyword;
}
