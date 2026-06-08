package cn.iocoder.yudao.module.yms.controller.admin.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.util.Date;

@Data
public class YmsYardTaskLogRespVO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long yardTaskId;
    private String actionType;
    private String beforeStatus;
    private String afterStatus;
    private String actionContent;
    private Long operatorId;
    private String operatorName;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date actionTime;
}
