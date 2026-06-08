-- ============================================================
-- 堆场主数据收敛方案 B：yard_zone + yard_dock 统一承载堆场位
-- Date: 2026-05-29
-- 说明：
--   1. 新建 BASE 表 yard_zone（自 yms_yard_zone 迁移）
--   2. 扩展 yard_dock 承载堆场位 + YMS 占用状态
--   3. 迁移 yms_yard_position → yard_dock，并回写业务表 ID
--   4. 隐藏 YMS 堆场分区/堆场位管理菜单
-- 执行前请备份 yard_dock、yms_yard_zone、yms_yard_position 及相关业务表
-- ============================================================

-- ── 1. 堆场分区表（BASE） ─────────────────────────────────────
CREATE TABLE IF NOT EXISTS `yard_zone` (
    `id`            BIGINT          NOT NULL                    COMMENT '主键',
    `tenant_id`     VARCHAR(20)     NOT NULL DEFAULT '000000'   COMMENT '租户ID',
    `warehouse_id`  BIGINT          NOT NULL                    COMMENT '仓库ID',
    `zone_code`     VARCHAR(30)     NOT NULL                    COMMENT '分区编码',
    `zone_name`     VARCHAR(100)    NOT NULL                    COMMENT '分区名称',
    `zone_type`     VARCHAR(30)     NOT NULL DEFAULT 'CONTAINER' COMMENT 'CONTAINER/TRUCK/SELF_PICKUP/PARKING',
    `sort_order`    INT             DEFAULT NULL                COMMENT '排序',
    `remark`        VARCHAR(500)    DEFAULT NULL,
    `create_dept`   BIGINT          DEFAULT NULL,
    `create_by`     BIGINT          DEFAULT NULL,
    `create_time`   DATETIME        DEFAULT NULL,
    `update_by`     BIGINT          DEFAULT NULL,
    `update_time`   DATETIME        DEFAULT NULL,
    `deleted`       TINYINT(1)      NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_yard_zone_code_tenant` (`zone_code`, `tenant_id`, `deleted`),
    KEY `idx_yard_zone_warehouse` (`warehouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='堆场分区（BASE主数据）';

-- 自 yms_yard_zone 迁移（保留原 ID）
INSERT INTO `yard_zone` (
    `id`, `tenant_id`, `warehouse_id`, `zone_code`, `zone_name`, `zone_type`,
    `sort_order`, `remark`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `deleted`
)
SELECT
    z.`id`, z.`tenant_id`, z.`warehouse_id`, z.`zone_code`, z.`zone_name`, z.`zone_type`,
    z.`sort_order`, z.`remark`, z.`create_dept`, z.`create_by`, z.`create_time`, z.`update_by`, z.`update_time`, z.`deleted`
FROM `yms_yard_zone` z
WHERE z.`deleted` = 0
  AND NOT EXISTS (SELECT 1 FROM `yard_zone` yz WHERE yz.`id` = z.`id`);

-- ── 2. 扩展 yard_dock ─────────────────────────────────────────
DROP PROCEDURE IF EXISTS patch_yard_dock_slot_columns;
DELIMITER $$
CREATE PROCEDURE patch_yard_dock_slot_columns()
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'yard_dock' AND COLUMN_NAME = 'zone_id'
    ) THEN
        ALTER TABLE `yard_dock`
            ADD COLUMN `zone_id` BIGINT DEFAULT NULL COMMENT '堆场分区ID（yard_zone.id）' AFTER `warehouse_name`,
            ADD COLUMN `zone_code` VARCHAR(30) DEFAULT NULL COMMENT '堆场分区编码（冗余）' AFTER `zone_id`,
            ADD COLUMN `occupied_object_type` VARCHAR(20) DEFAULT NULL COMMENT '占用对象类型 CONTAINER/TRAILER/...' AFTER `dock_status`,
            ADD COLUMN `occupied_object_id` BIGINT DEFAULT NULL COMMENT '占用对象ID' AFTER `occupied_object_type`,
            ADD COLUMN `occupied_object_no` VARCHAR(64) DEFAULT NULL COMMENT '占用对象编号快照' AFTER `occupied_object_id`,
            ADD COLUMN `occupied_since` DATETIME DEFAULT NULL COMMENT '占用开始时间' AFTER `occupied_object_no`,
            ADD COLUMN `legacy_yard_position_id` BIGINT DEFAULT NULL COMMENT '迁移映射：原 yms_yard_position.id' AFTER `occupied_since`;
    END IF;
