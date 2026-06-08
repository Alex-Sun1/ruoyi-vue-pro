package cn.iocoder.yudao.module.wms.controller.admin.inventory.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class WmsPalletPageReqVO extends PageParam {

    private Long warehouseId;
    private Long locationId;
    private Long cargoOrderId;
    private Long shipmentId;
    private String keyword;
    private String palletStatus;
    /** ACTIVE=在库+已出单，OUTBOUND=已出库，ALL=全部 */
    private String scope;

}
