package cn.iocoder.yudao.module.base.controller.admin.yarddock.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Schema(description = "管理后台 - 月台分页/查询 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class YardDockPageReqVO extends PageParam {

    private String dockCode;
    private String dockName;
    private Long warehouseId;
    private Long zoneId;
    private String locationType;
    private Long businessTypeId;
    private String dockLocation;
    private String dockStatus;
    private Integer enabledFlag;

}
