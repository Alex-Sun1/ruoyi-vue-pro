package cn.iocoder.yudao.module.base.controller.admin.terminal.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

@Schema(description = "管理后台 - 码头 Response VO")
@Data
public class TerminalRespVO {

    private Long id;
    private String terminalCode;
    private String terminalName;
    private String terminalNameEn;
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
    private LocalDateTime createTime;

}
