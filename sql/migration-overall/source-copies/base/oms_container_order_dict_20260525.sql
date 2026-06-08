-- 海柜订单字段字典：拆柜方式 / 装载类型
-- 可重复执行。

INSERT IGNORE INTO `sys_dict_type`
(`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES
(5000110, '000000', '海柜拆柜方式', 'oms_devanning_method', 103, 1, NOW(), NULL, NULL, '海柜订单拆柜方式'),
(5000111, '000000', '海柜装载类型', 'oms_loading_type', 103, 1, NOW(), NULL, NULL, '海柜订单装载类型');

INSERT IGNORE INTO `sys_dict_data`
(`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES
(5000291, '000000', 1, '人工拆柜', 'MANUAL', 'oms_devanning_method', '', 'default', 'N', 103, 1, NOW(), NULL, NULL, ''),
(5000292, '000000', 2, '叉车拆柜', 'FORKLIFT', 'oms_devanning_method', '', 'default', 'N', 103, 1, NOW(), NULL, NULL, ''),
(5000293, '000000', 3, '流水线拆柜', 'CONVEYOR', 'oms_devanning_method', '', 'default', 'N', 103, 1, NOW(), NULL, NULL, ''),
(5000294, '000000', 4, '混合拆柜', 'MIXED', 'oms_devanning_method', '', 'default', 'N', 103, 1, NOW(), NULL, NULL, ''),
(5000311, '000000', 1, '散装', 'FLOOR', 'oms_loading_type', '', 'default', 'N', 103, 1, NOW(), NULL, NULL, ''),
(5000312, '000000', 2, '卡板', 'PALLET', 'oms_loading_type', '', 'default', 'N', 103, 1, NOW(), NULL, NULL, ''),
(5000313, '000000', 3, '混装', 'MIXED', 'oms_loading_type', '', 'default', 'N', 103, 1, NOW(), NULL, NULL, '');

-- Hold 类型（详情页 NSelect: useDict('oms_container_hold_type')）
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

-- 查验类型（详情页 NSelect: useDict('oms_container_exam_type')）
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

-- 执行后校验（应各 >= 4 行）
-- SELECT dict_type, COUNT(*) FROM sys_dict_data WHERE dict_type IN ('oms_container_hold_type','oms_container_exam_type') GROUP BY dict_type;
