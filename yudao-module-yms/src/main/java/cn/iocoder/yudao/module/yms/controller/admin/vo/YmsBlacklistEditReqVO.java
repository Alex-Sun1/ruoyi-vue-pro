package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsBlacklistDO;

import java.util.Date;

@Data
public class YmsBlacklistEditReqVO {

    @NotNull(message = "ID不能为空")
    private Long id;

    private String reason;
    private Date expireTime;
    private String status;
    private String remark;
}
