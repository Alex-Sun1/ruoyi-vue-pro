-- =============================================
-- YMS Phase 1 final sync
-- Date: 2026-05-30
-- Purpose:
--   1. Keep Phase 1 cleanup idempotent.
--   2. Remove deprecated Phase 1 modules from menu/dict/table level.
--   3. Converge yard arrival task status to ARRIVED.
-- =============================================

SET SQL_SAFE_UPDATES = 0;

-- Deprecated Phase 1 modules: appointment, call rule, blacklist, slot template, yardgo.
DELETE rm
FROM sys_role_menu rm
JOIN sys_menu m ON rm.menu_id = m.menu_id
WHERE m.component IN (
  'yms/appointment/index',
  'yms/appointment-rule/index',
  'yms/appointment-board/index',
  'yms/call-rule/index',
  'yms/blacklist/index',
  'yms/slot-template/index',
  'yms/yardgo/index',
  'yms/waiting-pool/index',
  'yms/exception-center/index',
  'yms/yard-map/index',
  'yms/gate-container-checkin/index',
  'yms/gate-loading-checkin/index'
);

DELETE FROM sys_menu
WHERE component IN (
  'yms/appointment/index',
  'yms/appointment-rule/index',
  'yms/appointment-board/index',
  'yms/call-rule/index',
  'yms/blacklist/index',
  'yms/slot-template/index',
  'yms/yardgo/index',
  'yms/waiting-pool/index',
  'yms/exception-center/index',
  'yms/yard-map/index',
  'yms/gate-container-checkin/index',
  'yms/gate-loading-checkin/index'
);

DROP TABLE IF EXISTS `yms_appointment`;
DROP TABLE IF EXISTS `yms_appointment_rule`;
DROP TABLE IF EXISTS `yms_appointment_rule_slot`;
DROP TABLE IF EXISTS `yms_call_rule`;
DROP TABLE IF EXISTS `yms_call_rule_condition`;
DROP TABLE IF EXISTS `yms_call_rule_sort`;
DROP TABLE IF EXISTS `yms_call_record`;
DROP TABLE IF EXISTS `yms_blacklist`;
DROP TABLE IF EXISTS `yms_slot_template`;
DROP TABLE IF EXISTS `yms_yardgo_task`;

DELETE FROM sys_dict_data
WHERE dict_type IN (
  'yms_appointment_status',
  'yms_appointment_match_type',
  'yms_call_rule_sort_field',
  'yms_call_status',
  'yms_blacklist_type',
  'yms_blacklist_status'
);

DELETE FROM sys_dict_type
WHERE dict_type IN (
  'yms_appointment_status',
  'yms_appointment_match_type',
  'yms_call_rule_sort_field',
  'yms_call_status',
  'yms_blacklist_type',
  'yms_blacklist_status'
);

UPDATE yms_yard_task
SET yard_status = 'ARRIVED'
WHERE yard_status IN ('CONTAINER_ARRIVED', 'VEHICLE_ARRIVED');

UPDATE yms_yard_task_log
SET before_status = 'ARRIVED'
WHERE before_status IN ('CONTAINER_ARRIVED', 'VEHICLE_ARRIVED');

UPDATE yms_yard_task_log
SET after_status = 'ARRIVED'
WHERE after_status IN ('CONTAINER_ARRIVED', 'VEHICLE_ARRIVED');

DELETE FROM sys_dict_data
WHERE dict_type IN ('yms_devanning_status', 'yms_loading_status')
  AND dict_value IN ('CONTAINER_ARRIVED', 'VEHICLE_ARRIVED');

INSERT IGNORE INTO sys_dict_type
(`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `create_dept`, `create_by`, `create_time`, `remark`)
VALUES
(6000003501, '000000', 'YMS拆柜任务状态', 'yms_devanning_status', 103, 1, NOW(), 'YMS拆柜任务状态'),
(6000003502, '000000', 'YMS装车任务状态', 'yms_loading_status', 103, 1, NOW(), 'YMS装车任务状态');

INSERT IGNORE INTO sys_dict_data
(`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `remark`)
VALUES
(6000003511, '000000', 3, '已到仓', 'ARRIVED', 'yms_devanning_status', '', 'info', 'N', 103, 1, NOW(), '统一到仓状态'),
(6000003512, '000000', 3, '已到仓', 'ARRIVED', 'yms_loading_status', '', 'info', 'N', 103, 1, NOW(), '统一到仓状态');

SET SQL_SAFE_UPDATES = 1;
