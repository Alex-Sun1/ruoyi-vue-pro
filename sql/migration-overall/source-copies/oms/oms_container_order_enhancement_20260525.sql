-- ============================================================
-- 海柜订单字段增强：可提时间 / 要求到仓时间 / Hold&查验字典
-- Date: 2026-05-25
-- 说明：可重复执行
-- ============================================================

-- 1. 新增字段
SET @need_available := (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'oms_container_order'
    AND COLUMN_NAME = 'available_time'
);

SET @add_available_sql := IF(
  @need_available = 0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `available_time` datetime DEFAULT NULL COMMENT ''可提时间（海柜Available）'' AFTER `empty_return_lfd`',
  'SELECT ''available_time 列已存在，跳过'' AS msg'
);
PREPARE stmt FROM @add_available_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @need_required_arrival := (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'oms_container_order'
    AND COLUMN_NAME = 'required_arrival_time'
);

SET @add_required_arrival_sql := IF(
  @need_required_arrival = 0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `required_arrival_time` datetime DEFAULT NULL COMMENT ''要求到仓时间'' AFTER `expected_arrival_time`',
  'SELECT ''required_arrival_time 列已存在，跳过'' AS msg'
);
PREPARE stmt FROM @add_required_arrival_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2. Hold 类型字典
INSERT IGNORE INTO `sys_dict_type`
(`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES
(5000112, '000000', '海柜Hold类型', 'oms_container_hold_type', 103, 1, NOW(), NULL, NULL, '海柜订单Hold类型');

INSERT IGNORE INTO `sys_dict_data`
(`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES
(5000321, '000000', 1, '海关Hold', 'CUSTOMS', 'oms_container_hold_type', '', 'error', 'N', 103, 1, NOW(), NULL, NULL, ''),
(5000322, '000000', 2, '船公司Hold', 'CARRIER', 'oms_container_hold_type', '', 'warning', 'N', 103, 1, NOW(), NULL, NULL, ''),
(5000323, '000000', 3, '码头Hold', 'TERMINAL', 'oms_container_hold_type', '', 'warning', 'N', 103, 1, NOW(), NULL, NULL, ''),
(5000324, '000000', 4, '费用Hold', 'FEE', 'oms_container_hold_type', '', 'default', 'N', 103, 1, NOW(), NULL, NULL, '');

-- 3. 查验类型字典
INSERT IGNORE INTO `sys_dict_type`
(`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES
(5000113, '000000', '海柜查验类型', 'oms_container_exam_type', 103, 1, NOW(), NULL, NULL, '海柜订单查验类型');

INSERT IGNORE INTO `sys_dict_data`
(`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES
(5000331, '000000', 1, 'X-Ray', 'X_RAY', 'oms_container_exam_type', '', 'default', 'N', 103, 1, NOW(), NULL, NULL, ''),
(5000332, '000000', 2, 'Tailgate', 'TAILGATE', 'oms_container_exam_type', '', 'default', 'N', 103, 1, NOW(), NULL, NULL, ''),
(5000333, '000000', 3, 'Intensive', 'INTENSIVE', 'oms_container_exam_type', '', 'warning', 'N', 103, 1, NOW(), NULL, NULL, ''),
(5000334, '000000', 4, 'CES', 'CES', 'oms_container_exam_type', '', 'default', 'N', 103, 1, NOW(), NULL, NULL, '');
