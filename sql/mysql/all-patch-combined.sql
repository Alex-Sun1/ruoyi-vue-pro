-- ============================================================
-- 全量补丁合并（幂等，MySQL 5.7+ 兼容）
-- 执行库：overseas（与 application-*.yaml 配置一致）
-- ============================================================
SET NAMES utf8mb4;

-- 通用辅助存储过程：列不存在时才执行 ALTER
DROP PROCEDURE IF EXISTS _add_col;
DELIMITER $$
CREATE PROCEDURE _add_col(
  IN p_table VARCHAR(64),
  IN p_col   VARCHAR(64),
  IN p_def   TEXT
)
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME   = p_table
      AND COLUMN_NAME  = p_col
  ) THEN
    SET @_sql = CONCAT('ALTER TABLE `', p_table, '` ADD COLUMN ', p_def);
    PREPARE _st FROM @_sql;
    EXECUTE _st;
    DEALLOCATE PREPARE _st;
  END IF;
END$$
DELIMITER ;

-- ==============================================================
-- 1. cargo_order  配送 / 收货人字段
-- ==============================================================
CALL _add_col('cargo_order','delivery_method',  '`delivery_method`  varchar(30)  DEFAULT NULL COMMENT ''派送方式''');
CALL _add_col('cargo_order','consignee_name',   '`consignee_name`   varchar(128) DEFAULT NULL COMMENT ''联系人''');
CALL _add_col('cargo_order','consignee_phone',  '`consignee_phone`  varchar(64)  DEFAULT NULL COMMENT ''电话''');
CALL _add_col('cargo_order','consignee_email',  '`consignee_email`  varchar(100) DEFAULT NULL COMMENT ''邮箱''');
CALL _add_col('cargo_order','delivery_address', '`delivery_address` varchar(512) DEFAULT NULL COMMENT ''地址''');
CALL _add_col('cargo_order','delivery_city',    '`delivery_city`    varchar(64)  DEFAULT NULL COMMENT ''城市''');
CALL _add_col('cargo_order','delivery_state',   '`delivery_state`   varchar(32)  DEFAULT NULL COMMENT ''州省''');
CALL _add_col('cargo_order','delivery_zip',     '`delivery_zip`     varchar(20)  DEFAULT NULL COMMENT ''邮编''');
CALL _add_col('cargo_order','appointment_no',   '`appointment_no`   varchar(64)  DEFAULT NULL COMMENT ''预约号''');
CALL _add_col('cargo_order','on_hold',          '`on_hold`          bit(1)       NOT NULL DEFAULT b''0'' COMMENT ''订单级HOLD''');

-- ==============================================================
-- 2. cargo_order  订单基础 / 来源
-- ==============================================================
CALL _add_col('cargo_order','cargo_order_no',        '`cargo_order_no`        varchar(64)  DEFAULT NULL COMMENT ''货物订单号（新编号体系）''');
CALL _add_col('cargo_order','external_order_no',     '`external_order_no`     varchar(128) DEFAULT NULL COMMENT ''外部订单号（客户/来源系统）''');
CALL _add_col('cargo_order','order_source',          '`order_source`          varchar(32)  DEFAULT NULL COMMENT ''订单来源(MANUAL/IMPORT/API/PORTAL)''');
CALL _add_col('cargo_order','business_type_id',      '`business_type_id`      bigint       DEFAULT NULL COMMENT ''业务类型ID''');
CALL _add_col('cargo_order','channel_id',            '`channel_id`            bigint       DEFAULT NULL COMMENT ''渠道ID''');
CALL _add_col('cargo_order','platform_id',           '`platform_id`           bigint       DEFAULT NULL COMMENT ''平台ID''');
CALL _add_col('cargo_order','customer_service_id',   '`customer_service_id`   bigint       DEFAULT NULL COMMENT ''客服ID''');
CALL _add_col('cargo_order','customer_service_name', '`customer_service_name` varchar(128) DEFAULT NULL COMMENT ''客服名称（冗余）''');

