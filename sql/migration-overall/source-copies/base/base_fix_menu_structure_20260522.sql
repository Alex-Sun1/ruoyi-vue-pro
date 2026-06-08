-- =============================================
-- 海外仓系统 - 基础资料菜单结构调整
-- 日期：2026-05-22
-- 说明：
--   1. 主体管理、仓库管理归入“组织资料”
--   2. 费项管理归入“财务资料”
--   3. 邮编库管理从“物流基础”调整到“地理资料”
--   4. 原“币种汇率”目录更名为“财务资料”
-- =============================================

INSERT INTO sys_menu
  (menu_id, menu_name, parent_id, order_num, path, component, query_param, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (2400, '组织资料', 2000, 1, 'organization', NULL, '', 1, 0, 'M', '0', '0', '', 'tree-table', 103, 1, NOW(), NULL, NULL, '组织资料目录')
ON DUPLICATE KEY UPDATE
  menu_name = VALUES(menu_name),
  parent_id = VALUES(parent_id),
  order_num = VALUES(order_num),
  path = VALUES(path),
  component = VALUES(component),
  menu_type = VALUES(menu_type),
  visible = VALUES(visible),
  status = VALUES(status),
  perms = VALUES(perms),
  icon = VALUES(icon),
  remark = VALUES(remark);

UPDATE sys_menu
   SET parent_id = 2400,
       order_num = 1,
       path = 'company',
       component = 'base/company/index',
       menu_type = 'C',
       perms = 'base:company:list'
 WHERE menu_id = 2001;

UPDATE sys_menu
   SET parent_id = 2400,
       order_num = 2,
       path = 'warehouse',
       component = 'base/warehouse/index',
       menu_type = 'C',
       perms = 'base:warehouse:list'
 WHERE menu_id = 2002;

UPDATE sys_menu
   SET menu_name = '财务资料',
       parent_id = 2000,
       order_num = 5,
       path = 'finance',
       component = NULL,
       menu_type = 'M',
       perms = '',
       icon = 'dollar',
       remark = '财务资料目录'
 WHERE menu_id = 2008;

UPDATE sys_menu
   SET parent_id = 2008,
       order_num = 3,
       path = 'fee-item',
       component = 'base/fee-item/index',
       menu_type = 'C',
       perms = 'base:feeItem:list'
 WHERE menu_id = 2003;

UPDATE sys_menu
   SET parent_id = 2007,
       order_num = 5,
       path = 'zip-code',
       component = 'base/zip-code/index',
       menu_type = 'C',
       perms = 'base:zipCode:list'
 WHERE menu_id = 2303;

UPDATE sys_menu SET order_num = 2 WHERE menu_id = 2004;
UPDATE sys_menu SET order_num = 3 WHERE menu_id = 2006;
UPDATE sys_menu SET order_num = 4 WHERE menu_id = 2007;
UPDATE sys_menu SET order_num = 6 WHERE menu_id = 2009;

-- 若普通角色已拥有子菜单权限，自动补齐新/调整后的父目录权限，避免菜单树缺父节点。
INSERT IGNORE INTO sys_role_menu (role_id, menu_id)
SELECT DISTINCT role_id, 2400
  FROM sys_role_menu
 WHERE menu_id IN (2001, 2002);

INSERT IGNORE INTO sys_role_menu (role_id, menu_id)
SELECT DISTINCT role_id, 2008
  FROM sys_role_menu
 WHERE menu_id IN (2003, 2201, 2202);

INSERT IGNORE INTO sys_role_menu (role_id, menu_id)
SELECT DISTINCT role_id, 2007
  FROM sys_role_menu
 WHERE menu_id IN (2101, 2102, 2103, 2104, 2303);
