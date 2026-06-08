-- 海柜订单菜单（对齐参考系统 container-order）
-- 依赖：oms-menu.sql (6900)

SET NAMES utf8mb4;

UPDATE `system_menu`
SET `name` = '海柜订单',
    `permission` = 'oms:containerOrder:list',
    `path` = 'container-order',
    `component` = 'oms/container-order/index',
    `component_name` = 'OmsContainerOrder',
    `updater` = 'admin',
    `update_time` = NOW()
WHERE `id` = 6901;

INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`,
                           `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`,
                           `create_time`, `updater`, `update_time`, `deleted`)
VALUES
    (6917, '海柜订单查询', 'oms:containerOrder:query', 3, 7, 6901, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6918, '海柜订单新增', 'oms:containerOrder:add', 3, 8, 6901, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6919, '海柜订单删除', 'oms:containerOrder:remove', 3, 9, 6901, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6920, '海柜订单导出', 'oms:containerOrder:export', 3, 10, 6901, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6925, '海柜订单改状态', 'oms:containerOrder:updateStatus', 3, 11, 6901, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6926, '导入柜内订单', 'oms:containerOrder:importCargo', 3, 12, 6901, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6927, '上传附件', 'oms:containerOrder:attachmentUpload', 3, 13, 6901, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6928, '上传DO', 'oms:containerOrder:uploadDo', 3, 14, 6901, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6929, '删除附件', 'oms:containerOrder:attachmentRemove', 3, 15, 6901, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`), `permission` = VALUES(`permission`), `updater` = 'admin', `update_time` = NOW();
