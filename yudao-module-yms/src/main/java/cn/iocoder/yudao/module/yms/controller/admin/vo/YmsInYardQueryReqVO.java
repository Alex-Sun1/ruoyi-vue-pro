package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.common.pojo.PageParam;

@Data
@EqualsAndHashCode(callSuper = true)
public class YmsInYardQueryReqVO extends PageParam {

    private Long warehouseId;

    /** 对象类型：CONTAINER / TRAILER */
    private String objectType;

    /** 关键字（车牌/柜号/车厢号） */
    private String keyword;

    /** 当前区域：WAITING / YARD / DOCK */
    private String currentArea;
}
