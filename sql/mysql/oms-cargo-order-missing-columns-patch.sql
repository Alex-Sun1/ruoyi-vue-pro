-- 补全 cargo_order 建单字段（仅当列不存在时手工执行对应语句）
-- 若报 Duplicate column name，说明该列已有，跳过该行即可。
-- 请在 application-*.yaml 里配置的同一库（如 overseas）执行。
SET NAMES utf8mb4;

ALTER TABLE `cargo_order`
    ADD COLUMN `delivery_method` varchar(30) DEFAULT NULL COMMENT '派送方式' AFTER `biz_type`;

ALTER TABLE `cargo_order`
    ADD COLUMN `consignee_name` varchar(128) DEFAULT NULL COMMENT '联系人' AFTER `delivery_method`;

ALTER TABLE `cargo_order`
    ADD COLUMN `consignee_phone` varchar(64) DEFAULT NULL COMMENT '电话' AFTER `consignee_name`;

ALTER TABLE `cargo_order`
    ADD COLUMN `consignee_email` varchar(100) DEFAULT NULL COMMENT '邮箱' AFTER `consignee_phone`;

ALTER TABLE `cargo_order`
    ADD COLUMN `delivery_address` varchar(512) DEFAULT NULL COMMENT '地址' AFTER `consignee_email`;

ALTER TABLE `cargo_order`
    ADD COLUMN `delivery_city` varchar(64) DEFAULT NULL COMMENT '城市' AFTER `delivery_address`;

ALTER TABLE `cargo_order`
    ADD COLUMN `delivery_state` varchar(32) DEFAULT NULL COMMENT '州省' AFTER `delivery_city`;

ALTER TABLE `cargo_order`
    ADD COLUMN `delivery_zip` varchar(20) DEFAULT NULL COMMENT '邮编' AFTER `delivery_state`;

ALTER TABLE `cargo_order`
    ADD COLUMN `appointment_no` varchar(64) DEFAULT NULL COMMENT '预约号' AFTER `delivery_zip`;

ALTER TABLE `cargo_order`
    ADD COLUMN `on_hold` bit(1) NOT NULL DEFAULT b'0' COMMENT '订单级HOLD' AFTER `appointment_no`;
