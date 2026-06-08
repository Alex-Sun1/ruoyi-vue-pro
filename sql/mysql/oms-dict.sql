-- OMS 系统字典（拆柜状态等）
-- 执行前：SELECT MAX(id) FROM system_dict_type; SELECT MAX(id) FROM system_dict_data;
-- dict_type.id 7200~7209；dict_data.id 72001~72099（快递承运商 72011~72019）

SET NAMES utf8mb4;

INSERT INTO `system_dict_type` (`id`, `name`, `type`, `status`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `deleted_time`) VALUES
(7200, 'OMS 拆柜状态', 'oms_unstuff_status', 0, '海柜 unstuff_status', 'admin', NOW(), 'admin', NOW(), b'0', NULL)
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`), `status` = VALUES(`status`), `remark` = VALUES(`remark`),
    `updater` = VALUES(`updater`), `update_time` = NOW();

INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(72001, 1, '未创建任务', 'NOT_CREATED', 'oms_unstuff_status', 0, 'info', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72002, 2, '拆柜中', 'PROCESSING', 'oms_unstuff_status', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72003, 3, '已完成', 'COMPLETED', 'oms_unstuff_status', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE
    `sort` = VALUES(`sort`), `label` = VALUES(`label`), `value` = VALUES(`value`),
    `dict_type` = VALUES(`dict_type`), `status` = VALUES(`status`), `color_type` = VALUES(`color_type`),
    `updater` = VALUES(`updater`), `update_time` = NOW();

INSERT INTO `system_dict_type` (`id`, `name`, `type`, `status`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `deleted_time`) VALUES
(7201, 'OMS 快递承运商', 'oms_express_carrier', 0, 'cargo_order.express_carrier', 'admin', NOW(), 'admin', NOW(), b'0', NULL)
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`), `status` = VALUES(`status`), `remark` = VALUES(`remark`),
    `updater` = VALUES(`updater`), `update_time` = NOW();

INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(72011, 1, 'UPS', 'UPS', 'oms_express_carrier', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72012, 2, 'FedEx', 'FEDEX', 'oms_express_carrier', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE
    `sort` = VALUES(`sort`), `label` = VALUES(`label`), `value` = VALUES(`value`),
    `dict_type` = VALUES(`dict_type`), `status` = VALUES(`status`), `color_type` = VALUES(`color_type`),
    `updater` = VALUES(`updater`), `update_time` = NOW();
