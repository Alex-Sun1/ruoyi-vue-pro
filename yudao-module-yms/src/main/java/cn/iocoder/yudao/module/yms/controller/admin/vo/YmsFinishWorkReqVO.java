package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

/**
 * 完成作业 BO（附带可选的下口目的位置）
 */
@Data
public class YmsFinishWorkReqVO {

    /** 下口目标堆场位 ID（与 toDockId 二选一） */
    private Long toPositionId;
    private String toPositionCode;

    /** 下口目标道口 ID（选填，与 toPositionId 二选一） */
    private Long toDockId;
    private String toDockCode;
}
