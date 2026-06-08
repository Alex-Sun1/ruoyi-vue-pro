package cn.iocoder.yudao.module.org.controller.admin.pilot.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Schema(description = "管理后台 - 组织权限试点单据分页 Request VO")
@Data
public class OrgScopePilotRecordPageReqVO extends PageParam {

    @Schema(description = "业务单号")
    private String bizCode;

}
