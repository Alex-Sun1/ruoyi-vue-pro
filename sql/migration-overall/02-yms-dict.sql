-- YMS 系统字典（芋道 / ruoyi-vue-pro 格式）
-- 执行前：SELECT MAX(id) FROM system_dict_type; SELECT MAX(id) FROM system_dict_data;
-- 本脚本 dict_type.id 7300~7317；dict_data.id 73001~73199
-- 若 type 已存在请先删除或调整 ID 段

SET NAMES utf8mb4;

-- ========== 字典类型 ==========
INSERT INTO `system_dict_type` (`id`, `name`, `type`, `status`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `deleted_time`) VALUES
(7300, 'YMS月台类型', 'yms_dock_type', 0, 'YMS月台/Dock类型', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7301, 'YMS月台状态', 'yms_dock_status', 0, 'YMS月台运行状态', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7302, '海柜状态', 'yms_container_status', 0, '海柜在园区的状态', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7303, '海柜柜型', 'yms_container_type', 0, '海柜柜型', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7304, '重空状态', 'yms_empty_status', 0, '重柜/空柜状态', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7305, '车厢状态', 'yms_trailer_status', 0, '车厢在园区的状态', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7306, '车辆来源', 'yms_vehicle_source', 0, '车辆/车厢来源类型', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7307, '堆场位类型', 'yms_position_type', 0, '堆场位位置类型', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7308, '堆场位状态', 'yms_position_status', 0, '堆场位占用状态', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7309, '院内任务类型', 'yms_internal_task_type', 0, '院内任务类型', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7310, '院内任务状态', 'yms_internal_task_status', 0, 'YardGo院内任务状态', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7311, '园区任务类型', 'yms_task_type', 0, 'YMS园区任务类型', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7312, '拆柜任务状态', 'yms_devanning_status', 0, '拆柜园区任务状态', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7313, '装车任务状态', 'yms_loading_status', 0, '装车园区任务状态', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7314, '堆场分区类型', 'yms_zone_type', 0, 'YMS堆场分区类型', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7315, 'YMS预约状态', 'yms_appointment_status', 0, 'YMS预约状态', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7316, 'YMS签到结果', 'yms_check_result', 0, 'YMS门卫签到检查结果', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7317, 'YardGo机器人状态', 'yms_robot_status', 0, 'YardGo机器人任务状态', 'admin', NOW(), 'admin', NOW(), b'0', NULL)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `remark` = VALUES(`remark`), `updater` = 'admin', `update_time` = NOW();

-- ========== yms_dock_type ==========
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(73001, 1, '海柜拆柜Dock', 'CONTAINER_DOCK', 'yms_dock_type', 0, 'primary', '', '专用海柜拆柜Dock', 'admin', NOW(), 'admin', NOW(), b'0'),
(73002, 2, '装车Dock', 'TRUCK_DOCK', 'yms_dock_type', 0, 'success', '', '普通装车Dock', 'admin', NOW(), 'admin', NOW(), b'0'),
(73003, 3, '自提Dock', 'SELF_PICKUP_DOCK', 'yms_dock_type', 0, 'info', '', '自提专用Dock', 'admin', NOW(), 'admin', NOW(), b'0'),
(73004, 4, '混合Dock', 'MIXED_DOCK', 'yms_dock_type', 0, 'warning', '', '混合使用Dock', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`), `sort` = VALUES(`sort`), `color_type` = VALUES(`color_type`), `updater` = 'admin', `update_time` = NOW();

-- ========== yms_dock_status ==========
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(73011, 1, '空闲', 'IDLE', 'yms_dock_status', 0, 'success', '', '可分配', 'admin', NOW(), 'admin', NOW(), b'0'),
(73012, 2, '已预占', 'RESERVED', 'yms_dock_status', 0, 'warning', '', '已分配待使用', 'admin', NOW(), 'admin', NOW(), b'0'),
(73013, 3, '作业中', 'OCCUPIED', 'yms_dock_status', 0, 'primary', '', '正在作业', 'admin', NOW(), 'admin', NOW(), b'0'),
(73014, 4, '维修', 'MAINTENANCE', 'yms_dock_status', 0, 'danger', '', '维修中', 'admin', NOW(), 'admin', NOW(), b'0'),
(73015, 5, '停用', 'CLOSED', 'yms_dock_status', 0, 'default', '', '已停用', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`), `sort` = VALUES(`sort`), `color_type` = VALUES(`color_type`), `updater` = 'admin', `update_time` = NOW();