-- ==============================================================
-- 3. cargo_order  快递派送
-- ==============================================================
CALL _add_col('cargo_order','parcel_carrier_name', '`parcel_carrier_name` varchar(128) DEFAULT NULL COMMENT ''快递商名称''');
CALL _add_col('cargo_order','parcel_tracking_no',  '`parcel_tracking_no`  varchar(128) DEFAULT NULL COMMENT ''快递追踪号''');

-- ==============================================================
-- 4. cargo_order  货量计量
-- ==============================================================
CALL _add_col('cargo_order','forecast_qty_unit',   '`forecast_qty_unit`   varchar(32)   NOT NULL DEFAULT ''BY_CARTON'' COMMENT ''预报计量单位 BY_CARTON/BY_PALLET''');
CALL _add_col('cargo_order','declared_carton_qty', '`declared_carton_qty` decimal(10,2) DEFAULT NULL COMMENT ''预报箱数''');
CALL _add_col('cargo_order','declared_pallet_qty', '`declared_pallet_qty` decimal(10,2) DEFAULT NULL COMMENT ''预报托盘数''');
CALL _add_col('cargo_order','declared_piece_qty',  '`declared_piece_qty`  decimal(12,2) DEFAULT NULL COMMENT ''预报件数''');
CALL _add_col('cargo_order','actual_carton_qty',   '`actual_carton_qty`   decimal(10,2) DEFAULT NULL COMMENT ''实际箱数''');
CALL _add_col('cargo_order','actual_piece_qty',    '`actual_piece_qty`    decimal(12,2) DEFAULT NULL COMMENT ''实际件数''');
CALL _add_col('cargo_order','actual_pallet_qty',   '`actual_pallet_qty`   decimal(10,2) DEFAULT NULL COMMENT ''实际托盘数（WMS打板统计）''');
CALL _add_col('cargo_order','declared_cbm',        '`declared_cbm`        decimal(12,3) DEFAULT NULL COMMENT ''预报体积(m³)''');
CALL _add_col('cargo_order','actual_cbm',          '`actual_cbm`          decimal(12,3) DEFAULT NULL COMMENT ''实际体积(m³)''');
CALL _add_col('cargo_order','weight_unit',         '`weight_unit`         varchar(16)   NOT NULL DEFAULT ''KG''  COMMENT ''重量单位(KG/LB)''');
CALL _add_col('cargo_order','volume_unit',         '`volume_unit`         varchar(16)   NOT NULL DEFAULT ''CBM'' COMMENT ''体积单位''');

-- ==============================================================
-- 5. cargo_order  主状态
-- ==============================================================
CALL _add_col('cargo_order','order_status', '`order_status` varchar(32) NOT NULL DEFAULT ''NORMAL'' COMMENT ''订单状态(NORMAL/CANCELLED/CLOSED)''');

-- ==============================================================
-- 6. cargo_order  关键时间节点
-- ==============================================================
CALL _add_col('cargo_order','ata',                       '`ata`                       datetime DEFAULT NULL COMMENT ''ATA实际到港''');
CALL _add_col('cargo_order','actual_pickup_time',        '`actual_pickup_time`        datetime DEFAULT NULL COMMENT ''实际提柜时间''');
CALL _add_col('cargo_order','actual_arrival_time',       '`actual_arrival_time`       datetime DEFAULT NULL COMMENT ''实际到仓时间''');
CALL _add_col('cargo_order','devanning_finish_time',     '`devanning_finish_time`     datetime DEFAULT NULL COMMENT ''拆柜完成时间''');
CALL _add_col('cargo_order','actual_inbound_time',       '`actual_inbound_time`       datetime DEFAULT NULL COMMENT ''入库完成时间''');
CALL _add_col('cargo_order','delivery_appointment_time', '`delivery_appointment_time` datetime DEFAULT NULL COMMENT ''派送预约时间''');
CALL _add_col('cargo_order','actual_outbound_time',      '`actual_outbound_time`      datetime DEFAULT NULL COMMENT ''实际出库时间''');
CALL _add_col('cargo_order','signed_time',               '`signed_time`               datetime DEFAULT NULL COMMENT ''签收时间''');
CALL _add_col('cargo_order','pod_upload_time',           '`pod_upload_time`           datetime DEFAULT NULL COMMENT ''POD回传时间''');
CALL _add_col('cargo_order','billing_time',              '`billing_time`              datetime DEFAULT NULL COMMENT ''出账单时间''');
CALL _add_col('cargo_order','completed_time',            '`completed_time`            datetime DEFAULT NULL COMMENT ''全链路完成时间''');

