package cn.iocoder.yudao.module.oms.controller.admin.preoutbound.vo;

import cn.iocoder.yudao.module.oms.controller.admin.preoutbound.vo.PreOutboundItemsReqVO;

import lombok.Data;

import java.util.List;

@Data
public class PreOutboundItemsReqVO {
    private List<Long> cargoOrderIds;
}
