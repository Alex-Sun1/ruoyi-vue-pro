-- =============================================
-- YMS YardGo 任务流调整
-- 日期：2026-05-31
-- 口径：
--   1. 停车位统一按堆场位理解；
--   2. 院内任务采用司机自领取模式，PENDING = 待领取；
--   3. ASSIGNED 仅作为未来调度派单预留，不作为当前必经状态；
--   4. 上口、换 Dock、下口均通过 YardGo 院内任务执行。
-- =============================================

INSERT INTO sys_dict_type
    (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark)
SELECT 6000003600, '000000', 'YMS院内任务状态', 'yms_internal_task_status', 1, NOW(), 'YardGo院内任务状态'
WHERE NOT EXISTS (
    SELECT 1 FROM sys_dict_type WHERE dict_type = 'yms_internal_task_status'
);

INSERT INTO sys_dict_data
    (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
SELECT 6000003601, '000000', 1, '待领取', 'PENDING', 'yms_internal_task_status', '', 'default', 'Y', 1, NOW(), '等待 YardGo 司机领取'
WHERE NOT EXISTS (
    SELECT 1 FROM sys_dict_data WHERE dict_type = 'yms_internal_task_status' AND dict_value = 'PENDING'
);

INSERT INTO sys_dict_data
    (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
SELECT 6000003602, '000000', 2, '已分配', 'ASSIGNED', 'yms_internal_task_status', '', 'info', 'N', 1, NOW(), '预留状态：未来如启用调度派单，可用于已分配执行人'
WHERE NOT EXISTS (
    SELECT 1 FROM sys_dict_data WHERE dict_type = 'yms_internal_task_status' AND dict_value = 'ASSIGNED'
);

INSERT INTO sys_dict_data
    (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
SELECT 6000003603, '000000', 3, '已领取', 'ACCEPTED', 'yms_internal_task_status', '', 'warning', 'N', 1, NOW(), 'YardGo 司机已领取'
WHERE NOT EXISTS (
    SELECT 1 FROM sys_dict_data WHERE dict_type = 'yms_internal_task_status' AND dict_value = 'ACCEPTED'
);

INSERT INTO sys_dict_data
    (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
SELECT 6000003604, '000000', 4, '执行中', 'IN_PROGRESS', 'yms_internal_task_status', '', 'processing', 'N', 1, NOW(), 'YardGo任务执行中'
WHERE NOT EXISTS (
    SELECT 1 FROM sys_dict_data WHERE dict_type = 'yms_internal_task_status' AND dict_value = 'IN_PROGRESS'
);

INSERT INTO sys_dict_data
    (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
SELECT 6000003605, '000000', 5, '已完成', 'COMPLETED', 'yms_internal_task_status', '', 'success', 'N', 1, NOW(), 'YardGo任务已完成'
WHERE NOT EXISTS (
    SELECT 1 FROM sys_dict_data WHERE dict_type = 'yms_internal_task_status' AND dict_value = 'COMPLETED'
);

INSERT INTO sys_dict_data
    (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
SELECT 6000003606, '000000', 6, '异常', 'FAILED', 'yms_internal_task_status', '', 'error', 'N', 1, NOW(), 'YardGo任务异常'
WHERE NOT EXISTS (
    SELECT 1 FROM sys_dict_data WHERE dict_type = 'yms_internal_task_status' AND dict_value = 'FAILED'
);

INSERT INTO sys_dict_data
    (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
SELECT 6000003607, '000000', 7, '已取消', 'CANCELLED', 'yms_internal_task_status', '', 'default', 'N', 1, NOW(), 'YardGo任务已取消'
WHERE NOT EXISTS (
    SELECT 1 FROM sys_dict_data WHERE dict_type = 'yms_internal_task_status' AND dict_value = 'CANCELLED'
);

UPDATE sys_dict_data
SET dict_label = '待领取',
    list_class = 'default',
    remark = '等待 YardGo 司机领取',
    update_by = 1,
    update_time = NOW()
WHERE dict_type = 'yms_internal_task_status'
  AND dict_value = 'PENDING';

UPDATE sys_dict_data
SET dict_label = '已领取',
    list_class = 'warning',
    remark = 'YardGo 司机已领取',
    update_by = 1,
    update_time = NOW()
WHERE dict_type = 'yms_internal_task_status'
  AND dict_value = 'ACCEPTED';

UPDATE sys_dict_data
SET remark = '预留状态：未来如启用调度派单，可用于已分配执行人',
    update_by = 1,
    update_time = NOW()
WHERE dict_type = 'yms_internal_task_status'
  AND dict_value = 'ASSIGNED';
