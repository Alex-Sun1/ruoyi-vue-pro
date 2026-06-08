package cn.iocoder.yudao.module.base.controller.admin.packaging.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Schema(description = "管理后台 - 包装分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class PackagingPageReqVO extends PageParam {

    @Schema(description = "关键字，模糊 pkg_code / pkg_name")
    private String keyword;

    @Schema(description = "包装类型 1-5")
    private Integer pkgType;

    @Schema(description = "状态")
    private Integer status;

}