-- ========== yms_container_status ==========
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(73021, 1, '预计到仓', 'EXPECTED_ARRIVAL', 'yms_container_status', 0, 'default', '', '尚未到达', 'admin', NOW(), 'admin', NOW(), b'0'),
(73022, 2, '运输中', 'IN_TRANSIT', 'yms_container_status', 0, 'info', '', '在途', 'admin', NOW(), 'admin', NOW(), b'0'),
(73023, 3, '已到园区', 'ARRIVED', 'yms_container_status', 0, 'primary', '', '已签到', 'admin', NOW(), 'admin', NOW(), b'0'),
(73024, 4, '已甩柜', 'DROPPED', 'yms_container_status', 0, 'warning', '', '甩柜等待', 'admin', NOW(), 'admin', NOW(), b'0'),
(73025, 5, '等待拆柜', 'WAIT_DEVANNING', 'yms_container_status', 0, 'warning', '', '在等待队列中', 'admin', NOW(), 'admin', NOW(), b'0'),
(73026, 6, '已上口', 'ON_DOCK', 'yms_container_status', 0, 'primary', '', '已到Dock', 'admin', NOW(), 'admin', NOW(), b'0'),
(73027, 7, '拆柜中', 'DEVANNING', 'yms_container_status', 0, 'primary', '', 'WMS作业中', 'admin', NOW(), 'admin', NOW(), b'0'),
(73028, 8, '拆柜完成', 'DEVANNED', 'yms_container_status', 0, 'success', '', '拆柜已完成', 'admin', NOW(), 'admin', NOW(), b'0'),
(73029, 9, '空柜待还', 'EMPTY_WAIT_RETURN', 'yms_container_status', 0, 'warning', '', '等待还柜', 'admin', NOW(), 'admin', NOW(), b'0'),
(73030, 10, '已还柜', 'RETURNED', 'yms_container_status', 0, 'success', '', '已还柜', 'admin', NOW(), 'admin', NOW(), b'0'),
(73031, 11, '已离园', 'LEFT_YARD', 'yms_container_status', 0, 'default', '', '已离场', 'admin', NOW(), 'admin', NOW(), b'0'),
(73032, 12, '异常', 'EXCEPTION', 'yms_container_status', 0, 'danger', '', '异常状态', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`), `sort` = VALUES(`sort`), `color_type` = VALUES(`color_type`), `updater` = 'admin', `update_time` = NOW();

-- ========== yms_container_type / yms_empty_status ==========
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(73041, 1, '40HQ', '40HQ', 'yms_container_type', 0, 'primary', '', '40尺高柜', 'admin', NOW(), 'admin', NOW(), b'0'),
(73042, 2, '45HQ', '45HQ', 'yms_container_type', 0, 'success', '', '45尺高柜', 'admin', NOW(), 'admin', NOW(), b'0'),
(73043, 3, '53FT', '53FT', 'yms_container_type', 0, 'info', '', '53尺平柜', 'admin', NOW(), 'admin', NOW(), b'0'),
(73044, 4, '20GP', '20GP', 'yms_container_type', 0, 'default', '', '20尺标准柜', 'admin', NOW(), 'admin', NOW(), b'0'),
(73045, 5, '40GP', '40GP', 'yms_container_type', 0, 'default', '', '40尺标准柜', 'admin', NOW(), 'admin', NOW(), b'0'),
(73051, 1, '重柜', 'FULL', 'yms_empty_status', 0, 'primary', '', '有货重柜', 'admin', NOW(), 'admin', NOW(), b'0'),
(73052, 2, '空柜', 'EMPTY', 'yms_empty_status', 0, 'default', '', '空柜', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`), `sort` = VALUES(`sort`), `color_type` = VALUES(`color_type`), `updater` = 'admin', `update_time` = NOW();

