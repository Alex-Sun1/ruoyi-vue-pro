package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

import java.io.Serializable;

@Data
public class YmsOverviewTrendRespVO implements Serializable {

    private int hour;
    private int checkInCount;
}
