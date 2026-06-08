package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class YmsCallRuleSortReqVO {

    private Long id;

    @NotBlank(message = "排序字段不能为空")
    private String sortField;

    @NotBlank(message = "排序方向不能为空")
    private String sortDirection;

    @NotNull(message = "排序优先级不能为空")
    private Integer priorityOrder;
}
