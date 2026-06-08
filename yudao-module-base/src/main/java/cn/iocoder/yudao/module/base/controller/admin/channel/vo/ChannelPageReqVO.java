package cn.iocoder.yudao.module.base.controller.admin.channel.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Schema(description = "Admin - Channel page Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class ChannelPageReqVO extends PageParam {

    private String keyword;
    private String channelType;
    private String containerMode;
    private Integer status;

}