END$$
DELIMITER ;
CALL patch_yard_dock_slot_columns();
DROP PROCEDURE IF EXISTS patch_yard_dock_slot_columns;

-- ── 3. 字典：扩展位置类型 + 状态 RESERVED ─────────────────────
INSERT IGNORE INTO `sys_dict_data`
    (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `list_class`, `is_default`, `create_by`, `create_time`, `remark`)
VALUES
    (9005202, '000000', 3, '海柜堆位',     'CONTAINER_SLOT',       'yard_location_type', 'primary', 'N', 1, NOW(), 'Container slot'),
    (9005203, '000000', 4, '空柜堆位',     'EMPTY_CONTAINER_SLOT', 'yard_location_type', 'info',    'N', 1, NOW(), 'Empty container slot'),
    (9005204, '000000', 5, '车厢堆位',     'TRAILER_SLOT',         'yard_location_type', 'success', 'N', 1, NOW(), 'Trailer slot'),
    (9005205, '000000', 6, '等待位',       'WAITING_SLOT',         'yard_location_type', 'warning', 'N', 1, NOW(), 'Waiting slot'),
    (9005206, '000000', 7, '禁入位',       'BLOCKED_SLOT',         'yard_location_type', 'error',   'N', 1, NOW(), 'Blocked slot');

INSERT IGNORE INTO `sys_dict_type`
    (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `create_by`, `create_time`, `remark`)
VALUES
    (9005102, '000000', '堆场分区类型', 'yard_zone_type', 1, NOW(), 'Yard zone type');

INSERT IGNORE INTO `sys_dict_data`
    (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `list_class`, `is_default`, `create_by`, `create_time`, `remark`)
VALUES
    (9005220, '000000', 1, '海柜区',   'CONTAINER',   'yard_zone_type', 'primary', 'Y', 1, NOW(), NULL),
    (9005221, '000000', 2, '车厢区',   'TRUCK',       'yard_zone_type', 'success', 'N', 1, NOW(), NULL),
    (9005222, '000000', 3, '自提区',   'SELF_PICKUP', 'yard_zone_type', 'info',    'N', 1, NOW(), NULL),
    (9005223, '000000', 4, '停车区',   'PARKING',     'yard_zone_type', 'default', 'N', 1, NOW(), NULL);

-- ── 4. 迁移 yms_yard_position → yard_dock（新 ID，保留 legacy 映射） ──
INSERT INTO `yard_dock` (
    `id`, `tenant_id`, `dock_code`, `dock_name`, `location_type`,
    `warehouse_id`, `zone_id`, `zone_code`,
    `grid_row`, `grid_col`, `dock_status`, `enabled_flag`, `sort_order`,
    `occupied_object_type`, `occupied_object_id`, `occupied_object_no`, `occupied_since`,
    `legacy_yard_position_id`, `remark`,
    `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`
)
SELECT
    p.`id`,
    p.`tenant_id`,
    p.`position_code`,
    IFNULL(p.`position_name`, p.`position_code`),
    p.`position_type`,
    p.`warehouse_id`,
    p.`zone_id`,
    p.`zone_code`,
    p.`grid_row`,
    p.`grid_col`,
    CASE p.`position_status`
        WHEN 'FREE' THEN 'IDLE'
        WHEN 'OCCUPIED' THEN 'OCCUPIED'
        WHEN 'RESERVED' THEN 'RESERVED'
        ELSE 'DISABLED'
    END,
    CASE WHEN p.`position_status` = 'DISABLED' THEN 0 ELSE 1 END,
    p.`grid_row`,
    p.`occupied_object_type`,
    p.`occupied_object_id`,
    p.`occupied_object_no`,
    p.`occupied_since`,
    p.`id`,
    p.`remark`,
    p.`create_dept`, p.`create_by`, p.`create_time`, p.`update_by`, p.`update_time`, 0
FROM `yms_yard_position` p
WHERE p.`deleted` = 0
  AND NOT EXISTS (SELECT 1 FROM `yard_dock` d WHERE d.id = p.id)
  AND NOT EXISTS (
      SELECT 1 FROM `yard_dock` d
      WHERE d.`legacy_yard_position_id` = p.`id` OR d.`id` = p.`id`
  );

-- 若 yard_dock.id 与 yms_yard_position.id 冲突，改用 legacy 映射更新业务表：
-- （上式使用同 ID；若冲突请手工处理后再执行下方 UPDATE）

