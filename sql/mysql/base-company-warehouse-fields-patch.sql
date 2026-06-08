-- ============================================================
-- Patch: add missing columns to mdm_company and mdm_warehouse
-- ============================================================

-- Add missing columns to mdm_company
ALTER TABLE mdm_company ADD COLUMN IF NOT EXISTS country_code       VARCHAR(10)   DEFAULT NULL COMMENT '国家代码';
ALTER TABLE mdm_company ADD COLUMN IF NOT EXISTS registered_addr    VARCHAR(500)  DEFAULT NULL COMMENT '注册地址';
ALTER TABLE mdm_company ADD COLUMN IF NOT EXISTS vat_registered     TINYINT(1)    DEFAULT NULL COMMENT '是否VAT注册（0否1是）';
ALTER TABLE mdm_company ADD COLUMN IF NOT EXISTS invoice_title      VARCHAR(200)  DEFAULT NULL COMMENT '开票抬头';
ALTER TABLE mdm_company ADD COLUMN IF NOT EXISTS invoice_tax_no     VARCHAR(50)   DEFAULT NULL COMMENT '开票税号';
ALTER TABLE mdm_company ADD COLUMN IF NOT EXISTS invoice_bank_name  VARCHAR(200)  DEFAULT NULL COMMENT '开票银行';
ALTER TABLE mdm_company ADD COLUMN IF NOT EXISTS bank_account_masked VARCHAR(50)  DEFAULT NULL COMMENT '银行账号（脱敏展示）';
ALTER TABLE mdm_company ADD COLUMN IF NOT EXISTS bank_name          VARCHAR(200)  DEFAULT NULL COMMENT '银行名称';
ALTER TABLE mdm_company ADD COLUMN IF NOT EXISTS bank_account_no    VARCHAR(200)  DEFAULT NULL COMMENT '银行账号（加密存储）';
ALTER TABLE mdm_company ADD COLUMN IF NOT EXISTS swift_code         VARCHAR(20)   DEFAULT NULL COMMENT 'SWIFT/BIC代码';
ALTER TABLE mdm_company ADD COLUMN IF NOT EXISTS beneficiary        VARCHAR(200)  DEFAULT NULL COMMENT '收款人';
ALTER TABLE mdm_company ADD COLUMN IF NOT EXISTS currency_code      VARCHAR(10)   DEFAULT NULL COMMENT '结算货币代码';
ALTER TABLE mdm_company ADD COLUMN IF NOT EXISTS timezone           VARCHAR(64)   DEFAULT NULL COMMENT '时区（IANA标准）';
ALTER TABLE mdm_company ADD COLUMN IF NOT EXISTS license_files      TEXT          DEFAULT NULL COMMENT '营业执照等附件（JSON数组）';

-- Add missing columns to mdm_warehouse
ALTER TABLE mdm_warehouse ADD COLUMN IF NOT EXISTS warehouse_type        VARCHAR(32)    DEFAULT NULL COMMENT '仓库类型';
ALTER TABLE mdm_warehouse ADD COLUMN IF NOT EXISTS state_code            VARCHAR(20)    DEFAULT NULL COMMENT '州/省代码';
ALTER TABLE mdm_warehouse ADD COLUMN IF NOT EXISTS city                  VARCHAR(100)   DEFAULT NULL COMMENT '城市';
ALTER TABLE mdm_warehouse ADD COLUMN IF NOT EXISTS zip_code              VARCHAR(20)    DEFAULT NULL COMMENT '邮编';
ALTER TABLE mdm_warehouse ADD COLUMN IF NOT EXISTS currency_code         VARCHAR(10)    DEFAULT NULL COMMENT '货币代码';
ALTER TABLE mdm_warehouse ADD COLUMN IF NOT EXISTS contact_name          VARCHAR(100)   DEFAULT NULL COMMENT '联系人';
ALTER TABLE mdm_warehouse ADD COLUMN IF NOT EXISTS contact_phone         VARCHAR(50)    DEFAULT NULL COMMENT '联系电话';
ALTER TABLE mdm_warehouse ADD COLUMN IF NOT EXISTS is_bonded             TINYINT(1)     DEFAULT NULL COMMENT '是否保税仓';
ALTER TABLE mdm_warehouse ADD COLUMN IF NOT EXISTS operation_start_time  VARCHAR(8)     DEFAULT NULL COMMENT '运营开始时间';
ALTER TABLE mdm_warehouse ADD COLUMN IF NOT EXISTS operation_end_time    VARCHAR(8)     DEFAULT NULL COMMENT '运营结束时间';
ALTER TABLE mdm_warehouse ADD COLUMN IF NOT EXISTS support_unloading     TINYINT(1)     DEFAULT NULL COMMENT '支持卸货';
ALTER TABLE mdm_warehouse ADD COLUMN IF NOT EXISTS support_dropship      TINYINT(1)     DEFAULT NULL COMMENT '支持一件代发';
ALTER TABLE mdm_warehouse ADD COLUMN IF NOT EXISTS support_transit       TINYINT(1)     DEFAULT NULL COMMENT '支持中转';
ALTER TABLE mdm_warehouse ADD COLUMN IF NOT EXISTS support_transfer      TINYINT(1)     DEFAULT NULL COMMENT '支持转仓';
ALTER TABLE mdm_warehouse ADD COLUMN IF NOT EXISTS support_fba           TINYINT(1)     DEFAULT NULL COMMENT '支持FBA';
ALTER TABLE mdm_warehouse ADD COLUMN IF NOT EXISTS support_self_pickup   TINYINT(1)     DEFAULT NULL COMMENT '支持自提';
ALTER TABLE mdm_warehouse ADD COLUMN IF NOT EXISTS support_appointment   TINYINT(1)     DEFAULT NULL COMMENT '支持预约';
ALTER TABLE mdm_warehouse ADD COLUMN IF NOT EXISTS max_capacity_cbm      DECIMAL(12, 3) DEFAULT NULL COMMENT '最大容量CBM';
ALTER TABLE mdm_warehouse ADD COLUMN IF NOT EXISTS daily_unloading_cap   INT            DEFAULT NULL COMMENT '日卸货能力';
ALTER TABLE mdm_warehouse ADD COLUMN IF NOT EXISTS daily_outbound_cap    INT            DEFAULT NULL COMMENT '日出货能力';
ALTER TABLE mdm_warehouse ADD COLUMN IF NOT EXISTS dock_count            INT            DEFAULT NULL COMMENT '月台数';
ALTER TABLE mdm_warehouse ADD COLUMN IF NOT EXISTS door_count            INT            DEFAULT NULL COMMENT '门数';
ALTER TABLE mdm_warehouse ADD COLUMN IF NOT EXISTS forklift_count        INT            DEFAULT NULL COMMENT '叉车数';
ALTER TABLE mdm_warehouse ADD COLUMN IF NOT EXISTS pda_enabled           TINYINT(1)     DEFAULT NULL COMMENT 'PDA启用';
ALTER TABLE mdm_warehouse ADD COLUMN IF NOT EXISTS api_enabled           TINYINT(1)     DEFAULT NULL COMMENT 'API启用';
ALTER TABLE mdm_warehouse ADD COLUMN IF NOT EXISTS api_config            TEXT           DEFAULT NULL COMMENT 'API配置（JSON）';
