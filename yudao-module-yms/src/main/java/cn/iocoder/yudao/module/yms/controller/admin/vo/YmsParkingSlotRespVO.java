package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

/**
 * 堆场位简要信息 VO（H5 下拉选择用）
 */
@Data
public class YmsParkingSlotRespVO {

    private Long id;
    private String dockCode;
    private String dockName;
    private String zoneCode;
    private String zoneName;
    /** 状态：IDLE=空闲 OCCUPIED=占用 */
    private String dockStatus;
}