-- 回写资源表堆场位 ID（legacy → 新 yard_dock.id）
-- MySQL Workbench Safe Update：必须单表 UPDATE + WHERE 主键 IN；迁移块临时关闭 Safe Update
SET @OLD_SQL_SAFE_UPDATES := @@SQL_SAFE_UPDATES;
SET SQL_SAFE_UPDATES = 0;

UPDATE `yms_container_resource`
SET `yard_position_id` = (
        SELECT d.`id` FROM `yard_dock` d
        WHERE d.`legacy_yard_position_id` = `yms_container_resource`.`yard_position_id`
        LIMIT 1
    ),
    `yard_zone_id` = (
        SELECT d.`zone_id` FROM `yard_dock` d
        WHERE d.`legacy_yard_position_id` = `yms_container_resource`.`yard_position_id`
        LIMIT 1
    )
WHERE `id` IN (
    SELECT `id` FROM (
        SELECT c2.`id`
        FROM `yms_container_resource` c2
        INNER JOIN `yard_dock` d2 ON d2.`legacy_yard_position_id` = c2.`yard_position_id`
        WHERE c2.`yard_position_id` IS NOT NULL
          AND c2.`yard_position_id` <> d2.`id`
    ) AS _container_ids
);

UPDATE `yms_trailer_resource`
SET `yard_position_id` = (
        SELECT d.`id` FROM `yard_dock` d
        WHERE d.`legacy_yard_position_id` = `yms_trailer_resource`.`yard_position_id`
        LIMIT 1
    ),
    `yard_zone_id` = (
        SELECT d.`zone_id` FROM `yard_dock` d
        WHERE d.`legacy_yard_position_id` = `yms_trailer_resource`.`yard_position_id`
        LIMIT 1
    )
WHERE `id` IN (
    SELECT `id` FROM (
        SELECT t2.`id`
        FROM `yms_trailer_resource` t2
        INNER JOIN `yard_dock` d2 ON d2.`legacy_yard_position_id` = t2.`yard_position_id`
        WHERE t2.`yard_position_id` IS NOT NULL
          AND t2.`yard_position_id` <> d2.`id`
    ) AS _trailer_ids
);

UPDATE `yms_internal_task`
SET `from_position_id` = (
        SELECT d.`id` FROM `yard_dock` d
        WHERE d.`legacy_yard_position_id` = `yms_internal_task`.`from_position_id`
        LIMIT 1
    )
WHERE `id` IN (
    SELECT `id` FROM (
        SELECT it2.`id`
        FROM `yms_internal_task` it2
        INNER JOIN `yard_dock` d2 ON d2.`legacy_yard_position_id` = it2.`from_position_id`
        WHERE it2.`from_position_id` IS NOT NULL
          AND it2.`from_position_id` <> d2.`id`
    ) AS _internal_from_ids
);

UPDATE `yms_internal_task`
SET `to_position_id` = (
        SELECT d.`id` FROM `yard_dock` d
        WHERE d.`legacy_yard_position_id` = `yms_internal_task`.`to_position_id`
        LIMIT 1
    )
WHERE `id` IN (
    SELECT `id` FROM (
        SELECT it2.`id`
        FROM `yms_internal_task` it2
        INNER JOIN `yard_dock` d2 ON d2.`legacy_yard_position_id` = it2.`to_position_id`
        WHERE it2.`to_position_id` IS NOT NULL
          AND it2.`to_position_id` <> d2.`id`
    ) AS _internal_to_ids
);

UPDATE `yms_yard_inventory_item`
SET `system_position_id` = (
        SELECT d.`id` FROM `yard_dock` d
        WHERE d.`legacy_yard_position_id` = `yms_yard_inventory_item`.`system_position_id`
        LIMIT 1
    )
WHERE `id` IN (
    SELECT `id` FROM (
        SELECT i2.`id`
        FROM `yms_yard_inventory_item` i2
        INNER JOIN `yard_dock` d2 ON d2.`legacy_yard_position_id` = i2.`system_position_id`
        WHERE i2.`system_position_id` IS NOT NULL
          AND i2.`system_position_id` <> d2.`id`
    ) AS _inv_sys_ids
);

UPDATE `yms_yard_inventory_item`
SET `actual_position_id` = (
        SELECT d.`id` FROM `yard_dock` d
        WHERE d.`legacy_yard_position_id` = `yms_yard_inventory_item`.`actual_position_id`
        LIMIT 1
    )