-- ==============================================================
-- 7. cargo_order  异常
-- ==============================================================
CALL _add_col('cargo_order','exception_flag',  '`exception_flag`  tinyint(1) NOT NULL DEFAULT 0 COMMENT ''是否有未关闭异常''');
CALL _add_col('cargo_order','exception_count', '`exception_count` int        NOT NULL DEFAULT 0 COMMENT ''未关闭异常数量''');

-- ==============================================================
-- 8. cargo_order  HOLD
-- ==============================================================
CALL _add_col('cargo_order','hold_status',    '`hold_status`    varchar(32)  NOT NULL DEFAULT ''NORMAL'' COMMENT ''NORMAL/HOLDING/RELEASED''');
CALL _add_col('cargo_order','hold_type',      '`hold_type`      varchar(64)  DEFAULT NULL COMMENT ''暂扣类型''');
CALL _add_col('cargo_order','hold_reason',    '`hold_reason`    varchar(500) DEFAULT NULL COMMENT ''当前暂扣原因''');
CALL _add_col('cargo_order','hold_time',      '`hold_time`      datetime     DEFAULT NULL COMMENT ''暂扣时间''');
CALL _add_col('cargo_order','hold_user_id',   '`hold_user_id`   bigint       DEFAULT NULL COMMENT ''暂扣人ID''');
CALL _add_col('cargo_order','hold_user_name', '`hold_user_name` varchar(128) DEFAULT NULL COMMENT ''暂扣人名称''');
CALL _add_col('cargo_order','release_time',   '`release_time`   datetime     DEFAULT NULL COMMENT ''最近放行时间''');
CALL _add_col('cargo_order','hold_remark',    '`hold_remark`    varchar(500) DEFAULT NULL COMMENT ''HOLD原因/说明''');

-- ==============================================================
-- 9. cargo_order  拆单
-- ==============================================================
CALL _add_col('cargo_order','parent_order_id',           '`parent_order_id`           bigint       DEFAULT NULL COMMENT ''父订单ID''');
CALL _add_col('cargo_order','parent_order_no',           '`parent_order_no`           varchar(64)  DEFAULT NULL COMMENT ''父订单号''');
CALL _add_col('cargo_order','root_order_id',             '`root_order_id`             bigint       DEFAULT NULL COMMENT ''根订单ID''');
CALL _add_col('cargo_order','root_order_no',             '`root_order_no`             varchar(64)  DEFAULT NULL COMMENT ''根订单号''');
CALL _add_col('cargo_order','split_flag',                '`split_flag`                tinyint(1)   NOT NULL DEFAULT 0      COMMENT ''是否参与拆单''');
CALL _add_col('cargo_order','split_role',                '`split_role`                varchar(32)  NOT NULL DEFAULT ''NORMAL'' COMMENT ''NORMAL/SPLIT_PARENT/SPLIT_CHILD''');
CALL _add_col('cargo_order','split_status',              '`split_status`              varchar(32)  NOT NULL DEFAULT ''NONE''   COMMENT ''NONE/SPLIT_ACTIVE/MERGED_BACK''');
CALL _add_col('cargo_order','split_group_no',            '`split_group_no`            varchar(64)  DEFAULT NULL COMMENT ''拆单批次号''');
CALL _add_col('cargo_order','child_order_count',         '`child_order_count`         int          NOT NULL DEFAULT 0 COMMENT ''子单数量''');
CALL _add_col('cargo_order','merged_back_time',          '`merged_back_time`          datetime     DEFAULT NULL COMMENT ''回并时间''');
CALL _add_col('cargo_order','merged_back_by',            '`merged_back_by`            bigint       DEFAULT NULL COMMENT ''回并人ID''');
CALL _add_col('cargo_order','split_source',              '`split_source`              varchar(32)  DEFAULT NULL COMMENT ''CUSTOMER/INTERNAL''');
CALL _add_col('cargo_order','customer_visible_flag',     '`customer_visible_flag`     tinyint(1)   NOT NULL DEFAULT 1 COMMENT ''客户是否可见''');
CALL _add_col('cargo_order','customer_split_reason',     '`customer_split_reason`     varchar(500) DEFAULT NULL COMMENT ''客户拆单原因''');
CALL _add_col('cargo_order','internal_split_reason',     '`internal_split_reason`     varchar(500) DEFAULT NULL COMMENT ''内部拆单原因''');
CALL _add_col('cargo_order','split_requested_by',        '`split_requested_by`        varchar(32)  DEFAULT NULL COMMENT ''发起来源''');
CALL _add_col('cargo_order','split_requested_user_id',   '`split_requested_user_id`   bigint       DEFAULT NULL COMMENT ''发起人ID''');
CALL _add_col('cargo_order','split_requested_user_name', '`split_requested_user_name` varchar(128) DEFAULT NULL COMMENT ''发起人名称''');
CALL _add_col('cargo_order','split_time',                '`split_time`                datetime     DEFAULT NULL COMMENT ''拆单时间''');
CALL _add_col('cargo_order','split_fee_flag',            '`split_fee_flag`            tinyint(1)   NOT NULL DEFAULT 0 COMMENT ''是否可能产生拆单费用''');
CALL _add_col('cargo_order','split_fee_amount',          '`split_fee_amount`          decimal(10,2) DEFAULT NULL COMMENT ''拆单费用''');
CALL _add_col('cargo_order','split_fee_remark',          '`split_fee_remark`          varchar(500) DEFAULT NULL COMMENT ''拆单费用备注''');

