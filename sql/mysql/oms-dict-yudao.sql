-- OMS 业务字典（Yudao system_dict_type / system_dict_data）
-- 在 oms-init-from-reference.sql 之后执行
-- dict_type.id: 7210~7235；dict_data.id: 721001~721999
SET NAMES utf8mb4;

-- ========== 货物订单履约 / 账单 / 预出单 ==========
INSERT INTO `system_dict_type` (`id`, `name`, `type`, `status`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `deleted_time`) VALUES
(7210, '货物订单主履约状态', 'oms_cargo_fulfillment_status', 0, '', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7211, '货物订单账单状态', 'oms_cargo_billing_status', 0, '', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7212, '货物订单预出单状态', 'oms_cargo_pre_outbound_status', 0, '', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7213, '货物预报计量单位', 'oms_cargo_forecast_qty_unit', 0, 'BY_CARTON/BY_PALLET', 'admin', NOW(), 'admin', NOW(), b'0', NULL)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `status` = VALUES(`status`), `remark` = VALUES(`remark`), `updater` = 'admin', `update_time` = NOW();

INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(721001, 1,  '待受理',     'PENDING_ACCEPT',     'oms_cargo_fulfillment_status', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721002, 2,  '已受理',     'ACCEPTED',           'oms_cargo_fulfillment_status', 0, 'info',    '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721003, 3,  '在途',       'IN_TRANSIT',         'oms_cargo_fulfillment_status', 0, 'info',    '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721004, 4,  '已到港',     'ARRIVED_PORT',       'oms_cargo_fulfillment_status', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721005, 5,  '已提柜',     'PICKED_UP',          'oms_cargo_fulfillment_status', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721006, 6,  '已到仓',     'ARRIVED_WAREHOUSE',  'oms_cargo_fulfillment_status', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721007, 7,  '拆柜中',     'DEVANNING',          'oms_cargo_fulfillment_status', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721008, 8,  '拆柜完成',   'DEVANNED',           'oms_cargo_fulfillment_status', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721009, 9,  '已入库',     'INBOUNDED',          'oms_cargo_fulfillment_status', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721010, 10, '已出单',     'OUTBOUND_ORDERED',   'oms_cargo_fulfillment_status', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721011, 11, '已预约派送', 'DELIVERY_APPOINTED', 'oms_cargo_fulfillment_status', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721012, 12, '已出库',     'OUTBOUNDED',         'oms_cargo_fulfillment_status', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721013, 13, '派送中',     'DELIVERING',         'oms_cargo_fulfillment_status', 0, 'primary', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721014, 14, '已签收',     'DELIVERED',          'oms_cargo_fulfillment_status', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721015, 15, 'POD已回传',  'POD_UPLOADED',       'oms_cargo_fulfillment_status', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721016, 16, '已出账单',   'BILLED',             'oms_cargo_fulfillment_status', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721017, 17, '已完成',     'COMPLETED',          'oms_cargo_fulfillment_status', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721018, 18, '异常中',     'EXCEPTION',          'oms_cargo_fulfillment_status', 0, 'danger',  '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721019, 19, '已取消',     'CANCELLED',          'oms_cargo_fulfillment_status', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721021, 1,  '未出账单',   'UNBILLED',           'oms_cargo_billing_status', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721022, 2,  '已出账单',   'BILLED',             'oms_cargo_billing_status', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721023, 3,  '已作废',     'VOIDED',             'oms_cargo_billing_status', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721031, 1,  '无预出单',   'NONE',               'oms_cargo_pre_outbound_status', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721032, 2,  '已预出单',   'PRE_CREATED',        'oms_cargo_pre_outbound_status', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721033, 3,  '已转正式',   'CONVERTED',          'oms_cargo_pre_outbound_status', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721034, 4,  '已取消',     'CANCELLED',          'oms_cargo_pre_outbound_status', 0, 'danger',  '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721041, 1,  '按箱',       'BY_CARTON',          'oms_cargo_forecast_qty_unit', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721042, 2,  '按板',       'BY_PALLET',          'oms_cargo_forecast_qty_unit', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `sort` = VALUES(`sort`), `label` = VALUES(`label`), `value` = VALUES(`value`), `dict_type` = VALUES(`dict_type`), `color_type` = VALUES(`color_type`), `updater` = 'admin', `update_time` = NOW();

-- ========== 海柜订单 ==========
INSERT INTO `system_dict_type` (`id`, `name`, `type`, `status`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `deleted_time`) VALUES
(7214, '海柜状态', 'oms_container_status', 0, 'OMS海柜订单生命周期状态', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7215, '柜型', 'oms_container_type', 0, 'OMS海柜柜型', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7216, '码头释放状态', 'oms_terminal_release_status', 0, '码头释放/Hold状态', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7217, '海柜拆柜方式', 'oms_devanning_method', 0, '', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7218, '海柜装载类型', 'oms_loading_type', 0, '', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7219, '海柜Hold类型', 'oms_container_hold_type', 0, '', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7220, '海柜查验类型', 'oms_container_exam_type', 0, '', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7221, 'OMS附件类型', 'oms_attachment_type', 0, '货物/海柜文件管理上传类型', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7222, 'OMS拆柜状态', 'oms_unstuff_status', 0, '海柜 unstuff_status', 'admin', NOW(), 'admin', NOW(), b'0', NULL)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `status` = VALUES(`status`), `remark` = VALUES(`remark`), `updater` = 'admin', `update_time` = NOW();

INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(721101, 1,  '草稿',       'DRAFT',                'oms_container_status', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721102, 2,  '待受理',     'PENDING_ACCEPT',       'oms_container_status', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721103, 3,  '在途',       'IN_TRANSIT',           'oms_container_status', 0, 'info',    '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721104, 4,  '已到港',     'ARRIVED_PORT',         'oms_container_status', 0, 'info',    '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721105, 5,  'HOLD中',     'HOLDING',              'oms_container_status', 0, 'danger',  '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721106, 6,  '查验中',     'EXAMINING',            'oms_container_status', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721107, 7,  '已可提',     'AVAILABLE_FOR_PICKUP', 'oms_container_status', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721108, 8,  '已预约提柜', 'PICKUP_APPOINTED',     'oms_container_status', 0, 'info',    '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721109, 9,  '已提柜',     'PICKED_UP',            'oms_container_status', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721110, 10, '已到仓',     'ARRIVED_WAREHOUSE',    'oms_container_status', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721111, 11, '拆柜中',     'DEVANNING',            'oms_container_status', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721112, 12, '拆柜完成',   'DEVANNED',             'oms_container_status', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721113, 13, '已还柜',     'EMPTY_RETURNED',       'oms_container_status', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721114, 14, '已完成',     'COMPLETED',            'oms_container_status', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721115, 15, '已取消',     'CANCELLED',            'oms_container_status', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721121, 1,  '20GP',       '20GP',                 'oms_container_type', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721122, 2,  '40GP',       '40GP',                 'oms_container_type', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721123, 3,  '40HQ',       '40HQ',                 'oms_container_type', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721124, 4,  '45HQ',       '45HQ',                 'oms_container_type', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721131, 1,  '未知',       'UNKNOWN',              'oms_terminal_release_status', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721132, 2,  '已释放',     'RELEASED',             'oms_terminal_release_status', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721133, 3,  'HOLD中',     'HOLDING',              'oms_terminal_release_status', 0, 'danger',  '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721141, 1,  '人工拆柜',   'MANUAL',               'oms_devanning_method', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721142, 2,  '叉车拆柜',   'FORKLIFT',             'oms_devanning_method', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721143, 3,  '流水线拆柜', 'CONVEYOR',             'oms_devanning_method', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721144, 4,  '混合拆柜',   'MIXED',                'oms_devanning_method', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721151, 1,  '散装',       'FLOOR',                'oms_loading_type', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721152, 2,  '卡板',       'PALLET',               'oms_loading_type', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721153, 3,  '混装',       'MIXED',                'oms_loading_type', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721161, 1,  '海关Hold',   'CUSTOMS',              'oms_container_hold_type', 0, 'danger',  '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721162, 2,  '船公司Hold', 'CARRIER',              'oms_container_hold_type', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721163, 3,  '码头Hold',   'TERMINAL',             'oms_container_hold_type', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721164, 4,  '费用Hold',   'FEE',                  'oms_container_hold_type', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721171, 1,  'X-Ray',      'X_RAY',                'oms_container_exam_type', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721172, 2,  'Tailgate',   'TAILGATE',             'oms_container_exam_type', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721173, 3,  'Intensive',  'INTENSIVE',            'oms_container_exam_type', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721174, 4,  'CES',        'CES',                  'oms_container_exam_type', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721181, 1,  'DO',         'DO',                   'oms_attachment_type', 0, 'primary', '', '海柜DO，客户可见', 'admin', NOW(), 'admin', NOW(), b'0'),
(721182, 2,  'BOL/提单',   'BOL',                  'oms_attachment_type', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721183, 3,  'POD',        'POD',                  'oms_attachment_type', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721184, 4,  '发票',       'INVOICE',              'oms_attachment_type', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721185, 5,  '异常图片',   'EXCEPTION_IMAGE',      'oms_attachment_type', 0, 'danger',  '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721186, 6,  '客户文件',   'CUSTOMER_FILE',        'oms_attachment_type', 0, 'info',    '', '客户可见', 'admin', NOW(), 'admin', NOW(), b'0'),
(721187, 99, '其他',       'OTHER',                'oms_attachment_type', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721191, 1,  '未创建任务', 'NOT_CREATED',          'oms_unstuff_status', 0, 'info',    '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721192, 2,  '拆柜中',     'PROCESSING',           'oms_unstuff_status', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721193, 3,  '已完成',     'COMPLETED',            'oms_unstuff_status', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `sort` = VALUES(`sort`), `label` = VALUES(`label`), `value` = VALUES(`value`), `dict_type` = VALUES(`dict_type`), `color_type` = VALUES(`color_type`), `updater` = 'admin', `update_time` = NOW();

-- ========== 地址 / 快递 / 分组规则 ==========
INSERT INTO `system_dict_type` (`id`, `name`, `type`, `status`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `deleted_time`) VALUES
(7223, '地址类型', 'oms_address_type', 0, '平台仓、私仓、商业地址', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7224, '货件类型', 'oms_shipment_type', 0, '预留货件类型', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7225, 'OMS快递商', 'oms_parcel_carrier', 0, '快递派送承运商', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7226, 'OMS分组规则状态', 'oms_cargo_grouping_rule_status', 0, '', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7227, 'OMS分组字段数据类型', 'oms_cargo_grouping_field_data_type', 0, '', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7228, 'OMS分组规则匹配操作符', 'oms_cargo_grouping_condition_op', 0, '', 'admin', NOW(), 'admin', NOW(), b'0', NULL)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `status` = VALUES(`status`), `remark` = VALUES(`remark`), `updater` = 'admin', `update_time` = NOW();

INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(721201, 1, '平台仓',   'PLATFORM_WH', 'oms_address_type', 0, 'primary', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721202, 2, '私仓',     'PRIVATE',     'oms_address_type', 0, 'info',    '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721203, 3, '商业地址', 'COMMERCIAL',  'oms_address_type', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721211, 1, '标准货件', 'STANDARD',    'oms_shipment_type', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721221, 1, 'UPS',              'UPS',              'oms_parcel_carrier', 0, 'primary', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721222, 2, 'FedEx',            'FedEx',            'oms_parcel_carrier', 0, 'info',    '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721223, 3, 'USPS',             'USPS',             'oms_parcel_carrier', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721224, 4, 'DHL',              'DHL',              'oms_parcel_carrier', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721225, 5, 'OnTrac',           'OnTrac',           'oms_parcel_carrier', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721226, 6, 'LaserShip',        'LaserShip',        'oms_parcel_carrier', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721227, 7, 'Amazon Shipping',  'Amazon Shipping',  'oms_parcel_carrier', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721231, 1, '启用', 'enabled',  'oms_cargo_grouping_rule_status', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721232, 2, '停用', 'disabled', 'oms_cargo_grouping_rule_status', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721241, 1, '文本',     'STRING', 'oms_cargo_grouping_field_data_type', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721242, 2, '数字',     'NUMBER', 'oms_cargo_grouping_field_data_type', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721243, 3, '日期',     'DATE',   'oms_cargo_grouping_field_data_type', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721244, 4, '枚举',     'ENUM',   'oms_cargo_grouping_field_data_type', 0, 'info',    '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721245, 5, '基础资料', 'REF',    'oms_cargo_grouping_field_data_type', 0, 'info',    '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721251, 1, '等于',     'EQ',          'oms_cargo_grouping_condition_op', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721252, 2, '不等于',   'NEQ',         'oms_cargo_grouping_condition_op', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721253, 3, '包含于',   'IN',          'oms_cargo_grouping_condition_op', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721254, 4, '不包含于', 'NOT_IN',      'oms_cargo_grouping_condition_op', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721255, 5, '为空',     'IS_NULL',     'oms_cargo_grouping_condition_op', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721256, 6, '不为空',   'IS_NOT_NULL', 'oms_cargo_grouping_condition_op', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `sort` = VALUES(`sort`), `label` = VALUES(`label`), `value` = VALUES(`value`), `dict_type` = VALUES(`dict_type`), `color_type` = VALUES(`color_type`), `updater` = 'admin', `update_time` = NOW();

-- ========== 出库 / 预出单 / 出单工作台 ==========
INSERT INTO `system_dict_type` (`id`, `name`, `type`, `status`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `deleted_time`) VALUES
(7229, '出单方向', 'oms_outbound_direction', 0, 'OMS出单方向', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7230, '出单准备状态', 'oms_outbound_readiness', 0, '出单工作台准备状态', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7231, '预出单状态', 'oms_pre_outbound_status', 0, '预出单状态', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7232, '出库订单状态', 'oms_outbound_status', 0, '出库订单状态', 'admin', NOW(), 'admin', NOW(), b'0', NULL)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `status` = VALUES(`status`), `remark` = VALUES(`remark`), `updater` = 'admin', `update_time` = NOW();

INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(721301, 1, '派送',     'DELIVERY',          'oms_outbound_direction', 0, 'primary', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721302, 2, '调拨',     'TRANSFER',          'oms_outbound_direction', 0, 'info',    '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721311, 1, '未入库',   'NOT_INBOUNDED',     'oms_outbound_readiness', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721312, 2, '拆柜中',   'DEVANNING',         'oms_outbound_readiness', 0, 'info',    '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721313, 3, '已入库',   'INBOUNDED',         'oms_outbound_readiness', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721321, 1, '待入库',   'PENDING_INBOUND',   'oms_pre_outbound_status', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721322, 2, '拆柜中',   'DEVANNING',         'oms_pre_outbound_status', 0, 'info',    '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721323, 3, '可转出库', 'READY_TO_CONVERT',  'oms_pre_outbound_status', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721324, 4, '已转出库', 'CONVERTED',         'oms_pre_outbound_status', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721325, 5, '已取消',   'CANCELLED',         'oms_pre_outbound_status', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721331, 1, '已创建',   'CREATED',           'oms_outbound_status', 0, 'info',    '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721332, 2, '已派发',   'DISPATCHED',        'oms_outbound_status', 0, 'info',    '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721333, 3, '已出库',   'OUTBOUNDED',        'oms_outbound_status', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721334, 4, '派送中',   'DELIVERING',        'oms_outbound_status', 0, 'info',    '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721335, 5, '已签收',   'DELIVERED',         'oms_outbound_status', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721336, 6, '已完成',   'COMPLETED',         'oms_outbound_status', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(721337, 7, '已取消',   'CANCELLED',         'oms_outbound_status', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `sort` = VALUES(`sort`), `label` = VALUES(`label`), `value` = VALUES(`value`), `dict_type` = VALUES(`dict_type`), `color_type` = VALUES(`color_type`), `updater` = 'admin', `update_time` = NOW();
