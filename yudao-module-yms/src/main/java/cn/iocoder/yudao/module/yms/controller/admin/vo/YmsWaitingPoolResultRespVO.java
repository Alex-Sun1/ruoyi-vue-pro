package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.util.List;

@Data
public class YmsWaitingPoolResultRespVO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    /** 等待海柜数 */
    private int waitContainerCount;

    /** 等待装车车辆数 */
    private int waitLoadingCount;

    /** 等待租赁车厢数 */
    private int waitRentedTrailerCount;

    /** 超时等待数（等待超过120分钟） */
    private int timeoutCount;

    private List<YmsWaitingPoolRespVO> list;
}
