package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

@Data
public class YmsAppointmentBoardSlotRespVO implements Serializable {

    private String slotLabel;
    private String startTime;
    private String endTime;
    private int capacity;
    private int used;
    private int remaining;
    private List<YmsAppointmentRespVO> appointments;
}
