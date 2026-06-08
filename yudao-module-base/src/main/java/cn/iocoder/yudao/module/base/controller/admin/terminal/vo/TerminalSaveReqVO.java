package cn.iocoder.yudao.module.base.controller.admin.terminal.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Schema(description = "管理后台 - 码头创建/更新 Request VO")
@Data
public class TerminalSaveReqVO {

    private Long id;

    @NotBlank(message = "码头代码不能为空")
    private String terminalCode;

    @NotBlank(message = "码头名称不能为空")
    private String terminalName;

    private String terminalNameEn;

    @NotNull(message = "所属港口不能为空")
    private Long portId;

    private String portCode;
    private String portName;
    private String countryCode;
    private String stateCode;
    private String city;
    private String address;
    private String contactPhone;
    private String contactEmail;
    private String website;
    private Integer appointmentSupported;
    private String defaultAppointmentMethod;
    private String defaultReleaseMethod;
    private String timezone;
    private Integer status;
    private String remark;

}