-- ==============================================================
-- 10. cargo_order  附件统计 / 备注扩展
-- ==============================================================
CALL _add_col('cargo_order','attachment_count',           '`attachment_count`           int      NOT NULL DEFAULT 0 COMMENT ''附件总数''');
CALL _add_col('cargo_order','pod_attachment_count',       '`pod_attachment_count`       int      NOT NULL DEFAULT 0 COMMENT ''POD附件数量''');
CALL _add_col('cargo_order','exception_attachment_count', '`exception_attachment_count` int      NOT NULL DEFAULT 0 COMMENT ''异常附件数量''');
CALL _add_col('cargo_order','latest_attachment_time',     '`latest_attachment_time`     datetime DEFAULT NULL COMMENT ''最近附件上传时间''');
CALL _add_col('cargo_order','customer_remark',            '`customer_remark`            text     DEFAULT NULL COMMENT ''客户备注''');
CALL _add_col('cargo_order','operation_remark',           '`operation_remark`           text     DEFAULT NULL COMMENT ''操作备注''');
CALL _add_col('cargo_order','follow_up_remark',           '`follow_up_remark`           text     DEFAULT NULL COMMENT ''跟进记录''');

-- ==============================================================
-- 11. cargo_order  提柜 / 拆柜 / 还柜
-- ==============================================================
CALL _add_col('cargo_order','pickup_appointment_no',       '`pickup_appointment_no`       varchar(100) DEFAULT NULL COMMENT ''提柜预约单号''');
CALL _add_col('cargo_order','pickup_appointment_time',     '`pickup_appointment_time`     datetime     DEFAULT NULL COMMENT ''提柜预约时间''');
CALL _add_col('cargo_order','pickup_remark',               '`pickup_remark`               varchar(500) DEFAULT NULL COMMENT ''提柜备注''');
CALL _add_col('cargo_order','arrival_remark',              '`arrival_remark`              varchar(500) DEFAULT NULL COMMENT ''到港备注''');
CALL _add_col('cargo_order','devanning_remark',            '`devanning_remark`            varchar(500) DEFAULT NULL COMMENT ''拆柜备注''');
CALL _add_col('cargo_order','empty_return_location',       '`empty_return_location`       varchar(200) DEFAULT NULL COMMENT ''还柜地点''');
CALL _add_col('cargo_order','empty_return_appointment_no', '`empty_return_appointment_no` varchar(100) DEFAULT NULL COMMENT ''还柜预约单号''');
CALL _add_col('cargo_order','empty_return_time',           '`empty_return_time`           datetime     DEFAULT NULL COMMENT ''还柜时间''');
CALL _add_col('cargo_order','empty_return_status',         '`empty_return_status`         varchar(50)  DEFAULT NULL COMMENT ''还柜状态''');
CALL _add_col('cargo_order','empty_return_remark',         '`empty_return_remark`         varchar(500) DEFAULT NULL COMMENT ''还柜备注''');

