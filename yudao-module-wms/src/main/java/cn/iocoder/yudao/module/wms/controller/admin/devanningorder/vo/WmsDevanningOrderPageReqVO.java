package cn.iocoder.yudao.module.wms.controller.admin.devanningorder.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

import java.util.Date;

@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class WmsDevanningOrderPageReqVO extends PageParam {

    private String keyword;
    private String devanningNo;
    private String containerNo;
    private String status;
    private Long warehouseId;
    private Long channelId;
    private Long customerServiceId;
    private Date etaBegin;
    private Date etaEnd;
    private Date arrivalBegin;
    private Date arrivalEnd;
    private Date finishBegin;
    private Date finishEnd;

}