-- ========== yms_trailer_status / yms_vehicle_source ==========
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(73061, 1, '预计到仓', 'EXPECTED_ARRIVAL', 'yms_trailer_status', 0, 'default', '', '尚未到达', 'admin', NOW(), 'admin', NOW(), b'0'),
(73062, 2, '空车厢已到', 'ARRIVED_EMPTY', 'yms_trailer_status', 0, 'info', '', '空车厢到仓', 'admin', NOW(), 'admin', NOW(), b'0'),
(73063, 3, '等待装车', 'WAIT_LOADING', 'yms_trailer_status', 0, 'warning', '', '在等待队列', 'admin', NOW(), 'admin', NOW(), b'0'),
(73064, 4, '已上口', 'ON_DOCK', 'yms_trailer_status', 0, 'primary', '', '已到Dock', 'admin', NOW(), 'admin', NOW(), b'0'),
(73065, 5, '装车中', 'LOADING', 'yms_trailer_status', 0, 'primary', '', 'WMS装车中', 'admin', NOW(), 'admin', NOW(), b'0'),
(73066, 6, '装车完成', 'LOADED', 'yms_trailer_status', 0, 'success', '', '装车已完成', 'admin', NOW(), 'admin', NOW(), b'0'),
(73067, 7, '等待提走', 'WAIT_PICKUP', 'yms_trailer_status', 0, 'warning', '', '等待车头提走', 'admin', NOW(), 'admin', NOW(), b'0'),
(73068, 8, '已离场', 'LEFT_YARD', 'yms_trailer_status', 0, 'default', '', '已离场', 'admin', NOW(), 'admin', NOW(), b'0'),
(73069, 9, '异常', 'EXCEPTION', 'yms_trailer_status', 0, 'danger', '', '异常状态', 'admin', NOW(), 'admin', NOW(), b'0'),
(73071, 1, '供应商车辆', 'SUPPLIER_TRUCK', 'yms_vehicle_source', 0, 'primary', '', '供应商自带车头+车厢', 'admin', NOW(), 'admin', NOW(), b'0'),
(73072, 2, '租赁车厢', 'RENTED_TRAILER', 'yms_vehicle_source', 0, 'info', '', '我方租赁车厢', 'admin', NOW(), 'admin', NOW(), b'0'),
(73073, 3, '自有车厢', 'OWN_TRAILER', 'yms_vehicle_source', 0, 'success', '', '自有车厢', 'admin', NOW(), 'admin', NOW(), b'0'),
(73074, 4, '临时车辆', 'TEMP_TRUCK', 'yms_vehicle_source', 0, 'warning', '', '临时外部车辆', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`), `sort` = VALUES(`sort`), `color_type` = VALUES(`color_type`), `updater` = 'admin', `update_time` = NOW();

-- ========== yms_position_type / yms_position_status ==========
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(73081, 1, '海柜位', 'CONTAINER_SLOT', 'yms_position_type', 0, 'primary', '', '存放重柜/在场海柜', 'admin', NOW(), 'admin', NOW(), b'0'),
(73082, 2, '空柜位', 'EMPTY_CONTAINER_SLOT', 'yms_position_type', 0, 'info', '', '存放空柜', 'admin', NOW(), 'admin', NOW(), b'0'),
(73083, 3, '车厢位', 'TRAILER_SLOT', 'yms_position_type', 0, 'success', '', '存放车厢', 'admin', NOW(), 'admin', NOW(), b'0'),
(73084, 4, '临时等待位', 'WAITING_SLOT', 'yms_position_type', 0, 'warning', '', '临时等待/暂存', 'admin', NOW(), 'admin', NOW(), b'0'),
(73085, 5, '禁用位', 'BLOCKED_SLOT', 'yms_position_type', 0, 'danger', '', '禁用/不可用', 'admin', NOW(), 'admin', NOW(), b'0'),
(73091, 1, '空闲', 'FREE', 'yms_position_status', 0, 'success', '', '可使用', 'admin', NOW(), 'admin', NOW(), b'0'),
(73092, 2, '占用中', 'OCCUPIED', 'yms_position_status', 0, 'primary', '', '已有对象', 'admin', NOW(), 'admin', NOW(), b'0'),
(73093, 3, '已预占', 'RESERVED', 'yms_position_status', 0, 'warning', '', '已分配待使用', 'admin', NOW(), 'admin', NOW(), b'0'),
(73094, 4, '禁用', 'DISABLED', 'yms_position_status', 0, 'default', '', '不可用', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`), `sort` = VALUES(`sort`), `color_type` = VALUES(`color_type`), `updater` = 'admin', `update_time` = NOW();