WHERE `id` IN (
    SELECT `id` FROM (
        SELECT i2.`id`
        FROM `yms_yard_inventory_item` i2
        INNER JOIN `yard_dock` d2 ON d2.`legacy_yard_position_id` = i2.`actual_position_id`
        WHERE i2.`actual_position_id` IS NOT NULL
          AND i2.`actual_position_id` <> d2.`id`
    ) AS _inv_act_ids
);

-- 堆场分区 ID 指向 yard_zone（同 ID 迁移后一般无需变更，兜底同步）
UPDATE `yms_container_resource`
SET `yard_zone_id` = (
        SELECT z.`id` FROM `yard_zone` z
        WHERE z.`id` = `yms_container_resource`.`yard_zone_id`
        LIMIT 1
    )
WHERE `id` IN (
    SELECT `id` FROM (
        SELECT c2.`id`
        FROM `yms_container_resource` c2
        INNER JOIN `yard_zone` z2 ON z2.`id` = c2.`yard_zone_id`
        WHERE c2.`yard_zone_id` IS NOT NULL
    ) AS _container_zone_ids
);

UPDATE `yms_trailer_resource`
SET `yard_zone_id` = (
        SELECT z.`id` FROM `yard_zone` z
        WHERE z.`id` = `yms_trailer_resource`.`yard_zone_id`
        LIMIT 1
    )
WHERE `id` IN (
    SELECT `id` FROM (
        SELECT t2.`id`
        FROM `yms_trailer_resource` t2
        INNER JOIN `yard_zone` z2 ON z2.`id` = t2.`yard_zone_id`
        WHERE t2.`yard_zone_id` IS NOT NULL
    ) AS _trailer_zone_ids
);

SET SQL_SAFE_UPDATES = @OLD_SQL_SAFE_UPDATES;

-- ── 5. BASE 堆场分区菜单（堆场管理 → 堆场分区） ───────────────
-- sys_menu 标准 20 列：与 base_shipping_route_yard_dock / yms_phase2 一致
INSERT IGNORE INTO `sys_menu` VALUES
    (2620, '堆场分区', 2600, 2, 'zone', 'yard/zone/index', '', 1, 0, 'C', '0', '0', 'yard:zone:list', 'grid', 103, 1, NOW(), NULL, NULL, 'Yard zone master');

INSERT IGNORE INTO `sys_menu` VALUES
    (2621, '堆场分区查询', 2620, 1, '#', '', '', 1, 0, 'F', '0', '0', 'yard:zone:query',  '#', 103, 1, NOW(), NULL, NULL, ''),
    (2622, '堆场分区新增', 2620, 2, '#', '', '', 1, 0, 'F', '0', '0', 'yard:zone:add',    '#', 103, 1, NOW(), NULL, NULL, ''),
    (2623, '堆场分区编辑', 2620, 3, '#', '', '', 1, 0, 'F', '0', '0', 'yard:zone:edit',   '#', 103, 1, NOW(), NULL, NULL, ''),
    (2624, '堆场分区删除', 2620, 4, '#', '', '', 1, 0, 'F', '0', '0', 'yard:zone:remove', '#', 103, 1, NOW(), NULL, NULL, '');

-- ── 6. 隐藏 YMS 重复菜单 ─────────────────────────────────────
UPDATE `sys_menu`
SET `visible` = '1',
    `remark` = CONCAT(IFNULL(`remark`, ''), ' [已收敛至BASE yard/zone + yard/dock]')
WHERE `menu_id` IN (
    SELECT `menu_id` FROM (
        SELECT `menu_id` FROM `sys_menu`
        WHERE (`path` IN ('yard-position', 'yms/yard-position', 'zone', 'yms/zone')
               OR `component` IN ('yms/yard-position/index', 'yms/zone/index'))
          AND `menu_type` = 'C'
    ) AS _hide_menu_ids
);

-- 月台设置菜单改名提示（可选）
UPDATE `sys_menu`
SET `menu_name` = '月台与堆位',
    `remark` = CONCAT(IFNULL(`remark`, ''), ' [含道口/停车位/堆场堆位]')
WHERE `menu_id` IN (
    SELECT `menu_id` FROM (
        SELECT `menu_id` FROM `sys_menu`
        WHERE `path` = 'dock' AND `component` = 'yard/dock/index'
        LIMIT 1
    ) AS _dock_menu_ids
);
