-- WMS 拆柜订单 PRD v1.0

CREATE TABLE IF NOT EXISTS `wms_devanning_order` (
  `id`                      BIGINT          NOT NULL                        COMMENT '主键',
  `tenant_id`               VARCHAR(20)     NOT NULL DEFAULT '000000'       COMMENT '租户ID',
  `company_id`              BIGINT          DEFAULT NULL                    COMMENT '主体公司ID',
  `warehouse_id`            BIGINT          NOT NULL                        COMMENT '仓库ID',
  `biz_root_id`             BIGINT          DEFAULT NULL                    COMMENT '业务主线ID',
  `devanning_no`            VARCHAR(64)     NOT NULL                        COMMENT 'WMS工作单号',
  `source_order_id`         BIGINT          DEFAULT NULL                    COMMENT '来源单ID',
  `source_order_no`         VARCHAR(64)     DEFAULT NULL                    COMMENT '来源单号',
  `source_order_type`       VARCHAR(30)     DEFAULT NULL                    COMMENT '来源单类型',
  `container_no`            VARCHAR(64)     DEFAULT NULL                    COMMENT '柜号',
  `customer_id`             BIGINT          DEFAULT NULL                    COMMENT '客户ID',
  `customer_name`           VARCHAR(100)    DEFAULT NULL                    COMMENT '客户名称',
  `channel_id`              BIGINT          DEFAULT NULL                    COMMENT '渠道ID',
  `channel_name`            VARCHAR(100)    DEFAULT NULL                    COMMENT '渠道名称',
  `customer_service_id`     BIGINT          DEFAULT NULL                    COMMENT '客服ID',
  `customer_service_name`   VARCHAR(50)     DEFAULT NULL                    COMMENT '客服姓名',
  `eta_warehouse_time`      DATETIME        DEFAULT NULL                    COMMENT 'ETA预计到仓',
  `pickup_time`             DATETIME        DEFAULT NULL                    COMMENT '提柜时间',
  `actual_arrival_time`     DATETIME        DEFAULT NULL                    COMMENT '实际到仓时间',
  `planned_devanning_time`  DATETIME        DEFAULT NULL                    COMMENT '预计拆柜时间',
  `devanning_start_time`    DATETIME        DEFAULT NULL                    COMMENT '拆柜开始时间',
  `devanning_finish_time`   DATETIME        DEFAULT NULL                    COMMENT '拆柜完成时间',
  `dock_id`                 BIGINT          DEFAULT NULL                    COMMENT 'Dock ID',
  `dock_code`               VARCHAR(30)     DEFAULT NULL                    COMMENT 'Dock编号',
  `dock_assign_time`        DATETIME        DEFAULT NULL                    COMMENT 'Dock分配时间',
  `devanning_method`        VARCHAR(30)     NOT NULL DEFAULT 'MANUAL'       COMMENT '拆柜方式',
  `devanning_remark`        VARCHAR(500)    DEFAULT NULL                    COMMENT '拆柜备注',
  `planned_truck_qty`       INT             DEFAULT NULL                    COMMENT '预排车数',
  `planned_cbm`             DECIMAL(10,3)   DEFAULT NULL                    COMMENT '预排方数',
  `total_box_qty`           DECIMAL(10,0)   DEFAULT NULL                    COMMENT '总箱数',
  `total_weight`            DECIMAL(10,3)   DEFAULT NULL                    COMMENT '总重量kg',
  `total_cbm`               DECIMAL(10,3)   DEFAULT NULL                    COMMENT '总方数',
  `inbounded_box_qty`       DECIMAL(10,0)   NOT NULL DEFAULT 0              COMMENT '已入库箱数',
  `exception_flag`          TINYINT(1)      NOT NULL DEFAULT 0              COMMENT '异常标记',
  `exception_count`         INT             NOT NULL DEFAULT 0              COMMENT '异常次数',
  `attachment_urls`         TEXT            DEFAULT NULL                    COMMENT '附件JSON',
  `status`                  VARCHAR(30)     NOT NULL DEFAULT 'UNPICKEDUP'   COMMENT '状态',
  `version`                 INT             NOT NULL DEFAULT 0              COMMENT '乐观锁',
  `remark`                  VARCHAR(500)    DEFAULT NULL                    COMMENT '备注',
  `create_dept`             BIGINT          DEFAULT NULL,
  `create_by`               BIGINT          DEFAULT NULL,
  `create_time`             DATETIME        DEFAULT NULL,
  `update_by`               BIGINT          DEFAULT NULL,
  `update_time`             DATETIME        DEFAULT NULL,
  `deleted`                 TINYINT(1)      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_devanning_no_tenant` (`devanning_no`, `tenant_id`),
  UNIQUE KEY `uk_source_order` (`source_order_id`, `source_order_type`, `deleted`),
  KEY `idx_tenant_status` (`tenant_id`, `status`),
  KEY `idx_warehouse_status` (`warehouse_id`, `status`),
  KEY `idx_container_no` (`container_no`),
  KEY `idx_biz_root_id` (`biz_root_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='WMS拆柜订单';

CREATE TABLE IF NOT EXISTS `wms_devanning_order_trace` (
  `id`                  BIGINT          NOT NULL                    COMMENT '主键',
  `tenant_id`           VARCHAR(20)     NOT NULL DEFAULT '000000'   COMMENT '租户ID',
  `devanning_order_id`  BIGINT          NOT NULL                    COMMENT '拆柜订单ID',
  `action_type`         VARCHAR(50)     NOT NULL                    COMMENT '动作类型',
  `before_status`       VARCHAR(30)     DEFAULT NULL                COMMENT '操作前状态',
  `after_status`        VARCHAR(30)     DEFAULT NULL                COMMENT '操作后状态',
  `action_content`      TEXT            DEFAULT NULL                COMMENT '描述',
  `operator_id`         BIGINT          DEFAULT NULL,
  `operator_name`       VARCHAR(50)     DEFAULT NULL,
  `action_time`         DATETIME        DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_devanning_order_id` (`devanning_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='WMS拆柜订单轨迹';

INSERT IGNORE INTO sys_dict_type(dict_id, tenant_id, dict_name, dict_type, create_dept, create_by, create_time, remark)
VALUES (7001001, '000000', 'WMS拆柜方式', 'wms_devanning_method', 103, 1, NOW(), '');
INSERT IGNORE INTO sys_dict_data(dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_dept, create_by, create_time)
VALUES
(70010011,'000000',1,'人工','MANUAL','wms_devanning_method','','default','Y',103,1,NOW()),
(70010012,'000000',2,'叉车','FORKLIFT','wms_devanning_method','','info','N',103,1,NOW()),
(70010013,'000000',3,'机械','MACHINE','wms_devanning_method','','primary','N',103,1,NOW());

INSERT IGNORE INTO sys_dict_type(dict_id, tenant_id, dict_name, dict_type, create_dept, create_by, create_time, remark)
VALUES (7001002, '000000', 'WMS来源单类型', 'wms_source_order_type', 103, 1, NOW(), '');
INSERT IGNORE INTO sys_dict_data(dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_dept, create_by, create_time)
VALUES
(70010021,'000000',1,'OMS海柜订单','CONTAINER_ORDER','wms_source_order_type','','info','Y',103,1,NOW()),
(70010022,'000000',2,'手动创建','MANUAL','wms_source_order_type','','default','N',103,1,NOW());

INSERT IGNORE INTO sys_dict_type(dict_id, tenant_id, dict_name, dict_type, create_dept, create_by, create_time, remark)
VALUES (7001003, '000000', 'WMS拆柜订单状态', 'wms_devanning_status', 103, 1, NOW(), '');
INSERT IGNORE INTO sys_dict_data(dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_dept, create_by, create_time)
VALUES
(70010031,'000000',1,'未提柜','UNPICKEDUP','wms_devanning_status','','default','N',103,1,NOW()),
(70010032,'000000',2,'已提柜','PICKEDUP','wms_devanning_status','','info','N',103,1,NOW()),
(70010033,'000000',3,'已到仓','ARRIVED','wms_devanning_status','','processing','N',103,1,NOW()),
(70010034,'000000',4,'拆柜中','DEVANNING','wms_devanning_status','','warning','N',103,1,NOW()),
(70010035,'000000',5,'拆柜完成','DEVANNED','wms_devanning_status','','success','N',103,1,NOW()),
(70010036,'000000',6,'异常','EXCEPTION','wms_devanning_status','','error','N',103,1,NOW()),
(70010037,'000000',7,'取消','CANCELLED','wms_devanning_status','','default','N',103,1,NOW());

INSERT IGNORE INTO sys_menu VALUES(6100, '订单管理', 6000, 3, 'order', NULL, '', 1, 0, 'M', '0', '0', '', 'ep:document', 103, 1, NOW(), NULL, NULL, 'WMS订单管理');
INSERT IGNORE INTO sys_menu VALUES(6101, '拆柜订单', 6100, 1, 'devanning-order', 'wms/devanning-order/index', '', 1, 0, 'C', '0', '0', 'wms:devanningOrder:list', 'ep:box', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6110, '拆柜订单详情', 6101, 1, '#', '', '', 1, 0, 'F', '0', '0', 'wms:devanningOrder:query', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6111, '拆柜订单新建', 6101, 2, '#', '', '', 1, 0, 'F', '0', '0', 'wms:devanningOrder:add', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6112, '拆柜订单编辑', 6101, 3, '#', '', '', 1, 0, 'F', '0', '0', 'wms:devanningOrder:edit', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6113, '确认提柜', 6101, 4, '#', '', '', 1, 0, 'F', '0', '0', 'wms:devanningOrder:confirmPickup', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6114, '到仓登记', 6101, 5, '#', '', '', 1, 0, 'F', '0', '0', 'wms:devanningOrder:confirmArrival', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6115, '开始拆柜', 6101, 6, '#', '', '', 1, 0, 'F', '0', '0', 'wms:devanningOrder:startDevanning', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6116, '完成拆柜', 6101, 7, '#', '', '', 1, 0, 'F', '0', '0', 'wms:devanningOrder:completeDevanning', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6117, '标记异常', 6101, 8, '#', '', '', 1, 0, 'F', '0', '0', 'wms:devanningOrder:markException', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6118, '解除异常', 6101, 9, '#', '', '', 1, 0, 'F', '0', '0', 'wms:devanningOrder:clearException', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6119, '取消拆柜', 6101, 10, '#', '', '', 1, 0, 'F', '0', '0', 'wms:devanningOrder:cancel', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6120, '入库计划', 6101, 11, '#', '', '', 1, 0, 'F', '0', '0', 'wms:devanningOrder:inboundPlan', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6121, '文件管理', 6101, 12, '#', '', '', 1, 0, 'F', '0', '0', 'wms:devanningOrder:attachment', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6122, '拆柜订单导出', 6101, 13, '#', '', '', 1, 0, 'F', '0', '0', 'wms:devanningOrder:export', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6123, 'OMS推单', 6101, 14, '#', '', '', 1, 0, 'F', '0', '0', 'wms:devanningOrder:push', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6124, 'Dock同步', 6101, 15, '#', '', '', 1, 0, 'F', '0', '0', 'wms:devanningOrder:syncDock', '#', 103, 1, NOW(), NULL, NULL, '');

INSERT IGNORE INTO sys_role_menu(role_id, menu_id)
SELECT 1, menu_id FROM sys_menu WHERE menu_id BETWEEN 6100 AND 6124;
