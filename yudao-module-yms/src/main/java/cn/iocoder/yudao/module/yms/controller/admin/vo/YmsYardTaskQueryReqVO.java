package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.common.pojo.PageParam;

@Data
@EqualsAndHashCode(callSuper = true)
public class YmsYardTaskQueryReqVO extends PageParam {
    private Long warehouseId;
    private String taskType;
    private String yardStatus;
    /** 综合关键字（任务号/来源单号/柜号/车牌/司机姓名） */
    private String keyword;
    private String containerNo;
    private String truckNo;
    private String sourceOrderNo;
    private String beginGateInTime;
    private String endGateInTime;
    /** 任务分组：DEVANNING / LOADING（前端 Tab 快捷过滤，taskType 有值时优先用 taskType） */
    private String taskGroup;
    /** 时间字段名（eta_yard_time/gate_in_time/dock_start_time/dock_finish_time/release_time/gate_out_time/create_time） */
    private String timeField;
    /** 时间范围起始 */
    private String beginTime;
    /** 时间范围结束 */
    private String endTime;
}
