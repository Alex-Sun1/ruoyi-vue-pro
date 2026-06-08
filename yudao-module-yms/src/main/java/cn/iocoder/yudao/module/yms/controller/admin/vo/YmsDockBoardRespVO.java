package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/** Dock看板VO，包含当前任务和排队任务 */
@Data
public class YmsDockBoardRespVO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private Long id;
    private String dockCode;
    private String dockName;
    private String dockType;
    private String dockLocation;
    private Integer gridRow;
    private Integer gridCol;
    private String dockStatus;
    private Integer enableQueue;
    private Integer maxQueueCount;
    private Integer sortOrder;
    private Integer enabledFlag;

    /** 当前作业任务 */
    private YmsYardTaskRespVO activeTask;

    /** 已分配目标道口、等待 YardGo 上口/换口的任务 */
    private List<YmsYardTaskRespVO> incomingTasks = new ArrayList<>();

    /** 排队中的任务 */
    private List<YmsYardTaskRespVO> queuedTasks = new ArrayList<>();
}