-- ==============================================================
-- 12. cargo_order_item  货件关联字段
-- ==============================================================
CALL _add_col('cargo_order_item','shipment_id', '`shipment_id` bigint       DEFAULT NULL COMMENT ''货件ID''');
CALL _add_col('cargo_order_item','sku_name',    '`sku_name`    varchar(255) DEFAULT NULL COMMENT ''SKU名称''');
CALL _add_col('cargo_order_item','planned_qty', '`planned_qty` int          DEFAULT NULL COMMENT ''计划数量''');

-- ==============================================================
-- 13. shipment  货件建单字段
-- ==============================================================
CALL _add_col('shipment','shipment_code',    '`shipment_code`    varchar(64)   DEFAULT NULL COMMENT ''货件编码''');
CALL _add_col('shipment','po_no',            '`po_no`            varchar(64)   DEFAULT NULL COMMENT ''PO号''');
CALL _add_col('shipment','dw_date',          '`dw_date`          date          DEFAULT NULL COMMENT ''DW日期''');
CALL _add_col('shipment','dw_start',         '`dw_start`         varchar(16)   DEFAULT NULL COMMENT ''DW开始''');
CALL _add_col('shipment','dw_end',           '`dw_end`           varchar(16)   DEFAULT NULL COMMENT ''DW结束''');
CALL _add_col('shipment','planned_ctns',     '`planned_ctns`     int           DEFAULT NULL COMMENT ''计划箱数''');
CALL _add_col('shipment','gross_weight_lbs', '`gross_weight_lbs` decimal(18,3) DEFAULT NULL COMMENT ''重量磅''');
CALL _add_col('shipment','cbm',              '`cbm`              decimal(18,3) DEFAULT NULL COMMENT ''体积''');
CALL _add_col('shipment','goods_name',       '`goods_name`       varchar(255)  DEFAULT NULL COMMENT ''商品名称''');

-- ==============================================================
-- 14. oms_outbound_order  地址 / 转仓 / 物流字段
-- ==============================================================
CALL _add_col('oms_outbound_order','transfer_out_warehouse_id', '`transfer_out_warehouse_id` bigint       DEFAULT NULL COMMENT ''转出仓库ID''');
CALL _add_col('oms_outbound_order','estimated_transfer_time',   '`estimated_transfer_time`   datetime     DEFAULT NULL COMMENT ''预计转仓时间''');
CALL _add_col('oms_outbound_order','address_line1',             '`address_line1`             varchar(255) DEFAULT NULL COMMENT ''地址行1''');
CALL _add_col('oms_outbound_order','address_line2',             '`address_line2`             varchar(255) DEFAULT NULL COMMENT ''地址行2''');
CALL _add_col('oms_outbound_order','city',                      '`city`                      varchar(100) DEFAULT NULL COMMENT ''城市''');
CALL _add_col('oms_outbound_order','state',                     '`state`                     varchar(100) DEFAULT NULL COMMENT ''州/省''');
CALL _add_col('oms_outbound_order','zip_code',                  '`zip_code`                  varchar(20)  DEFAULT NULL COMMENT ''邮编''');
CALL _add_col('oms_outbound_order','country',                   '`country`                   varchar(50)  DEFAULT NULL COMMENT ''国家''');
CALL _add_col('oms_outbound_order','carrier',                   '`carrier`                   varchar(100) DEFAULT NULL COMMENT ''承运商''');
CALL _add_col('oms_outbound_order','tracking_no',               '`tracking_no`               varchar(100) DEFAULT NULL COMMENT ''追踪单号''');
CALL _add_col('oms_outbound_order','actual_signed_time',        '`actual_signed_time`        datetime     DEFAULT NULL COMMENT ''实际签收时间''');
CALL _add_col('oms_outbound_order','dispatch_remark',           '`dispatch_remark`           varchar(500) DEFAULT NULL COMMENT ''派送备注''');
CALL _add_col('oms_outbound_order','operation_remark',          '`operation_remark`          varchar(500) DEFAULT NULL COMMENT ''操作备注''');

