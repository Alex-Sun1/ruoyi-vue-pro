package cn.iocoder.yudao.module.base.controller.admin.channel.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Schema(description = "Admin - Channel create/update Request VO")
@Data
public class ChannelSaveReqVO {

    private Long id;

    @NotBlank(message = "channelCode cannot be blank")
    private String channelCode;

    @NotBlank(message = "channelName cannot be blank")
    private String channelName;

    @NotBlank(message = "channelType cannot be blank")
    private String channelType;

    private String containerMode;
    private Integer priority;
    private Integer sortOrder;
    private Integer status;
    private String remark;

}