-- ========== yms_internal_task_type / yms_internal_task_status ==========
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(73101, 1, '海柜上口', 'CONTAINER_TO_DOCK', 'yms_internal_task_type', 0, 'primary', '', '海柜移到Dock', 'admin', NOW(), 'admin', NOW(), b'0'),
(73102, 2, '海柜下口', 'CONTAINER_OFF_DOCK', 'yms_internal_task_type', 0, 'success', '', '海柜离开Dock', 'admin', NOW(), 'admin', NOW(), b'0'),
(73103, 3, '车厢上口', 'TRAILER_TO_DOCK', 'yms_internal_task_type', 0, 'primary', '', '车厢移到Dock', 'admin', NOW(), 'admin', NOW(), b'0'),
(73104, 4, '车厢下口', 'TRAILER_OFF_DOCK', 'yms_internal_task_type', 0, 'success', '', '车厢离开Dock', 'admin', NOW(), 'admin', NOW(), b'0'),
(73105, 5, '院内挪柜', 'CONTAINER_MOVE', 'yms_internal_task_type', 0, 'warning', '', '柜子在堆场内移动', 'admin', NOW(), 'admin', NOW(), b'0'),
(73106, 6, '院内挪车厢', 'TRAILER_MOVE', 'yms_internal_task_type', 0, 'warning', '', '车厢在堆场内移动', 'admin', NOW(), 'admin', NOW(), b'0'),
(73107, 7, '空柜还柜', 'EMPTY_CONTAINER_RETURN', 'yms_internal_task_type', 0, 'info', '', '空柜移至还柜区', 'admin', NOW(), 'admin', NOW(), b'0'),
(73108, 8, '园区盘点', 'YARD_INVENTORY_SCAN', 'yms_internal_task_type', 0, 'default', '', '盘点扫描', 'admin', NOW(), 'admin', NOW(), b'0'),
(73111, 1, '待领取', 'PENDING', 'yms_internal_task_status', 0, 'default', '', '等待 YardGo 司机领取', 'admin', NOW(), 'admin', NOW(), b'0'),
(73112, 2, '已分配', 'ASSIGNED', 'yms_internal_task_status', 0, 'info', '', '预留：调度派单', 'admin', NOW(), 'admin', NOW(), b'0'),
(73113, 3, '已领取', 'ACCEPTED', 'yms_internal_task_status', 0, 'warning', '', 'YardGo 司机已领取', 'admin', NOW(), 'admin', NOW(), b'0'),
(73114, 4, '执行中', 'IN_PROGRESS', 'yms_internal_task_status', 0, 'primary', '', 'YardGo任务执行中', 'admin', NOW(), 'admin', NOW(), b'0'),
(73115, 5, '已完成', 'COMPLETED', 'yms_internal_task_status', 0, 'success', '', 'YardGo任务已完成', 'admin', NOW(), 'admin', NOW(), b'0'),
(73116, 6, '异常', 'FAILED', 'yms_internal_task_status', 0, 'danger', '', 'YardGo任务异常', 'admin', NOW(), 'admin', NOW(), b'0'),
(73117, 7, '已取消', 'CANCELLED', 'yms_internal_task_status', 0, 'default', '', 'YardGo任务已取消', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`), `sort` = VALUES(`sort`), `color_type` = VALUES(`color_type`), `remark` = VALUES(`remark`), `updater` = 'admin', `update_time` = NOW();

-- ========== yms_task_type ==========
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(73121, 1, '拆柜', 'DEVANNING', 'yms_task_type', 0, 'primary', '', '海柜拆柜任务', 'admin', NOW(), 'admin', NOW(), b'0'),
(73122, 2, '派送装车', 'DELIVERY_LOADING', 'yms_task_type', 0, 'success', '', '派送出库装车', 'admin', NOW(), 'admin', NOW(), b'0'),
(73123, 3, '调拨装车', 'TRANSFER_LOADING', 'yms_task_type', 0, 'info', '', '调拨装车', 'admin', NOW(), 'admin', NOW(), b'0'),
(73124, 4, '自提装车', 'PICKUP_LOADING', 'yms_task_type', 0, 'warning', '', '自提客户', 'admin', NOW(), 'admin', NOW(), b'0'),
(73125, 5, '退货装车', 'RETURN_LOADING', 'yms_task_type', 0, 'danger', '', '退货装车', 'admin', NOW(), 'admin', NOW(), b'0'),
(73126, 6, '院内挪柜', 'INTERNAL_MOVE', 'yms_task_type', 0, 'default', '', '院内挪柜任务', 'admin', NOW(), 'admin', NOW(), b'0'),
(73127, 7, '园区盘点', 'YARD_INVENTORY', 'yms_task_type', 0, 'default', '', '园区盘点任务', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`), `sort` = VALUES(`sort`), `color_type` = VALUES(`color_type`), `updater` = 'admin', `update_time` = NOW();