-- ==============================================================
-- 15. mdm_company  公司扩展字段
-- ==============================================================
CALL _add_col('mdm_company','country_code',        '`country_code`        varchar(10)  DEFAULT NULL COMMENT ''国家代码''');
CALL _add_col('mdm_company','registered_addr',     '`registered_addr`     varchar(500) DEFAULT NULL COMMENT ''注册地址''');
CALL _add_col('mdm_company','vat_registered',      '`vat_registered`      tinyint(1)   DEFAULT NULL COMMENT ''是否VAT注册（0否1是）''');
CALL _add_col('mdm_company','invoice_title',       '`invoice_title`       varchar(200) DEFAULT NULL COMMENT ''开票抬头''');
CALL _add_col('mdm_company','invoice_tax_no',      '`invoice_tax_no`      varchar(50)  DEFAULT NULL COMMENT ''开票税号''');
CALL _add_col('mdm_company','invoice_bank_name',   '`invoice_bank_name`   varchar(200) DEFAULT NULL COMMENT ''开票银行''');
CALL _add_col('mdm_company','bank_account_masked', '`bank_account_masked` varchar(50)  DEFAULT NULL COMMENT ''银行账号（脱敏展示）''');
CALL _add_col('mdm_company','bank_name',           '`bank_name`           varchar(200) DEFAULT NULL COMMENT ''银行名称''');
CALL _add_col('mdm_company','bank_account_no',     '`bank_account_no`     varchar(200) DEFAULT NULL COMMENT ''银行账号（加密存储）''');
CALL _add_col('mdm_company','swift_code',          '`swift_code`          varchar(20)  DEFAULT NULL COMMENT ''SWIFT/BIC代码''');
CALL _add_col('mdm_company','beneficiary',         '`beneficiary`         varchar(200) DEFAULT NULL COMMENT ''收款人''');
CALL _add_col('mdm_company','currency_code',       '`currency_code`       varchar(10)  DEFAULT NULL COMMENT ''结算货币代码''');
CALL _add_col('mdm_company','timezone',            '`timezone`            varchar(64)  DEFAULT NULL COMMENT ''时区（IANA标准）''');
CALL _add_col('mdm_company','license_files',       '`license_files`       text         DEFAULT NULL COMMENT ''营业执照等附件（JSON数组）''');

