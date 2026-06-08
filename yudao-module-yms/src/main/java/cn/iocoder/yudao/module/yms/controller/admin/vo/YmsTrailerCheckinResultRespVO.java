package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

/**
 * 装车司机 H5 预登记 — 提交结果
 */
@Data
public class YmsTrailerCheckinResultRespVO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private Boolean success;

    private String message;

    /** 登记流水号（yardTaskNo，供司机凭证展示） */
    private String checkInNo;
}
