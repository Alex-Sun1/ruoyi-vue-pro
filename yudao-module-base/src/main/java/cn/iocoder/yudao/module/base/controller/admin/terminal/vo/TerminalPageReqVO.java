package cn.iocoder.yudao.module.base.controller.admin.terminal.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Schema(description = "管理后台 - 码头分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class TerminalPageReqVO extends PageParam {

    private String terminalCode;
    private String terminalName;
    private Long portId;
    private String defaultReleaseMethod;
    private Integer appointmentSupported;
    private Integer status;

}
