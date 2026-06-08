package cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule.vo;

import lombok.Data;

@Data
public class CargoGroupingRulePageReqVO {
    private String warehouseName;
    private String ruleName;
    private String status;
    /** 兼容参考系统入库计划页参数（单仓） */
    private String warehouseId;
    /**
     * 查询筛选：逗号分隔的仓库 ID（如 9001 或 9001,9002）。
     * 匹配规则表 warehouse_ids JSON 数组是否包含其中任一仓库，与存储格式无关。
     */
    private String warehouseIds;
    /** 支持逗号分隔多选：0/1 */
    private String isDefault;
}
