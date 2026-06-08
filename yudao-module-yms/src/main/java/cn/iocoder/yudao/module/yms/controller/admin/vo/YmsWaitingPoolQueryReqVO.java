package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.common.pojo.PageParam;

@Data
@EqualsAndHashCode(callSuper = true)
public class YmsWaitingPoolQueryReqVO extends PageParam {

    private Long warehouseId;

    /** 等待类型：CONTAINER / LOADING / RENTED_TRAILER */
    private String waitType;

    /** 关键字（柜号/车牌/车厢号） */
    private String keyword;
}