-- ==============================================================
-- 16. mdm_warehouse  仓库扩展字段
-- ==============================================================
CALL _add_col('mdm_warehouse','warehouse_type',       '`warehouse_type`       varchar(32)   DEFAULT NULL COMMENT ''仓库类型''');
CALL _add_col('mdm_warehouse','state_code',           '`state_code`           varchar(20)   DEFAULT NULL COMMENT ''州/省代码''');
CALL _add_col('mdm_warehouse','city',                 '`city`                 varchar(100)  DEFAULT NULL COMMENT ''城市''');
CALL _add_col('mdm_warehouse','zip_code',             '`zip_code`             varchar(20)   DEFAULT NULL COMMENT ''邮编''');
CALL _add_col('mdm_warehouse','currency_code',        '`currency_code`        varchar(10)   DEFAULT NULL COMMENT ''货币代码''');
CALL _add_col('mdm_warehouse','contact_name',         '`contact_name`         varchar(100)  DEFAULT NULL COMMENT ''联系人''');
CALL _add_col('mdm_warehouse','contact_phone',        '`contact_phone`        varchar(50)   DEFAULT NULL COMMENT ''联系电话''');
CALL _add_col('mdm_warehouse','is_bonded',            '`is_bonded`            tinyint(1)    DEFAULT NULL COMMENT ''是否保税仓''');
CALL _add_col('mdm_warehouse','operation_start_time', '`operation_start_time` varchar(8)    DEFAULT NULL COMMENT ''运营开始时间''');
CALL _add_col('mdm_warehouse','operation_end_time',   '`operation_end_time`   varchar(8)    DEFAULT NULL COMMENT ''运营结束时间''');
CALL _add_col('mdm_warehouse','support_unloading',    '`support_unloading`    tinyint(1)    DEFAULT NULL COMMENT ''支持卸货''');
CALL _add_col('mdm_warehouse','support_dropship',     '`support_dropship`     tinyint(1)    DEFAULT NULL COMMENT ''支持一件代发''');
CALL _add_col('mdm_warehouse','support_transit',      '`support_transit`      tinyint(1)    DEFAULT NULL COMMENT ''支持中转''');
CALL _add_col('mdm_warehouse','support_transfer',     '`support_transfer`     tinyint(1)    DEFAULT NULL COMMENT ''支持转仓''');
CALL _add_col('mdm_warehouse','support_fba',          '`support_fba`          tinyint(1)    DEFAULT NULL COMMENT ''支持FBA''');
CALL _add_col('mdm_warehouse','support_self_pickup',  '`support_self_pickup`  tinyint(1)    DEFAULT NULL COMMENT ''支持自提''');
CALL _add_col('mdm_warehouse','support_appointment',  '`support_appointment`  tinyint(1)    DEFAULT NULL COMMENT ''支持预约''');
CALL _add_col('mdm_warehouse','max_capacity_cbm',     '`max_capacity_cbm`     decimal(12,3) DEFAULT NULL COMMENT ''最大容量CBM''');
CALL _add_col('mdm_warehouse','daily_unloading_cap',  '`daily_unloading_cap`  int           DEFAULT NULL COMMENT ''日卸货能力''');
CALL _add_col('mdm_warehouse','daily_outbound_cap',   '`daily_outbound_cap`   int           DEFAULT NULL COMMENT ''日出货能力''');
CALL _add_col('mdm_warehouse','dock_count',           '`dock_count`           int           DEFAULT NULL COMMENT ''月台数''');
CALL _add_col('mdm_warehouse','door_count',           '`door_count`           int           DEFAULT NULL COMMENT ''门数''');
CALL _add_col('mdm_warehouse','forklift_count',       '`forklift_count`       int           DEFAULT NULL COMMENT ''叉车数''');
CALL _add_col('mdm_warehouse','pda_enabled',          '`pda_enabled`          tinyint(1)    DEFAULT NULL COMMENT ''PDA启用''');
CALL _add_col('mdm_warehouse','api_enabled',          '`api_enabled`          tinyint(1)    DEFAULT NULL COMMENT ''API启用''');
CALL _add_col('mdm_warehouse','api_config',           '`api_config`           text          DEFAULT NULL COMMENT ''API配置（JSON）''');

-- ==============================================================
-- 17. base_shipping_line  排序字段
-- ==============================================================
CALL _add_col('base_shipping_line','sort', '`sort` int DEFAULT 0 COMMENT ''排序''');

-- ==============================================================
-- 18. system_menu  OMS 菜单按钮（ON DUPLICATE KEY UPDATE 幂等）
-- ==============================================================
INSERT INTO `system_menu` (`id`,`name`,`permission`,`type`,`sort`,`parent_id`,`path`,`icon`,`component`,
                           `component_name`,`status`,`visible`,`keep_alive`,`always_show`,`creator`,
                           `create_time`,`updater`,`update_time`,`deleted`)
VALUES
  (6914,'海柜查看',  'oms:container:view',3,4,6901,'','','',NULL,0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0'),
  (6915,'海柜复制',  'oms:container:copy',3,5,6901,'','','',NULL,0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0'),
  (6924,'委托单查询','oms:order:query',   3,4,6902,'','','',NULL,0,b'1',b'1',b'1','admin',NOW(),'admin',NOW(),b'0')
ON DUPLICATE KEY UPDATE
  `name`=VALUES(`name`), `permission`=VALUES(`permission`),
  `parent_id`=VALUES(`parent_id`), `updater`=VALUES(`updater`),
  `update_time`=NOW(), `deleted`=VALUES(`deleted`);

-- ==============================================================
-- 清理辅助存储过程
-- ==============================================================
DROP PROCEDURE IF EXISTS _add_col;

SELECT 'all-patch-combined.sql executed successfully' AS result;
