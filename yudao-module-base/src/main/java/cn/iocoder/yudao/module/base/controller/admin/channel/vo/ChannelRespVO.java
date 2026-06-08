package cn.iocoder.yudao.module.base.controller.admin.channel.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

@Schema(description = "Admin - Channel Response VO")
@Data
public class ChannelRespVO {

    private Long id;
    private String channelCode;
    private String channelName;
    private String channelType;
    private String containerMode;
    private Integer priority;
    private Integer sortOrder;
    private Integer status;
    private String remark;
    private LocalDateTime createTime;

}
