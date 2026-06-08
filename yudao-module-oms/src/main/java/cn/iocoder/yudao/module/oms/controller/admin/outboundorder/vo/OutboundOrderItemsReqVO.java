package cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo;

import lombok.Data;

import java.util.List;

@Data
public class OutboundOrderItemsReqVO {
    private List<Long> cargoOrderIds;
}
