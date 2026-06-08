package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsYardPositionDO;

@Data
@EqualsAndHashCode(callSuper = true)
public class YmsYardPositionEditReqVO extends YmsYardPositionAddReqVO {

    @NotNull(message = "主键不能为空")
    private Long id;
}