-- ========== yms_devanning_status / yms_loading_status ==========
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(73131, 1, '已创建', 'CREATED', 'yms_devanning_status', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(73132, 2, '等待到仓', 'WAIT_CONTAINER', 'yms_devanning_status', 0, 'default', '', '海柜尚未到仓', 'admin', NOW(), 'admin', NOW(), b'0'),
(73133, 3, '海柜已到', 'CONTAINER_ARRIVED', 'yms_devanning_status', 0, 'info', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(73134, 4, '已分配位置', 'YARD_ASSIGNED', 'yms_devanning_status', 0, 'info', '', '已分配堆场位', 'admin', NOW(), 'admin', NOW(), b'0'),
(73135, 5, '等待叫号', 'WAIT_CALL', 'yms_devanning_status', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(73136, 6, '已叫号', 'CALLED', 'yms_devanning_status', 0, 'primary', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(73137, 7, '上口中', 'MOVE_TO_DOCK', 'yms_devanning_status', 0, 'primary', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(73138, 8, '已上口', 'ON_DOCK', 'yms_devanning_status', 0, 'primary', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(73139, 9, 'WMS拆柜中', 'WMS_WORKING', 'yms_devanning_status', 0, 'primary', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(73140, 10, 'WMS完成', 'WMS_FINISHED', 'yms_devanning_status', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(73141, 11, '下口中', 'MOVE_OFF_DOCK', 'yms_devanning_status', 0, 'info', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(73142, 12, '空柜待还', 'WAIT_RETURN', 'yms_devanning_status', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(73143, 13, '已离园', 'LEFT_YARD', 'yms_devanning_status', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(73144, 14, '已取消', 'CANCELLED', 'yms_devanning_status', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(73145, 15, '异常', 'EXCEPTION', 'yms_devanning_status', 0, 'danger', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(73151, 1, '已创建', 'CREATED', 'yms_loading_status', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(73152, 2, '等待WMS备货', 'WAIT_WMS_READY', 'yms_loading_status', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(73153, 3, '等待车辆到仓', 'WAIT_VEHICLE', 'yms_loading_status', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(73154, 4, '车辆已到仓', 'VEHICLE_ARRIVED', 'yms_loading_status', 0, 'info', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(73155, 5, '等待叫号', 'WAIT_CALL', 'yms_loading_status', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(73156, 6, '已叫号', 'CALLED', 'yms_loading_status', 0, 'primary', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(73157, 7, '上口中', 'MOVE_TO_DOCK', 'yms_loading_status', 0, 'primary', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(73158, 8, '已上口', 'ON_DOCK', 'yms_loading_status', 0, 'primary', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(73159, 9, 'WMS装车中', 'WMS_LOADING', 'yms_loading_status', 0, 'primary', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(73160, 10, 'WMS装车完成', 'WMS_LOADED', 'yms_loading_status', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(73161, 11, '下口中', 'MOVE_OFF_DOCK', 'yms_loading_status', 0, 'info', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(73162, 12, '等待离场', 'WAIT_LEAVE', 'yms_loading_status', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(73163, 13, '已离园', 'LEFT_YARD', 'yms_loading_status', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(73164, 14, '已取消', 'CANCELLED', 'yms_loading_status', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(73165, 15, '异常', 'EXCEPTION', 'yms_loading_status', 0, 'danger', '', '', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`), `sort` = VALUES(`sort`), `color_type` = VALUES(`color_type`), `updater` = 'admin', `update_time` = NOW();

-- ========== yms_zone_type / yms_appointment_status / yms_check_result / yms_robot_status ==========
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(73171, 1, '集装箱区', 'CONTAINER', 'yms_zone_type', 0, 'info', '', '集装箱停放区', 'admin', NOW(), 'admin', NOW(), b'0'),
(73172, 2, '卡车区', 'TRUCK', 'yms_zone_type', 0, 'info', '', '普通卡车区', 'admin', NOW(), 'admin', NOW(), b'0'),
(73173, 3, '自提区', 'SELF_PICKUP', 'yms_zone_type', 0, 'default', '', '自提车辆区', 'admin', NOW(), 'admin', NOW(), b'0'),
(73174, 4, '停车区', 'PARKING', 'yms_zone_type', 0, 'default', '', '普通停车区', 'admin', NOW(), 'admin', NOW(), b'0'),
(73181, 1, '待确认', 'PENDING', 'yms_appointment_status', 0, 'warning', '', '等待仓库确认', 'admin', NOW(), 'admin', NOW(), b'0'),
(73182, 2, '已确认', 'CONFIRMED', 'yms_appointment_status', 0, 'success', '', '仓库已确认', 'admin', NOW(), 'admin', NOW(), b'0'),
(73183, 3, '已取消', 'CANCELLED', 'yms_appointment_status', 0, 'default', '', '已取消', 'admin', NOW(), 'admin', NOW(), b'0'),
(73184, 4, '已完成', 'COMPLETED', 'yms_appointment_status', 0, 'info', '', '车辆已入场完成', 'admin', NOW(), 'admin', NOW(), b'0'),
(73185, 5, '未到场', 'NO_SHOW', 'yms_appointment_status', 0, 'danger', '', '预约时段内未到场', 'admin', NOW(), 'admin', NOW(), b'0'),
(73191, 1, '通过', 'PASSED', 'yms_check_result', 0, 'success', '', '验证通过放行', 'admin', NOW(), 'admin', NOW(), b'0'),
(73192, 2, '黑名单', 'BLACKLISTED', 'yms_check_result', 0, 'danger', '', '命中黑名单拦截', 'admin', NOW(), 'admin', NOW(), b'0'),
(73193, 3, '拒绝', 'REJECTED', 'yms_check_result', 0, 'warning', '', '无预约拒绝入场', 'admin', NOW(), 'admin', NOW(), b'0'),
(73194, 4, '待人工', 'PENDING', 'yms_check_result', 0, 'info', '', '等待人工审核', 'admin', NOW(), 'admin', NOW(), b'0'),
(73201, 1, '待执行', 'PENDING', 'yms_robot_status', 0, 'default', '', '等待机器人接收', 'admin', NOW(), 'admin', NOW(), b'0'),
(73202, 2, '执行中', 'RUNNING', 'yms_robot_status', 0, 'info', '', '机器人作业中', 'admin', NOW(), 'admin', NOW(), b'0'),
(73203, 3, '已暂停', 'PAUSED', 'yms_robot_status', 0, 'warning', '', '任务暂停', 'admin', NOW(), 'admin', NOW(), b'0'),
(73204, 4, '已完成', 'COMPLETED', 'yms_robot_status', 0, 'success', '', '作业完成', 'admin', NOW(), 'admin', NOW(), b'0'),
(73205, 5, '失败', 'FAILED', 'yms_robot_status', 0, 'danger', '', '机器人报错', 'admin', NOW(), 'admin', NOW(), b'0'),
(73206, 6, '已取消', 'CANCELLED', 'yms_robot_status', 0, 'default', '', '已取消', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`), `sort` = VALUES(`sort`), `color_type` = VALUES(`color_type`), `updater` = 'admin', `update_time` = NOW();
