package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class YmsCallRuleEditReqVO extends YmsCallRuleAddReqVO {

    @NotNull(message = "ID不能为空")
    private Long id;
}
