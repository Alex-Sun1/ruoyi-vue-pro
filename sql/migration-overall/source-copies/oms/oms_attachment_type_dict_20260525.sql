-- OMS 附件/文件类型字典（货物订单、海柜订单文件管理上传）

INSERT IGNORE INTO `sys_dict_type`
(`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES
(5000114, '000000', 'OMS附件类型', 'oms_attachment_type', 103, 1, NOW(), NULL, NULL, '货物/海柜文件管理上传类型');

INSERT IGNORE INTO `sys_dict_data`
(`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`)
VALUES
(5000340, '000000', 1, 'DO', 'DO', 'oms_attachment_type', '', 'primary', 'N', 103, 1, NOW(), NULL, NULL, '海柜DO，客户可见'),
(5000341, '000000', 2, 'BOL/提单', 'BOL', 'oms_attachment_type', '', 'default', 'N', 103, 1, NOW(), NULL, NULL, ''),
(5000342, '000000', 3, 'POD', 'POD', 'oms_attachment_type', '', 'success', 'N', 103, 1, NOW(), NULL, NULL, ''),
(5000343, '000000', 4, '发票', 'INVOICE', 'oms_attachment_type', '', 'default', 'N', 103, 1, NOW(), NULL, NULL, ''),
(5000344, '000000', 5, '异常图片', 'EXCEPTION_IMAGE', 'oms_attachment_type', '', 'error', 'N', 103, 1, NOW(), NULL, NULL, ''),
(5000345, '000000', 6, '客户文件', 'CUSTOMER_FILE', 'oms_attachment_type', '', 'info', 'N', 103, 1, NOW(), NULL, NULL, '客户可见'),
(5000346, '000000', 99, '其他', 'OTHER', 'oms_attachment_type', '', 'default', 'Y', 103, 1, NOW(), NULL, NULL, '');
