package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class YmsInternalTaskBoardRespVO {

    private String status;
    private String statusLabel;
    private int count;
    private List<YmsInternalTaskRespVO> tasks = new ArrayList<>();
}
