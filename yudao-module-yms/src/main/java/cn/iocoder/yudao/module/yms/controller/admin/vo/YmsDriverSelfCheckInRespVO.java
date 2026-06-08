package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

/**
 * 司机自助 Check-in 结果 VO（H5 返回给手机端）
 */
@Data
public class YmsDriverSelfCheckInRespVO {

    /** 是否成功 */
    private boolean success;

    /** 提示消息（成功/失败原因） */
    private String message;

    /** 匹配到的任务号（如有） */
    private String yardTaskNo;

    /** 分配的堆场位或道口编码 */
    private String positionCode;

    /** 柜号或车厢号 */
    private String objectNo;
}
