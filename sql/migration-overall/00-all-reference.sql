CREATE DATABASE  IF NOT EXISTS `sun` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `sun`;
-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: sun
-- ------------------------------------------------------
-- Server version	8.4.8

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `base_business_type`
--

DROP TABLE IF EXISTS `base_business_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `base_business_type` (
  `id` bigint NOT NULL COMMENT '主键（雪花ID）',
  `tenant_id` varchar(20) NOT NULL COMMENT '租户ID',
  `business_type_code` varchar(64) NOT NULL COMMENT '业务类型编码（租户内唯一，创建后不可修改）',
  `business_type_name` varchar(128) NOT NULL COMMENT '业务类型名称',
  `business_category` varchar(32) NOT NULL COMMENT '业务大类',
  `operation_flow_type` varchar(32) DEFAULT NULL COMMENT '作业流程类型',
  `receive_required` char(1) NOT NULL DEFAULT '0' COMMENT '是否需要接单',
  `inbound_required` char(1) NOT NULL DEFAULT '0' COMMENT '是否需要入库',
  `putaway_required` char(1) NOT NULL DEFAULT '0' COMMENT '是否需要上架',
  `storage_required` char(1) NOT NULL DEFAULT '0' COMMENT '是否需要仓储',
  `picking_required` char(1) NOT NULL DEFAULT '0' COMMENT '是否需要拣货',
  `outbound_required` char(1) NOT NULL DEFAULT '0' COMMENT '是否需要出库',
  `delivery_required` char(1) NOT NULL DEFAULT '0' COMMENT '是否需要派送',
  `appointment_required` char(1) NOT NULL DEFAULT '0' COMMENT '是否需要预约',
  `vas_supported` char(1) NOT NULL DEFAULT '0' COMMENT '是否支持增值服务',
  `sorting_strategy` varchar(32) DEFAULT NULL COMMENT '分货策略',
  `sorting_field` varchar(64) DEFAULT NULL COMMENT '分货依据字段',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序',
  `status` char(1) NOT NULL DEFAULT '0' COMMENT '状态（0=正常，1=禁用）',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` bigint DEFAULT '0' COMMENT '逻辑删除（0=存在，1=删除）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_base_business_type_code` (`tenant_id`,`business_type_code`),
  KEY `idx_base_business_type_status` (`tenant_id`,`status`),
  KEY `idx_base_business_type_category` (`tenant_id`,`business_category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='业务类型基础资料';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `base_business_type`
--

LOCK TABLES `base_business_type` WRITE;
/*!40000 ALTER TABLE `base_business_type` DISABLE KEYS */;
INSERT INTO `base_business_type` VALUES (5002001,'000000','TRUCK_DELIVERY','卡车派送','TRANSPORT','OUTBOUND','1','0','0','0','1','1','1','1','0','FIELD_BASED','warehouse_code',1,'0','Ú£ÇÞªüþ╗┤µèñÞ»ªþ╗åµ┤¥ÚÇüÕ£░ÕØÇ´╝îÕÅ»µîëÕ╣│ÕÅ░õ╗ô/þºüõ╗ô/Õòåõ©ÜÕ£░ÕØÇÕî║Õêå',103,1,'2026-05-22 01:18:15',1,'2026-05-26 04:36:37',0),(5002002,'000000','EXPRESS_DELIVERY','快递派送','TRANSPORT','OUTBOUND','1','0','0','0','1','1','1','0','0','NONE',NULL,2,'0','Õ┐½ÚÇÆÕòåÕ┐àÕí½´╝îÞ┐¢Þ©¬ÕÅÀÕÅ»ÕÉÄÞíÑ',103,1,'2026-05-22 01:18:15',1,'2026-05-26 04:36:46',0),(5002003,'000000','CUSTOMER_PICKUP','客户自提','TRANSPORT','OUTBOUND','1','0','0','0','1','1','0','0','0','NONE',NULL,3,'0','Õ«óµêÀÞç¬ÞíîµÅÉÞ┤º´╝îÕ£░ÕØÇÚØ×Õ┐àÕí½',103,1,'2026-05-22 01:18:15',1,'2026-05-26 04:36:55',0),(5002004,'000000','LTL','LTL','TRANSPORT','OUTBOUND','1','0','0','0','1','1','1','0','0','NONE',NULL,4,'0','ÚøÂµïàµ┤¥ÚÇü´╝îÕ£░ÕØÇõ┐íµü»ÕÅ»ÕÉÄþ╗¡þö▒Þ░âÕ║ªÞíÑÕàà',103,1,'2026-05-25 12:32:22',1,'2026-05-25 12:33:36',0),(5002005,'000000','BULK_TRANSFER','大货中转','WAREHOUSE','INBOUND_OUTBOUND','0','1','1','1','1','1','0','0','0','FIELD_BASED','warehouse_code',5,'0',NULL,103,1,'2026-05-25 12:32:22',1,'2026-05-26 04:37:06',0),(5002006,'000000','DROPSHIP','一件代发','WAREHOUSE','OUTBOUND','1','0','0','1','1','1','1','0','1','FIELD_BASED','sku',6,'0',NULL,103,1,'2026-05-25 12:32:22',1,'2026-05-26 04:37:15',0),(5002007,'000000','WAREHOUSE_SUPPLIES','仓库物资','WAREHOUSE','SERVICE','0','1','1','1','0','0','0','0','0','NONE',NULL,7,'0','õ╗ôÕ║ôÞÇùµØÉÒÇüþë®ÞÁäþ▒╗ÕåàÚâ¿õ©ÜÕèí',103,1,'2026-05-25 12:32:22',1,'2026-05-26 04:37:31',0);
/*!40000 ALTER TABLE `base_business_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `base_channel`
--

DROP TABLE IF EXISTS `base_channel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `base_channel` (
  `id` bigint NOT NULL COMMENT '主键（雪花ID）',
  `tenant_id` varchar(20) NOT NULL COMMENT '租户ID',
  `channel_code` varchar(64) NOT NULL COMMENT '渠道编码（租户内唯一，创建后不可修改）',
  `channel_name` varchar(128) NOT NULL COMMENT '渠道名称',
  `channel_type` varchar(32) NOT NULL COMMENT '渠道类型',
  `container_mode` varchar(32) DEFAULT NULL COMMENT '装载模式',
  `priority` int NOT NULL DEFAULT '100' COMMENT '优先级',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序',
  `status` char(1) NOT NULL DEFAULT '0' COMMENT '状态（0=正常，1=禁用）',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` bigint DEFAULT '0' COMMENT '逻辑删除（0=存在，1=删除）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_base_channel_code` (`tenant_id`,`channel_code`),
  KEY `idx_base_channel_status` (`tenant_id`,`status`),
  KEY `idx_base_channel_type` (`tenant_id`,`channel_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='渠道基础资料';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `base_channel`
--

LOCK TABLES `base_channel` WRITE;
/*!40000 ALTER TABLE `base_channel` DISABLE KEYS */;
INSERT INTO `base_channel` VALUES (5001001,'000000','SEA_TRUCK','海卡海派','SEA','LCL',100,1,'0','海运到港后卡车派送',103,1,'2026-05-22 01:18:15',1,'2026-05-22 01:18:15',0),(5001002,'000000','AIR_EXPRESS','空派','AIR','BULK',80,2,'0','空运加快递/卡派',103,1,'2026-05-22 01:18:15',1,'2026-05-22 01:18:15',0),(5001003,'000000','FCL','整柜','SEA','FCL',60,3,'0','整柜运输渠道',103,1,'2026-05-22 01:18:15',1,'2026-05-22 01:18:15',0);
/*!40000 ALTER TABLE `base_channel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `base_shipping_route`
--

DROP TABLE IF EXISTS `base_shipping_route`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `base_shipping_route` (
  `id` bigint NOT NULL COMMENT '??????ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '??????ID',
  `route_code` varchar(64) NOT NULL COMMENT '????????????',
  `route_name` varchar(128) NOT NULL COMMENT '????????????',
  `route_name_en` varchar(128) DEFAULT NULL COMMENT '????????????',
  `shipping_line_id` bigint DEFAULT NULL COMMENT '??????ID',
  `shipping_line_code` varchar(64) DEFAULT NULL COMMENT '????????????',
  `shipping_line_name` varchar(128) DEFAULT NULL COMMENT '????????????',
  `origin_port_id` bigint DEFAULT NULL COMMENT '?????????ID',
  `origin_port_code` varchar(64) DEFAULT NULL COMMENT '???????????????',
  `origin_port_name` varchar(128) DEFAULT NULL COMMENT '???????????????',
  `destination_port_id` bigint DEFAULT NULL COMMENT '?????????ID',
  `destination_port_code` varchar(64) DEFAULT NULL COMMENT '???????????????',
  `destination_port_name` varchar(128) DEFAULT NULL COMMENT '???????????????',
  `default_transit_days` int DEFAULT NULL COMMENT '??????????????????',
  `route_type` varchar(32) DEFAULT NULL COMMENT 'DIRECT/TRANSSHIP',
  `reference_min_days` int DEFAULT NULL COMMENT '??????????????????',
  `reference_avg_days` int DEFAULT NULL COMMENT '??????????????????',
  `reference_max_days` int DEFAULT NULL COMMENT '??????????????????',
  `reference_freight` decimal(10,2) DEFAULT NULL COMMENT '????????????',
  `status` varchar(32) NOT NULL DEFAULT '0' COMMENT '?????????0??????/1?????????',
  `remark` varchar(500) DEFAULT NULL COMMENT '??????',
  `create_dept` bigint DEFAULT NULL COMMENT '????????????',
  `create_by` bigint DEFAULT NULL COMMENT '?????????',
  `create_time` datetime DEFAULT NULL COMMENT '????????????',
  `update_by` bigint DEFAULT NULL COMMENT '?????????',
  `update_time` datetime DEFAULT NULL COMMENT '????????????',
  `del_flag` bigint NOT NULL DEFAULT '0' COMMENT '????????????',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_route_code_tenant` (`route_code`,`tenant_id`),
  KEY `idx_route_line` (`tenant_id`,`shipping_line_id`),
  KEY `idx_route_ports` (`origin_port_id`,`destination_port_id`),
  KEY `idx_route_status` (`tenant_id`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='????????????';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `base_shipping_route`
--

LOCK TABLES `base_shipping_route` WRITE;
/*!40000 ALTER TABLE `base_shipping_route` DISABLE KEYS */;
INSERT INTO `base_shipping_route` VALUES (3009001,'000000','AAS2','US West Express AAS2',NULL,3007003,'COSU','COSCO',3006007,'CNSZX','Port of Shenzhen (Yantian)',3006001,'USLAX','Port of Los Angeles',12,'DIRECT',11,14,17,1850.00,'0','Main US West route',NULL,1,'2026-05-24 00:09:48',1,'2026-05-24 00:09:48',0),(3009002,'000000','SEA','Southeast Asia Express SEA',NULL,3007004,'EGLV','Evergreen',3006009,'CNNBO','Port of Ningbo-Zhoushan',3006001,'USLAX','Port of Los Angeles',12,'DIRECT',11,14,17,1700.00,'0','Tokyo transit reference',NULL,1,'2026-05-24 00:09:48',1,'2026-05-24 00:09:48',0),(3009003,'000000','TP1','Trans-Pacific TP1',NULL,3007001,'MSCU','MSC',3006006,'CNSHA','Port of Shanghai',3006001,'USLAX','Port of Los Angeles',15,'DIRECT',14,18,21,2100.00,'0','Peak season capacity tight',NULL,1,'2026-05-24 00:09:48',1,'2026-05-24 00:09:48',0);
/*!40000 ALTER TABLE `base_shipping_route` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `base_terminal`
--

DROP TABLE IF EXISTS `base_terminal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `base_terminal` (
  `id` bigint NOT NULL COMMENT '??????ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '??????ID',
  `terminal_code` varchar(64) NOT NULL COMMENT '????????????',
  `terminal_name` varchar(128) NOT NULL COMMENT '????????????',
  `terminal_name_en` varchar(128) DEFAULT NULL COMMENT '????????????',
  `port_id` bigint NOT NULL COMMENT '????????????ID',
  `port_code` varchar(64) DEFAULT NULL COMMENT '??????????????????',
  `port_name` varchar(128) DEFAULT NULL COMMENT '??????????????????',
  `country_code` varchar(32) DEFAULT NULL COMMENT '????????????',
  `state_code` varchar(32) DEFAULT NULL COMMENT '???/?????????',
  `city` varchar(128) DEFAULT NULL COMMENT '??????',
  `address` varchar(255) DEFAULT NULL COMMENT '??????',
  `contact_phone` varchar(64) DEFAULT NULL COMMENT '????????????',
  `contact_email` varchar(128) DEFAULT NULL COMMENT '????????????',
  `website` varchar(255) DEFAULT NULL COMMENT '??????',
  `appointment_supported` tinyint NOT NULL DEFAULT '0' COMMENT '??????????????????',
  `default_appointment_method` varchar(32) DEFAULT NULL COMMENT '?????????????????????EMAIL/PLATFORM/PHONE/API',
  `default_release_method` varchar(32) DEFAULT NULL COMMENT '?????????????????????DO/EDO/PIN/EMAIL_RELEASE/PAPER',
  `timezone` varchar(64) DEFAULT NULL COMMENT '??????',
  `status` varchar(32) NOT NULL DEFAULT '0' COMMENT '?????????0??????/1?????????',
  `remark` varchar(500) DEFAULT NULL COMMENT '??????',
  `create_dept` bigint DEFAULT NULL COMMENT '????????????',
  `create_by` bigint DEFAULT NULL COMMENT '?????????',
  `create_time` datetime DEFAULT NULL COMMENT '????????????',
  `update_by` bigint DEFAULT NULL COMMENT '?????????',
  `update_time` datetime DEFAULT NULL COMMENT '????????????',
  `del_flag` bigint NOT NULL DEFAULT '0' COMMENT '????????????',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_terminal_code_tenant` (`terminal_code`,`tenant_id`),
  KEY `idx_terminal_port` (`tenant_id`,`port_id`),
  KEY `idx_terminal_status` (`tenant_id`,`status`),
  KEY `idx_terminal_release_method` (`default_release_method`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='????????????';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `base_terminal`
--

LOCK TABLES `base_terminal` WRITE;
/*!40000 ALTER TABLE `base_terminal` DISABLE KEYS */;
INSERT INTO `base_terminal` VALUES (3008001,'000000','APM','APM Terminals','APM Terminals Los Angeles',3006001,'USLAX','Port of Los Angeles','US','CA','Los Angeles','100 E 9th St, Wilmington, CA 90744','+1 310-123-4567',NULL,'https://www.apmterminals.com',1,'EMAIL','EMAIL_RELEASE','America/Los_Angeles','0','???????????? APM ??????',NULL,1,'2026-05-23 23:50:21',1,'2026-05-23 23:50:21',0),(3008002,'000000','TRAPAC','TraPac Container Terminal','TraPac Container Terminal',3006001,'USLAX','Port of Los Angeles','US','CA','Los Angeles','727 N Harbor Blvd, Wilmington, CA 90744','+1 310-234-5678',NULL,'https://www.trapac.com',1,'PLATFORM','EDO','America/Los_Angeles','0','???????????? TraPac ??????',NULL,1,'2026-05-23 23:50:21',1,'2026-05-23 23:50:21',0),(3008003,'000000','LBCT','Long Beach Container Terminal','Long Beach Container Terminal',3006002,'USLGB','Port of Long Beach','US','CA','Long Beach','2360 Pier G Ave, Long Beach, CA 90802','+1 562-345-6789',NULL,'https://www.lbct.com',1,'PLATFORM','PIN','America/Los_Angeles','0','????????? LBCT ??????',NULL,1,'2026-05-23 23:50:21',1,'2026-05-23 23:50:21',0),(3008004,'000000','PIERA','Pier A Terminal','Pier A Terminal',3006002,'USLGB','Port of Long Beach','US','CA','Long Beach','100 Aquarium Way, Long Beach, CA 90802','+1 562-456-7890',NULL,NULL,1,'EMAIL','EMAIL_RELEASE','America/Los_Angeles','0','????????? Pier A ??????',NULL,1,'2026-05-23 23:50:21',1,'2026-05-23 23:50:21',0),(3008005,'000000','HOUSTONCT','Bayport Container Terminal','Bayport Container Terminal',3006005,'USHOU','Port of Houston','US','TX','Houston','4020 McKinney St, Pasadena, TX 77507','+1 713-678-9012',NULL,NULL,1,'PHONE','PIN','America/Chicago','1','????????? Bayport ????????????????????????',NULL,1,'2026-05-23 23:50:21',1,'2026-05-23 23:50:21',0);
/*!40000 ALTER TABLE `base_terminal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `base_value_added_service`
--

DROP TABLE IF EXISTS `base_value_added_service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `base_value_added_service` (
  `id` bigint NOT NULL COMMENT '主键（雪花ID）',
  `tenant_id` varchar(20) NOT NULL COMMENT '租户ID',
  `service_code` varchar(64) NOT NULL COMMENT '服务编码（租户内唯一，创建后不可修改）',
  `service_name` varchar(128) NOT NULL COMMENT '服务名称',
  `service_category` varchar(32) NOT NULL COMMENT '服务分类',
  `billing_mode` varchar(32) DEFAULT NULL COMMENT '默认计费方式',
  `chargeable_flag` char(1) NOT NULL DEFAULT '1' COMMENT '是否参与计费',
  `operation_required` char(1) NOT NULL DEFAULT '1' COMMENT '是否需要仓库实际作业',
  `pda_operation_flag` char(1) NOT NULL DEFAULT '0' COMMENT '是否需要PDA操作',
  `photo_required` char(1) NOT NULL DEFAULT '0' COMMENT '是否需要拍照',
  `qc_required` char(1) NOT NULL DEFAULT '0' COMMENT '是否需要质检',
  `support_batch_operation` char(1) NOT NULL DEFAULT '1' COMMENT '是否支持批量作业',
  `default_selected` char(1) NOT NULL DEFAULT '0' COMMENT '是否默认勾选',
  `priority` int NOT NULL DEFAULT '100' COMMENT '优先级',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序',
  `status` char(1) NOT NULL DEFAULT '0' COMMENT '状态（0=正常，1=禁用）',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` bigint DEFAULT '0' COMMENT '逻辑删除（0=存在，1=删除）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_base_vas_code` (`tenant_id`,`service_code`),
  KEY `idx_base_vas_status` (`tenant_id`,`status`),
  KEY `idx_base_vas_category` (`tenant_id`,`service_category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='增值服务基础资料';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `base_value_added_service`
--

LOCK TABLES `base_value_added_service` WRITE;
/*!40000 ALTER TABLE `base_value_added_service` DISABLE KEYS */;
INSERT INTO `base_value_added_service` VALUES (5003001,'000000','LABELING','贴标','LABEL','BY_ITEM','1','1','1','0','0','1','0',100,1,'0',NULL,103,1,'2026-05-22 01:18:15',1,'2026-05-22 01:18:15',0),(5003002,'000000','QC','质检','QC','BY_ITEM','1','1','1','1','1','1','0',80,2,'0',NULL,103,1,'2026-05-22 01:18:15',1,'2026-05-22 01:18:15',0),(5003003,'000000','PALLETIZE','打托','PALLET','BY_PALLET','1','1','1','0','0','1','0',90,3,'0',NULL,103,1,'2026-05-22 01:18:15',1,'2026-05-22 01:18:15',0),(5003004,'000000','BASIC_SCAN','基础扫描','STORAGE',NULL,'0','1','1','0','0','1','0',10,4,'0',NULL,103,1,'2026-05-22 01:18:15',1,'2026-05-22 01:18:15',0);
/*!40000 ALTER TABLE `base_value_added_service` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `base_vessel`
--

DROP TABLE IF EXISTS `base_vessel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `base_vessel` (
  `id` bigint NOT NULL COMMENT 'Primary key',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT 'Tenant ID',
  `vessel_code` varchar(64) NOT NULL COMMENT 'Vessel code',
  `vessel_name` varchar(128) NOT NULL COMMENT 'Vessel name',
  `vessel_name_en` varchar(128) DEFAULT NULL COMMENT 'English vessel name',
  `imo_no` varchar(64) DEFAULT NULL COMMENT 'IMO number',
  `mmsi` varchar(64) DEFAULT NULL COMMENT 'MMSI',
  `call_sign` varchar(64) DEFAULT NULL COMMENT 'Call sign',
  `shipping_line_id` bigint NOT NULL COMMENT 'Shipping line ID',
  `shipping_line_code` varchar(64) DEFAULT NULL COMMENT 'Shipping line code',
  `shipping_line_name` varchar(128) DEFAULT NULL COMMENT 'Shipping line name',
  `vessel_type` varchar(32) DEFAULT 'CONTAINER' COMMENT 'CONTAINER/BULK/REEFER/RORO/OTHER',
  `capacity_teu` int DEFAULT NULL COMMENT 'TEU capacity',
  `length_m` decimal(10,2) DEFAULT NULL COMMENT 'Length in meters',
  `width_m` decimal(10,2) DEFAULT NULL COMMENT 'Width in meters',
  `build_year` int DEFAULT NULL COMMENT 'Build year',
  `flag_country` varchar(64) DEFAULT NULL COMMENT 'Flag country',
  `status` varchar(32) NOT NULL DEFAULT '0' COMMENT '0 enabled / 1 disabled',
  `remark` varchar(500) DEFAULT NULL COMMENT 'Remark',
  `create_dept` bigint DEFAULT NULL COMMENT 'Create department',
  `create_by` bigint DEFAULT NULL COMMENT 'Create user',
  `create_time` datetime DEFAULT NULL COMMENT 'Create time',
  `update_by` bigint DEFAULT NULL COMMENT 'Update user',
  `update_time` datetime DEFAULT NULL COMMENT 'Update time',
  `del_flag` bigint NOT NULL DEFAULT '0' COMMENT 'Delete flag',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_vessel_code_tenant` (`vessel_code`,`tenant_id`),
  KEY `idx_vessel_line` (`tenant_id`,`shipping_line_id`),
  KEY `idx_vessel_imo` (`tenant_id`,`imo_no`),
  KEY `idx_vessel_name` (`tenant_id`,`vessel_name`),
  KEY `idx_vessel_status` (`tenant_id`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Vessel master';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `base_vessel`
--

LOCK TABLES `base_vessel` WRITE;
/*!40000 ALTER TABLE `base_vessel` DISABLE KEYS */;
INSERT INTO `base_vessel` VALUES (3011001,'000000','VSL000001','COSCO SHIPPING AQUARIUS','COSCO SHIPPING AQUARIUS','9789347','477123456','VRAB8',3007003,'COSU','COSCO','CONTAINER',20908,400.00,58.60,2017,'Hong Kong','0','Demo vessel',NULL,1,'2026-05-24 00:23:03',1,'2026-05-24 00:23:03',0),(3011002,'000000','VSL000002','EVER LOGIC','EVER LOGIC','9851234','563123456','9VLOG',3007004,'EGLV','Evergreen','CONTAINER',14200,366.00,51.00,2020,'Singapore','0','Demo vessel',NULL,1,'2026-05-24 00:23:03',1,'2026-05-24 00:23:03',0),(3011003,'000000','VSL000003','MSC GULSUN','MSC GULSUN','9831111','636123456','D5GS8',3007001,'MSCU','MSC','CONTAINER',23756,399.90,61.50,2019,'Panama','0','Demo vessel',NULL,1,'2026-05-24 00:23:03',1,'2026-05-24 00:23:03',0),(3011004,'000000','VSL000004','MAERSK SEATTLE','MAERSK SEATTLE','9899999','219123456','OXST2',3007002,'MAEU','Maersk','CONTAINER',15500,353.00,53.50,2018,'Denmark','0','Demo vessel',NULL,1,'2026-05-24 00:23:03',1,'2026-05-24 00:23:03',0),(3011005,'000000','VSL000005','ZIM ASHDOD','ZIM ASHDOD','9701111','428123456','4XZA8',3007008,'ZIMU','Zim','CONTAINER',10000,300.00,48.20,2016,'Israel','0','Demo vessel',NULL,1,'2026-05-24 00:23:03',1,'2026-05-24 00:23:03',0);
/*!40000 ALTER TABLE `base_vessel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `biz_attachment`
--

DROP TABLE IF EXISTS `biz_attachment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `biz_attachment` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `biz_root_id` bigint DEFAULT NULL COMMENT '业务主线ID，海柜附件可为空',
  `target_type` varchar(64) NOT NULL COMMENT '目标类型：CARGO_ORDER/CARGO_SHIPMENT/CONTAINER_ORDER/POD/EXCEPTION',
  `target_id` bigint NOT NULL COMMENT '目标对象ID',
  `target_no` varchar(64) NOT NULL COMMENT '目标对象编号',
  `attachment_type` varchar(64) NOT NULL COMMENT '附件类型：DO/BOL/POD/INVOICE/EXCEPTION_IMAGE/CUSTOMER_FILE/OTHER',
  `file_name` varchar(255) NOT NULL COMMENT '文件名',
  `file_url` varchar(500) NOT NULL COMMENT '文件URL',
  `file_size` bigint DEFAULT NULL COMMENT '文件大小',
  `file_ext` varchar(32) DEFAULT NULL COMMENT '文件后缀',
  `mime_type` varchar(128) DEFAULT NULL COMMENT 'MIME类型',
  `customer_visible_flag` tinyint(1) NOT NULL DEFAULT '0' COMMENT '客户是否可见',
  `internal_visible_flag` tinyint(1) NOT NULL DEFAULT '1' COMMENT '内部是否可见',
  `upload_user_id` bigint DEFAULT NULL COMMENT '上传人ID',
  `upload_user_name` varchar(128) DEFAULT NULL COMMENT '上传人名称',
  `upload_time` datetime NOT NULL COMMENT '上传时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  KEY `idx_target` (`target_type`,`target_id`),
  KEY `idx_biz_root_id` (`biz_root_id`),
  KEY `idx_attachment_type` (`attachment_type`),
  KEY `idx_upload_time` (`upload_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='业务附件表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `biz_attachment`
--

LOCK TABLES `biz_attachment` WRITE;
/*!40000 ALTER TABLE `biz_attachment` DISABLE KEYS */;
/*!40000 ALTER TABLE `biz_attachment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `biz_root`
--

DROP TABLE IF EXISTS `biz_root`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `biz_root` (
  `id` bigint NOT NULL COMMENT '业务主线ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `company_id` bigint NOT NULL COMMENT '主体ID',
  `warehouse_id` bigint DEFAULT NULL COMMENT '当前主仓库ID',
  `root_no` varchar(64) NOT NULL COMMENT '业务主线编号',
  `root_type` varchar(30) NOT NULL COMMENT '业务主线类型',
  `source_module` varchar(30) NOT NULL COMMENT '来源模块',
  `source_order_id` bigint NOT NULL COMMENT '来源订单ID',
  `source_order_no` varchar(64) NOT NULL COMMENT '来源订单号',
  `customer_id` bigint DEFAULT NULL COMMENT '客户ID',
  `customer_name` varchar(128) DEFAULT NULL COMMENT '客户名称',
  `channel_id` bigint DEFAULT NULL COMMENT '渠道ID',
  `business_type_id` bigint DEFAULT NULL COMMENT '业务类型ID',
  `current_module` varchar(30) DEFAULT NULL COMMENT '当前模块',
  `current_node` varchar(64) DEFAULT NULL COMMENT '当前节点编码',
  `current_node_name` varchar(128) DEFAULT NULL COMMENT '当前节点名称',
  `current_node_time` datetime DEFAULT NULL COMMENT '当前节点时间',
  `root_status` varchar(30) NOT NULL DEFAULT 'RUNNING' COMMENT '主线状态',
  `exception_flag` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否异常',
  `exception_count` int NOT NULL DEFAULT '0' COMMENT '异常数',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `complete_time` datetime DEFAULT NULL COMMENT '完成时间',
  `cancel_time` datetime DEFAULT NULL COMMENT '取消时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_root_no_tenant` (`root_no`,`tenant_id`),
  KEY `idx_source_order` (`source_module`,`source_order_id`),
  KEY `idx_company_warehouse` (`company_id`,`warehouse_id`),
  KEY `idx_root_status` (`tenant_id`,`root_status`),
  KEY `idx_biz_root_current_node` (`current_node`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='业务主线根';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `biz_root`
--

LOCK TABLES `biz_root` WRITE;
/*!40000 ALTER TABLE `biz_root` DISABLE KEYS */;
INSERT INTO `biz_root` VALUES (10001,'000000',4000001,4001001,'CO-2026-000001','CARGO_ORDER','OMS',1001,'CO-2026-000001',200,'测试客户A',NULL,10,'OMS','IN_TRANSIT','Õ£¿ÚÇö','2026-05-24 14:01:36','RUNNING',0,0,'2026-05-23 02:06:16',NULL,NULL,'ÕÄåÕÅ▓Þ┤ºþë®Þ«óÕìòÞíÑÕ╗║õ©ÜÕèíõ©╗þ║┐',NULL,1,'2026-05-23 02:06:16',1,'2026-05-24 14:01:36',0),(10002,'000000',4000001,4001001,'CO-2026-000002','CARGO_ORDER','OMS',1002,'CO-2026-000002',201,'测试客户B',NULL,11,'OMS','DEVANNING','µïåµƒ£õ©¡','2026-05-27 14:34:43','RUNNING',0,0,'2026-05-23 02:06:16',NULL,NULL,'ÕÄåÕÅ▓Þ┤ºþë®Þ«óÕìòÞíÑÕ╗║õ©ÜÕèíõ©╗þ║┐',NULL,1,'2026-05-23 02:06:16',1,'2026-05-27 14:34:43',0),(10003,'000000',100,41,'CO-2026-000003','CARGO_ORDER','OMS',1003,'CO-2026-000003',202,'测试客户C',NULL,12,'OMS','OUTBOUND_ORDERED','ÕÀ▓Õç║Õìò','2026-05-27 14:17:20','RUNNING',0,0,'2026-05-23 02:06:16',NULL,NULL,'ÕÄåÕÅ▓Þ┤ºþë®Þ«óÕìòÞíÑÕ╗║õ©ÜÕèíõ©╗þ║┐',NULL,1,'2026-05-23 02:06:16',1,'2026-05-27 14:17:20',0),(10004,'000000',100,41,'CO-2026-000004','CARGO_ORDER','OMS',1004,'CO-2026-000004',200,'测试客户A',NULL,10,'OMS','INBOUNDED','已入库','2026-05-28 02:47:14','RUNNING',0,0,'2026-05-23 02:06:16',NULL,NULL,'ÕÄåÕÅ▓Þ┤ºþë®Þ«óÕìòÞíÑÕ╗║õ©ÜÕèíõ©╗þ║┐',NULL,1,'2026-05-23 02:06:16',1,'2026-05-28 02:47:14',0),(10005,'000000',100,42,'CO-2026-000005','CARGO_ORDER','OMS',1005,'CO-2026-000005',203,'测试客户D',NULL,11,'OMS','COMPLETED','ÕÀ▓Õ«îµêÉ','2026-05-23 02:06:16','DONE',0,0,'2026-05-23 02:06:16','2026-05-23 02:06:16',NULL,'ÕÄåÕÅ▓Þ┤ºþë®Þ«óÕìòÞíÑÕ╗║õ©ÜÕèíõ©╗þ║┐',NULL,1,'2026-05-23 02:06:16',1,'2026-05-23 02:06:16',0),(9150001,'000000',4000001,4001001,'BIZ202605150001','CARGO','OMS',9200001,'CO202605150001',8001001,'Pacific Home Goods LLC',5001001,5002001,'OMS','IN_TRANSIT','在途','2026-05-15 14:00:00','RUNNING',0,0,'2026-05-15 09:00:00',NULL,NULL,NULL,NULL,1,'2026-05-15 09:00:00',1,'2026-05-15 14:00:00',0),(9150002,'000000',4000001,4001001,'BIZ202605150002','CARGO','OMS',9200002,'CO202605150002',8001001,'Pacific Home Goods LLC',5001001,5002001,'OMS','IN_TRANSIT','在途','2026-05-15 14:00:00','RUNNING',0,0,'2026-05-15 09:30:00',NULL,NULL,NULL,NULL,1,'2026-05-15 09:30:00',1,'2026-05-15 14:00:00',0),(9150003,'000000',4000001,4001001,'BIZ202605100001','CARGO','OMS',9200003,'CO202605100001',8001002,'Northstar Outdoor Inc.',5001002,5002001,'OMS','ARRIVED_PORT','已到港','2026-05-20 11:20:00','RUNNING',1,1,'2026-05-10 10:00:00',NULL,NULL,NULL,NULL,1,'2026-05-10 10:00:00',1,'2026-05-20 11:20:00',0),(9150004,'000000',4000001,4001001,'BIZ202605100002','CARGO','OMS',9200004,'CO202605100002',8001002,'Northstar Outdoor Inc.',5001002,5002001,'OMS','ARRIVED_PORT','已到港','2026-05-20 11:20:00','RUNNING',0,0,'2026-05-10 10:30:00',NULL,NULL,NULL,NULL,1,'2026-05-10 10:30:00',1,'2026-05-20 11:20:00',0),(9150005,'000000',4000001,4001002,'BIZ202605050001','CARGO','OMS',9200005,'CO202605050001',8001003,'East Market Supply Co.',5001001,5002002,'OMS','DEVANNING','拆柜中','2026-05-22 10:15:00','RUNNING',0,0,'2026-05-05 11:00:00',NULL,NULL,NULL,NULL,1,'2026-05-05 11:00:00',1,'2026-05-22 10:15:00',0),(9150006,'000000',4000001,4001002,'BIZ202605050002','CARGO','OMS',9200006,'CO202605050002',8001003,'East Market Supply Co.',5001001,5002002,'OMS','DEVANNED','拆柜完成','2026-05-22 11:30:00','RUNNING',0,0,'2026-05-05 11:30:00',NULL,NULL,NULL,NULL,1,'2026-05-05 11:30:00',1,'2026-05-22 11:30:00',0),(9150007,'000000',4000001,4001002,'BIZ202605050003','CARGO','OMS',9200007,'CO202605050003',8001003,'East Market Supply Co.',5001001,5002002,'OMS','INBOUNDED','已入库','2026-05-22 14:00:00','RUNNING',0,0,'2026-05-05 12:00:00',NULL,NULL,NULL,NULL,1,'2026-05-05 12:00:00',1,'2026-05-22 15:00:00',0),(9150013,'000000',4000001,4001002,'BIZ202605080001','CARGO','OMS',9200013,'CO202605080001',8001001,'Pacific Home Goods LLC',5001001,5002001,'OMS','INBOUNDED','ÕÀ▓ÕàÑÕ║ô','2026-05-13 10:00:00','RUNNING',0,0,'2026-05-08 14:00:00',NULL,NULL,NULL,NULL,1,'2026-05-08 14:00:00',1,'2026-05-13 10:00:00',0),(9150014,'000000',4000001,4001002,'BIZ202605080002','CARGO','OMS',9200014,'CO202605080002',8001001,'Pacific Home Goods LLC',5001001,5002001,'OMS','INBOUNDED','已入库','2026-05-28 02:47:14','RUNNING',0,0,'2026-05-08 14:00:00',NULL,NULL,NULL,NULL,1,'2026-05-08 14:00:00',1,'2026-05-28 02:47:14',0),(9150015,'000000',4000001,4001002,'BIZ202605080003','CARGO','OMS',9200015,'CO202605080003',8001002,'Northstar Outdoor Inc.',5001002,5002001,'OMS','INBOUNDED','ÕÀ▓ÕàÑÕ║ô','2026-05-14 09:00:00','RUNNING',0,0,'2026-05-08 15:00:00',NULL,NULL,NULL,NULL,1,'2026-05-08 15:00:00',1,'2026-05-14 09:00:00',0),(9150016,'000000',4000001,4001002,'BIZ202605080004','CARGO','OMS',9200016,'CO202605080004',8001002,'Northstar Outdoor Inc.',5001002,5002001,'OMS','INBOUNDED','ÕÀ▓ÕàÑÕ║ô','2026-05-14 10:15:00','RUNNING',0,0,'2026-05-08 15:30:00',NULL,NULL,NULL,NULL,1,'2026-05-08 15:30:00',1,'2026-05-14 10:15:00',0),(9150017,'000000',4000001,4001002,'BIZ202605080005','CARGO','OMS',9200017,'CO202605080005',8001003,'East Market Supply Co.',5001001,5002002,'OMS','INBOUNDED','ÕÀ▓ÕàÑÕ║ô','2026-05-14 14:00:00','RUNNING',0,0,'2026-05-08 16:00:00',NULL,NULL,NULL,NULL,1,'2026-05-08 16:00:00',1,'2026-05-14 14:00:00',0);
/*!40000 ALTER TABLE `biz_root` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `city`
--

DROP TABLE IF EXISTS `city`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `city` (
  `id` bigint NOT NULL COMMENT '主键（雪花ID）',
  `tenant_id` varchar(20) NOT NULL COMMENT '租户ID',
  `country_code` varchar(10) NOT NULL COMMENT '所属国家代码',
  `state_code` varchar(20) DEFAULT NULL COMMENT '所属州/省代码',
  `name_en` varchar(100) NOT NULL COMMENT '英文名称',
  `status` char(1) NOT NULL DEFAULT '0' COMMENT '状态（0=正常，1=停用）',
  `create_by` bigint DEFAULT NULL COMMENT '???',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '???',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` bigint DEFAULT '0' COMMENT '逻辑删除（0=存在，1=删除）',
  `create_dept` bigint DEFAULT NULL COMMENT '????',
  PRIMARY KEY (`id`),
  KEY `idx_country_state` (`tenant_id`,`country_code`,`state_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='城市管理（GEO-001）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `city`
--

LOCK TABLES `city` WRITE;
/*!40000 ALTER TABLE `city` DISABLE KEYS */;
INSERT INTO `city` VALUES (3002001,'000000','US','CA','Los Angeles','0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3002002,'000000','US','CA','San Francisco','0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3002003,'000000','US','CA','San Diego','0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3002004,'000000','US','CA','Ontario','0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3002005,'000000','US','CA','Long Beach','0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3002006,'000000','US','NY','New York City','0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3002007,'000000','US','NY','Buffalo','0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3002008,'000000','US','TX','Houston','0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3002009,'000000','US','TX','Dallas','0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3002010,'000000','US','FL','Miami','0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3002011,'000000','US','FL','Orlando','0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3002012,'000000','US','NJ','Newark','0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3002013,'000000','US','NJ','Jersey City','0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3002014,'000000','CN','GD','Guangzhou','0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3002015,'000000','CN','GD','Shenzhen','0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3002016,'000000','CN','GD','Dongguan','0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3002017,'000000','CN','SH','Shanghai','0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3002018,'000000','CN','ZJ','Hangzhou','0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3002019,'000000','CN','ZJ','Ningbo','0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL);
/*!40000 ALTER TABLE `city` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `country`
--

DROP TABLE IF EXISTS `country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `country` (
  `id` bigint NOT NULL COMMENT '主键（雪花ID）',
  `tenant_id` varchar(20) NOT NULL COMMENT '租户ID',
  `code` varchar(10) NOT NULL COMMENT '国家代码（ISO 3166-1 alpha-2，如US/DE/JP）',
  `name_en` varchar(100) NOT NULL COMMENT '英文名称',
  `phone_code` varchar(20) DEFAULT NULL COMMENT '国际电话区号（如+1/+49）',
  `currency_code` varchar(10) DEFAULT NULL COMMENT '默认货币代码',
  `timezone_default` varchar(50) DEFAULT NULL COMMENT '默认时区',
  `is_active` tinyint NOT NULL DEFAULT '1' COMMENT '是否已开通（1=是，0=否）',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序',
  `create_by` bigint DEFAULT NULL COMMENT '???',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '???',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` bigint DEFAULT '0' COMMENT '逻辑删除（0=存在，1=删除）',
  `create_dept` bigint DEFAULT NULL COMMENT '????',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_code` (`tenant_id`,`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='国家管理（GEO-001）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `country`
--

LOCK TABLES `country` WRITE;
/*!40000 ALTER TABLE `country` DISABLE KEYS */;
INSERT INTO `country` VALUES (3000001,'000000','US','United States','+1','USD','America/New_York',1,1,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3000002,'000000','CN','China','+86','CNY','Asia/Shanghai',1,2,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3000003,'000000','DE','Germany','+49','EUR','Europe/Berlin',1,3,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3000004,'000000','GB','United Kingdom','+44','GBP','Europe/London',1,4,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3000005,'000000','JP','Japan','+81','JPY','Asia/Tokyo',1,5,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3000006,'000000','CA','Canada','+1','CAD','America/Toronto',1,6,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3000007,'000000','AU','Australia','+61','AUD','Australia/Sydney',1,7,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3000008,'000000','MX','Mexico','+52','MXN','America/Mexico_City',1,8,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3000009,'000000','FR','France','+33','EUR','Europe/Paris',1,9,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3000010,'000000','NL','Netherlands','+31','EUR','Europe/Amsterdam',1,10,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL);
/*!40000 ALTER TABLE `country` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `currency`
--

DROP TABLE IF EXISTS `currency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `currency` (
  `id` bigint NOT NULL COMMENT '主键（雪花ID）',
  `tenant_id` varchar(20) NOT NULL COMMENT '租户ID',
  `code` varchar(10) NOT NULL COMMENT 'ISO 4217货币代码（如USD/EUR/JPY）',
  `name_en` varchar(100) NOT NULL COMMENT '货币英文名称',
  `symbol` varchar(10) DEFAULT NULL COMMENT '货币符号（如$/€/¥）',
  `decimal_places` int NOT NULL DEFAULT '2' COMMENT '小数位数（日元=0，美元=2）',
  `is_base` tinyint NOT NULL DEFAULT '0' COMMENT '是否基准货币（1=是，全局唯一）',
  `status` char(1) NOT NULL DEFAULT '0' COMMENT '状态（0=正常，1=停用）',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序',
  `create_by` bigint DEFAULT NULL COMMENT '???',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '???',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` bigint DEFAULT '0' COMMENT '逻辑删除（0=存在，1=删除）',
  `create_dept` bigint DEFAULT NULL COMMENT '????',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_code` (`tenant_id`,`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='币种管理（FIN-001）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `currency`
--

LOCK TABLES `currency` WRITE;
/*!40000 ALTER TABLE `currency` DISABLE KEYS */;
INSERT INTO `currency` VALUES (3004001,'000000','USD','US Dollar','$',2,1,'0',1,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3004002,'000000','CNY','Chinese Yuan','¥',2,0,'0',2,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3004003,'000000','EUR','Euro','€',2,0,'0',3,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3004004,'000000','GBP','British Pound','£',2,0,'0',4,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3004005,'000000','JPY','Japanese Yen','¥',0,0,'0',5,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3004006,'000000','CAD','Canadian Dollar','CA$',2,0,'0',6,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3004007,'000000','AUD','Australian Dollar','A$',2,0,'0',7,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3004008,'000000','MXN','Mexican Peso','$',2,0,'0',8,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL);
/*!40000 ALTER TABLE `currency` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exchange_rate`
--

DROP TABLE IF EXISTS `exchange_rate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exchange_rate` (
  `id` bigint NOT NULL COMMENT '主键（雪花ID）',
  `tenant_id` varchar(20) NOT NULL COMMENT '租户ID',
  `from_currency` varchar(10) NOT NULL COMMENT '源货币代码',
  `to_currency` varchar(10) NOT NULL COMMENT '目标货币代码',
  `rate` decimal(18,8) NOT NULL COMMENT '汇率（1单位源货币=rate单位目标货币）',
  `effective_date` date NOT NULL COMMENT '生效日期',
  `expired_date` date DEFAULT NULL COMMENT '失效日期（NULL=当前有效）',
  `is_current` tinyint NOT NULL DEFAULT '1' COMMENT '是否当前有效（1=是，0=历史）',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_by` bigint DEFAULT NULL COMMENT '???',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '???',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `create_dept` bigint DEFAULT NULL COMMENT '????',
  PRIMARY KEY (`id`),
  KEY `idx_from_to_current` (`tenant_id`,`from_currency`,`to_currency`,`is_current`),
  KEY `idx_effective_date` (`tenant_id`,`effective_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='汇率管理（FIN-001）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exchange_rate`
--

LOCK TABLES `exchange_rate` WRITE;
/*!40000 ALTER TABLE `exchange_rate` DISABLE KEYS */;
INSERT INTO `exchange_rate` VALUES (3005001,'000000','USD','CNY',7.25000000,'2026-01-01',NULL,1,'参考汇率（非实时）',1,'2026-05-22 00:41:18',NULL,NULL,NULL),(3005002,'000000','USD','EUR',0.92000000,'2026-01-01',NULL,1,'参考汇率（非实时）',1,'2026-05-22 00:41:18',NULL,NULL,NULL),(3005003,'000000','USD','GBP',0.79000000,'2026-01-01',NULL,1,'参考汇率（非实时）',1,'2026-05-22 00:41:18',NULL,NULL,NULL),(3005004,'000000','USD','JPY',151.50000000,'2026-01-01',NULL,1,'参考汇率（非实时）',1,'2026-05-22 00:41:18',NULL,NULL,NULL),(3005005,'000000','USD','CAD',1.36000000,'2026-01-01',NULL,1,'参考汇率（非实时）',1,'2026-05-22 00:41:18',NULL,NULL,NULL),(3005006,'000000','USD','AUD',1.52000000,'2026-01-01',NULL,1,'参考汇率（非实时）',1,'2026-05-22 00:41:18',NULL,NULL,NULL),(3005007,'000000','USD','MXN',17.15000000,'2026-01-01',NULL,1,'参考汇率（非实时）',1,'2026-05-22 00:41:18',NULL,NULL,NULL);
/*!40000 ALTER TABLE `exchange_rate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flow_category`
--

DROP TABLE IF EXISTS `flow_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_category` (
  `category_id` bigint NOT NULL COMMENT '流程分类ID',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `parent_id` bigint DEFAULT '0' COMMENT '父流程分类id',
  `ancestors` varchar(500) DEFAULT '' COMMENT '祖级列表',
  `category_name` varchar(30) NOT NULL COMMENT '流程分类名称',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='流程分类';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flow_category`
--

LOCK TABLES `flow_category` WRITE;
/*!40000 ALTER TABLE `flow_category` DISABLE KEYS */;
INSERT INTO `flow_category` VALUES (100,'000000',0,'0','OA审批',0,'0',103,1,'2026-05-21 23:15:14',NULL,NULL),(101,'000000',100,'0,100','假勤管理',0,'0',103,1,'2026-05-21 23:15:14',NULL,NULL),(102,'000000',100,'0,100','人事管理',1,'0',103,1,'2026-05-21 23:15:14',NULL,NULL),(103,'000000',101,'0,100,101','请假',0,'0',103,1,'2026-05-21 23:15:14',NULL,NULL),(104,'000000',101,'0,100,101','出差',1,'0',103,1,'2026-05-21 23:15:14',NULL,NULL),(105,'000000',101,'0,100,101','加班',2,'0',103,1,'2026-05-21 23:15:14',NULL,NULL),(106,'000000',101,'0,100,101','换班',3,'0',103,1,'2026-05-21 23:15:14',NULL,NULL),(107,'000000',101,'0,100,101','外出',4,'0',103,1,'2026-05-21 23:15:14',NULL,NULL),(108,'000000',102,'0,100,102','转正',1,'0',103,1,'2026-05-21 23:15:14',NULL,NULL),(109,'000000',102,'0,100,102','离职',2,'0',103,1,'2026-05-21 23:15:14',NULL,NULL);
/*!40000 ALTER TABLE `flow_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flow_definition`
--

DROP TABLE IF EXISTS `flow_definition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_definition` (
  `id` bigint NOT NULL COMMENT '主键id',
  `flow_code` varchar(40) NOT NULL COMMENT '流程编码',
  `flow_name` varchar(100) NOT NULL COMMENT '流程名称',
  `model_value` varchar(40) NOT NULL DEFAULT 'CLASSICS' COMMENT '设计器模型（CLASSICS经典模型 MIMIC仿钉钉模型）',
  `category` varchar(100) DEFAULT NULL COMMENT '流程类别',
  `version` varchar(20) NOT NULL COMMENT '流程版本',
  `is_publish` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否发布（0未发布 1已发布 9失效）',
  `form_custom` char(1) DEFAULT 'N' COMMENT '审批表单是否自定义（Y是 N否）',
  `form_path` varchar(100) DEFAULT NULL COMMENT '审批表单路径',
  `activity_status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '流程激活状态（0挂起 1激活）',
  `listener_type` varchar(100) DEFAULT NULL COMMENT '监听器类型',
  `listener_path` varchar(400) DEFAULT NULL COMMENT '监听器路径',
  `ext` varchar(500) DEFAULT NULL COMMENT '业务详情 存业务表对象json字符串',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新人',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志',
  `tenant_id` varchar(40) DEFAULT NULL COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='流程定义表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flow_definition`
--

LOCK TABLES `flow_definition` WRITE;
/*!40000 ALTER TABLE `flow_definition` DISABLE KEYS */;
/*!40000 ALTER TABLE `flow_definition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flow_his_task`
--

DROP TABLE IF EXISTS `flow_his_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_his_task` (
  `id` bigint NOT NULL COMMENT '主键id',
  `definition_id` bigint NOT NULL COMMENT '对应flow_definition表的id',
  `instance_id` bigint NOT NULL COMMENT '对应flow_instance表的id',
  `task_id` bigint NOT NULL COMMENT '对应flow_task表的id',
  `node_code` varchar(100) DEFAULT NULL COMMENT '开始节点编码',
  `node_name` varchar(100) DEFAULT NULL COMMENT '开始节点名称',
  `node_type` tinyint(1) DEFAULT NULL COMMENT '开始节点类型（0开始节点 1中间节点 2结束节点 3互斥网关 4并行网关）',
  `target_node_code` varchar(200) DEFAULT NULL COMMENT '目标节点编码',
  `target_node_name` varchar(200) DEFAULT NULL COMMENT '结束节点名称',
  `approver` varchar(40) DEFAULT NULL COMMENT '审批人',
  `cooperate_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '协作方式(1审批 2转办 3委派 4会签 5票签 6加签 7减签)',
  `collaborator` varchar(500) DEFAULT NULL COMMENT '协作人',
  `skip_type` varchar(10) NOT NULL COMMENT '流转类型（PASS通过 REJECT退回 NONE无动作）',
  `flow_status` varchar(20) NOT NULL COMMENT '流程状态（0待提交 1审批中 2审批通过 4终止 5作废 6撤销 8已完成 9已退回 10失效 11拿回）',
  `form_custom` char(1) DEFAULT 'N' COMMENT '审批表单是否自定义（Y是 N否）',
  `form_path` varchar(100) DEFAULT NULL COMMENT '审批表单路径',
  `message` varchar(500) DEFAULT NULL COMMENT '审批意见',
  `variable` text COMMENT '任务变量',
  `ext` text COMMENT '业务详情 存业务表对象json字符串',
  `create_time` datetime DEFAULT NULL COMMENT '任务开始时间',
  `update_time` datetime DEFAULT NULL COMMENT '审批完成时间',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志',
  `tenant_id` varchar(40) DEFAULT NULL COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='历史任务记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flow_his_task`
--

LOCK TABLES `flow_his_task` WRITE;
/*!40000 ALTER TABLE `flow_his_task` DISABLE KEYS */;
/*!40000 ALTER TABLE `flow_his_task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flow_instance`
--

DROP TABLE IF EXISTS `flow_instance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_instance` (
  `id` bigint NOT NULL COMMENT '主键id',
  `definition_id` bigint NOT NULL COMMENT '对应flow_definition表的id',
  `business_id` varchar(40) NOT NULL COMMENT '业务id',
  `node_type` tinyint(1) NOT NULL COMMENT '节点类型（0开始节点 1中间节点 2结束节点 3互斥网关 4并行网关）',
  `node_code` varchar(40) NOT NULL COMMENT '流程节点编码',
  `node_name` varchar(100) DEFAULT NULL COMMENT '流程节点名称',
  `variable` text COMMENT '任务变量',
  `flow_status` varchar(20) NOT NULL COMMENT '流程状态（0待提交 1审批中 2审批通过 4终止 5作废 6撤销 8已完成 9已退回 10失效 11拿回）',
  `activity_status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '流程激活状态（0挂起 1激活）',
  `def_json` text COMMENT '流程定义json',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新人',
  `ext` varchar(500) DEFAULT NULL COMMENT '扩展字段，预留给业务系统使用',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志',
  `tenant_id` varchar(40) DEFAULT NULL COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='流程实例表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flow_instance`
--

LOCK TABLES `flow_instance` WRITE;
/*!40000 ALTER TABLE `flow_instance` DISABLE KEYS */;
/*!40000 ALTER TABLE `flow_instance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flow_instance_biz_ext`
--

DROP TABLE IF EXISTS `flow_instance_biz_ext`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_instance_biz_ext` (
  `id` bigint NOT NULL COMMENT '主键id',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `business_code` varchar(255) DEFAULT NULL COMMENT '业务编码',
  `business_title` varchar(1000) DEFAULT NULL COMMENT '业务标题',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  `instance_id` bigint DEFAULT NULL COMMENT '流程实例Id',
  `business_id` varchar(255) DEFAULT NULL COMMENT '业务Id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='流程实例业务扩展表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flow_instance_biz_ext`
--

LOCK TABLES `flow_instance_biz_ext` WRITE;
/*!40000 ALTER TABLE `flow_instance_biz_ext` DISABLE KEYS */;
/*!40000 ALTER TABLE `flow_instance_biz_ext` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flow_node`
--

DROP TABLE IF EXISTS `flow_node`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_node` (
  `id` bigint NOT NULL COMMENT '主键id',
  `node_type` tinyint(1) NOT NULL COMMENT '节点类型（0开始节点 1中间节点 2结束节点 3互斥网关 4并行网关）',
  `definition_id` bigint NOT NULL COMMENT '流程定义id',
  `node_code` varchar(100) NOT NULL COMMENT '流程节点编码',
  `node_name` varchar(100) DEFAULT NULL COMMENT '流程节点名称',
  `permission_flag` varchar(200) DEFAULT NULL COMMENT '权限标识（权限类型:权限标识，可以多个，用@@隔开)',
  `node_ratio` varchar(200) DEFAULT NULL COMMENT '流程签署比例值',
  `coordinate` varchar(100) DEFAULT NULL COMMENT '坐标',
  `any_node_skip` varchar(100) DEFAULT NULL COMMENT '任意结点跳转',
  `listener_type` varchar(100) DEFAULT NULL COMMENT '监听器类型',
  `listener_path` varchar(400) DEFAULT NULL COMMENT '监听器路径',
  `form_custom` char(1) DEFAULT 'N' COMMENT '审批表单是否自定义（Y是 N否）',
  `form_path` varchar(100) DEFAULT NULL COMMENT '审批表单路径',
  `version` varchar(20) NOT NULL COMMENT '版本',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新人',
  `ext` text COMMENT '节点扩展属性',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志',
  `tenant_id` varchar(40) DEFAULT NULL COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='流程节点表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flow_node`
--

LOCK TABLES `flow_node` WRITE;
/*!40000 ALTER TABLE `flow_node` DISABLE KEYS */;
/*!40000 ALTER TABLE `flow_node` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flow_skip`
--

DROP TABLE IF EXISTS `flow_skip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_skip` (
  `id` bigint NOT NULL COMMENT '主键id',
  `definition_id` bigint NOT NULL COMMENT '流程定义id',
  `now_node_code` varchar(100) NOT NULL COMMENT '当前流程节点的编码',
  `now_node_type` tinyint(1) DEFAULT NULL COMMENT '当前节点类型（0开始节点 1中间节点 2结束节点 3互斥网关 4并行网关）',
  `next_node_code` varchar(100) NOT NULL COMMENT '下一个流程节点的编码',
  `next_node_type` tinyint(1) DEFAULT NULL COMMENT '下一个节点类型（0开始节点 1中间节点 2结束节点 3互斥网关 4并行网关）',
  `skip_name` varchar(100) DEFAULT NULL COMMENT '跳转名称',
  `skip_type` varchar(40) DEFAULT NULL COMMENT '跳转类型（PASS审批通过 REJECT退回）',
  `skip_condition` varchar(200) DEFAULT NULL COMMENT '跳转条件',
  `coordinate` varchar(100) DEFAULT NULL COMMENT '坐标',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新人',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志',
  `tenant_id` varchar(40) DEFAULT NULL COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='节点跳转关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flow_skip`
--

LOCK TABLES `flow_skip` WRITE;
/*!40000 ALTER TABLE `flow_skip` DISABLE KEYS */;
/*!40000 ALTER TABLE `flow_skip` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flow_spel`
--

DROP TABLE IF EXISTS `flow_spel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_spel` (
  `id` bigint NOT NULL COMMENT '主键id',
  `component_name` varchar(255) DEFAULT NULL COMMENT '组件名称',
  `method_name` varchar(255) DEFAULT NULL COMMENT '方法名',
  `method_params` varchar(255) DEFAULT NULL COMMENT '参数',
  `view_spel` varchar(255) DEFAULT NULL COMMENT '预览spel表达式',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='流程spel表达式定义表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flow_spel`
--

LOCK TABLES `flow_spel` WRITE;
/*!40000 ALTER TABLE `flow_spel` DISABLE KEYS */;
INSERT INTO `flow_spel` VALUES (1,'spelRuleComponent','selectDeptLeaderById','initiatorDeptId','#{@spelRuleComponent.selectDeptLeaderById(#initiatorDeptId)}','根据部门id获取部门负责人','0','0',103,1,'2026-05-21 23:15:14',1,'2026-05-21 23:15:14'),(2,NULL,NULL,'initiator','${initiator}','流程发起人','0','0',103,1,'2026-05-21 23:15:14',1,'2026-05-21 23:15:14');
/*!40000 ALTER TABLE `flow_spel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flow_task`
--

DROP TABLE IF EXISTS `flow_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_task` (
  `id` bigint NOT NULL COMMENT '主键id',
  `definition_id` bigint NOT NULL COMMENT '对应flow_definition表的id',
  `instance_id` bigint NOT NULL COMMENT '对应flow_instance表的id',
  `node_code` varchar(100) NOT NULL COMMENT '节点编码',
  `node_name` varchar(100) DEFAULT NULL COMMENT '节点名称',
  `node_type` tinyint(1) NOT NULL COMMENT '节点类型（0开始节点 1中间节点 2结束节点 3互斥网关 4并行网关）',
  `flow_status` varchar(20) NOT NULL COMMENT '流程状态（0待提交 1审批中 2审批通过 4终止 5作废 6撤销 8已完成 9已退回 10失效 11拿回）',
  `form_custom` char(1) DEFAULT 'N' COMMENT '审批表单是否自定义（Y是 N否）',
  `form_path` varchar(100) DEFAULT NULL COMMENT '审批表单路径',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新人',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志',
  `tenant_id` varchar(40) DEFAULT NULL COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='待办任务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flow_task`
--

LOCK TABLES `flow_task` WRITE;
/*!40000 ALTER TABLE `flow_task` DISABLE KEYS */;
/*!40000 ALTER TABLE `flow_task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flow_user`
--

DROP TABLE IF EXISTS `flow_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_user` (
  `id` bigint NOT NULL COMMENT '主键id',
  `type` char(1) NOT NULL COMMENT '人员类型（1待办任务的审批人权限 2待办任务的转办人权限 3待办任务的委托人权限）',
  `processed_by` varchar(80) DEFAULT NULL COMMENT '权限人',
  `associated` bigint NOT NULL COMMENT '任务表id',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(80) DEFAULT NULL COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '创建人',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志',
  `tenant_id` varchar(40) DEFAULT NULL COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `user_processed_type` (`processed_by`,`type`),
  KEY `user_associated` (`associated`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='流程用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flow_user`
--

LOCK TABLES `flow_user` WRITE;
/*!40000 ALTER TABLE `flow_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `flow_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gen_table`
--

DROP TABLE IF EXISTS `gen_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table` (
  `table_id` bigint NOT NULL COMMENT '编号',
  `data_name` varchar(200) DEFAULT '' COMMENT '数据源名称',
  `table_name` varchar(200) DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `package_name` varchar(100) DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) DEFAULT NULL COMMENT '其它生成选项',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='代码生成业务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table`
--

LOCK TABLES `gen_table` WRITE;
/*!40000 ALTER TABLE `gen_table` DISABLE KEYS */;
/*!40000 ALTER TABLE `gen_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gen_table_column`
--

DROP TABLE IF EXISTS `gen_table_column`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table_column` (
  `column_id` bigint NOT NULL COMMENT '编号',
  `table_id` bigint DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) DEFAULT '' COMMENT '字典类型',
  `sort` int DEFAULT NULL COMMENT '排序',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='代码生成业务表字段';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table_column`
--

LOCK TABLES `gen_table_column` WRITE;
/*!40000 ALTER TABLE `gen_table_column` DISABLE KEYS */;
/*!40000 ALTER TABLE `gen_table_column` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mdm_company`
--

DROP TABLE IF EXISTS `mdm_company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mdm_company` (
  `id` bigint NOT NULL COMMENT '主键（雪花ID）',
  `tenant_id` varchar(20) NOT NULL COMMENT '租户ID',
  `company_code` varchar(50) NOT NULL COMMENT '主体编码（租户内唯一，新增后不可修改）',
  `company_name` varchar(100) NOT NULL COMMENT '主体名称',
  `country_code` varchar(10) NOT NULL COMMENT '国家代码（ISO 3166-1 alpha-2）',
  `registered_addr` varchar(255) DEFAULT NULL COMMENT '注册地址',
  `tax_no` varchar(100) DEFAULT NULL COMMENT '税号（EIN/注册号）',
  `vat_registered` tinyint NOT NULL DEFAULT '0' COMMENT '是否VAT注册（0=否，1=是）',
  `invoice_title` varchar(200) DEFAULT NULL COMMENT '开票抬头',
  `invoice_tax_no` varchar(100) DEFAULT NULL COMMENT '开票税号',
  `invoice_bank_name` varchar(100) DEFAULT NULL COMMENT '开票银行',
  `bank_account_masked` varchar(100) DEFAULT NULL COMMENT '银行账号（脱敏展示）',
  `bank_name` varchar(100) DEFAULT NULL COMMENT '银行名称',
  `bank_account_no` varchar(255) DEFAULT NULL COMMENT '银行账号（加密存储）',
  `swift_code` varchar(50) DEFAULT NULL COMMENT 'SWIFT/BIC代码',
  `beneficiary` varchar(100) DEFAULT NULL COMMENT '收款人',
  `currency_code` varchar(10) NOT NULL DEFAULT 'USD' COMMENT '结算货币代码',
  `timezone` varchar(50) NOT NULL DEFAULT 'UTC' COMMENT '时区（IANA标准）',
  `license_files` json DEFAULT NULL COMMENT '营业执照等附件（JSON数组，存OSS URL）',
  `status` char(1) NOT NULL DEFAULT '0' COMMENT '状态（0=启用，1=停用）',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '???',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '???',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` bigint DEFAULT '0' COMMENT '逻辑删除（0=存在，1=删除）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_company_code` (`tenant_id`,`company_code`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='主体管理';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mdm_company`
--

LOCK TABLES `mdm_company` WRITE;
/*!40000 ALTER TABLE `mdm_company` DISABLE KEYS */;
INSERT INTO `mdm_company` VALUES (4000001,'000000','EXAMPLE-US','Example Overseas Logistics LLC','US','2525 E Slauson Ave, Los Angeles, CA 90058',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'USD','America/Los_Angeles',NULL,'0','自营美国主体',NULL,1,'2026-05-22 00:43:22',1,'2026-05-22 00:43:22',0),(4000002,'000000','EXAMPLE-CN','示例供应链有限公司','CN','广东省深圳市南山区科技园南路10号 518057',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'CNY','Asia/Shanghai',NULL,'0','国内供应商主体',NULL,1,'2026-05-22 00:43:22',1,'2026-05-22 00:43:22',0);
/*!40000 ALTER TABLE `mdm_company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mdm_fee_item`
--

DROP TABLE IF EXISTS `mdm_fee_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mdm_fee_item` (
  `id` bigint NOT NULL COMMENT '主键（雪花ID）',
  `tenant_id` varchar(20) NOT NULL COMMENT '租户ID',
  `fee_code` varchar(50) NOT NULL COMMENT '费项编码（租户内唯一，新增后不可修改）',
  `fee_name` varchar(100) NOT NULL COMMENT '费项名称',
  `fee_category` varchar(30) NOT NULL COMMENT '费项类别（字典：fee_category）',
  `business_stage` varchar(30) NOT NULL COMMENT '业务阶段（字典：fee_business_stage）',
  `business_type` varchar(30) DEFAULT NULL COMMENT '业务类型（字典：fulfillment_type，NULL=通用）',
  `is_system` tinyint NOT NULL DEFAULT '0' COMMENT '是否系统预设（0=否，1=是，不可删除）',
  `is_billable` tinyint NOT NULL DEFAULT '1' COMMENT '是否出账单（0=否，1=是）',
  `description` varchar(500) DEFAULT NULL COMMENT '费项说明',
  `status` char(1) NOT NULL DEFAULT '0' COMMENT '状态（0=正常，1=禁用）',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '???',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '???',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` bigint DEFAULT '0' COMMENT '逻辑删除（0=存在，1=删除）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_fee_code` (`tenant_id`,`fee_code`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='费项管理';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mdm_fee_item`
--

LOCK TABLES `mdm_fee_item` WRITE;
/*!40000 ALTER TABLE `mdm_fee_item` DISABLE KEYS */;
INSERT INTO `mdm_fee_item` VALUES (1000001,'000000','PICKUP_CONTAINER','提柜费','INBOUND','INBOUND',NULL,1,1,NULL,'0',10,NULL,NULL,1,'2026-05-22 00:32:42',1,'2026-05-22 00:32:42',0),(1000002,'000000','INBOUND_HANDLING','入库操作费','INBOUND','INBOUND',NULL,1,1,NULL,'0',20,NULL,NULL,1,'2026-05-22 00:32:42',1,'2026-05-22 00:32:42',0),(1000003,'000000','STORAGE_FEE','仓储费','STORAGE','STORAGE',NULL,1,1,NULL,'0',30,NULL,NULL,1,'2026-05-22 00:32:42',1,'2026-05-22 00:32:42',0),(1000004,'000000','PICK_FEE','拣货费','OUTBOUND','OUTBOUND',NULL,1,1,NULL,'0',40,NULL,NULL,1,'2026-05-22 00:32:42',1,'2026-05-22 00:32:42',0),(1000005,'000000','LABEL_FEE','贴标费','OUTBOUND','OUTBOUND',NULL,1,1,NULL,'0',50,NULL,NULL,1,'2026-05-22 00:32:42',1,'2026-05-22 00:32:42',0),(1000006,'000000','QC_CHECK','质检费','INBOUND','INBOUND',NULL,1,1,NULL,'0',60,NULL,NULL,1,'2026-05-22 00:32:42',1,'2026-05-22 00:32:42',0),(1000007,'000000','DELIVERY_FEE','配送费','OUTBOUND','OUTBOUND',NULL,1,1,NULL,'0',70,NULL,NULL,1,'2026-05-22 00:32:42',1,'2026-05-22 00:32:42',0),(1000008,'000000','FUEL_SURCHARGE','燃油附加费','TRANSPORT','TRANSPORT',NULL,1,1,NULL,'0',80,NULL,NULL,1,'2026-05-22 00:32:42',1,'2026-05-22 00:32:42',0),(1000009,'000000','RETURN_HANDLING','退货处理费','RETURN','RETURN',NULL,1,1,NULL,'0',90,NULL,NULL,1,'2026-05-22 00:32:42',1,'2026-05-22 00:32:42',0);
/*!40000 ALTER TABLE `mdm_fee_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mdm_sku`
--

DROP TABLE IF EXISTS `mdm_sku`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mdm_sku` (
  `id` bigint NOT NULL COMMENT '主键（雪花ID）',
  `tenant_id` varchar(20) NOT NULL COMMENT '租户ID',
  `client_id` bigint NOT NULL COMMENT '所属客户ID（mdm_client.id）',
  `sku_code` varchar(100) NOT NULL COMMENT 'SKU编码（客户内唯一）',
  `sku_name` varchar(200) NOT NULL COMMENT 'SKU名称（中文）',
  `sku_name_en` varchar(200) DEFAULT NULL COMMENT 'SKU名称（英文）',
  `barcode` varchar(100) DEFAULT NULL COMMENT '条形码/UPC/EAN',
  `category_id` bigint DEFAULT NULL COMMENT '品类ID（BASE-020，暂预留）',
  `brand` varchar(100) DEFAULT NULL COMMENT '品牌',
  `model` varchar(100) DEFAULT NULL COMMENT '型号',
  `color` varchar(50) DEFAULT NULL COMMENT '颜色',
  `size_spec` varchar(100) DEFAULT NULL COMMENT '尺寸规格',
  `unit` varchar(20) NOT NULL DEFAULT 'pcs' COMMENT '计量单位',
  `length_cm` decimal(8,2) DEFAULT NULL COMMENT '长(cm)',
  `width_cm` decimal(8,2) DEFAULT NULL COMMENT '宽(cm)',
  `height_cm` decimal(8,2) DEFAULT NULL COMMENT '高(cm)',
  `weight_kg` decimal(8,3) DEFAULT NULL COMMENT '重量(kg)',
  `volume_cbm` decimal(12,6) DEFAULT NULL COMMENT '体积(CBM，系统自动计算)',
  `package_length_cm` decimal(8,2) DEFAULT NULL COMMENT '外箱长(cm)',
  `package_width_cm` decimal(8,2) DEFAULT NULL COMMENT '外箱宽(cm)',
  `package_height_cm` decimal(8,2) DEFAULT NULL COMMENT '外箱高(cm)',
  `package_weight_kg` decimal(8,3) DEFAULT NULL COMMENT '外箱重(kg)',
  `is_fragile` tinyint NOT NULL DEFAULT '0' COMMENT '易碎（0=否，1=是）',
  `is_liquid` tinyint NOT NULL DEFAULT '0' COMMENT '液体',
  `is_battery` tinyint NOT NULL DEFAULT '0' COMMENT '含电池',
  `is_magnetic` tinyint NOT NULL DEFAULT '0' COMMENT '带磁',
  `is_dangerous` tinyint NOT NULL DEFAULT '0' COMMENT '危险品',
  `is_oversize` tinyint NOT NULL DEFAULT '0' COMMENT '超大件',
  `default_pkg_id` bigint DEFAULT NULL COMMENT '默认包装规格ID（mdm_packaging.id）',
  `default_fee_codes` json DEFAULT NULL COMMENT '默认作业费项（JSON数组，如["LABEL_FEE","QC_CHECK"]）',
  `declared_name_cn` varchar(200) DEFAULT NULL COMMENT '申报品名（中文）',
  `declared_name_en` varchar(200) DEFAULT NULL COMMENT '申报品名（英文）',
  `hs_code` varchar(30) DEFAULT NULL COMMENT 'HS编码',
  `declared_value` decimal(12,2) DEFAULT NULL COMMENT '申报价值',
  `declared_currency` varchar(10) DEFAULT NULL COMMENT '申报货币代码',
  `origin_country_code` varchar(10) DEFAULT NULL COMMENT '原产国代码',
  `image_url` varchar(500) DEFAULT NULL COMMENT '商品主图URL',
  `status` char(1) NOT NULL DEFAULT '0' COMMENT '状态（0=正常，1=禁用）',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '???',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '???',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` bigint DEFAULT '0' COMMENT '逻辑删除（0=存在，1=删除）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_client_sku` (`tenant_id`,`client_id`,`sku_code`),
  KEY `idx_client_id` (`client_id`),
  KEY `idx_barcode` (`barcode`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='SKU管理';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mdm_sku`
--

LOCK TABLES `mdm_sku` WRITE;
/*!40000 ALTER TABLE `mdm_sku` DISABLE KEYS */;
INSERT INTO `mdm_sku` VALUES (4002001,'000000',4000001,'BT-ANC-001','蓝牙降噪耳机 Pro','Bluetooth ANC Headphone Pro','012345000001',NULL,'SoundMax','SM-ANC01','黑色',NULL,'pcs',20.00,18.00,8.00,0.350,0.002880,NULL,NULL,NULL,NULL,0,0,1,0,0,0,NULL,NULL,'无线蓝牙耳机','Bluetooth Headphone','8518300000',35.00,'USD','CN',NULL,'0','含锂电池，走纯电池渠道',NULL,1,'2026-05-22 00:43:22',1,'2026-05-22 00:43:22',0),(4002002,'000000',4000001,'PH-CASE-002','手机保护壳 iPhone 15 Pro','Phone Case for iPhone 15 Pro','012345000002',NULL,'SafeGuard','SC-15P','透明',NULL,'pcs',15.00,8.00,1.50,0.080,0.000180,NULL,NULL,NULL,NULL,0,0,0,0,0,0,NULL,NULL,'手机保护壳','Phone Protective Case','3926909090',5.00,'USD','CN',NULL,'0',NULL,NULL,1,'2026-05-22 00:43:22',1,'2026-05-22 00:43:22',0),(4002003,'000000',4000001,'LED-STRIP-003','LED灯带 5米 RGB','LED Strip Light 5M RGB','012345000003',NULL,'BrightTech','BT-LED5M',NULL,NULL,'pcs',50.00,5.00,5.00,0.200,0.001250,NULL,NULL,NULL,NULL,0,0,0,1,0,0,NULL,NULL,'LED灯带','LED Strip Light','8539500000',12.00,'USD','CN',NULL,'0','带磁，部分渠道限制',NULL,1,'2026-05-22 00:43:22',1,'2026-05-22 00:43:22',0),(4002004,'000000',4000001,'USB-HUB-004','USB-C 集线器 7合1','USB-C Hub 7-in-1','012345000004',NULL,'ConnectPro','CP-HUB7','深灰',NULL,'pcs',12.00,6.00,2.00,0.150,0.000144,NULL,NULL,NULL,NULL,0,0,0,0,0,0,NULL,NULL,'USB集线器','USB Hub','8473301000',18.00,'USD','CN',NULL,'0',NULL,NULL,1,'2026-05-22 00:43:22',1,'2026-05-22 00:43:22',0),(4002005,'000000',4000001,'WATCH-SW-005','智能运动手表','Smart Watch Sport Edition','012345000005',NULL,'TimeTech','TT-SW01','黑色',NULL,'pcs',5.00,5.00,1.50,0.070,0.000038,NULL,NULL,NULL,NULL,0,0,1,0,0,0,NULL,NULL,'智能手表','Smart Watch','8541900000',45.00,'USD','CN',NULL,'0','含电池，重量轻',NULL,1,'2026-05-22 00:43:22',1,'2026-05-22 00:43:22',0),(4002006,'000000',4000001,'YOGA-MAT-006','瑜伽垫 TPE 10mm 加厚','Yoga Mat TPE Extra Thick 10mm','012345000006',NULL,'FitLife','FL-YM10','紫色',NULL,'pcs',61.00,10.00,10.00,1.200,0.006100,NULL,NULL,NULL,NULL,0,0,0,0,0,0,NULL,NULL,'瑜伽垫','Yoga Mat','3926909090',15.00,'USD','CN',NULL,'0',NULL,NULL,1,'2026-05-22 00:43:22',1,'2026-05-22 00:43:22',0),(4002007,'000000',4000001,'COFFEE-007','挂耳咖啡 精品单品 10包','Drip Coffee Premium 10-Pack','012345000007',NULL,'BrewMaster','BM-DC10',NULL,NULL,'box',12.00,8.00,5.00,0.250,0.000480,NULL,NULL,NULL,NULL,0,1,0,0,0,0,NULL,NULL,'咖啡','Coffee','0901210000',8.00,'USD','CN',NULL,'0','液体类商品',NULL,1,'2026-05-22 00:43:22',1,'2026-05-22 00:43:22',0),(4002008,'000000',4000001,'POWER-BANK-008','移动电源 20000mAh PD65W','Power Bank 20000mAh PD65W','012345000008',NULL,'ChargePro','CP-PB20K','白色',NULL,'pcs',14.00,7.00,3.00,0.450,0.000294,NULL,NULL,NULL,NULL,0,0,1,0,0,0,NULL,NULL,'移动电源','Power Bank','8507600090',25.00,'USD','CN',NULL,'0','含锂电池，大容量',NULL,1,'2026-05-22 00:43:22',1,'2026-05-22 00:43:22',0),(4002009,'000000',4000001,'STAND-DESK-009','升降电动站立办公桌','Electric Height Adjustable Desk','012345000009',NULL,'ErgoDesk','ED-1400','黑色',NULL,'pcs',140.00,70.00,15.00,32.000,0.147000,NULL,NULL,NULL,NULL,0,0,0,0,0,1,NULL,NULL,'办公桌','Office Desk','9403200000',180.00,'USD','CN',NULL,'0','超大件，需专用物流',NULL,1,'2026-05-22 00:43:22',1,'2026-05-22 00:43:22',0),(4002010,'000000',4000001,'PERFUME-010','香水 EDT 50ml','Eau de Toilette 50ml','012345000010',NULL,'ScentLux','SL-EDT50',NULL,NULL,'pcs',5.00,5.00,9.00,0.130,0.000225,NULL,NULL,NULL,NULL,1,1,0,0,1,0,NULL,NULL,'香水','Perfume','3303000000',28.00,'USD','FR',NULL,'0','液体+危险品，限量渠道',NULL,1,'2026-05-22 00:43:22',1,'2026-05-22 00:43:22',0);
/*!40000 ALTER TABLE `mdm_sku` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mdm_warehouse`
--

DROP TABLE IF EXISTS `mdm_warehouse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mdm_warehouse` (
  `id` bigint NOT NULL COMMENT '主键（雪花ID）',
  `tenant_id` varchar(20) NOT NULL COMMENT '租户ID',
  `company_id` bigint NOT NULL COMMENT '所属主体ID（mdm_company.id）',
  `warehouse_code` varchar(50) NOT NULL COMMENT '仓库编码（租户内唯一，如 LA01/NJ01）',
  `warehouse_name` varchar(100) NOT NULL COMMENT '仓库名称',
  `warehouse_type` varchar(20) NOT NULL COMMENT '仓库类型（字典：warehouse_type）',
  `country_code` varchar(10) NOT NULL COMMENT '国家代码',
  `state_code` varchar(10) DEFAULT NULL COMMENT '州/省代码',
  `city` varchar(100) DEFAULT NULL COMMENT '城市',
  `address` varchar(255) DEFAULT NULL COMMENT '详细地址',
  `zip_code` varchar(20) DEFAULT NULL COMMENT '邮编',
  `timezone` varchar(50) DEFAULT NULL COMMENT '时区（IANA标准）',
  `currency_code` varchar(10) DEFAULT NULL COMMENT '结算货币代码',
  `contact_name` varchar(100) DEFAULT NULL COMMENT '联系人',
  `contact_phone` varchar(50) DEFAULT NULL COMMENT '联系电话',
  `is_bonded` tinyint NOT NULL DEFAULT '0' COMMENT '是否保税仓（0=否，1=是）',
  `operation_start_time` varchar(10) DEFAULT NULL COMMENT '运营开始时间（HH:mm）',
  `operation_end_time` varchar(10) DEFAULT NULL COMMENT '运营结束时间（HH:mm）',
  `support_unloading` tinyint NOT NULL DEFAULT '0' COMMENT '支持卸柜',
  `support_dropship` tinyint NOT NULL DEFAULT '0' COMMENT '支持一件代发',
  `support_transit` tinyint NOT NULL DEFAULT '0' COMMENT '支持转运',
  `support_transfer` tinyint NOT NULL DEFAULT '0' COMMENT '支持调拨',
  `support_fba` tinyint NOT NULL DEFAULT '0' COMMENT '支持FBA头程',
  `support_self_pickup` tinyint NOT NULL DEFAULT '0' COMMENT '支持自提',
  `support_appointment` tinyint NOT NULL DEFAULT '0' COMMENT '支持预约',
  `max_capacity_cbm` decimal(10,2) DEFAULT NULL COMMENT '最大容量(CBM)',
  `daily_unloading_cap` int DEFAULT NULL COMMENT '日卸柜量(柜)',
  `daily_outbound_cap` int DEFAULT NULL COMMENT '日出库量(单)',
  `dock_count` int DEFAULT '0' COMMENT '月台数',
  `door_count` int DEFAULT '0' COMMENT '仓门数',
  `forklift_count` int DEFAULT '0' COMMENT '叉车数',
  `pda_enabled` tinyint NOT NULL DEFAULT '0' COMMENT '启用PDA（0=否，1=是）',
  `api_enabled` tinyint NOT NULL DEFAULT '0' COMMENT '启用API对接',
  `api_config` json DEFAULT NULL COMMENT 'API配置（JSON，预留）',
  `status` char(1) NOT NULL DEFAULT '0' COMMENT '状态（0=启用，1=停用）',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '???',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '???',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` bigint DEFAULT '0' COMMENT '逻辑删除（0=存在，1=删除）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_warehouse_code` (`tenant_id`,`warehouse_code`),
  KEY `idx_company_id` (`company_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='仓库管理';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mdm_warehouse`
--

LOCK TABLES `mdm_warehouse` WRITE;
/*!40000 ALTER TABLE `mdm_warehouse` DISABLE KEYS */;
INSERT INTO `mdm_warehouse` VALUES (4001001,'000000',4000001,'LA01','Los Angeles Central Warehouse','SELF_OP','US','CA','Los Angeles','2525 E Slauson Ave','90058','America/Los_Angeles','USD','John Smith','+1-310-555-0100',0,'08:00','18:00',1,1,1,1,1,1,1,5000.00,20,500,8,4,6,1,0,NULL,'0','洛杉矶中心仓，支持全品类',NULL,1,'2026-05-22 00:43:22',1,'2026-05-22 00:43:22',0),(4001002,'000000',4000001,'NJ01','New Jersey East Coast Warehouse','SELF_OP','US','NJ','Newark','50 Industrial Pkwy','07102','America/New_York','USD','Jane Doe','+1-973-555-0200',0,'07:00','19:00',1,1,1,1,1,0,1,3000.00,15,300,6,3,4,1,0,NULL,'0','新泽西东海岸仓',NULL,1,'2026-05-22 00:43:22',1,'2026-05-22 00:43:22',0),(4001003,'000000',4000001,'TX01','Texas Central Hub','PARTNER','US','TX','Houston','1234 Shipping Lane','77001','America/Chicago','USD','Bob Chen','+1-713-555-0300',0,'08:00','17:00',0,1,1,1,0,0,0,2000.00,10,200,4,2,3,0,0,NULL,'0','德克萨斯合作中转枢纽',NULL,1,'2026-05-22 00:43:22',1,'2026-05-22 00:43:22',0);
/*!40000 ALTER TABLE `mdm_warehouse` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oms_cargo_grouping_field_meta`
--

DROP TABLE IF EXISTS `oms_cargo_grouping_field_meta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oms_cargo_grouping_field_meta` (
  `id` bigint NOT NULL COMMENT 'ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `table_alias` varchar(32) NOT NULL COMMENT '????????? order/shipment',
  `field_name` varchar(64) NOT NULL COMMENT '?????????',
  `display_name` varchar(128) NOT NULL COMMENT '????????????',
  `data_type` varchar(32) NOT NULL COMMENT 'STRING/NUMBER/DATE/ENUM/REF',
  `enum_code` varchar(64) DEFAULT NULL COMMENT '????????????',
  `ref_type` varchar(64) DEFAULT NULL COMMENT '??????????????????',
  `can_be_condition` tinyint(1) NOT NULL DEFAULT '1' COMMENT '?????????????????????',
  `can_be_group_key` tinyint(1) NOT NULL DEFAULT '1' COMMENT '????????????????????????',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '??????',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '????????????',
  `remark` varchar(500) DEFAULT NULL COMMENT '??????',
  `create_dept` bigint DEFAULT NULL COMMENT '????????????',
  `create_by` bigint DEFAULT NULL COMMENT '?????????',
  `create_time` datetime DEFAULT NULL COMMENT '????????????',
  `update_by` bigint DEFAULT NULL COMMENT '?????????',
  `update_time` datetime DEFAULT NULL COMMENT '????????????',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_grouping_field` (`table_alias`,`field_name`),
  KEY `idx_grouping_field_enabled` (`enabled`),
  KEY `idx_grouping_field_condition` (`can_be_condition`),
  KEY `idx_grouping_field_group_key` (`can_be_group_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='OMS?????????????????????????????????';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oms_cargo_grouping_field_meta`
--

LOCK TABLES `oms_cargo_grouping_field_meta` WRITE;
/*!40000 ALTER TABLE `oms_cargo_grouping_field_meta` DISABLE KEYS */;
INSERT INTO `oms_cargo_grouping_field_meta` VALUES (9301001,'000000','order','order_no','订单号','STRING',NULL,NULL,0,1,10,1,'货物订单号',NULL,1,'2026-05-27 17:34:49',NULL,NULL),(9301002,'000000','order','order_type','业务类型/派送方式','ENUM','base_business_type',NULL,1,1,20,1,'货物订单业务类型/派送方式',NULL,1,'2026-05-27 17:34:49',NULL,NULL),(9301003,'000000','order','address_type','地址类型','ENUM','oms_address_type',NULL,1,1,30,1,'平台仓、私仓、商业地址',NULL,1,'2026-05-27 17:34:49',NULL,NULL),(9301004,'000000','order','platform_code','仓库代码','REF',NULL,'base_platform_address',1,1,45,1,'目的地平台仓代码',NULL,1,'2026-05-27 17:34:49',NULL,NULL),(9301005,'000000','order','customer_id','客户','REF',NULL,'base_customer',1,0,50,1,'客户ID',NULL,1,'2026-05-27 17:34:49',NULL,NULL),(9301006,'000000','order','channel_id','渠道','REF',NULL,'base_channel',1,0,60,1,'业务渠道',NULL,1,'2026-05-27 17:34:49',NULL,NULL),(9301007,'000000','shipment','shipment_no','货件编号','STRING',NULL,NULL,0,1,70,1,'货件编号',NULL,1,'2026-05-27 17:34:49',NULL,NULL),(9301008,'000000','shipment','warehouse_code','货件仓库代码','STRING',NULL,NULL,0,1,80,1,'货件分组仓库代码，当前从订单仓库代码兜底',NULL,1,'2026-05-27 17:34:49',NULL,NULL),(9301009,'000000','shipment','shipment_type','货件类型','ENUM','oms_shipment_type',NULL,0,1,90,1,'预留货件类型',NULL,1,'2026-05-27 17:34:49',NULL,NULL),(9301010,'000000','order','platform_id','平台','REF',NULL,'base_platform',1,1,40,1,'目的地平台基础资料',NULL,1,'2026-05-27 18:35:16',NULL,NULL),(9301011,'000000','order','parcel_carrier_name','快递商','ENUM','oms_parcel_carrier',NULL,1,1,47,1,'快递派送承运商字典',NULL,1,'2026-05-27 19:01:15',NULL,NULL),(1031041137903,'000000','order','transfer_warehouse_code','转仓地址','STRING',NULL,NULL,0,1,92,1,NULL,NULL,1,'2026-05-28 01:03:38',1,'2026-05-28 01:03:38'),(6517679650818,'000000','order','transfer_flag','是否转仓','ENUM','yes_no_int',NULL,1,0,91,1,NULL,NULL,1,'2026-05-28 01:03:38',1,'2026-05-28 01:03:38'),(7185785797597,'000000','order','hold_flag','HOLD标记','ENUM','yes_no_int',NULL,1,1,90,1,NULL,NULL,1,'2026-05-28 01:03:38',1,'2026-05-28 01:03:38');
/*!40000 ALTER TABLE `oms_cargo_grouping_field_meta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oms_cargo_grouping_rule`
--

DROP TABLE IF EXISTS `oms_cargo_grouping_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oms_cargo_grouping_rule` (
  `id` bigint NOT NULL COMMENT 'ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '??????ID',
  `warehouse_name` varchar(128) DEFAULT NULL COMMENT '????????????',
  `warehouse_ids` text COMMENT '仓库ID列表，JSON字符串数组，如["1","2","3"]',
  `rule_name` varchar(128) NOT NULL COMMENT '????????????',
  `condition_config` json NOT NULL COMMENT '????????????JSON',
  `group_key_config` json NOT NULL COMMENT '?????????JSON',
  `priority` int NOT NULL DEFAULT '0' COMMENT '??????????????????????????????',
  `is_default` tinyint(1) NOT NULL DEFAULT '0' COMMENT '????????????????????????',
  `status` varchar(32) NOT NULL DEFAULT 'enabled' COMMENT 'enabled/disabled',
  `version` int NOT NULL DEFAULT '0' COMMENT '???????????????',
  `remark` varchar(500) DEFAULT NULL COMMENT '??????',
  `create_dept` bigint DEFAULT NULL COMMENT '????????????',
  `create_by` bigint DEFAULT NULL COMMENT '?????????',
  `create_time` datetime DEFAULT NULL COMMENT '????????????',
  `update_by` bigint DEFAULT NULL COMMENT '?????????',
  `update_time` datetime DEFAULT NULL COMMENT '????????????',
  `deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '????????????',
  PRIMARY KEY (`id`),
  KEY `idx_grouping_rule_status` (`status`),
  KEY `idx_grouping_rule_priority` (`status`,`priority`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='OMS????????????????????????';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oms_cargo_grouping_rule`
--

LOCK TABLES `oms_cargo_grouping_rule` WRITE;
/*!40000 ALTER TABLE `oms_cargo_grouping_rule` DISABLE KEYS */;
INSERT INTO `oms_cargo_grouping_rule` VALUES (2059814468601593857,'000000','Los Angeles Central Warehouse','[\"4001001\"]','LA-平台仓分组','{\"mode\": \"VALUE_MATCH\", \"logic\": \"AND\", \"conditions\": [{\"op\": \"EQ\", \"field\": \"order.order_type\", \"value\": \"卡车派送\"}, {\"op\": \"EQ\", \"field\": \"order.address_type\", \"value\": \"PLATFORM_WH\"}]}','{\"fields\": [{\"field\": \"order.platform_id\"}, {\"field\": \"order.platform_code\"}], \"separator\": \"-\"}',0,0,'enabled',1,NULL,103,1,'2026-05-28 09:50:13',1,'2026-05-28 09:52:47',0),(2059814689469448193,'000000','Los Angeles Central Warehouse','[\"4001001\"]','LA仓-商业地址','{\"mode\": \"VALUE_MATCH\", \"logic\": \"AND\", \"conditions\": [{\"op\": \"EQ\", \"field\": \"order.order_type\", \"value\": \"卡车派送\"}, {\"op\": \"EQ\", \"field\": \"order.address_type\", \"value\": \"COMMERCIAL\"}]}','{\"fields\": [{\"field\": \"order.address_type\"}, {\"field\": \"order.order_no\"}], \"separator\": \"-\"}',0,0,'enabled',0,NULL,103,1,'2026-05-28 09:51:06',1,'2026-05-28 09:51:06',0),(2059814887272824834,'000000','Los Angeles Central Warehouse','[\"4001001\"]','LA仓-私人地址','{\"mode\": \"VALUE_MATCH\", \"logic\": \"AND\", \"conditions\": [{\"op\": \"EQ\", \"field\": \"order.order_type\", \"value\": \"卡车派送\"}, {\"op\": \"EQ\", \"field\": \"order.address_type\", \"value\": \"PRIVATE\"}]}','{\"fields\": [{\"field\": \"order.address_type\"}, {\"field\": \"order.order_no\"}], \"separator\": \"-\"}',0,0,'enabled',0,NULL,103,1,'2026-05-28 09:51:53',1,'2026-05-28 09:51:53',0),(2059818114852667394,'000000','Los Angeles Central Warehouse','[\"4001001\"]','LA仓-快递派送','{\"mode\": \"VALUE_MATCH\", \"logic\": \"AND\", \"conditions\": [{\"op\": \"EQ\", \"field\": \"order.order_type\", \"value\": \"快递派送\"}]}','{\"fields\": [{\"field\": \"order.parcel_carrier_name\"}], \"separator\": \"-\"}',0,0,'enabled',0,NULL,103,1,'2026-05-28 10:04:43',1,'2026-05-28 10:04:43',0),(2059818230577709057,'000000','Los Angeles Central Warehouse','[\"4001001\"]','LA仓-客户自提','{\"mode\": \"VALUE_MATCH\", \"logic\": \"AND\", \"conditions\": [{\"op\": \"EQ\", \"field\": \"order.order_type\", \"value\": \"客户自提\"}]}','{\"fields\": [{\"field\": \"order.order_type\"}, {\"field\": \"order.order_no\"}], \"separator\": \"-\"}',0,0,'enabled',0,NULL,103,1,'2026-05-28 10:05:10',1,'2026-05-28 10:05:10',0),(2059818382247936002,'000000','Los Angeles Central Warehouse','[\"4001001\"]','LA-大货中转','{\"mode\": \"VALUE_MATCH\", \"logic\": \"AND\", \"conditions\": [{\"op\": \"EQ\", \"field\": \"order.order_type\", \"value\": \"大货中转\"}]}','{\"fields\": [{\"field\": \"order.order_type\"}, {\"field\": \"order.order_no\"}], \"separator\": \"-\"}',0,0,'enabled',1,NULL,103,1,'2026-05-28 10:05:47',1,'2026-05-28 16:09:00',0),(2059818545750294529,'000000','Los Angeles Central Warehouse','[\"4001001\"]','LA-一件代发','{\"mode\": \"VALUE_MATCH\", \"logic\": \"AND\", \"conditions\": [{\"op\": \"EQ\", \"field\": \"order.order_type\", \"value\": \"一件代发\"}]}','{\"fields\": [{\"field\": \"order.order_type\"}, {\"field\": \"shipment.shipment_no\"}], \"separator\": \"-\"}',0,0,'enabled',1,NULL,103,1,'2026-05-28 10:06:26',1,'2026-05-28 16:08:52',0),(2059909717730582530,'000000','Los Angeles Central Warehouse','[\"4001001\"]','LA-快递','{\"mode\": \"VALUE_MATCH\", \"logic\": \"AND\", \"conditions\": [{\"op\": \"EQ\", \"field\": \"order.order_type\", \"value\": \"快递派送\"}]}','{\"fields\": [{\"field\": \"order.parcel_carrier_name\"}], \"separator\": \"-\"}',0,0,'enabled',0,NULL,103,1,'2026-05-28 16:08:43',1,'2026-05-28 16:08:43',0);
/*!40000 ALTER TABLE `oms_cargo_grouping_rule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oms_cargo_order`
--

DROP TABLE IF EXISTS `oms_cargo_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oms_cargo_order` (
  `id` bigint NOT NULL COMMENT '主键ID（雪花）',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `company_id` bigint DEFAULT NULL COMMENT '主体公司ID',
  `biz_root_id` bigint DEFAULT NULL COMMENT '业务主线ID（全链路串联）',
  `shipment_codes` varchar(2000) DEFAULT NULL COMMENT '货件编码汇总（逗号分隔，服务层聚合回写）',
  `po_nos` varchar(2000) DEFAULT NULL COMMENT 'PO号汇总（逗号分隔，服务层聚合回写）',
  `marks` varchar(2000) DEFAULT NULL COMMENT '唛头汇总（逗号分隔，服务层聚合回写）',
  `cargo_order_no` varchar(64) NOT NULL COMMENT '货物订单号',
  `external_order_no` varchar(128) DEFAULT NULL COMMENT '外部订单号（客户/来源系统）',
  `order_source` varchar(32) DEFAULT NULL COMMENT '订单来源(MANUAL/IMPORT/API/PORTAL)',
  `customer_id` bigint DEFAULT NULL COMMENT '客户ID',
  `customer_name` varchar(128) DEFAULT NULL COMMENT '客户名称（冗余）',
  `business_type_id` bigint DEFAULT NULL COMMENT '业务类型ID',
  `business_type_name` varchar(128) DEFAULT NULL COMMENT '业务类型名称（冗余）',
  `channel_id` bigint DEFAULT NULL COMMENT '渠道ID',
  `channel_name` varchar(128) DEFAULT NULL COMMENT '渠道名称（冗余）',
  `platform_id` bigint DEFAULT NULL COMMENT '平台ID',
  `platform_name` varchar(128) DEFAULT NULL COMMENT '平台名称（冗余，如Amazon-US）',
  `customer_service_id` bigint DEFAULT NULL COMMENT '客服ID',
  `customer_service_name` varchar(128) DEFAULT NULL COMMENT '客服名称（冗余）',
  `container_order_id` bigint DEFAULT NULL COMMENT '关联海柜订单ID',
  `container_no` varchar(32) DEFAULT NULL COMMENT '柜号（冗余）',
  `inbound_warehouse_id` bigint DEFAULT NULL COMMENT '入库仓库ID',
  `inbound_warehouse_name` varchar(128) DEFAULT NULL COMMENT '入库仓库名称（冗余）',
  `address_type` varchar(32) DEFAULT NULL COMMENT '地址类型(PLATFORM_WH/PRIVATE/COMMERCIAL)',
  `platform_warehouse_code` varchar(64) DEFAULT NULL COMMENT '平台仓库代码',
  `consignee_name` varchar(128) DEFAULT NULL COMMENT '收货方名称',
  `address_line1` varchar(255) DEFAULT NULL COMMENT '地址Line1',
  `address_line2` varchar(255) DEFAULT NULL COMMENT '地址Line2',
  `city` varchar(128) DEFAULT NULL COMMENT 'City',
  `state` varchar(64) DEFAULT NULL COMMENT 'State',
  `zip_code` varchar(32) DEFAULT NULL COMMENT 'Zip Code',
  `country` varchar(64) DEFAULT NULL COMMENT 'Country',
  `contact_name` varchar(128) DEFAULT NULL COMMENT '联系人',
  `contact_phone` varchar(64) DEFAULT NULL COMMENT '联系电话',
  `contact_email` varchar(128) DEFAULT NULL COMMENT '联系邮箱',
  `parcel_carrier_name` varchar(128) DEFAULT NULL COMMENT '快递商名称',
  `parcel_tracking_no` varchar(128) DEFAULT NULL COMMENT '快递追踪号',
  `transfer_flag` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否转仓',
  `transfer_warehouse_code` varchar(64) DEFAULT NULL COMMENT '转仓目标仓库代码',
  `forecast_qty_unit` varchar(32) NOT NULL DEFAULT 'BY_CARTON' COMMENT '预报计量单位 BY_CARTON/BY_PALLET',
  `declared_carton_qty` decimal(10,2) DEFAULT NULL COMMENT '预报箱数',
  `declared_pallet_qty` decimal(10,2) DEFAULT NULL COMMENT '预报板数',
  `declared_piece_qty` decimal(12,2) DEFAULT NULL COMMENT '预报件数',
  `declared_weight` decimal(12,3) DEFAULT NULL COMMENT '预报重量(kg)',
  `declared_cbm` decimal(12,3) DEFAULT NULL COMMENT '预报体积(m³)',
  `actual_carton_qty` decimal(10,2) DEFAULT NULL COMMENT '实际箱数',
  `actual_pallet_qty` decimal(10,2) DEFAULT NULL COMMENT '实际板数（WMS打板统计）',
  `actual_piece_qty` decimal(12,2) DEFAULT NULL COMMENT '实际件数',
  `actual_weight` decimal(12,3) DEFAULT NULL COMMENT '实际重量(kg)',
  `actual_cbm` decimal(12,3) DEFAULT NULL COMMENT '实际体积(m³)',
  `group_code` varchar(100) DEFAULT NULL COMMENT '入库分组（从货件汇总，多分组时存MULTI）',
  `weight_unit` varchar(16) DEFAULT 'KG' COMMENT '重量单位(KG/LB)',
  `volume_unit` varchar(16) DEFAULT 'CBM' COMMENT '体积单位',
  `pre_outbound_flag` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否有预出单',
  `pre_outbound_no` varchar(64) DEFAULT NULL COMMENT '预出单号',
  `latest_pre_outbound_id` bigint DEFAULT NULL COMMENT '???????????????ID',
  `pre_outbound_status` varchar(32) NOT NULL DEFAULT 'NONE' COMMENT '预出单状态(NONE/PRE_CREATED/CONVERTED/CANCELLED)',
  `pre_outbound_time` datetime DEFAULT NULL COMMENT '生成预出单时间',
  `pre_outbound_convert_time` datetime DEFAULT NULL COMMENT '预出单转正式时间',
  `outbound_batch_no` varchar(64) DEFAULT NULL COMMENT '正式出单号/批次号',
  `latest_outbound_order_id` bigint DEFAULT NULL COMMENT '??????????????????ID',
  `outbound_order_status` varchar(32) NOT NULL DEFAULT 'NONE' COMMENT '出单状态(NONE/ORDERED/CANCELLED)',
  `outbound_direction` varchar(32) DEFAULT NULL COMMENT '???????????? DELIVERY/TRANSFER',
  `outbound_order_time` datetime DEFAULT NULL COMMENT '正式出单时间',
  `order_status` varchar(32) NOT NULL DEFAULT 'NORMAL' COMMENT '订单状态(NORMAL/CANCELLED/CLOSED)',
  `fulfillment_status` varchar(32) NOT NULL DEFAULT 'PENDING_ACCEPT' COMMENT '主履约状态',
  `appointment_status` varchar(32) NOT NULL DEFAULT 'NONE' COMMENT '预约状态(NONE/APPOINTED/CANCELLED)',
  `pod_status` varchar(32) NOT NULL DEFAULT 'PENDING' COMMENT 'POD状态(PENDING/UPLOADED/EXCEPTION)',
  `billing_status` varchar(32) NOT NULL DEFAULT 'UNBILLED' COMMENT '账单状态(UNBILLED/BILLED/VOIDED)',
  `earliest_dw_time` datetime DEFAULT NULL COMMENT '最早DW时间（货件层聚合，系统回写）',
  `eta` datetime DEFAULT NULL COMMENT 'ETA预计到港',
  `ata` datetime DEFAULT NULL COMMENT 'ATA实际到港',
  `actual_pickup_time` datetime DEFAULT NULL COMMENT '实际提柜时间',
  `actual_arrival_time` datetime DEFAULT NULL COMMENT '实际到仓时间',
  `devanning_finish_time` datetime DEFAULT NULL COMMENT '拆柜完成时间',
  `actual_inbound_time` datetime DEFAULT NULL COMMENT '入库完成时间',
  `delivery_lfd` datetime DEFAULT NULL COMMENT '派送LFD（最晚完成派送日期）',
  `delivery_appointment_time` datetime DEFAULT NULL COMMENT '派送预约时间',
  `actual_outbound_time` datetime DEFAULT NULL COMMENT '实际出库时间',
  `signed_time` datetime DEFAULT NULL COMMENT '签收时间',
  `pod_upload_time` datetime DEFAULT NULL COMMENT 'POD回传时间',
  `billing_time` datetime DEFAULT NULL COMMENT '出账单时间',
  `completed_time` datetime DEFAULT NULL COMMENT '全链路完成时间',
  `exception_flag` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否有未关闭异常',
  `exception_count` int NOT NULL DEFAULT '0' COMMENT '未关闭异常数量',
  `hold_flag` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'HOLD标志（0正常/1HOLD中）',
  `hold_status` varchar(32) NOT NULL DEFAULT 'NORMAL' COMMENT 'NORMAL/HOLDING/RELEASED',
  `hold_type` varchar(64) DEFAULT NULL COMMENT '暂扣类型',
  `hold_reason` varchar(500) DEFAULT NULL COMMENT '当前暂扣原因',
  `hold_time` datetime DEFAULT NULL COMMENT '暂扣时间',
  `hold_user_id` bigint DEFAULT NULL COMMENT '暂扣人ID',
  `hold_user_name` varchar(128) DEFAULT NULL COMMENT '暂扣人名称',
  `release_time` datetime DEFAULT NULL COMMENT '最近放行时间',
  `hold_remark` varchar(500) DEFAULT NULL COMMENT 'HOLD原因/说明',
  `parent_order_id` bigint DEFAULT NULL COMMENT '父订单ID（由拆单产生时填写）',
  `parent_order_no` varchar(64) DEFAULT NULL COMMENT '父级货物订单号',
  `root_order_id` bigint DEFAULT NULL COMMENT '最初原单ID',
  `root_order_no` varchar(64) DEFAULT NULL COMMENT '最初原单号',
  `split_flag` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否参与拆单',
  `split_role` varchar(32) NOT NULL DEFAULT 'NORMAL' COMMENT 'NORMAL/SPLIT_PARENT/SPLIT_CHILD',
  `split_status` varchar(32) NOT NULL DEFAULT 'NONE' COMMENT 'NONE/SPLIT_ACTIVE/MERGED_BACK/PARTIAL_MERGED_BACK',
  `split_group_no` varchar(64) DEFAULT NULL COMMENT '拆单批次号',
  `child_order_count` int NOT NULL DEFAULT '0' COMMENT '子单数量',
  `merged_back_time` datetime DEFAULT NULL COMMENT '回并时间',
  `merged_back_by` bigint DEFAULT NULL COMMENT '回并人',
  `split_source` varchar(32) DEFAULT NULL COMMENT 'CUSTOMER/INTERNAL',
  `customer_visible_flag` tinyint(1) NOT NULL DEFAULT '1' COMMENT '客户是否可见',
  `customer_split_reason` varchar(500) DEFAULT NULL COMMENT '客户拆单原因',
  `internal_split_reason` varchar(500) DEFAULT NULL COMMENT '内部拆单原因',
  `split_requested_by` varchar(32) DEFAULT NULL COMMENT '发起来源',
  `split_requested_user_id` bigint DEFAULT NULL COMMENT '发起人ID',
  `split_requested_user_name` varchar(128) DEFAULT NULL COMMENT '发起人名称',
  `split_time` datetime DEFAULT NULL COMMENT '拆单时间',
  `split_fee_flag` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否可能产生拆单费用',
  `split_fee_amount` decimal(10,2) DEFAULT NULL COMMENT '拆单费用',
  `split_fee_remark` varchar(500) DEFAULT NULL COMMENT '拆单费用备注',
  `attachment_count` int NOT NULL DEFAULT '0' COMMENT '本单附件数量',
  `pod_attachment_count` int NOT NULL DEFAULT '0' COMMENT 'POD附件数量',
  `exception_attachment_count` int NOT NULL DEFAULT '0' COMMENT '异常附件数量',
  `latest_attachment_time` datetime DEFAULT NULL COMMENT '最近附件上传时间',
  `customer_remark` text COMMENT '客户备注',
  `internal_remark` text COMMENT '内部备注',
  `operation_remark` text COMMENT '操作备注',
  `follow_up_remark` text COMMENT '跟进记录（客服/运营跟进内容）',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_cargo_order_no_tenant` (`cargo_order_no`,`tenant_id`),
  KEY `idx_tenant_fulfillment_status` (`tenant_id`,`fulfillment_status`),
  KEY `idx_company_id` (`company_id`),
  KEY `idx_customer_id` (`customer_id`),
  KEY `idx_biz_root_id` (`biz_root_id`),
  KEY `idx_container_order_id` (`container_order_id`),
  KEY `idx_inbound_warehouse_id` (`inbound_warehouse_id`),
  KEY `idx_earliest_dw_time` (`earliest_dw_time`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_group_code` (`group_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='货物订单主表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oms_cargo_order`
--

LOCK TABLES `oms_cargo_order` WRITE;
/*!40000 ALTER TABLE `oms_cargo_order` DISABLE KEYS */;
INSERT INTO `oms_cargo_order` VALUES (1001,'000000',4000001,10001,'SC-001, SC-002','PO-20260501-001, PO-20260501-002','MARK-A','CO-2026-000001','EXT-REF-001','MANUAL',200,'测试客户A',5002001,'卡车派送',NULL,NULL,2000001,'Amazon',30,'张客服',9100001,'TGHU1234567',4001001,'Los Angeles Central Warehouse','PLATFORM_WH','ONT8','Amazon Fulfillment Center','1 Fulfillment Way',NULL,'Ontario','CA','91761','US','John Smith','+1-909-555-0001','john.smith@amazon.com',NULL,NULL,0,NULL,'BY_CARTON',120.00,0.00,NULL,860.500,6.800,NULL,NULL,NULL,NULL,NULL,'Amazon-ONT8','KG','CBM',1,'POB2060128929778593792',NULL,'PRE_CREATED','2026-05-29 06:39:47',NULL,NULL,NULL,'NONE',NULL,NULL,'NORMAL','IN_TRANSIT','NONE','PENDING','UNBILLED','2026-06-01 00:00:00','2026-05-28 00:00:00',NULL,NULL,NULL,NULL,NULL,'2026-06-05 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,'NORMAL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'SPLIT_PARENT','SPLIT_ACTIVE','SPLIT2058428177850880000',2,NULL,NULL,'INTERNAL',1,NULL,'内部作业拆单',NULL,NULL,NULL,'2026-05-24 14:01:36',0,NULL,NULL,0,0,0,NULL,'请注意FBA入仓要求',NULL,NULL,NULL,NULL,103,1,'2026-05-23 02:06:16',1,'2026-05-29 06:39:47',0),(1002,'000000',4000001,10002,'SC-003','PO-20260502-001','MARK-B','CO-2026-000002','EXT-REF-002','IMPORT',201,'测试客户B',5002001,'卡车派送',NULL,NULL,NULL,NULL,30,'张客服',9100001,'TGHU1234567',4001001,'Los Angeles Central Warehouse','PRIVATE',NULL,'Private Warehouse LLC','2500 Industrial Blvd','Suite 300','Los Angeles','CA','90001','US','Mike Johnson','+1-323-555-0002','mike@private-wh.com',NULL,NULL,1,'RNO1','BY_CARTON',80.00,0.00,NULL,560.000,4.200,40.00,4.00,NULL,420.000,2.100,'PRIVATE-CO-2026-000002','KG','CBM',0,'POB2059563689638731776',NULL,'NONE','2026-05-27 17:13:43',NULL,NULL,NULL,'NONE',NULL,NULL,'NORMAL','DEVANNING','NONE','PENDING','UNBILLED','2026-05-20 00:00:00','2026-05-18 00:00:00','2026-05-19 10:30:00','2026-05-20 08:00:00','2026-05-20 14:00:00',NULL,NULL,'2026-05-29 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,'NORMAL','OPERATION_HOLD','运营暂扣','2026-05-24 14:25:46',1,'admin','2026-05-24 14:25:42','运营暂扣',NULL,NULL,NULL,NULL,0,'NORMAL','NONE',NULL,0,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,0,0,NULL,NULL,'转仓至RNO1，需重新预约','已联系转仓仓库确认接收','2026-05-21 客户确认转仓，预计6月10前完成派送',NULL,103,1,'2026-05-23 02:06:16',1,'2026-05-28 17:10:05',0),(1003,'000000',100,10003,'SC-004, SC-005, SC-006','PO-20260503-001, PO-20260503-002, PO-20260503-003','MARK-C1, MARK-C2','CO-2026-000003','EXT-REF-003','API',202,'测试客户C',12,'商业地址派送',NULL,NULL,NULL,NULL,31,'李客服',9100002,'MSCU7654321',41,'纽约仓(JFK)','COMMERCIAL',NULL,'XYZ Distribution Co.','888 Commerce Street',NULL,'Newark','NJ','07102','US','Sarah Lee','+1-973-555-0003','sarah@xyzdc.com',NULL,NULL,0,NULL,'BY_CARTON',200.00,0.00,NULL,1450.000,11.500,200.00,10.00,NULL,1445.000,11.480,NULL,'KG','CBM',1,'POB202605240001',NULL,'CONVERTED',NULL,'2026-05-27 14:09:52','OB2059517419632996352',NULL,'CANCELLED',NULL,'2026-05-27 14:09:52','NORMAL','OUTBOUND_ORDERED','NONE','PENDING','UNBILLED','2026-05-15 00:00:00','2026-05-12 00:00:00','2026-05-13 09:00:00','2026-05-14 07:00:00','2026-05-14 16:00:00','2026-05-15 12:00:00','2026-05-16 10:00:00','2026-05-31 00:00:00',NULL,NULL,NULL,NULL,NULL,NULL,1,2,0,'NORMAL',NULL,NULL,NULL,NULL,NULL,NULL,'客户要求暂停出单，等待清关文件补充',NULL,NULL,NULL,NULL,0,'NORMAL','NONE',NULL,0,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,0,0,NULL,'请保管好货物','客户有清关问题，等待文件','已通知仓库暂停出单','2026-05-20 与客户沟通，预计5月25前提供文件',NULL,103,1,'2026-05-23 02:06:16',1,'2026-05-27 14:17:20',0),(1004,'000000',100,10004,'SC-007','PO-20260504-001','MARK-D','CO-2026-000004',NULL,'PORTAL',200,'测试客户A',10,'FBA头程',NULL,NULL,20,'Amazon US',30,'张客服',9100003,'OOLU4567890',41,'纽约仓(JFK)','PLATFORM_WH','JFK7','Amazon Fulfillment Center JFK7','600 Outer Road',NULL,'Jamaica','NY','11430','US','Amazon Receiving','+1-718-555-0004',NULL,NULL,NULL,0,NULL,'BY_CARTON',50.00,0.00,NULL,380.000,2.900,50.00,3.00,NULL,379.500,2.890,NULL,'KG','CBM',0,'POB2059563689638731776',NULL,'NONE','2026-05-27 17:13:43','2026-05-27 17:23:28','OB2059707989890539520',NULL,'NONE',NULL,'2026-05-28 02:47:07','NORMAL','INBOUNDED','APPOINTED','PENDING','UNBILLED','2026-05-10 00:00:00','2026-05-08 00:00:00','2026-05-09 11:00:00','2026-05-10 06:00:00','2026-05-10 15:00:00','2026-05-11 10:00:00','2026-05-28 02:47:14','2026-05-20 00:00:00','2026-05-18 09:00:00','2026-05-18 14:00:00',NULL,NULL,NULL,NULL,0,0,0,'NORMAL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'NORMAL','NONE',NULL,0,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,0,0,NULL,NULL,NULL,'已出单，快递追踪正常','2026-05-19 快递显示已到目的城市，预计明天签收',NULL,103,1,'2026-05-23 02:06:16',1,'2026-05-28 02:47:14',0),(1005,'000000',100,10005,'SC-008, SC-009','PO-20260420-001','MARK-E','CO-2026-000005','EXT-REF-005','MANUAL',203,'测试客户D',11,'私仓派送',NULL,NULL,NULL,NULL,31,'李客服',5005,'CNSHA2600005',42,'西雅图仓(SEA)','PRIVATE',NULL,'Seattle Storage Inc.','1200 Harbor Ave SW',NULL,'Seattle','WA','98126','US','Tom Wang','+1-206-555-0005','tom@sea-storage.com',NULL,NULL,0,NULL,'BY_CARTON',30.00,0.00,NULL,210.000,1.600,30.00,2.00,NULL,209.800,1.590,NULL,'KG','CBM',0,NULL,NULL,'CONVERTED',NULL,NULL,'OB-2026-005',NULL,'NONE',NULL,NULL,'NORMAL','COMPLETED','APPOINTED','UPLOADED','BILLED','2026-04-25 00:00:00','2026-04-22 00:00:00','2026-04-23 10:00:00','2026-04-24 07:00:00','2026-04-24 16:00:00','2026-04-25 11:00:00','2026-04-26 09:00:00','2026-05-05 00:00:00','2026-05-03 10:00:00','2026-05-03 15:00:00','2026-05-04 11:00:00',NULL,NULL,NULL,0,0,0,'NORMAL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'NORMAL','NONE',NULL,0,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,0,0,NULL,NULL,NULL,'全程顺利，已出账',NULL,NULL,103,1,'2026-05-23 02:06:16',1,'2026-05-23 02:06:16',0),(9200013,'000000',4000001,9150013,'PH-EWR4-008A','PO-PHG-2026-4401','PHG/EWR4/S8','CO202605080001','PHG-2026-05-008','MANUAL',8001001,'Pacific Home Goods LLC',5002001,'FBA头程',5001001,'Amazon US',NULL,NULL,1,'Amy',9100004,'CMAU9876543',4001002,'New Jersey East Coast Warehouse','PLATFORM_WH','EWR4','Amazon.com Services LLC','50 New Canton Way',NULL,'Robbinsville','NJ','08691','US','FBA Receiving','800-999-0000','fba-inbound@amazon.com',NULL,NULL,0,NULL,'BY_CARTON',280.00,0.00,3360.00,3668.000,15.400,280.00,10.00,3360.00,3680.000,15.500,NULL,'KG','CBM',0,NULL,NULL,'NONE',NULL,NULL,NULL,NULL,'NONE',NULL,NULL,'NORMAL','INBOUNDED','NONE','PENDING','UNBILLED','2026-05-20 00:00:00','2026-05-10 06:00:00','2026-05-10 08:45:00','2026-05-11 10:20:00','2026-05-11 17:55:00','2026-05-14 16:30:00','2026-05-13 10:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,'NORMAL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'NORMAL','NONE',NULL,0,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,0,0,NULL,'Please deliver ASAP, DW已过期','DW已过期，优先安排出单',NULL,NULL,'演示数据：INBOUNDED，DW已超期，出单工作台-紧急',NULL,1,'2026-05-08 14:00:00',1,'2026-05-13 10:00:00',0),(9200014,'000000',4000001,9150014,'PH-EWR9-009A','PO-PHG-2026-4402','PHG/EWR9/S9','CO202605080002','PHG-2026-05-009','MANUAL',8001001,'Pacific Home Goods LLC',5002001,'FBA头程',5001001,'Amazon US',NULL,NULL,1,'Amy',9100004,'CMAU9876543',4001002,'New Jersey East Coast Warehouse','PLATFORM_WH','EWR9','Amazon.com Services LLC','8003 Industrial Blvd',NULL,'Carteret','NJ','07008','US','FBA Receiving','800-999-0000','fba-inbound@amazon.com',NULL,NULL,0,NULL,'BY_CARTON',310.00,0.00,3720.00,4061.000,17.200,312.00,11.00,3744.00,4082.400,17.330,NULL,'KG','CBM',0,NULL,NULL,'NONE',NULL,NULL,'OB2059707989890539520',NULL,'NONE',NULL,'2026-05-28 02:47:07','NORMAL','INBOUNDED','NONE','PENDING','UNBILLED','2026-05-28 00:00:00','2026-05-10 06:00:00','2026-05-10 08:45:00','2026-05-11 10:20:00','2026-05-11 17:55:00','2026-05-14 16:30:00','2026-05-28 02:47:14',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,'NORMAL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'NORMAL','NONE',NULL,0,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,0,0,NULL,NULL,'实收多2箱，DW 5/28',NULL,NULL,'演示数据：INBOUNDED，出单工作台-FBA EWR9',NULL,1,'2026-05-08 14:00:00',1,'2026-05-28 02:47:14',0),(9200015,'000000',4000001,9150015,'NO-BDL2-008A','PO-NO-2026-2201','NO/BDL2/A','CO202605080003','NO-2026-05-008','IMPORT',8001002,'Northstar Outdoor Inc.',5002001,'FBA头程',5001002,'Walmart US',NULL,NULL,1,'Mia',9100004,'CMAU9876543',4001002,'New Jersey East Coast Warehouse','PLATFORM_WH','BDL2','Amazon.com Services LLC','8 Logistics Dr',NULL,'Bloomfield','CT','06002','US','FBA Receiving','800-999-0000','fba-inbound@amazon.com',NULL,NULL,0,NULL,'BY_CARTON',260.00,0.00,3120.00,3458.000,14.600,260.00,9.00,3120.00,3458.000,14.600,NULL,'KG','CBM',0,NULL,NULL,'NONE',NULL,NULL,NULL,NULL,'NONE',NULL,NULL,'NORMAL','INBOUNDED','NONE','PENDING','UNBILLED','2026-05-26 00:00:00','2026-05-10 06:00:00','2026-05-10 08:45:00','2026-05-11 10:20:00','2026-05-11 17:55:00','2026-05-14 16:30:00','2026-05-14 09:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,'NORMAL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'NORMAL','NONE',NULL,0,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,0,0,NULL,NULL,'DW 5/26 临近，需尽快出单',NULL,NULL,'演示数据：INBOUNDED，出单工作台-FBA BDL2',NULL,1,'2026-05-08 15:00:00',1,'2026-05-14 09:00:00',0),(9200016,'000000',4000001,9150016,'NO-NJP-009A','PO-NO-2026-2301','NO/NJP/A','CO202605080004','NO-2026-05-009','IMPORT',8001002,'Northstar Outdoor Inc.',5002001,'FBA头程',5001002,'Walmart US',NULL,NULL,1,'Mia',9100004,'CMAU9876543',4001002,'New Jersey East Coast Warehouse','PRIVATE',NULL,'Northstar NJ Distribution','205 Raritan Center Pkwy',NULL,'Edison','NJ','08837','US','David Park','+1-732-555-0310','inbound@northstar-nj.com',NULL,NULL,0,NULL,'BY_CARTON',180.00,0.00,2160.00,2394.000,10.000,180.00,7.00,2160.00,2394.000,10.000,NULL,'KG','CBM',0,NULL,NULL,'NONE',NULL,NULL,NULL,NULL,'NONE',NULL,NULL,'NORMAL','INBOUNDED','NONE','PENDING','UNBILLED','2026-05-30 00:00:00','2026-05-10 06:00:00','2026-05-10 08:45:00','2026-05-11 10:20:00','2026-05-11 17:55:00','2026-05-14 16:30:00','2026-05-14 10:15:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,'NORMAL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'NORMAL','NONE',NULL,0,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,0,0,NULL,NULL,'私仓，需预约送货时间',NULL,NULL,'演示数据：INBOUNDED，出单工作台-私仓NJ',NULL,1,'2026-05-08 15:30:00',1,'2026-05-14 10:15:00',0),(9200017,'000000',4000001,9150017,'EM-MDW2-008A','PO-EM-2026-9901','EM/MDW2/S8','CO202605080005','EM-2026-05-008','API',8001003,'East Market Supply Co.',5002002,'FBM快递',5001001,'Amazon US',NULL,NULL,1,'Tom',9100004,'CMAU9876543',4001002,'New Jersey East Coast Warehouse','PLATFORM_WH','MDW2','Amazon.com Services LLC','250 Emerald Dr',NULL,'Joliet','IL','60433','US','FBA Receiving','800-999-0000','fba-inbound@amazon.com',NULL,NULL,0,NULL,'BY_CARTON',320.00,0.00,3840.00,4224.000,17.900,320.00,12.00,3840.00,4224.000,17.900,NULL,'KG','CBM',0,NULL,NULL,'NONE',NULL,NULL,NULL,NULL,'NONE',NULL,NULL,'NORMAL','INBOUNDED','NONE','PENDING','UNBILLED','2026-05-29 00:00:00','2026-05-10 06:00:00','2026-05-10 08:45:00','2026-05-11 10:20:00','2026-05-11 17:55:00','2026-05-14 16:30:00','2026-05-14 14:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,'NORMAL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'NORMAL','NONE',NULL,0,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,0,0,0,NULL,'Amazon MDW2，标签已贴好',NULL,NULL,NULL,'演示数据：INBOUNDED，出单工作台-FBA MDW2',NULL,1,'2026-05-08 16:00:00',1,'2026-05-14 14:00:00',0),(2058428177838297090,'000000',100,10001,NULL,NULL,NULL,'CO-2026-000001-1','EXT-REF-001','MANUAL',200,'测试客户A',10,'FBA头程',NULL,NULL,NULL,NULL,NULL,NULL,9100001,'TGHU1234567',40,'洛杉矶仓(LAX)',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,'BY_CARTON',0.00,NULL,NULL,0.000,0.000,NULL,NULL,NULL,NULL,NULL,NULL,'KG','CBM',0,NULL,NULL,'NONE',NULL,NULL,NULL,NULL,'NONE',NULL,NULL,'NORMAL','IN_TRANSIT','NONE','PENDING','UNBILLED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,'NORMAL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1001,'CO-2026-000001',1001,'CO-2026-000001',1,'SPLIT_CHILD','SPLIT_ACTIVE','SPLIT2058428177850880000',0,NULL,NULL,'INTERNAL',0,NULL,'内部作业拆单','OPERATION',1,'admin','2026-05-24 14:01:36',0,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,103,1,'2026-05-24 14:01:36',1,'2026-05-24 14:06:28',1),(2058428178035429378,'000000',100,10001,NULL,NULL,NULL,'CO-2026-000001-2','EXT-REF-001','MANUAL',200,'测试客户A',10,'FBA头程',NULL,NULL,NULL,NULL,NULL,NULL,9100001,'TGHU1234567',40,'洛杉矶仓(LAX)',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,'BY_CARTON',0.00,NULL,NULL,0.000,0.000,NULL,NULL,NULL,NULL,NULL,NULL,'KG','CBM',0,NULL,NULL,'NONE',NULL,NULL,NULL,NULL,'NONE',NULL,NULL,'NORMAL','IN_TRANSIT','NONE','PENDING','UNBILLED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,'NORMAL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1001,'CO-2026-000001',1001,'CO-2026-000001',1,'SPLIT_CHILD','SPLIT_ACTIVE','SPLIT2058428177850880000',0,NULL,NULL,'INTERNAL',0,NULL,'内部作业拆单','OPERATION',1,'admin','2026-05-24 14:01:36',0,NULL,NULL,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,103,1,'2026-05-24 14:01:36',1,'2026-05-24 14:06:24',1);
/*!40000 ALTER TABLE `oms_cargo_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oms_cargo_order_hold_record`
--

DROP TABLE IF EXISTS `oms_cargo_order_hold_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oms_cargo_order_hold_record` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `cargo_order_id` bigint NOT NULL COMMENT '货物订单ID',
  `cargo_order_no` varchar(64) NOT NULL COMMENT '货物订单号',
  `biz_root_id` bigint DEFAULT NULL COMMENT '业务主线ID',
  `hold_type` varchar(64) NOT NULL COMMENT '暂扣类型',
  `hold_reason` varchar(500) NOT NULL COMMENT '暂扣原因',
  `hold_status` varchar(32) NOT NULL COMMENT 'HOLDING/RELEASED',
  `hold_time` datetime NOT NULL COMMENT '暂扣时间',
  `hold_user_id` bigint DEFAULT NULL COMMENT '暂扣人ID',
  `hold_user_name` varchar(128) DEFAULT NULL COMMENT '暂扣人名称',
  `release_reason` varchar(500) DEFAULT NULL COMMENT '放行原因',
  `release_time` datetime DEFAULT NULL COMMENT '放行时间',
  `release_user_id` bigint DEFAULT NULL COMMENT '放行人ID',
  `release_user_name` varchar(128) DEFAULT NULL COMMENT '放行人名称',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`),
  KEY `idx_biz_root_id` (`biz_root_id`),
  KEY `idx_hold_status` (`hold_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='货物订单HOLD记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oms_cargo_order_hold_record`
--

LOCK TABLES `oms_cargo_order_hold_record` WRITE;
/*!40000 ALTER TABLE `oms_cargo_order_hold_record` DISABLE KEYS */;
INSERT INTO `oms_cargo_order_hold_record` VALUES (2058430354409463809,'000000',1002,'CO-2026-000002',10002,'OPERATION_HOLD','运营暂扣','RELEASED','2026-05-24 14:10:15',1,'admin','运营放行','2026-05-24 14:25:42',1,'admin',NULL,103,1,'2026-05-24 14:10:15',1,'2026-05-24 14:25:42'),(2058434260363427841,'000000',1002,'CO-2026-000002',10002,'OPERATION_HOLD','运营暂扣','HOLDING','2026-05-24 14:25:46',1,'admin',NULL,NULL,NULL,NULL,NULL,103,1,'2026-05-24 14:25:46',1,'2026-05-24 14:25:46');
/*!40000 ALTER TABLE `oms_cargo_order_hold_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oms_cargo_order_node_trace`
--

DROP TABLE IF EXISTS `oms_cargo_order_node_trace`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oms_cargo_order_node_trace` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `cargo_order_id` bigint NOT NULL COMMENT '货物订单ID',
  `biz_root_id` bigint DEFAULT NULL COMMENT '业务主线ID',
  `node_code` varchar(64) NOT NULL COMMENT '节点编码（对应 fulfillment_status）',
  `node_name` varchar(128) DEFAULT NULL COMMENT '节点名称（中文）',
  `node_status` varchar(32) NOT NULL DEFAULT 'DONE' COMMENT '节点状态(DONE/PENDING/EXCEPTION)',
  `status_from` varchar(32) DEFAULT NULL COMMENT '变更前状态',
  `status_to` varchar(32) DEFAULT NULL COMMENT '变更后状态',
  `action` varchar(64) DEFAULT NULL COMMENT '触发动作',
  `actual_time` datetime DEFAULT NULL COMMENT '实际完成时间',
  `source_type` varchar(32) DEFAULT NULL COMMENT '来源(MANUAL/OMS/WMS/TMS/SYSTEM)',
  `source_order_no` varchar(128) DEFAULT NULL COMMENT '来源单号',
  `operator_id` bigint DEFAULT NULL COMMENT '操作人ID',
  `operator_name` varchar(64) DEFAULT NULL COMMENT '操作人名称',
  `remark` text COMMENT '备注',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`),
  KEY `idx_biz_root_id` (`biz_root_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='货物订单节点轨迹表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oms_cargo_order_node_trace`
--

LOCK TABLES `oms_cargo_order_node_trace` WRITE;
/*!40000 ALTER TABLE `oms_cargo_order_node_trace` DISABLE KEYS */;
INSERT INTO `oms_cargo_order_node_trace` VALUES (200011,'000000',1001,10001,'PENDING_ACCEPT','待受理','DONE',NULL,'PENDING_ACCEPT','create','2026-05-01 09:00:00','MANUAL',NULL,1,'系统管理员','订单创建','2026-05-01 09:00:00'),(200012,'000000',1001,10001,'ACCEPTED','已受理','DONE','PENDING_ACCEPT','ACCEPTED','accept','2026-05-02 10:00:00','MANUAL',NULL,1,'系统管理员','已受理确认','2026-05-02 10:00:00'),(200013,'000000',1001,10001,'IN_TRANSIT','在途','DONE','ACCEPTED','IN_TRANSIT','markInTransit','2026-05-05 11:00:00','MANUAL',NULL,1,'张客服','船已开航','2026-05-05 11:00:00'),(200031,'000000',1003,10003,'PENDING_ACCEPT','待受理','DONE',NULL,'PENDING_ACCEPT','create','2026-05-01 08:00:00','MANUAL',NULL,1,'系统管理员','订单创建','2026-05-01 08:00:00'),(200032,'000000',1003,10003,'ACCEPTED','已受理','DONE','PENDING_ACCEPT','ACCEPTED','accept','2026-05-01 10:00:00','MANUAL',NULL,1,'系统管理员',NULL,'2026-05-01 10:00:00'),(200033,'000000',1003,10003,'IN_TRANSIT','在途','DONE','ACCEPTED','IN_TRANSIT','markInTransit','2026-05-03 09:00:00','MANUAL',NULL,1,'李客服',NULL,'2026-05-03 09:00:00'),(200034,'000000',1003,10003,'ARRIVED_PORT','已到港','DONE','IN_TRANSIT','ARRIVED_PORT','confirmArrivedPort','2026-05-13 09:00:00','OMS',NULL,1,'李客服',NULL,'2026-05-13 09:00:00'),(200035,'000000',1003,10003,'INBOUNDED','已入库','DONE','DEVANNED','INBOUNDED','confirmInbounded','2026-05-16 10:00:00','WMS',NULL,1,'系统','入库完成，等待出单','2026-05-16 10:00:00'),(200041,'000000',1004,10004,'INBOUNDED','已入库','DONE','DEVANNED','INBOUNDED','confirmInbounded','2026-05-12 09:00:00','WMS',NULL,1,'系统',NULL,'2026-05-12 09:00:00'),(200042,'000000',1004,10004,'OUTBOUND_ORDERED','已出单','DONE','INBOUNDED','OUTBOUND_ORDERED','convertPreOutbound','2026-05-15 14:00:00','OMS',NULL,1,'张客服','转正式出单','2026-05-15 14:00:00'),(200043,'000000',1004,10004,'DELIVERY_APPOINTED','已预约','DONE','OUTBOUND_ORDERED','DELIVERY_APPOINTED','appointDelivery','2026-05-17 10:00:00','OMS',NULL,1,'张客服','预约5月18日派送','2026-05-17 10:00:00'),(200044,'000000',1004,10004,'OUTBOUNDED','已出库','DONE','DELIVERY_APPOINTED','OUTBOUNDED','confirmOutbounded','2026-05-18 14:00:00','WMS',NULL,1,'系统',NULL,'2026-05-18 14:00:00'),(200045,'000000',1004,10004,'DELIVERING','派送中','DONE','OUTBOUNDED','DELIVERING','markDelivering','2026-05-18 16:00:00','TMS',NULL,1,'系统','快递已揽收','2026-05-18 16:00:00'),(200051,'000000',1005,10005,'DELIVERED','已签收','DONE','DELIVERING','DELIVERED','confirmDelivered','2026-05-04 11:00:00','TMS',NULL,1,'系统','签收成功','2026-05-04 11:00:00'),(200052,'000000',1005,10005,'POD_UPLOADED','POD已回传','DONE','DELIVERED','POD_UPLOADED','uploadPod','2026-05-05 09:00:00','OMS',NULL,1,'李客服','POD已上传','2026-05-05 09:00:00'),(200053,'000000',1005,10005,'BILLED','已出账单','DONE','POD_UPLOADED','BILLED','confirmBilled','2026-05-06 15:00:00','BMS',NULL,1,'财务','账单已确认','2026-05-06 15:00:00'),(200054,'000000',1005,10005,'COMPLETED','已完成','DONE','BILLED','COMPLETED','complete','2026-05-07 10:00:00','OMS',NULL,1,'系统管理员',NULL,'2026-05-07 10:00:00'),(9230050,'000000',9200013,9150013,'PENDING_ACCEPT','待受理','DONE',NULL,'PENDING_ACCEPT','mockCreate','2026-05-08 14:00:00','MANUAL',NULL,1,'admin','创建','2026-05-08 14:00:00'),(9230051,'000000',9200013,9150013,'ACCEPTED','已受理','DONE','PENDING_ACCEPT','ACCEPTED','accept','2026-05-08 16:00:00','MANUAL',NULL,1,'Amy','审核通过','2026-05-08 16:00:00'),(9230052,'000000',9200013,9150013,'IN_TRANSIT','在途','DONE','ACCEPTED','IN_TRANSIT','markInTransit','2026-05-08 18:00:00','OMS',NULL,1,'Amy','开航','2026-05-08 18:00:00'),(9230053,'000000',9200013,9150013,'ARRIVED_PORT','已到港','DONE','IN_TRANSIT','ARRIVED_PORT','confirmArrivedPort','2026-05-10 08:45:00','OMS',NULL,1,'Amy','靠港NJ','2026-05-10 08:45:00'),(9230054,'000000',9200013,9150013,'PICKED_UP','已提柜','DONE','ARRIVED_PORT','PICKED_UP','confirmPickedUp','2026-05-11 10:20:00','OMS',NULL,1,'Amy','拖车提柜','2026-05-11 10:20:00'),(9230055,'000000',9200013,9150013,'ARRIVED_WAREHOUSE','已到仓','DONE','PICKED_UP','ARRIVED_WAREHOUSE','confirmArrivedWarehouse','2026-05-11 17:55:00','OMS',NULL,1,'Amy','到仓YARD-B-03','2026-05-11 17:55:00'),(9230056,'000000',9200013,9150013,'DEVANNING','拆柜中','DONE','ARRIVED_WAREHOUSE','DEVANNING','startDevanning','2026-05-12 09:15:00','OMS',NULL,1,'Amy','开始拆柜','2026-05-12 09:15:00'),(9230057,'000000',9200013,9150013,'DEVANNED','拆柜完成','DONE','DEVANNING','DEVANNED','finishDevanning','2026-05-14 16:30:00','OMS',NULL,1,'Amy','拆柜完成','2026-05-14 16:30:00'),(9230058,'000000',9200013,9150013,'INBOUNDED','已入库','DONE','DEVANNED','INBOUNDED','confirmInbounded','2026-05-13 10:00:00','WMS',NULL,1,'Amy','WMS入库确认，10板','2026-05-13 10:00:00'),(9230059,'000000',9200014,9150014,'PENDING_ACCEPT','待受理','DONE',NULL,'PENDING_ACCEPT','mockCreate','2026-05-08 14:00:00','MANUAL',NULL,1,'admin','创建','2026-05-08 14:00:00'),(9230060,'000000',9200014,9150014,'ACCEPTED','已受理','DONE','PENDING_ACCEPT','ACCEPTED','accept','2026-05-08 16:05:00','MANUAL',NULL,1,'Amy','审核通过','2026-05-08 16:05:00'),(9230061,'000000',9200014,9150014,'IN_TRANSIT','在途','DONE','ACCEPTED','IN_TRANSIT','markInTransit','2026-05-08 18:00:00','OMS',NULL,1,'Amy','开航','2026-05-08 18:00:00'),(9230062,'000000',9200014,9150014,'ARRIVED_PORT','已到港','DONE','IN_TRANSIT','ARRIVED_PORT','confirmArrivedPort','2026-05-10 08:45:00','OMS',NULL,1,'Amy','靠港NJ','2026-05-10 08:45:00'),(9230063,'000000',9200014,9150014,'PICKED_UP','已提柜','DONE','ARRIVED_PORT','PICKED_UP','confirmPickedUp','2026-05-11 10:20:00','OMS',NULL,1,'Amy','拖车提柜','2026-05-11 10:20:00'),(9230064,'000000',9200014,9150014,'ARRIVED_WAREHOUSE','已到仓','DONE','PICKED_UP','ARRIVED_WAREHOUSE','confirmArrivedWarehouse','2026-05-11 17:55:00','OMS',NULL,1,'Amy','到仓','2026-05-11 17:55:00'),(9230065,'000000',9200014,9150014,'DEVANNING','拆柜中','DONE','ARRIVED_WAREHOUSE','DEVANNING','startDevanning','2026-05-12 09:15:00','OMS',NULL,1,'Amy','开始拆柜','2026-05-12 09:15:00'),(9230066,'000000',9200014,9150014,'DEVANNED','拆柜完成','DONE','DEVANNING','DEVANNED','finishDevanning','2026-05-14 16:30:00','OMS',NULL,1,'Amy','实收312箱','2026-05-14 16:30:00'),(9230067,'000000',9200014,9150014,'INBOUNDED','已入库','DONE','DEVANNED','INBOUNDED','confirmInbounded','2026-05-13 11:30:00','WMS',NULL,1,'Amy','WMS入库确认，11板','2026-05-13 11:30:00'),(9230068,'000000',9200015,9150015,'PENDING_ACCEPT','待受理','DONE',NULL,'PENDING_ACCEPT','mockCreate','2026-05-08 15:00:00','MANUAL',NULL,1,'admin','创建','2026-05-08 15:00:00'),(9230069,'000000',9200015,9150015,'ACCEPTED','已受理','DONE','PENDING_ACCEPT','ACCEPTED','accept','2026-05-08 17:00:00','MANUAL',NULL,1,'Mia','审核通过','2026-05-08 17:00:00'),(9230070,'000000',9200015,9150015,'IN_TRANSIT','在途','DONE','ACCEPTED','IN_TRANSIT','markInTransit','2026-05-08 18:00:00','OMS',NULL,1,'Mia','开航','2026-05-08 18:00:00'),(9230071,'000000',9200015,9150015,'ARRIVED_PORT','已到港','DONE','IN_TRANSIT','ARRIVED_PORT','confirmArrivedPort','2026-05-10 08:45:00','OMS',NULL,1,'Mia','靠港NJ','2026-05-10 08:45:00'),(9230072,'000000',9200015,9150015,'PICKED_UP','已提柜','DONE','ARRIVED_PORT','PICKED_UP','confirmPickedUp','2026-05-11 10:20:00','OMS',NULL,1,'Mia','拖车提柜','2026-05-11 10:20:00'),(9230073,'000000',9200015,9150015,'ARRIVED_WAREHOUSE','已到仓','DONE','PICKED_UP','ARRIVED_WAREHOUSE','confirmArrivedWarehouse','2026-05-11 17:55:00','OMS',NULL,1,'Mia','到仓','2026-05-11 17:55:00'),(9230074,'000000',9200015,9150015,'DEVANNING','拆柜中','DONE','ARRIVED_WAREHOUSE','DEVANNING','startDevanning','2026-05-12 09:15:00','OMS',NULL,1,'Mia','开始拆柜','2026-05-12 09:15:00'),(9230075,'000000',9200015,9150015,'DEVANNED','拆柜完成','DONE','DEVANNING','DEVANNED','finishDevanning','2026-05-14 16:30:00','OMS',NULL,1,'Mia','拆柜完成','2026-05-14 16:30:00'),(9230076,'000000',9200015,9150015,'INBOUNDED','已入库','DONE','DEVANNED','INBOUNDED','confirmInbounded','2026-05-14 09:00:00','WMS',NULL,1,'Mia','WMS入库确认，9板','2026-05-14 09:00:00'),(9230077,'000000',9200016,9150016,'PENDING_ACCEPT','待受理','DONE',NULL,'PENDING_ACCEPT','mockCreate','2026-05-08 15:30:00','MANUAL',NULL,1,'admin','创建','2026-05-08 15:30:00'),(9230078,'000000',9200016,9150016,'ACCEPTED','已受理','DONE','PENDING_ACCEPT','ACCEPTED','accept','2026-05-08 17:30:00','MANUAL',NULL,1,'Mia','审核通过','2026-05-08 17:30:00'),(9230079,'000000',9200016,9150016,'IN_TRANSIT','在途','DONE','ACCEPTED','IN_TRANSIT','markInTransit','2026-05-08 18:00:00','OMS',NULL,1,'Mia','开航','2026-05-08 18:00:00'),(9230080,'000000',9200016,9150016,'ARRIVED_PORT','已到港','DONE','IN_TRANSIT','ARRIVED_PORT','confirmArrivedPort','2026-05-10 08:45:00','OMS',NULL,1,'Mia','靠港NJ','2026-05-10 08:45:00'),(9230081,'000000',9200016,9150016,'PICKED_UP','已提柜','DONE','ARRIVED_PORT','PICKED_UP','confirmPickedUp','2026-05-11 10:20:00','OMS',NULL,1,'Mia','拖车提柜','2026-05-11 10:20:00'),(9230082,'000000',9200016,9150016,'ARRIVED_WAREHOUSE','已到仓','DONE','PICKED_UP','ARRIVED_WAREHOUSE','confirmArrivedWarehouse','2026-05-11 17:55:00','OMS',NULL,1,'Mia','到仓','2026-05-11 17:55:00'),(9230083,'000000',9200016,9150016,'DEVANNING','拆柜中','DONE','ARRIVED_WAREHOUSE','DEVANNING','startDevanning','2026-05-12 09:15:00','OMS',NULL,1,'Mia','开始拆柜','2026-05-12 09:15:00'),(9230084,'000000',9200016,9150016,'DEVANNED','拆柜完成','DONE','DEVANNING','DEVANNED','finishDevanning','2026-05-14 16:30:00','OMS',NULL,1,'Mia','拆柜完成','2026-05-14 16:30:00'),(9230085,'000000',9200016,9150016,'INBOUNDED','已入库','DONE','DEVANNED','INBOUNDED','confirmInbounded','2026-05-14 10:15:00','WMS',NULL,1,'Mia','WMS入库确认，7板','2026-05-14 10:15:00'),(9230086,'000000',9200017,9150017,'PENDING_ACCEPT','待受理','DONE',NULL,'PENDING_ACCEPT','mockCreate','2026-05-08 16:00:00','MANUAL',NULL,1,'admin','创建','2026-05-08 16:00:00'),(9230087,'000000',9200017,9150017,'ACCEPTED','已受理','DONE','PENDING_ACCEPT','ACCEPTED','accept','2026-05-08 18:00:00','MANUAL',NULL,1,'Tom','审核通过','2026-05-08 18:00:00'),(9230088,'000000',9200017,9150017,'IN_TRANSIT','在途','DONE','ACCEPTED','IN_TRANSIT','markInTransit','2026-05-08 18:30:00','OMS',NULL,1,'Tom','开航','2026-05-08 18:30:00'),(9230089,'000000',9200017,9150017,'ARRIVED_PORT','已到港','DONE','IN_TRANSIT','ARRIVED_PORT','confirmArrivedPort','2026-05-10 08:45:00','OMS',NULL,1,'Tom','靠港NJ','2026-05-10 08:45:00'),(9230090,'000000',9200017,9150017,'PICKED_UP','已提柜','DONE','ARRIVED_PORT','PICKED_UP','confirmPickedUp','2026-05-11 10:20:00','OMS',NULL,1,'Tom','拖车提柜','2026-05-11 10:20:00'),(9230091,'000000',9200017,9150017,'ARRIVED_WAREHOUSE','已到仓','DONE','PICKED_UP','ARRIVED_WAREHOUSE','confirmArrivedWarehouse','2026-05-11 17:55:00','OMS',NULL,1,'Tom','到仓','2026-05-11 17:55:00'),(9230092,'000000',9200017,9150017,'DEVANNING','拆柜中','DONE','ARRIVED_WAREHOUSE','DEVANNING','startDevanning','2026-05-12 09:15:00','OMS',NULL,1,'Tom','开始拆柜','2026-05-12 09:15:00'),(9230093,'000000',9200017,9150017,'DEVANNED','拆柜完成','DONE','DEVANNING','DEVANNED','finishDevanning','2026-05-14 16:30:00','OMS',NULL,1,'Tom','拆柜完成','2026-05-14 16:30:00'),(9230094,'000000',9200017,9150017,'INBOUNDED','已入库','DONE','DEVANNED','INBOUNDED','confirmInbounded','2026-05-14 14:00:00','WMS',NULL,1,'Tom','WMS入库确认，12板','2026-05-14 14:00:00'),(2058428177901211650,'000000',2058428177838297090,NULL,'IN_TRANSIT',NULL,'DONE','IN_TRANSIT','IN_TRANSIT','CARGO_ORDER_INTERNAL_SPLIT','2026-05-24 14:01:36','OMS',NULL,1,'admin',NULL,'2026-05-24 14:01:36'),(2058428178035429379,'000000',2058428178035429378,NULL,'IN_TRANSIT',NULL,'DONE','IN_TRANSIT','IN_TRANSIT','CARGO_ORDER_INTERNAL_SPLIT','2026-05-24 14:01:36','OMS',NULL,1,'admin',NULL,'2026-05-24 14:01:36'),(2058428178232561666,'000000',1001,NULL,'IN_TRANSIT',NULL,'DONE','IN_TRANSIT','IN_TRANSIT','CARGO_ORDER_INTERNAL_SPLIT','2026-05-24 14:01:36','OMS',NULL,1,'admin',NULL,'2026-05-24 14:01:36'),(2058430354812116993,'000000',1002,NULL,'ARRIVED_WAREHOUSE',NULL,'DONE','ARRIVED_WAREHOUSE','ARRIVED_WAREHOUSE','CARGO_ORDER_HOLD','2026-05-24 14:10:15','OMS',NULL,1,'admin','运营暂扣','2026-05-24 14:10:15'),(2058434242944483329,'000000',1002,NULL,'ARRIVED_WAREHOUSE',NULL,'DONE','ARRIVED_WAREHOUSE','ARRIVED_WAREHOUSE','CARGO_ORDER_RELEASED','2026-05-24 14:25:42','OMS',NULL,1,'admin','运营放行','2026-05-24 14:25:42'),(2058434260363427842,'000000',1002,NULL,'ARRIVED_WAREHOUSE',NULL,'DONE','ARRIVED_WAREHOUSE','ARRIVED_WAREHOUSE','CARGO_ORDER_HOLD','2026-05-24 14:25:46','OMS',NULL,1,'admin','运营暂扣','2026-05-24 14:25:46'),(2059566143172354049,'000000',1004,10004,'OUTBOUND_ORDERED','已出单','DONE','INBOUNDED','OUTBOUND_ORDERED','convertPreOutbound','2026-05-27 17:23:28','OMS',NULL,1,'admin','预出单转正式出库单','2026-05-27 17:23:28'),(2059707780334723073,'000000',1004,10004,'INBOUNDED','已入库','DONE','OUTBOUND_ORDERED','INBOUNDED','deleteOutboundOrder','2026-05-28 02:46:17','OMS',NULL,1,'admin','删除出库单回退至已入库','2026-05-28 02:46:17'),(2059707990586793985,'000000',9200014,9150014,'OUTBOUND_ORDERED','已出单','DONE','INBOUNDED','OUTBOUND_ORDERED','createOutboundOrder','2026-05-28 02:47:07','OMS',NULL,1,'admin','创建出库单','2026-05-28 02:47:07'),(2059707991039778817,'000000',1004,10004,'OUTBOUND_ORDERED','已出单','DONE','INBOUNDED','OUTBOUND_ORDERED','createOutboundOrder','2026-05-28 02:47:07','OMS',NULL,1,'admin','创建出库单','2026-05-28 02:47:07'),(2059708017459699713,'000000',1004,10004,'INBOUNDED','已入库','DONE','OUTBOUND_ORDERED','INBOUNDED','deleteOutboundOrder','2026-05-28 02:47:14','OMS',NULL,1,'admin','删除出库单回退至已入库','2026-05-28 02:47:14'),(2059708017908490241,'000000',9200014,9150014,'INBOUNDED','已入库','DONE','OUTBOUND_ORDERED','INBOUNDED','deleteOutboundOrder','2026-05-28 02:47:14','OMS',NULL,1,'admin','删除出库单回退至已入库','2026-05-28 02:47:14');
/*!40000 ALTER TABLE `oms_cargo_order_node_trace` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oms_cargo_order_shipment`
--

DROP TABLE IF EXISTS `oms_cargo_order_shipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oms_cargo_order_shipment` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `cargo_order_id` bigint NOT NULL COMMENT '货物订单ID',
  `biz_root_id` bigint DEFAULT NULL COMMENT '业务主线ID',
  `shipment_no` varchar(128) NOT NULL COMMENT '货件编码',
  `po_no` varchar(128) DEFAULT NULL COMMENT 'PO号',
  `shipping_mark` varchar(128) DEFAULT NULL COMMENT '唛头',
  `carton_qty` decimal(10,2) DEFAULT NULL COMMENT '货件箱数',
  `pallet_qty` decimal(12,0) DEFAULT NULL COMMENT '预报板数',
  `weight` decimal(12,3) DEFAULT NULL COMMENT '货件重量(kg)',
  `cbm` decimal(12,3) DEFAULT NULL COMMENT '货件体积(m³)',
  `group_code` varchar(100) DEFAULT NULL COMMENT '入库分组（由入库计划写入）',
  `dw_time` datetime DEFAULT NULL COMMENT 'DW时间（预计到仓，货件编码维度）',
  `remark` text COMMENT '备注',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  PRIMARY KEY (`id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`),
  KEY `idx_biz_root_id` (`biz_root_id`),
  KEY `idx_dw_time` (`dw_time`),
  KEY `idx_group_code` (`group_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='货物订单货件层（DW时间存此层）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oms_cargo_order_shipment`
--

LOCK TABLES `oms_cargo_order_shipment` WRITE;
/*!40000 ALTER TABLE `oms_cargo_order_shipment` DISABLE KEYS */;
INSERT INTO `oms_cargo_order_shipment` VALUES (10011,'000000',1001,10001,'SC-001','PO-20260501-001','MARK-A',60.00,NULL,430.000,3.400,'Amazon-ONT8','2026-06-01 00:00:00',NULL,1,'2026-05-23 02:06:16',1,'2026-05-28 17:10:05',0,103),(10012,'000000',1001,10001,'SC-002','PO-20260501-002','MARK-A',60.00,NULL,430.500,3.400,'Amazon-ONT8','2026-06-01 00:00:00',NULL,1,'2026-05-23 02:06:16',1,'2026-05-28 17:10:05',0,103),(10021,'000000',1002,10002,'SC-003','PO-20260502-001','MARK-B',80.00,NULL,560.000,4.200,'PRIVATE-CO-2026-000002','2026-05-20 00:00:00',NULL,1,'2026-05-23 02:06:16',1,'2026-05-28 17:10:05',0,103),(10031,'000000',1003,10003,'SC-004','PO-20260503-001','MARK-C1',70.00,NULL,500.000,3.900,NULL,'2026-05-15 00:00:00',NULL,1,'2026-05-23 02:06:16',1,'2026-05-23 02:06:16',0,103),(10032,'000000',1003,10003,'SC-005','PO-20260503-002','MARK-C2',80.00,NULL,580.000,4.600,NULL,'2026-05-15 00:00:00',NULL,1,'2026-05-23 02:06:16',1,'2026-05-23 02:06:16',0,103),(10033,'000000',1003,10003,'SC-006','PO-20260503-003','MARK-C2',50.00,NULL,370.000,3.000,NULL,'2026-05-15 00:00:00',NULL,1,'2026-05-23 02:06:16',1,'2026-05-23 02:06:16',0,103),(10041,'000000',1004,10004,'SC-007','PO-20260504-001','MARK-D',50.00,NULL,380.000,2.900,NULL,'2026-05-10 00:00:00',NULL,1,'2026-05-23 02:06:16',1,'2026-05-23 02:06:16',0,103),(10051,'000000',1005,10005,'SC-008','PO-20260420-001','MARK-E',15.00,NULL,105.000,0.800,NULL,'2026-04-25 00:00:00',NULL,1,'2026-05-23 02:06:16',1,'2026-05-23 02:06:16',0,103),(10052,'000000',1005,10005,'SC-009','PO-20260420-001','MARK-E',15.00,NULL,105.000,0.800,NULL,'2026-04-25 00:00:00',NULL,1,'2026-05-23 02:06:16',1,'2026-05-23 02:06:16',0,103),(9210017,'000000',9200013,9150013,'PH-EWR4-008A','PO-PHG-2026-4401','PHG/EWR4/S8',280.00,NULL,3668.000,15.400,NULL,'2026-05-20 00:00:00','DW已过期，紧急',1,'2026-05-08 14:00:00',1,'2026-05-13 10:00:00',0,NULL),(9210018,'000000',9200014,9150014,'PH-EWR9-009A','PO-PHG-2026-4402','PHG/EWR9/S9',310.00,NULL,4061.000,17.200,NULL,'2026-05-28 00:00:00','EWR9，实收多2箱',1,'2026-05-08 14:00:00',1,'2026-05-13 11:30:00',0,NULL),(9210019,'000000',9200015,9150015,'NO-BDL2-008A','PO-NO-2026-2201','NO/BDL2/A',260.00,NULL,3458.000,14.600,NULL,'2026-05-26 00:00:00','BDL2 FBA',1,'2026-05-08 15:00:00',1,'2026-05-14 09:00:00',0,NULL),(9210020,'000000',9200016,9150016,'NO-NJP-009A','PO-NO-2026-2301','NO/NJP/A',180.00,NULL,2394.000,10.000,NULL,'2026-05-30 00:00:00','私仓Edison，需预约',1,'2026-05-08 15:30:00',1,'2026-05-14 10:15:00',0,NULL),(9210021,'000000',9200017,9150017,'EM-MDW2-008A','PO-EM-2026-9901','EM/MDW2/S8',320.00,NULL,4224.000,17.900,NULL,'2026-05-29 00:00:00','MDW2 FBA，标签已贴',1,'2026-05-08 16:00:00',1,'2026-05-14 14:00:00',0,NULL);
/*!40000 ALTER TABLE `oms_cargo_order_shipment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oms_cargo_order_sku_item`
--

DROP TABLE IF EXISTS `oms_cargo_order_sku_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oms_cargo_order_sku_item` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `cargo_order_id` bigint NOT NULL COMMENT '货物订单ID（冗余）',
  `shipment_id` bigint NOT NULL COMMENT '货件ID',
  `shipment_no` varchar(128) DEFAULT NULL COMMENT '货件编码（冗余）',
  `po_no` varchar(128) DEFAULT NULL COMMENT 'PO号（冗余）',
  `shipping_mark` varchar(128) DEFAULT NULL COMMENT '唛头（冗余）',
  `sku` varchar(128) DEFAULT NULL COMMENT 'SKU编码',
  `fnsku` varchar(128) DEFAULT NULL COMMENT 'FNSKU（Amazon）',
  `product_name` varchar(255) DEFAULT NULL COMMENT '商品名称',
  `qty` decimal(12,2) DEFAULT NULL COMMENT '商品数量',
  `carton_qty` decimal(10,2) DEFAULT NULL COMMENT 'SKU维度箱数（可选）',
  `weight` decimal(12,3) DEFAULT NULL COMMENT 'SKU维度重量（可选）',
  `cbm` decimal(12,3) DEFAULT NULL COMMENT 'SKU维度体积（可选）',
  `remark` text COMMENT '备注',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  PRIMARY KEY (`id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`),
  KEY `idx_shipment_id` (`shipment_id`),
  KEY `idx_sku` (`sku`),
  KEY `idx_fnsku` (`fnsku`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='货物订单SKU明细层';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oms_cargo_order_sku_item`
--

LOCK TABLES `oms_cargo_order_sku_item` WRITE;
/*!40000 ALTER TABLE `oms_cargo_order_sku_item` DISABLE KEYS */;
INSERT INTO `oms_cargo_order_sku_item` VALUES (100111,'000000',1001,10011,'SC-001','PO-20260501-001','MARK-A','SKU-A001','X001FNSKU1','Wireless Earbuds Pro',600.00,60.00,NULL,NULL,NULL,1,'2026-05-23 02:06:16',1,'2026-05-28 12:35:37',0,103),(100121,'000000',1001,10012,'SC-002','PO-20260501-002','MARK-A','SKU-A002','X001FNSKU2','Phone Case Pack',1200.00,60.00,NULL,NULL,NULL,1,'2026-05-23 02:06:16',1,'2026-05-28 12:35:37',0,103),(100211,'000000',1002,10021,'SC-003','PO-20260502-001','MARK-B','SKU-B001',NULL,'Storage Shelf Unit',80.00,80.00,NULL,NULL,NULL,1,'2026-05-23 02:06:16',1,'2026-05-28 12:26:15',0,103),(100311,'000000',1003,10031,'SC-004','PO-20260503-001','MARK-C1','SKU-C001','Y002FNSKU1','LED Ring Light',420.00,70.00,NULL,NULL,NULL,1,'2026-05-23 02:06:16',1,'2026-05-23 02:06:16',0,103),(100321,'000000',1003,10032,'SC-005','PO-20260503-002','MARK-C2','SKU-C002','Y002FNSKU2','Tripod Stand',400.00,80.00,NULL,NULL,NULL,1,'2026-05-23 02:06:16',1,'2026-05-23 02:06:16',0,103),(100331,'000000',1003,10033,'SC-006','PO-20260503-003','MARK-C2','SKU-C002','Y002FNSKU2','Tripod Stand',250.00,50.00,NULL,NULL,NULL,1,'2026-05-23 02:06:16',1,'2026-05-23 02:06:16',0,103),(100411,'000000',1004,10041,'SC-007','PO-20260504-001','MARK-D','SKU-D001','Z003FNSKU1','Smart Watch Band',1000.00,50.00,NULL,NULL,NULL,1,'2026-05-23 02:06:16',1,'2026-05-23 02:06:16',0,103),(100511,'000000',1005,10051,'SC-008','PO-20260420-001','MARK-E','SKU-E001',NULL,'Yoga Mat Premium',60.00,15.00,NULL,NULL,NULL,1,'2026-05-23 02:06:16',1,'2026-05-23 02:06:16',0,103),(100521,'000000',1005,10052,'SC-009','PO-20260420-001','MARK-E','SKU-E001',NULL,'Yoga Mat Premium',60.00,15.00,NULL,NULL,NULL,1,'2026-05-23 02:06:16',1,'2026-05-23 02:06:16',0,103),(9220022,'000000',9200013,9210017,'PH-EWR4-008A','PO-PHG-2026-4401','PHG/EWR4/S8','PHG-LAMP-007','X014LAMP01','Smart RGB Floor Lamp',1680.00,140.00,1868.000,7.700,NULL,1,'2026-05-08 14:00:00',1,'2026-05-08 14:00:00',0,NULL),(9220023,'000000',9200013,9210017,'PH-EWR4-008A','PO-PHG-2026-4401','PHG/EWR4/S8','PHG-CORD-008','X015CORD01','USB-C Cable 3-pack',2800.00,140.00,1812.000,7.700,NULL,1,'2026-05-08 14:00:00',1,'2026-05-08 14:00:00',0,NULL),(9220024,'000000',9200014,9210018,'PH-EWR9-009A','PO-PHG-2026-4402','PHG/EWR9/S9','PHG-DESK-009','X016DESK01','Foldable Standing Desk',1550.00,155.00,2031.000,8.600,NULL,1,'2026-05-08 14:00:00',1,'2026-05-08 14:00:00',0,NULL),(9220025,'000000',9200014,9210018,'PH-EWR9-009A','PO-PHG-2026-4402','PHG/EWR9/S9','PHG-MONT-010','X017MONT01','Monitor Arm Dual VESA',1550.00,155.00,2031.000,8.600,NULL,1,'2026-05-08 14:00:00',1,'2026-05-08 14:00:00',0,NULL),(9220026,'000000',9200015,9210019,'NO-BDL2-008A','PO-NO-2026-2201','NO/BDL2/A','NO-BOOT-005','X018BOOT01','Waterproof Hiking Boots L',1300.00,130.00,1729.000,7.300,NULL,1,'2026-05-08 15:00:00',1,'2026-05-08 15:00:00',0,NULL),(9220027,'000000',9200015,9210019,'NO-BDL2-008A','PO-NO-2026-2201','NO/BDL2/A','NO-HELM-006','X019HELM01','Bike Helmet Adjustable',1300.00,130.00,1729.000,7.300,NULL,1,'2026-05-08 15:00:00',1,'2026-05-08 15:00:00',0,NULL),(9220028,'000000',9200016,9210020,'NO-NJP-009A','PO-NO-2026-2301','NO/NJP/A','NO-KAYAK-007','X020KAYA01','Inflatable Kayak Single',900.00,90.00,1197.000,5.000,NULL,1,'2026-05-08 15:30:00',1,'2026-05-08 15:30:00',0,NULL),(9220029,'000000',9200016,9210020,'NO-NJP-009A','PO-NO-2026-2301','NO/NJP/A','NO-PUMP-008','X021PUMP01','Electric Air Pump Portable',900.00,90.00,1197.000,5.000,NULL,1,'2026-05-08 15:30:00',1,'2026-05-08 15:30:00',0,NULL),(9220030,'000000',9200017,9210021,'EM-MDW2-008A','PO-EM-2026-9901','EM/MDW2/S8','EM-CUBE-009','X022CUBE01','Speed Cube 3x3 Competition',3200.00,160.00,2112.000,8.950,NULL,1,'2026-05-08 16:00:00',1,'2026-05-08 16:00:00',0,NULL),(9220031,'000000',9200017,9210021,'EM-MDW2-008A','PO-EM-2026-9901','EM/MDW2/S8','EM-CLAY-010','X023CLAY01','Modeling Clay Set 36 Colors',3200.00,160.00,2112.000,8.950,NULL,1,'2026-05-08 16:00:00',1,'2026-05-08 16:00:00',0,NULL);
/*!40000 ALTER TABLE `oms_cargo_order_sku_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oms_container_cargo_order_rel`
--

DROP TABLE IF EXISTS `oms_container_cargo_order_rel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oms_container_cargo_order_rel` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `container_order_id` bigint NOT NULL COMMENT '海柜订单ID',
  `container_order_no` varchar(64) NOT NULL COMMENT '海柜订单号',
  `container_no` varchar(32) NOT NULL COMMENT '柜号',
  `cargo_order_id` bigint NOT NULL COMMENT '货物订单ID',
  `cargo_order_no` varchar(64) NOT NULL COMMENT '货物订单号',
  `relation_type` varchar(30) NOT NULL COMMENT '关系类型',
  `relation_status` varchar(30) NOT NULL DEFAULT 'ACTIVE' COMMENT '关系状态',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_container_cargo` (`container_order_id`,`cargo_order_id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='OMS海柜货物订单关系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oms_container_cargo_order_rel`
--

LOCK TABLES `oms_container_cargo_order_rel` WRITE;
/*!40000 ALTER TABLE `oms_container_cargo_order_rel` DISABLE KEYS */;
INSERT INTO `oms_container_cargo_order_rel` VALUES (9240001,'000000',9100001,'SO202605220001','TGHU1234567',9200001,'CO202605150001','SPLIT','ACTIVE',NULL,1,'2026-05-15 09:00:00',1,'2026-05-15 09:00:00'),(9240002,'000000',9100001,'SO202605220001','TGHU1234567',9200002,'CO202605150002','SPLIT','ACTIVE',NULL,1,'2026-05-15 09:30:00',1,'2026-05-15 09:30:00'),(9240003,'000000',9100002,'SO202605220002','MSCU7654321',9200003,'CO202605100001','SPLIT','ACTIVE',NULL,1,'2026-05-10 10:00:00',1,'2026-05-10 10:00:00'),(9240004,'000000',9100002,'SO202605220002','MSCU7654321',9200004,'CO202605100002','SPLIT','ACTIVE',NULL,1,'2026-05-10 10:30:00',1,'2026-05-10 10:30:00'),(9240005,'000000',9100003,'SO202605220003','OOLU4567890',9200005,'CO202605050001','SPLIT','ACTIVE',NULL,1,'2026-05-05 11:00:00',1,'2026-05-05 11:00:00'),(9240006,'000000',9100003,'SO202605220003','OOLU4567890',9200006,'CO202605050002','SPLIT','ACTIVE',NULL,1,'2026-05-05 11:30:00',1,'2026-05-05 11:30:00'),(9240007,'000000',9100003,'SO202605220003','OOLU4567890',9200007,'CO202605050003','SPLIT','ACTIVE',NULL,1,'2026-05-05 12:00:00',1,'2026-05-05 12:00:00'),(9240013,'000000',9100004,'SO202605100004','CMAU9876543',9200013,'CO202605080001','SPLIT','ACTIVE',NULL,1,'2026-05-08 14:00:00',1,'2026-05-08 14:00:00'),(9240014,'000000',9100004,'SO202605100004','CMAU9876543',9200014,'CO202605080002','SPLIT','ACTIVE',NULL,1,'2026-05-08 14:00:00',1,'2026-05-08 14:00:00'),(9240015,'000000',9100004,'SO202605100004','CMAU9876543',9200015,'CO202605080003','SPLIT','ACTIVE',NULL,1,'2026-05-08 15:00:00',1,'2026-05-08 15:00:00'),(9240016,'000000',9100004,'SO202605100004','CMAU9876543',9200016,'CO202605080004','SPLIT','ACTIVE',NULL,1,'2026-05-08 15:30:00',1,'2026-05-08 15:30:00'),(9240017,'000000',9100004,'SO202605100004','CMAU9876543',9200017,'CO202605080005','SPLIT','ACTIVE',NULL,1,'2026-05-08 16:00:00',1,'2026-05-08 16:00:00');
/*!40000 ALTER TABLE `oms_container_cargo_order_rel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oms_container_order`
--

DROP TABLE IF EXISTS `oms_container_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oms_container_order` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `company_id` bigint NOT NULL COMMENT '主体ID',
  `customer_id` bigint NOT NULL COMMENT '客户ID',
  `customer_name` varchar(128) NOT NULL COMMENT '客户名称',
  `channel_id` bigint DEFAULT NULL COMMENT '渠道ID',
  `business_type_id` bigint DEFAULT NULL COMMENT '业务类型ID',
  `owner_user_id` bigint DEFAULT NULL COMMENT '负责人ID',
  `owner_user_name` varchar(64) DEFAULT NULL COMMENT '负责人名称',
  `customer_service_id` bigint DEFAULT NULL COMMENT '客服ID',
  `customer_service_name` varchar(64) DEFAULT NULL COMMENT '客服名称',
  `warehouse_id` bigint NOT NULL COMMENT '入库仓库ID',
  `inbound_warehouse_name` varchar(128) DEFAULT NULL COMMENT '??????',
  `container_order_no` varchar(64) NOT NULL COMMENT '海柜订单号',
  `order_source` varchar(32) NOT NULL DEFAULT 'MANUAL' COMMENT '????',
  `container_no` varchar(32) NOT NULL COMMENT '柜号',
  `container_type` varchar(30) NOT NULL COMMENT '柜型',
  `seal_no` varchar(64) DEFAULT NULL COMMENT '封条号',
  `shipping_line_id` bigint DEFAULT NULL COMMENT '船公司ID',
  `shipping_line_name` varchar(128) DEFAULT NULL COMMENT '船公司名称',
  `vessel_name` varchar(128) DEFAULT NULL COMMENT '船名',
  `voyage_no` varchar(64) DEFAULT NULL COMMENT '航次',
  `route_code` varchar(64) DEFAULT NULL COMMENT '????',
  `mbl_no` varchar(64) DEFAULT NULL COMMENT 'MBL',
  `hbl_no` varchar(64) DEFAULT NULL COMMENT 'HBL',
  `discharge_port_id` bigint DEFAULT NULL COMMENT '卸货港ID',
  `discharge_port_name` varchar(128) DEFAULT NULL COMMENT '卸货港名称',
  `terminal_id` bigint DEFAULT NULL COMMENT '码头ID',
  `terminal_name` varchar(128) DEFAULT NULL COMMENT '码头名称',
  `eta` datetime DEFAULT NULL COMMENT '预计到港',
  `ata` datetime DEFAULT NULL COMMENT '实际到港',
  `pickup_lfd` date DEFAULT NULL COMMENT '??LFD????',
  `empty_return_lfd` date DEFAULT NULL COMMENT '??LFD????',
  `available_time` datetime DEFAULT NULL COMMENT '可提时间（海柜Available）',
  `terminal_release_status` varchar(30) NOT NULL DEFAULT 'UNKNOWN' COMMENT '码头释放状态',
  `hold_flag` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否Hold',
  `hold_types` varchar(255) DEFAULT NULL COMMENT 'Hold类型，逗号分隔',
  `hold_remark` varchar(500) DEFAULT NULL COMMENT 'Hold??',
  `exam_flag` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否查验',
  `exam_types` varchar(255) DEFAULT NULL COMMENT '查验类型，逗号分隔',
  `exam_type` varchar(64) DEFAULT NULL COMMENT '????',
  `exam_remark` varchar(500) DEFAULT NULL COMMENT '????',
  `drayage_vendor_id` bigint DEFAULT NULL COMMENT '提柜供应商ID',
  `drayage_vendor_name` varchar(128) DEFAULT NULL COMMENT '提柜供应商名称',
  `pickup_appointment_no` varchar(64) DEFAULT NULL COMMENT '提柜预约号',
  `pickup_appointment_time` datetime DEFAULT NULL COMMENT '提柜预约时间',
  `actual_pickup_time` datetime DEFAULT NULL COMMENT '实际提柜时间',
  `pickup_remark` text COMMENT '????',
  `expected_arrival_time` datetime DEFAULT NULL COMMENT '预计到仓时间',
  `required_arrival_time` datetime DEFAULT NULL COMMENT '要求到仓时间',
  `actual_arrival_time` datetime DEFAULT NULL COMMENT '实际到仓时间',
  `container_location` varchar(128) DEFAULT NULL COMMENT '海柜Location',
  `arrival_remark` text COMMENT '????',
  `devanning_no` varchar(64) DEFAULT NULL COMMENT '????',
  `devanning_order_no` varchar(64) DEFAULT NULL COMMENT '拆柜单号',
  `devanning_warehouse_id` bigint DEFAULT NULL COMMENT '拆柜仓库ID',
  `expected_devanning_time` datetime DEFAULT NULL COMMENT '??????',
  `devanning_appointment_time` datetime DEFAULT NULL COMMENT '拆柜预约时间',
  `devanning_method` varchar(30) DEFAULT NULL COMMENT '拆柜方式',
  `loading_type` varchar(32) DEFAULT NULL COMMENT '????',
  `sorting_method` varchar(32) DEFAULT NULL COMMENT '????',
  `devanning_start_time` datetime DEFAULT NULL COMMENT '开始拆柜时间',
  `devanning_finish_time` datetime DEFAULT NULL COMMENT '拆柜完成时间',
  `devanning_remark` text COMMENT '????',
  `empty_return_location` varchar(128) DEFAULT NULL COMMENT '还柜地点',
  `empty_return_appointment_no` varchar(64) DEFAULT NULL COMMENT '还柜预约号',
  `empty_return_time` datetime DEFAULT NULL COMMENT '实际还柜时间',
  `empty_return_status` varchar(30) DEFAULT NULL COMMENT '还柜状态',
  `empty_return_remark` text COMMENT '????',
  `pre_plan_truck_qty` decimal(12,0) DEFAULT '0' COMMENT '????????????',
  `pre_plan_pallet_qty` decimal(12,0) DEFAULT '0' COMMENT '预排板数',
  `pre_plan_cbm` decimal(12,3) DEFAULT '0.000' COMMENT '预排体积',
  `total_carton_qty` decimal(12,0) DEFAULT '0' COMMENT '总箱数',
  `total_pallet_qty` decimal(12,0) DEFAULT '0' COMMENT '总板数',
  `total_weight` decimal(12,3) DEFAULT '0.000' COMMENT '总重量kg',
  `total_cbm` decimal(12,3) DEFAULT '0.000' COMMENT '总体积CBM',
  `container_exception_flag` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否海柜异常',
  `container_exception_type` varchar(128) DEFAULT NULL COMMENT '海柜异常类型',
  `container_exception_count` int NOT NULL DEFAULT '0' COMMENT '海柜异常数',
  `downstream_exception_flag` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否下游异常',
  `downstream_exception_count` int NOT NULL DEFAULT '0' COMMENT '下游异常数',
  `attachment_count` int NOT NULL DEFAULT '0' COMMENT '海柜附件总数',
  `do_attachment_count` int NOT NULL DEFAULT '0' COMMENT 'DO附件数量',
  `latest_attachment_time` datetime DEFAULT NULL COMMENT '最近附件上传时间',
  `latest_do_upload_time` datetime DEFAULT NULL COMMENT '最近DO上传时间',
  `container_status` varchar(30) NOT NULL DEFAULT 'PENDING_ACCEPT' COMMENT '海柜状态',
  `internal_remark` text COMMENT '内部备注',
  `status` varchar(10) NOT NULL DEFAULT '0' COMMENT '启停状态',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_container_order_no_tenant` (`container_order_no`,`tenant_id`),
  KEY `idx_tenant_status` (`tenant_id`,`container_status`),
  KEY `idx_company_warehouse` (`company_id`,`warehouse_id`),
  KEY `idx_container_no` (`container_no`),
  KEY `idx_eta` (`eta`),
  KEY `idx_pickup_lfd` (`pickup_lfd`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='OMS海柜订单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oms_container_order`
--

LOCK TABLES `oms_container_order` WRITE;
/*!40000 ALTER TABLE `oms_container_order` DISABLE KEYS */;
INSERT INTO `oms_container_order` VALUES (9100001,'000000',4000001,8001001,'Pacific Home Goods LLC',5001001,5002001,1,'Lily Chen',1,'Amy',4001001,'Los Angeles Central Warehouse','SO202605220001','MANUAL','TGHU1234567','40HQ','SEAL88901',230201,'MAERSK','MAERSK ATLANTA','430E','TP1','MAEU123456789','HBL-LAX-001',230101,'USLAX',230501,'Fenix Marine Services','2026-05-23 09:30:00',NULL,'2026-05-28','2026-06-03',NULL,'UNKNOWN',0,NULL,NULL,0,NULL,NULL,NULL,7001001,'LAX Drayage Express',NULL,NULL,NULL,NULL,'2026-05-24 16:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-25 09:00:00',NULL,'MANUAL','FLOOR','BY_ORDER',NULL,NULL,NULL,'FMS Empty Return Yard',NULL,NULL,NULL,NULL,1,1,6.800,980,18,12880.500,56.320,0,NULL,0,0,0,0,0,NULL,NULL,'IN_TRANSIT','模拟在途柜，等待到港','0','演示数据：LAX在途海柜',NULL,1,'2026-05-22 10:18:35',1,'2026-05-29 06:39:47',0),(9100002,'000000',4000001,8001002,'Northstar Outdoor Inc.',5001002,5002001,1,'Kevin Zhang',1,'Mia',4001001,'Los Angeles Central Warehouse','SO202605220002','IMPORT','MSCU7654321','40GP','SEAL77102',230202,'MSC','MSC ANTONIA','218W','AWE5','MSCU987654321','HBL-LAX-002',230101,'USLAX',230502,'Yusen Terminal','2026-05-20 08:00:00','2026-05-20 11:20:00','2026-05-24','2026-05-30',NULL,'HOLDING',1,'Customs','Customs hold pending release notice',1,NULL,'X-Ray','等待码头查验结果',7001002,'West Coast Trucking','PU-LAX-20260522-01','2026-05-23 10:30:00',NULL,'Hold解除后预约提柜','2026-05-23 18:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-24 13:00:00',NULL,'MIXED','MIXED','BY_WAREHOUSE_CODE',NULL,NULL,NULL,'YTI Empty Return',NULL,NULL,NULL,NULL,1,1,11.480,1160,22,15420.000,62.100,1,'CUSTOMS_HOLD',1,0,0,0,0,NULL,NULL,'HOLDING','模拟Hold与查验柜','0','演示数据：码头Hold',NULL,1,'2026-05-22 10:18:35',1,'2026-05-27 14:09:52',0),(9100003,'000000',4000001,8001003,'East Market Supply Co.',5001001,5002002,1,'Nina Wang',1,'Tom',4001002,'New Jersey East Coast Warehouse','SO202605220003','API','OOLU4567890','45HQ','SEAL66333',230203,'OOCL','OOCL BERLIN','096E','EC2','OOLU112233445','HBL-NJ-003',230102,'USNYC',230503,'APM Terminals Elizabeth','2026-05-18 07:00:00','2026-05-18 09:10:00','2026-05-22','2026-05-29',NULL,'RELEASED',0,NULL,NULL,0,NULL,NULL,NULL,7001003,'NJ Port Drayage','PU-NJ-20260520-02','2026-05-20 14:00:00','2026-05-20 15:30:00','已提柜，预约到仓','2026-05-21 09:00:00',NULL,'2026-05-21 09:35:00','YARD-A-08','已到仓等待拆柜','DEV202605220003',NULL,NULL,'2026-05-22 10:00:00',NULL,'MANUAL','PALLET','BY_ORDER','2026-05-22 10:15:00',NULL,'拆柜进行中','Maher Empty Return Depot',NULL,NULL,NULL,NULL,0,0,0.000,1420,30,18850.250,74.800,0,NULL,0,1,2,0,0,NULL,NULL,'DEVANNING','模拟已到仓拆柜中','0','演示数据：NJ拆柜中',NULL,1,'2026-05-22 10:18:35',1,'2026-05-28 02:47:07',0),(9100004,'000000',4000001,8001001,'Pacific Home Goods LLC',5001001,5002001,1,'Lily Chen',1,'Amy',4001002,'New Jersey East Coast Warehouse','SO202605100004','MANUAL','CMAU9876543','40HQ','SEAL55288',230201,'MAERSK','MAERSK VENICE','318E','EC1','MAEU556677889','HBL-NJ-004',230102,'USNYC',230503,'APM Terminals Elizabeth','2026-05-10 06:00:00','2026-05-10 08:45:00','2026-05-15','2026-05-22',NULL,'RELEASED',0,NULL,NULL,0,NULL,NULL,NULL,7001003,'NJ Port Drayage','PU-NJ-20260511-01','2026-05-11 09:00:00','2026-05-11 10:20:00','顺利提柜','2026-05-11 18:00:00',NULL,'2026-05-11 17:55:00','YARD-B-03','已到仓，停放YARD-B-03','DEV202605120004',NULL,NULL,'2026-05-12 09:00:00',NULL,'MANUAL','FLOOR','BY_ORDER','2026-05-12 09:15:00','2026-05-14 16:30:00','拆柜完成，5票全部清点入库','Maher Empty Return Depot',NULL,'2026-05-16 10:00:00',NULL,'空柜已还',0,0,0.000,1350,42,17685.000,98.600,0,NULL,0,0,0,0,0,NULL,NULL,'DEVANNED','全部已入库，等待出单','0','演示数据：NJ已拆柜全入库海柜',NULL,1,'2026-05-08 14:00:00',1,'2026-05-28 02:47:07',0),(9100005,'000000',4000001,8001002,'Northstar Outdoor Inc.',5001002,5002001,1,'Kevin Zhang',1,'Mia',4001001,'Los Angeles Central Warehouse','SO202605280005','IMPORT','EVYU1122334','40GP','SEAL11002',230202,'MSC','MSC MAGNIFICA','339W','AAS2','MSCU223344556','HBL-LAX-005',230101,'USLAX',230502,'Yusen Terminal','2026-05-31 06:00:00',NULL,'2026-06-03','2026-06-10',NULL,'HOLDING',1,'Customs','等待海关放行',0,NULL,NULL,NULL,7001001,'LAX Drayage Express',NULL,NULL,NULL,NULL,'2026-06-01 10:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-02 09:00:00',NULL,'MIXED','PALLET','BY_WAREHOUSE_CODE',NULL,NULL,NULL,'YTI Empty Return',NULL,NULL,NULL,NULL,3,25,70.200,1280,25,16500.000,70.200,1,'CUSTOMS_HOLD',1,0,0,0,0,NULL,NULL,'IN_TRANSIT','在途有Hold，ETA 5/31','0','演示数据',NULL,1,'2026-05-28 12:27:31',1,'2026-05-28 12:27:31',0),(9100006,'000000',4000001,8001001,'Pacific Home Goods LLC',5001001,5002002,1,'Nina Wang',1,'Tom',4001001,'Los Angeles Central Warehouse','SO202605260006','IMPORT','KMTU5566778','45HQ','SEAL11003',230203,'OOCL','OOCL MALAYSIA','045E','EC2','OOLU334455667','HBL-LAX-006',230101,'USLAX',230501,'Fenix Marine Services','2026-05-24 10:00:00','2026-05-24 13:30:00','2026-05-28','2026-06-04',NULL,'RELEASED',0,NULL,NULL,0,NULL,NULL,NULL,7001001,'LAX Drayage Express','PU-LAX-20260524-06','2026-05-25 10:00:00','2026-05-25 15:40:00','已提柜','2026-05-26 08:00:00',NULL,'2026-05-26 09:15:00','YARD-A-03','已到仓等待拆柜',NULL,NULL,NULL,'2026-05-27 08:00:00',NULL,'MANUAL','FLOOR','BY_ORDER',NULL,NULL,NULL,'FMS Empty Return',NULL,NULL,NULL,NULL,2,18,54.600,920,18,12100.000,54.600,0,NULL,0,0,0,0,0,NULL,NULL,'ARRIVED_WAREHOUSE','已到仓待拆柜','0','演示数据',NULL,1,'2026-05-28 12:27:31',1,'2026-05-28 12:27:31',0),(9100007,'000000',4000001,8001003,'East Market Supply Co.',5001001,5002001,1,'Lily Chen',1,'Amy',4001001,'Los Angeles Central Warehouse','SO202605270007','IMPORT','APLU2233445','40HQ','SEAL11004',230201,'MAERSK','MAERSK CHICAGO','428E','TP1','MAEU778899001','HBL-LAX-007',230101,'USLAX',230502,'Yusen Terminal','2026-05-25 08:00:00','2026-05-25 10:20:00','2026-05-29','2026-06-05',NULL,'RELEASED',0,NULL,NULL,0,NULL,NULL,NULL,7001001,'LAX Drayage Express','PU-LAX-20260526-07','2026-05-26 14:00:00','2026-05-26 16:30:00','已提柜','2026-05-27 07:30:00',NULL,'2026-05-27 08:45:00','YARD-A-01','已到仓，已分配Dock',NULL,NULL,NULL,'2026-05-28 09:00:00',NULL,'MANUAL','FLOOR','BY_ORDER',NULL,NULL,NULL,'YTI Empty Return',NULL,NULL,NULL,NULL,2,22,62.800,1100,22,14500.000,62.800,0,NULL,0,0,0,0,0,NULL,NULL,'ARRIVED_WAREHOUSE','已到仓，已分配Dock A03','0','演示数据',NULL,1,'2026-05-28 12:27:31',1,'2026-05-28 12:27:31',0),(9100008,'000000',4000001,8001001,'Pacific Home Goods LLC',5001002,5002001,1,'Kevin Zhang',1,'Mia',4001001,'Los Angeles Central Warehouse','SO202605270008','IMPORT','TCKU8899001','40HQ','SEAL11005',230202,'MSC','MSC ANNA','219W','SEA','MSCU889900123','HBL-LAX-008',230101,'USLAX',230501,'Fenix Marine Services','2026-05-23 09:00:00','2026-05-23 11:45:00','2026-05-27','2026-06-02',NULL,'RELEASED',0,NULL,NULL,0,NULL,NULL,NULL,7001001,'LAX Drayage Express','PU-LAX-20260524-08','2026-05-24 09:00:00','2026-05-24 15:10:00','已提柜','2026-05-25 14:00:00',NULL,'2026-05-25 15:20:00','DOCK-LA-001','拆柜进行中','DEV202605270008',NULL,NULL,'2026-05-27 09:00:00',NULL,'MANUAL','FLOOR','BY_ORDER','2026-05-27 09:15:00',NULL,'拆柜进行中，进度约45%','FMS Empty Return',NULL,NULL,NULL,NULL,3,28,76.400,1450,28,19200.000,76.400,0,NULL,0,0,0,0,0,NULL,NULL,'DEVANNING','拆柜中，进度45%','0','演示数据',NULL,1,'2026-05-28 12:27:31',1,'2026-05-28 12:27:31',0),(9100009,'000000',4000001,8001002,'Northstar Outdoor Inc.',5001001,5002002,1,'Nina Wang',1,'Tom',4001001,'Los Angeles Central Warehouse','SO202605270009','IMPORT','HJCU4455667','40GP','SEAL11006',230203,'OOCL','OOCL TIANJIN','096W','EC2','OOLU556677889','HBL-LAX-009',230101,'USLAX',230502,'Yusen Terminal','2026-05-22 07:00:00','2026-05-22 09:30:00','2026-05-26','2026-06-01',NULL,'RELEASED',0,NULL,NULL,0,NULL,NULL,NULL,7001001,'LAX Drayage Express','PU-LAX-20260523-09','2026-05-23 10:00:00','2026-05-23 14:45:00','已提柜','2026-05-24 10:00:00',NULL,'2026-05-24 11:35:00','DOCK-LA-002','拆柜进行中','DEV202605270009',NULL,NULL,'2026-05-27 13:00:00',NULL,'MIXED','PALLET','BY_WAREHOUSE_CODE','2026-05-27 13:10:00',NULL,'拆柜进行中，进度约20%','YTI Empty Return',NULL,NULL,NULL,NULL,3,26,68.000,1340,26,17800.000,68.000,0,NULL,0,0,0,0,0,NULL,NULL,'DEVANNING','拆柜中，进度20%','0','演示数据',NULL,1,'2026-05-28 12:27:31',1,'2026-05-28 12:27:31',0),(9100010,'000000',4000001,8001003,'East Market Supply Co.',5001002,5002002,1,'Lily Chen',1,'Amy',4001001,'Los Angeles Central Warehouse','SO202605260010','IMPORT','SEGU3344556','45HQ','SEAL11007',230201,'MAERSK','MAERSK NORFOLK','427E','TP1','MAEU334455667','HBL-LAX-010',230101,'USLAX',230501,'Fenix Marine Services','2026-05-20 08:00:00','2026-05-20 10:15:00','2026-05-24','2026-05-31',NULL,'RELEASED',0,NULL,NULL,0,NULL,NULL,NULL,7001001,'LAX Drayage Express','PU-LAX-20260521-10','2026-05-21 08:00:00','2026-05-21 14:20:00','已提柜','2026-05-22 08:00:00',NULL,'2026-05-22 09:00:00','DONE','已完成拆柜','DEV202605260010',NULL,NULL,'2026-05-24 10:00:00',NULL,'MANUAL','FLOOR','BY_ORDER','2026-05-24 10:20:00','2026-05-26 17:30:00','拆柜已完成','FMS Empty Return',NULL,'2026-05-28 11:00:00',NULL,'已归还空柜',4,32,88.200,1680,32,22400.000,88.200,0,NULL,0,0,0,0,0,NULL,NULL,'DEVANNING_FINISHED','拆柜完成，已放行','0','演示数据',NULL,1,'2026-05-28 12:27:31',1,'2026-05-28 12:27:31',0),(9100011,'000000',4000001,8001001,'Pacific Home Goods LLC',5001001,5002001,1,'Kevin Zhang',1,'Mia',4001001,'Los Angeles Central Warehouse','SO202605280011','IMPORT','GLDU7788990','40HQ','SEAL11008',230202,'MSC','MSC CELESTINA','340W','AAS2','MSCU990011223','HBL-LAX-011',230101,'USLAX',230502,'Yusen Terminal','2026-06-05 08:00:00',NULL,'2026-06-09','2026-06-16',NULL,'UNKNOWN',0,NULL,NULL,0,NULL,NULL,NULL,7001001,'LAX Drayage Express',NULL,NULL,NULL,NULL,'2026-06-06 10:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-07 09:00:00',NULL,'MANUAL','PALLET','BY_ORDER',NULL,NULL,NULL,'YTI Empty Return',NULL,NULL,NULL,NULL,2,20,56.800,1020,20,13400.000,56.800,0,NULL,0,0,0,0,0,NULL,NULL,'IN_TRANSIT','在途，ETA 6/5','0','演示数据',NULL,1,'2026-05-28 12:27:31',1,'2026-05-28 12:27:31',0),(9100012,'000000',4000001,8001002,'Northstar Outdoor Inc.',5001002,5002002,1,'Nina Wang',1,'Tom',4001001,'Los Angeles Central Warehouse','SO202605280012','IMPORT','CAIU9900123','40GP','SEAL11009',230203,'OOCL','OOCL RICHMOND','097E','EC2','OOLU112233445','HBL-LAX-012',230101,'USLAX',230501,'Fenix Marine Services','2026-05-26 09:00:00','2026-05-26 11:00:00','2026-05-30','2026-06-06',NULL,'RELEASED',0,NULL,NULL,0,NULL,NULL,NULL,7001001,'LAX Drayage Express','PU-LAX-20260527-12','2026-05-27 14:00:00',NULL,'已预约提柜','2026-05-28 16:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-29 09:00:00',NULL,'MANUAL','FLOOR','BY_ORDER',NULL,NULL,NULL,'FMS Empty Return',NULL,NULL,NULL,NULL,3,24,66.400,1220,24,16100.000,66.400,0,NULL,0,0,0,0,0,NULL,NULL,'AT_PORT','已到港待提柜','0','演示数据',NULL,1,'2026-05-28 12:27:31',1,'2026-05-28 12:27:31',0),(9100013,'000000',4000001,8001003,'East Market Supply Co.',5001001,5002001,1,'Lily Chen',1,'Amy',4001001,'Los Angeles Central Warehouse','SO202605280013','IMPORT','YMLU6677889','45HQ','SEAL11010',230201,'MAERSK','MAERSK COLUMBIA','429E','TP1','MAEU667788990','HBL-LAX-013',230101,'USLAX',230502,'Yusen Terminal','2026-05-27 07:00:00','2026-05-27 09:30:00','2026-05-31','2026-06-07',NULL,'RELEASED',0,NULL,NULL,0,NULL,NULL,NULL,7001001,'LAX Drayage Express','PU-LAX-20260527-13','2026-05-27 13:00:00','2026-05-27 16:50:00','已提柜在途','2026-05-28 16:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-29 08:00:00',NULL,'MANUAL','PALLET','BY_ORDER',NULL,NULL,NULL,'YTI Empty Return',NULL,NULL,NULL,NULL,2,24,66.000,1200,24,15900.000,66.000,0,NULL,0,0,0,0,0,NULL,NULL,'AT_PORT','已提柜，在途到仓','0','演示数据',NULL,1,'2026-05-28 12:27:31',1,'2026-05-28 12:27:31',0);
/*!40000 ALTER TABLE `oms_container_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oms_container_order_trace`
--

DROP TABLE IF EXISTS `oms_container_order_trace`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oms_container_order_trace` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `container_order_id` bigint NOT NULL COMMENT '海柜订单ID',
  `container_order_no` varchar(64) NOT NULL COMMENT '海柜订单号',
  `container_no` varchar(32) DEFAULT NULL COMMENT '柜号',
  `status_from` varchar(30) DEFAULT NULL COMMENT '变更前状态',
  `status_to` varchar(30) NOT NULL COMMENT '变更后状态',
  `action` varchar(64) NOT NULL COMMENT '动作编码',
  `action_desc` varchar(200) DEFAULT NULL COMMENT '动作说明',
  `operator_id` bigint DEFAULT NULL COMMENT '操作人ID',
  `operator_name` varchar(64) DEFAULT NULL COMMENT '操作人名称',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_container_order_id` (`container_order_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='OMS海柜订单轨迹';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oms_container_order_trace`
--

LOCK TABLES `oms_container_order_trace` WRITE;
/*!40000 ALTER TABLE `oms_container_order_trace` DISABLE KEYS */;
INSERT INTO `oms_container_order_trace` VALUES (9101001,'000000',9100001,'SO202605220001','TGHU1234567',NULL,'IN_TRANSIT','mockCreate','模拟创建在途海柜',1,'admin','演示数据',NULL,1,'2026-05-22 10:18:35',1,'2026-05-22 10:18:35'),(9101002,'000000',9100002,'SO202605220002','MSCU7654321',NULL,'HOLDING','mockCreate','模拟创建Hold海柜',1,'admin','演示数据',NULL,1,'2026-05-22 10:18:35',1,'2026-05-22 10:18:35'),(9101003,'000000',9100003,'SO202605220003','OOLU4567890',NULL,'ARRIVED_WAREHOUSE','mockArrived','模拟到仓',1,'admin','演示数据',NULL,1,'2026-05-22 10:18:35',1,'2026-05-22 10:18:35'),(9101004,'000000',9100003,'SO202605220003','OOLU4567890','ARRIVED_WAREHOUSE','DEVANNING','mockDevanning','模拟开始拆柜',1,'admin','演示数据',NULL,1,'2026-05-22 10:18:35',1,'2026-05-22 10:18:35'),(9101005,'000000',9100004,'SO202605100004','CMAU9876543',NULL,'IN_TRANSIT','markInTransit','开航，在途',1,'Amy','演示数据',NULL,1,'2026-05-08 14:00:00',1,'2026-05-08 14:00:00'),(9101006,'000000',9100004,'SO202605100004','CMAU9876543','IN_TRANSIT','ARRIVED_PORT','confirmArrivedPort','靠港 NJ',1,'Amy','演示数据',NULL,1,'2026-05-10 08:45:00',1,'2026-05-10 08:45:00'),(9101007,'000000',9100004,'SO202605100004','CMAU9876543','ARRIVED_PORT','PICKED_UP','confirmPickedUp','拖车提柜',1,'Amy','演示数据',NULL,1,'2026-05-11 10:20:00',1,'2026-05-11 10:20:00'),(9101008,'000000',9100004,'SO202605100004','CMAU9876543','PICKED_UP','ARRIVED_WAREHOUSE','confirmArrivedWarehouse','到仓 YARD-B-03',1,'Amy','演示数据',NULL,1,'2026-05-11 17:55:00',1,'2026-05-11 17:55:00'),(9101009,'000000',9100004,'SO202605100004','CMAU9876543','ARRIVED_WAREHOUSE','DEVANNING','startDevanning','开始拆柜',1,'Amy','演示数据',NULL,1,'2026-05-12 09:15:00',1,'2026-05-12 09:15:00'),(9101010,'000000',9100004,'SO202605100004','CMAU9876543','DEVANNING','DEVANNED','finishDevanning','拆柜完成，5票全部入库',1,'Amy','演示数据',NULL,1,'2026-05-14 16:30:00',1,'2026-05-14 16:30:00');
/*!40000 ALTER TABLE `oms_container_order_trace` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oms_outbound_order`
--

DROP TABLE IF EXISTS `oms_outbound_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oms_outbound_order` (
  `id` bigint NOT NULL COMMENT 'ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '??????ID',
  `biz_root_id` bigint DEFAULT NULL COMMENT '????????????ID',
  `cargo_order_id` bigint DEFAULT NULL COMMENT '货物订单ID（兼容字段，1:N后由明细表管理）',
  `cargo_order_no` varchar(64) DEFAULT NULL COMMENT '货物订单号（兼容字段，1:N后由明细表管理）',
  `pre_outbound_id` bigint DEFAULT NULL COMMENT '?????????ID',
  `pre_outbound_no` varchar(64) DEFAULT NULL COMMENT '????????????',
  `cargo_order_count` int NOT NULL DEFAULT '0' COMMENT '关联货物订单数',
  `outbound_order_no` varchar(64) NOT NULL COMMENT '???????????????',
  `outbound_status` varchar(32) NOT NULL DEFAULT 'CREATED' COMMENT 'CREATED/DISPATCHED/OUTBOUNDED/DELIVERING/DELIVERED/ARRIVED/POD_UPLOADED/COMPLETED/CANCELLED',
  `outbound_direction` varchar(32) NOT NULL DEFAULT 'DELIVERY' COMMENT 'DELIVERY/TRANSFER',
  `outbound_warehouse_id` bigint DEFAULT NULL COMMENT '????????????ID',
  `outbound_warehouse_name` varchar(128) DEFAULT NULL COMMENT '??????????????????',
  `customer_name` varchar(128) DEFAULT NULL COMMENT '??????',
  `container_no` varchar(32) DEFAULT NULL COMMENT '??????',
  `shipment_codes` varchar(2000) DEFAULT NULL COMMENT '????????????',
  `actual_carton_qty` decimal(10,2) DEFAULT NULL COMMENT '????????????',
  `actual_pallet_qty` decimal(10,2) DEFAULT NULL COMMENT '????????????',
  `actual_weight` decimal(12,3) DEFAULT NULL COMMENT '????????????',
  `actual_cbm` decimal(12,3) DEFAULT NULL COMMENT '????????????',
  `delivery_method` varchar(64) DEFAULT NULL COMMENT '????????????',
  `appointment_status` varchar(32) DEFAULT 'NONE' COMMENT '????????????',
  `appointment_time` datetime DEFAULT NULL COMMENT '????????????',
  `delivery_lfd` datetime DEFAULT NULL COMMENT '??????LFD',
  `contact_name` varchar(128) DEFAULT NULL COMMENT '?????????',
  `contact_phone` varchar(64) DEFAULT NULL COMMENT '????????????',
  `contact_email` varchar(128) DEFAULT NULL COMMENT '??????',
  `address_line1` varchar(255) DEFAULT NULL COMMENT '??????1',
  `address_line2` varchar(255) DEFAULT NULL COMMENT '??????2',
  `city` varchar(128) DEFAULT NULL COMMENT '??????',
  `state` varchar(64) DEFAULT NULL COMMENT '???',
  `zip_code` varchar(32) DEFAULT NULL COMMENT '??????',
  `country` varchar(64) DEFAULT NULL COMMENT '??????',
  `transfer_out_warehouse_id` bigint DEFAULT NULL COMMENT '?????????ID',
  `transfer_in_warehouse_id` bigint DEFAULT NULL COMMENT '?????????ID',
  `transfer_reason` varchar(500) DEFAULT NULL COMMENT '????????????',
  `transfer_method` varchar(64) DEFAULT NULL COMMENT '????????????',
  `estimated_transfer_time` datetime DEFAULT NULL COMMENT '??????????????????',
  `estimated_arrival_time` datetime DEFAULT NULL COMMENT '??????????????????',
  `carrier` varchar(128) DEFAULT NULL COMMENT '?????????',
  `tracking_no` varchar(128) DEFAULT NULL COMMENT '?????????',
  `actual_outbound_time` datetime DEFAULT NULL COMMENT '??????????????????',
  `actual_signed_time` datetime DEFAULT NULL COMMENT '????????????',
  `actual_arrival_time` datetime DEFAULT NULL COMMENT '??????????????????',
  `pod_status` varchar(32) DEFAULT 'PENDING' COMMENT 'POD??????',
  `pod_upload_time` datetime DEFAULT NULL COMMENT 'POD????????????',
  `completed_time` datetime DEFAULT NULL COMMENT '????????????',
  `dispatch_remark` varchar(500) DEFAULT NULL COMMENT '????????????',
  `operation_remark` varchar(500) DEFAULT NULL COMMENT '????????????',
  `remark` varchar(500) DEFAULT NULL COMMENT '??????',
  `create_dept` bigint DEFAULT NULL COMMENT '????????????',
  `create_by` bigint DEFAULT NULL COMMENT '?????????',
  `create_time` datetime DEFAULT NULL COMMENT '????????????',
  `update_by` bigint DEFAULT NULL COMMENT '?????????',
  `update_time` datetime DEFAULT NULL COMMENT '????????????',
  `deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '????????????',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_outbound_order_no_tenant` (`outbound_order_no`,`tenant_id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`),
  KEY `idx_pre_outbound_id` (`pre_outbound_id`),
  KEY `idx_biz_root_id` (`biz_root_id`),
  KEY `idx_outbound_status` (`outbound_status`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='OMS????????????';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oms_outbound_order`
--

LOCK TABLES `oms_outbound_order` WRITE;
/*!40000 ALTER TABLE `oms_outbound_order` DISABLE KEYS */;
INSERT INTO `oms_outbound_order` VALUES (6000003001,'000000',10004,1004,'CO-2026-000004',NULL,NULL,1,'OB202605240001','CANCELLED','DELIVERY',4001001,'Los Angeles Central Warehouse','测试客户A','OOLU4567890','SC-007',50.00,3.00,379.500,2.890,NULL,'NONE',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'PENDING',NULL,NULL,NULL,NULL,'前端取消',NULL,NULL,'2026-05-24 04:04:23',1,'2026-05-26 23:24:07',1),(2059517419800768514,'000000',10003,1003,'CO-2026-000003',6000002001,'POB202605240001',0,'OB2059517419632996352','CANCELLED','DELIVERY',4001001,'Los Angeles Central Warehouse','测试客户C','MSCU7654321','SC-004,SC-005,SC-006',200.00,10.00,1445.000,11.480,NULL,'UNCONFIRMED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'PENDING',NULL,NULL,NULL,NULL,'前端取消',103,1,'2026-05-27 14:09:52',1,'2026-05-26 23:24:07',1),(2059566142723563522,'000000',10004,NULL,NULL,2059563689777143809,'POB2059563689638731776',1,'OB2059566142677426176','CREATED','DELIVERY',41,'纽约仓(JFK)','测试客户A','OOLU4567890','SC-007',50.00,3.00,379.500,2.890,NULL,'UNCONFIRMED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'PENDING',NULL,NULL,NULL,NULL,NULL,103,1,'2026-05-27 17:23:28',1,'2026-05-28 02:46:17',1),(2059707990268026881,'000000',9150014,NULL,NULL,NULL,NULL,2,'OB2059707989890539520','CREATED','DELIVERY',4001002,'New Jersey East Coast Warehouse','Pacific Home Goods LLC','CMAU9876543,OOLU4567890','PH-EWR9-009A,SC-007',362.00,14.00,4461.900,20.220,'卡车派送','UNCONFIRMED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'PENDING',NULL,NULL,NULL,NULL,NULL,103,1,'2026-05-28 02:47:07',1,'2026-05-28 02:47:14',1);
/*!40000 ALTER TABLE `oms_outbound_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oms_outbound_order_item`
--

DROP TABLE IF EXISTS `oms_outbound_order_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oms_outbound_order_item` (
  `id` bigint NOT NULL COMMENT 'ID（雪花算法）',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `outbound_order_id` bigint NOT NULL COMMENT '出库单ID',
  `outbound_order_no` varchar(64) NOT NULL COMMENT '出库单号',
  `cargo_order_id` bigint NOT NULL COMMENT '货物订单ID',
  `cargo_order_no` varchar(64) NOT NULL COMMENT '货物订单号',
  `pre_outbound_item_id` bigint DEFAULT NULL COMMENT '来源预出单明细ID（从预出单转换时填充）',
  `actual_carton_qty` decimal(10,2) DEFAULT NULL COMMENT '实际箱数',
  `actual_pallet_qty` decimal(10,2) DEFAULT NULL COMMENT '实际板数',
  `actual_weight` decimal(12,3) DEFAULT NULL COMMENT '实际重量(kg)',
  `actual_cbm` decimal(12,3) DEFAULT NULL COMMENT '实际体积(m³)',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除（0正常1删除）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_outbound_cargo_tenant` (`outbound_order_id`,`cargo_order_id`,`tenant_id`),
  KEY `idx_outbound_order_id` (`outbound_order_id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`),
  KEY `idx_pre_outbound_item_id` (`pre_outbound_item_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='OMS出库单明细（货物订单维度）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oms_outbound_order_item`
--

LOCK TABLES `oms_outbound_order_item` WRITE;
/*!40000 ALTER TABLE `oms_outbound_order_item` DISABLE KEYS */;
INSERT INTO `oms_outbound_order_item` VALUES (14000003001,'000000',6000003001,'OB202605240001',1004,'CO-2026-000004',NULL,50.00,3.00,379.500,2.890,NULL,NULL,'2026-05-26 22:38:51',NULL,'2026-05-26 23:24:07',1),(2059566142786478081,'000000',2059566142723563522,'OB2059566142677426176',1004,'CO-2026-000004',2059563690037190657,50.00,3.00,379.500,2.890,103,1,'2026-05-27 17:23:28',1,'2026-05-27 17:23:28',1),(2059707990330941442,'000000',2059707990268026881,'OB2059707989890539520',9200014,'CO202605080002',NULL,312.00,11.00,4082.400,17.330,103,1,'2026-05-28 02:47:07',1,'2026-05-28 02:47:07',1),(2059707990846840834,'000000',2059707990268026881,'OB2059707989890539520',1004,'CO-2026-000004',NULL,50.00,3.00,379.500,2.890,103,1,'2026-05-28 02:47:07',1,'2026-05-28 02:47:07',1);
/*!40000 ALTER TABLE `oms_outbound_order_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oms_pre_outbound`
--

DROP TABLE IF EXISTS `oms_pre_outbound`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oms_pre_outbound` (
  `id` bigint NOT NULL COMMENT 'ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '??????ID',
  `biz_root_id` bigint DEFAULT NULL COMMENT '????????????ID',
  `cargo_order_id` bigint DEFAULT NULL COMMENT '货物订单ID（兼容字段，1:N后由明细表管理）',
  `cargo_order_no` varchar(64) DEFAULT NULL COMMENT '货物订单号（兼容字段，1:N后由明细表管理）',
  `cargo_order_count` int NOT NULL DEFAULT '0' COMMENT '关联货物订单数',
  `pre_outbound_no` varchar(64) NOT NULL COMMENT '????????????',
  `pre_outbound_status` varchar(32) NOT NULL DEFAULT 'PENDING_INBOUND' COMMENT 'PENDING_INBOUND/DEVANNING/READY_TO_CONVERT/CONVERTED/CANCELLED',
  `outbound_direction` varchar(32) NOT NULL DEFAULT 'DELIVERY' COMMENT 'DELIVERY/TRANSFER',
  `outbound_warehouse_id` bigint DEFAULT NULL COMMENT '????????????ID',
  `outbound_warehouse_name` varchar(128) DEFAULT NULL COMMENT '??????????????????',
  `customer_name` varchar(128) DEFAULT NULL COMMENT '??????',
  `container_no` varchar(32) DEFAULT NULL COMMENT '??????',
  `shipment_codes` varchar(2000) DEFAULT NULL COMMENT '????????????',
  `declared_carton_qty` decimal(10,2) DEFAULT NULL COMMENT '????????????',
  `declared_pallet_qty` decimal(10,2) DEFAULT NULL COMMENT '????????????',
  `declared_weight` decimal(12,3) DEFAULT NULL COMMENT '????????????',
  `declared_cbm` decimal(12,3) DEFAULT NULL COMMENT '????????????',
  `actual_carton_qty` decimal(10,2) DEFAULT NULL COMMENT '????????????',
  `actual_pallet_qty` decimal(10,2) DEFAULT NULL COMMENT '????????????',
  `actual_weight` decimal(12,3) DEFAULT NULL COMMENT '????????????',
  `actual_cbm` decimal(12,3) DEFAULT NULL COMMENT '????????????',
  `earliest_dw_time` datetime DEFAULT NULL COMMENT '??????DW??????',
  `delivery_lfd` datetime DEFAULT NULL COMMENT '??????LFD',
  `ready_time` datetime DEFAULT NULL COMMENT '??????????????????',
  `converted_time` datetime DEFAULT NULL COMMENT '?????????????????????',
  `outbound_order_no` varchar(64) DEFAULT NULL COMMENT '???????????????',
  `appointment_no` varchar(64) DEFAULT NULL COMMENT 'Úóäþ║ªÕÅÀ',
  `appointment_time` datetime DEFAULT NULL COMMENT 'Úóäþ║ªµùÑµ£ƒ',
  `delivery_truck` varchar(128) DEFAULT NULL COMMENT 'µ┤¥ÚÇüÕìíÞ¢ª',
  `loading_type` varchar(32) DEFAULT NULL COMMENT 'ÞúàÞ¢ªþ▒╗Õ×ï PALLET/FLOOR',
  `transport_type` varchar(32) DEFAULT NULL COMMENT 'Þ┐ÉÞ¥ôþ▒╗Õ×ï FTL/LTL',
  `delivery_tag` varchar(128) DEFAULT NULL COMMENT 'µ┤¥ÚÇüµáçþ¡¥',
  `destination` varchar(255) DEFAULT NULL COMMENT 'þø«þÜäÕ£░',
  `delivery_method` varchar(64) DEFAULT NULL COMMENT 'µ┤¥ÚÇüµû╣Õ╝Å/õ©ÜÕèíþ▒╗Õ×ï',
  `follow_record` varchar(1000) DEFAULT NULL COMMENT 'ÞÀƒÞ┐øÞ«░Õ¢ò',
  `remark` varchar(500) DEFAULT NULL COMMENT '??????',
  `create_dept` bigint DEFAULT NULL COMMENT '????????????',
  `create_by` bigint DEFAULT NULL COMMENT '?????????',
  `create_time` datetime DEFAULT NULL COMMENT '????????????',
  `update_by` bigint DEFAULT NULL COMMENT '?????????',
  `update_time` datetime DEFAULT NULL COMMENT '????????????',
  `deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '????????????',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_pre_outbound_no_tenant` (`pre_outbound_no`,`tenant_id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`),
  KEY `idx_biz_root_id` (`biz_root_id`),
  KEY `idx_pre_status` (`pre_outbound_status`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_appointment_time` (`appointment_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='OMS?????????';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oms_pre_outbound`
--

LOCK TABLES `oms_pre_outbound` WRITE;
/*!40000 ALTER TABLE `oms_pre_outbound` DISABLE KEYS */;
INSERT INTO `oms_pre_outbound` VALUES (6000002001,'000000',10003,1003,'CO-2026-000003',1,'POB202605240001','CONVERTED','DELIVERY',4001001,'Los Angeles Central Warehouse','测试客户C','MSCU7654321','SC-004,SC-005,SC-006',200.00,NULL,1450.000,11.500,200.00,10.00,1445.000,11.480,'2026-05-27 00:00:00','2026-05-31 00:00:00','2026-05-24 12:43:37','2026-05-27 14:09:52','OB2059517419632996352',NULL,NULL,NULL,'PALLET','FTL',NULL,'Los Angeles Central Warehouse',NULL,NULL,'mock pre outbound',NULL,NULL,'2026-05-24 04:04:23',1,'2026-05-26 23:24:07',1),(2059521670472052738,'000000',10004,NULL,NULL,2,'POB2059521670304280576','DEVANNING','DELIVERY',41,'纽约仓(JFK)','测试客户A','OOLU4567890,TGHU1234567','SC-007,SC-003',130.00,0.00,940.000,7.100,90.00,7.00,799.500,4.990,'2026-05-10 00:00:00','2026-05-20 00:00:00',NULL,NULL,NULL,'',NULL,'','PALLET','FTL','','JFK7',NULL,'',NULL,103,1,'2026-05-27 14:26:45',1,'2026-05-27 14:34:43',1),(2059563689777143809,'000000',10004,1004,'CO-2026-000004',1,'POB2059563689638731776','CONVERTED','DELIVERY',41,'纽约仓(JFK)','测试客户A','OOLU4567890','SC-007',50.00,0.00,380.000,2.900,50.00,3.00,379.500,2.890,'2026-05-10 00:00:00','2026-05-20 00:00:00','2026-05-27 17:23:19','2026-05-27 17:23:28','OB2059566142677426176','',NULL,'','PALLET','FTL','','JFK7',NULL,'',NULL,103,1,'2026-05-27 17:13:43',1,'2026-05-27 17:23:28',1),(2060128929988308994,'000000',10001,NULL,NULL,1,'POB2060128929778593792','PENDING_INBOUND','DELIVERY',4001001,'Los Angeles Central Warehouse','测试客户A','TGHU1234567','SC-001, SC-002',120.00,0.00,860.500,6.800,0.00,0.00,0.000,0.000,'2026-06-01 00:00:00','2026-06-05 00:00:00',NULL,NULL,NULL,'',NULL,'','PALLET','FTL','','Amazon-ONT8','卡车派送','',NULL,103,1,'2026-05-29 06:39:47',1,'2026-05-29 06:39:47',0);
/*!40000 ALTER TABLE `oms_pre_outbound` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oms_pre_outbound_item`
--

DROP TABLE IF EXISTS `oms_pre_outbound_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oms_pre_outbound_item` (
  `id` bigint NOT NULL COMMENT 'ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `pre_outbound_id` bigint NOT NULL COMMENT '预出单ID',
  `pre_outbound_no` varchar(64) NOT NULL COMMENT '预出单号',
  `cargo_order_id` bigint NOT NULL COMMENT '货物订单ID',
  `cargo_order_no` varchar(64) NOT NULL COMMENT '货物订单号',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_pre_outbound_cargo_tenant` (`pre_outbound_id`,`cargo_order_id`,`tenant_id`),
  KEY `idx_pre_outbound_id` (`pre_outbound_id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='OMS预出单明细';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oms_pre_outbound_item`
--

LOCK TABLES `oms_pre_outbound_item` WRITE;
/*!40000 ALTER TABLE `oms_pre_outbound_item` DISABLE KEYS */;
INSERT INTO `oms_pre_outbound_item` VALUES (15000002001,'000000',6000002001,'POB202605240001',1003,'CO-2026-000003',NULL,NULL,'2026-05-25 15:47:49',NULL,'2026-05-26 23:24:07',1),(2059521670807597057,'000000',2059521670472052738,'POB2059521670304280576',1004,'CO-2026-000004',103,1,'2026-05-27 14:26:45',1,'2026-05-27 14:26:45',1),(2059521671398993921,'000000',2059521670472052738,'POB2059521670304280576',1002,'CO-2026-000002',103,1,'2026-05-27 14:26:45',1,'2026-05-27 14:26:45',1),(2059563690037190657,'000000',2059563689777143809,'POB2059563689638731776',1004,'CO-2026-000004',103,1,'2026-05-27 17:13:43',1,'2026-05-27 17:13:43',1),(2059563690360152065,'000000',2059563689777143809,'POB2059563689638731776',1002,'CO-2026-000002',103,1,'2026-05-27 17:13:43',1,'2026-05-27 17:23:19',1),(2060128930315464706,'000000',2060128929988308994,'POB2060128929778593792',1001,'CO-2026-000001',103,1,'2026-05-29 06:39:47',1,'2026-05-29 06:39:47',0);
/*!40000 ALTER TABLE `oms_pre_outbound_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `platform`
--

DROP TABLE IF EXISTS `platform`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `platform` (
  `id` bigint NOT NULL COMMENT '主键ID（雪花）',
  `tenant_id` varchar(20) NOT NULL COMMENT '租户ID',
  `code` varchar(50) NOT NULL COMMENT '平台代码（如 AMAZON/WALMART/SHOPIFY）',
  `name_en` varchar(100) NOT NULL COMMENT '平台英文名称',
  `type_code` varchar(50) NOT NULL COMMENT '平台类型（字典：PLATFORM_TYPE）',
  `logo_oss_id` bigint DEFAULT NULL COMMENT 'Logo 图片 sys_oss.oss_id',
  `logo_url` varchar(500) DEFAULT NULL COMMENT 'Logo 图片访问 URL（冗余存储）',
  `address_format` json DEFAULT NULL COMMENT '地址格式配置（预留）',
  `api_config` json DEFAULT NULL COMMENT 'API 对接参数（预留）',
  `status` char(1) NOT NULL DEFAULT '0' COMMENT '状态（0=正常，1=禁用）',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `del_flag` bigint NOT NULL DEFAULT '0' COMMENT '删除标志（0=存在，1=删除）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`tenant_id`,`code`),
  KEY `idx_type_code` (`tenant_id`,`type_code`),
  KEY `idx_status` (`tenant_id`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='电商平台配置（BASE-010）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `platform`
--

LOCK TABLES `platform` WRITE;
/*!40000 ALTER TABLE `platform` DISABLE KEYS */;
INSERT INTO `platform` VALUES (2000001,'000000','AMAZON','Amazon','ECOMMERCE',NULL,NULL,NULL,NULL,'0',1,'全球最大电商平台',NULL,1,'2026-05-22 00:41:17',NULL,'0000-00-00 00:00:00',0),(2000002,'000000','WALMART','Walmart','ECOMMERCE',NULL,NULL,NULL,NULL,'0',2,'美国本土零售巨头',NULL,1,'2026-05-22 00:41:17',NULL,'0000-00-00 00:00:00',0),(2000003,'000000','SHOPIFY','Shopify','INDEPENDENT_SITE',NULL,NULL,NULL,NULL,'0',3,'SaaS独立站平台',NULL,1,'2026-05-22 00:41:17',NULL,'0000-00-00 00:00:00',0),(2000004,'000000','TEMU','Temu','ECOMMERCE',NULL,NULL,NULL,NULL,'0',4,'PDD旗下跨境电商',NULL,1,'2026-05-22 00:41:17',NULL,'0000-00-00 00:00:00',0),(2000005,'000000','SHEIN','Shein','INDEPENDENT_SITE',NULL,NULL,NULL,NULL,'0',5,'快时尚跨境平台',NULL,1,'2026-05-22 00:41:17',NULL,'0000-00-00 00:00:00',0);
/*!40000 ALTER TABLE `platform` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `platform_address`
--

DROP TABLE IF EXISTS `platform_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `platform_address` (
  `id` bigint NOT NULL COMMENT '主键ID（雪花）',
  `tenant_id` varchar(20) NOT NULL COMMENT '租户ID',
  `platform_id` bigint NOT NULL COMMENT '所属平台ID',
  `address_code` varchar(100) NOT NULL COMMENT '地址编码（如 FBA 仓库代码 ONT8/LAX9）',
  `address_type` tinyint NOT NULL COMMENT '地址类型（1=FBA仓库，2=门店，3=配送中心，4=其他）',
  `name_en` varchar(200) NOT NULL COMMENT '地址名称英文',
  `country_code` varchar(10) NOT NULL COMMENT '国家代码',
  `state_code` varchar(20) DEFAULT NULL COMMENT '州/省代码',
  `city` varchar(100) DEFAULT NULL COMMENT '城市',
  `address_line1` varchar(255) NOT NULL COMMENT '地址行1',
  `address_line2` varchar(255) DEFAULT NULL COMMENT '地址行2',
  `zip_code` varchar(20) DEFAULT NULL COMMENT '邮编',
  `unit_pallet_cbm` decimal(10,3) DEFAULT NULL COMMENT '单板CBM，用于计算预计打板数',
  `contact_name` varchar(100) DEFAULT NULL COMMENT '联系人',
  `contact_phone` varchar(50) DEFAULT NULL COMMENT '联系电话',
  `last_verified_at` datetime DEFAULT NULL COMMENT '最后核验时间',
  `status` char(1) NOT NULL DEFAULT '0' COMMENT '状态（0=正常，1=禁用）',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '???',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '???',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `del_flag` bigint NOT NULL DEFAULT '0' COMMENT '删除标志（0=存在，1=删除）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_address_code` (`tenant_id`,`platform_id`,`address_code`),
  KEY `idx_platform_id` (`tenant_id`,`platform_id`),
  KEY `idx_country_state` (`country_code`,`state_code`),
  KEY `idx_status` (`tenant_id`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='平台地址库（FBA仓库/门店/配送中心等，BASE-011）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `platform_address`
--

LOCK TABLES `platform_address` WRITE;
/*!40000 ALTER TABLE `platform_address` DISABLE KEYS */;
INSERT INTO `platform_address` VALUES (2001001,'000000',2000001,'ONT8',1,'Amazon FBA ONT8 - Ontario CA','US','CA','Ontario','2020 E Central Ave',NULL,'91764',2.000,NULL,NULL,NULL,'0','FBA仓库',NULL,1,'2026-05-22 00:41:18',NULL,'2026-05-27 23:55:51',0),(2001002,'000000',2000001,'LAX9',1,'Amazon FBA LAX9 - Moreno Valley CA','US','CA','Moreno Valley','24208 San Michele Rd',NULL,'92551',2.000,NULL,NULL,NULL,'0','FBA仓库',NULL,1,'2026-05-22 00:41:18',NULL,'2026-05-27 23:55:51',0),(2001003,'000000',2000001,'EWR4',1,'Amazon FBA EWR4 - Avenel NJ','US','NJ','Avenel','50 New Canton Way',NULL,'07001',2.000,NULL,NULL,NULL,'0','FBA仓库',NULL,1,'2026-05-22 00:41:18',NULL,'2026-05-27 23:55:51',0),(2001004,'000000',2000001,'ORD2',1,'Amazon FBA ORD2 - Joliet IL','US','IL','Joliet','1 Centerpoint Blvd',NULL,'60436',2.000,NULL,NULL,NULL,'0','FBA仓库',NULL,1,'2026-05-22 00:41:18',NULL,'2026-05-27 23:55:51',0),(2001005,'000000',2000001,'IAH1',1,'Amazon FBA IAH1 - Houston TX','US','TX','Houston','20900 Lucerne Dr',NULL,'77049',2.000,NULL,NULL,NULL,'0','FBA仓库',NULL,1,'2026-05-22 00:41:18',NULL,'2026-05-27 23:55:51',0),(2001006,'000000',2000002,'WM-DC-CA',3,'Walmart Distribution Center - Chino CA','US','CA','Chino','14699 Central Ave',NULL,'91710',2.000,NULL,NULL,NULL,'0','配送中心',NULL,1,'2026-05-22 00:41:18',NULL,'2026-05-27 23:55:51',0),(2001007,'000000',2000002,'WM-DC-NJ',3,'Walmart Distribution Center - Secaucus','US','NJ','Secaucus','300 Meadowlands Pkwy',NULL,'07094',2.000,NULL,NULL,NULL,'0','配送中心',NULL,1,'2026-05-22 00:41:18',NULL,'2026-05-27 23:55:51',0);
/*!40000 ALTER TABLE `platform_address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `platform_address_change_log`
--

DROP TABLE IF EXISTS `platform_address_change_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `platform_address_change_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `tenant_id` varchar(20) NOT NULL COMMENT '租户ID',
  `platform_address_id` bigint NOT NULL COMMENT '地址ID',
  `change_type` varchar(30) NOT NULL COMMENT '变更类型（CREATE/UPDATE/DISABLE）',
  `before_value` json DEFAULT NULL COMMENT '变更前值（JSON 快照）',
  `after_value` json DEFAULT NULL COMMENT '变更后值（JSON 快照）',
  `change_reason` varchar(255) DEFAULT NULL COMMENT '变更原因',
  `operator_id` bigint NOT NULL COMMENT '操作人ID（关联 sys_user）',
  `operator_name` varchar(50) NOT NULL COMMENT '操作人姓名（快照）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '记录时间',
  PRIMARY KEY (`id`),
  KEY `idx_address_id` (`platform_address_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='平台地址变更记录（不可删除，BASE-011）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `platform_address_change_log`
--

LOCK TABLES `platform_address_change_log` WRITE;
/*!40000 ALTER TABLE `platform_address_change_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `platform_address_change_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `port`
--

DROP TABLE IF EXISTS `port`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `port` (
  `id` bigint NOT NULL COMMENT '主键（雪花ID）',
  `tenant_id` varchar(20) NOT NULL COMMENT '租户ID',
  `port_code` varchar(20) NOT NULL COMMENT '港口代码（UN/LOCODE，如USLAX/DEHAM）',
  `name_en` varchar(100) NOT NULL COMMENT '港口英文名称',
  `country_code` varchar(10) NOT NULL COMMENT '所属国家代码',
  `state_code` varchar(20) DEFAULT NULL COMMENT '所属州/省代码',
  `city` varchar(100) DEFAULT NULL COMMENT '所在城市',
  `port_type` int NOT NULL DEFAULT '1' COMMENT '港口类型（1=海港，2=空港，3=内陆港）',
  `timezone` varchar(50) DEFAULT NULL COMMENT '港口时区',
  `container_query_url` varchar(500) DEFAULT NULL COMMENT '海柜状态查询URL模板（含{container_no}占位符）',
  `status` char(1) NOT NULL DEFAULT '0' COMMENT '状态（0=正常，1=停用）',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_by` bigint DEFAULT NULL COMMENT '???',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '???',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` bigint DEFAULT '0' COMMENT '逻辑删除（0=存在，1=删除）',
  `create_dept` bigint DEFAULT NULL COMMENT '????',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_port_code` (`tenant_id`,`port_code`),
  KEY `idx_country_code` (`tenant_id`,`country_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='港口管理（LOG-001）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `port`
--

LOCK TABLES `port` WRITE;
/*!40000 ALTER TABLE `port` DISABLE KEYS */;
INSERT INTO `port` VALUES (3006001,'000000','USLAX','Port of Los Angeles','US','CA','Los Angeles',1,'America/Los_Angeles',NULL,'0',1,'全美最大集装箱港',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3006002,'000000','USLGB','Port of Long Beach','US','CA','Long Beach',1,'America/Los_Angeles',NULL,'0',2,NULL,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3006003,'000000','USNYC','Port of New York & New Jersey','US','NJ','Newark',1,'America/New_York',NULL,'0',3,'东海岸最大港',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3006004,'000000','USSEA','Port of Seattle','US','WA','Seattle',1,'America/Los_Angeles',NULL,'0',4,NULL,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3006005,'000000','USHOU','Port of Houston','US','TX','Houston',1,'America/Chicago',NULL,'0',5,NULL,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3006006,'000000','CNSHA','Port of Shanghai','CN','SH','Shanghai',1,'Asia/Shanghai',NULL,'0',6,'全球最大集装箱港',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3006007,'000000','CNSZX','Port of Shenzhen (Yantian)','CN','GD','Shenzhen',1,'Asia/Shanghai',NULL,'0',7,NULL,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3006008,'000000','CNGZU','Port of Guangzhou (Nansha)','CN','GD','Guangzhou',1,'Asia/Shanghai',NULL,'0',8,NULL,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3006009,'000000','CNNBO','Port of Ningbo-Zhoushan','CN','ZJ','Ningbo',1,'Asia/Shanghai',NULL,'0',9,'全球第一吞吐量港口',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3006010,'000000','DEHAM','Port of Hamburg','DE',NULL,'Hamburg',1,'Europe/Berlin',NULL,'0',10,'欧洲最大港',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3006011,'000000','NLRTM','Port of Rotterdam','NL',NULL,'Rotterdam',1,'Europe/Amsterdam',NULL,'0',11,'欧洲最繁忙港口',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3006012,'000000','GBSOU','Port of Southampton','GB',NULL,'Southampton',1,'Europe/London',NULL,'0',12,NULL,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL);
/*!40000 ALTER TABLE `port` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shipping_line`
--

DROP TABLE IF EXISTS `shipping_line`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipping_line` (
  `id` bigint NOT NULL COMMENT '主键（雪花ID）',
  `tenant_id` varchar(20) NOT NULL COMMENT '租户ID',
  `code` varchar(20) NOT NULL COMMENT '船司代码（SCAC代码，如MSCU/COSU/EGLV）',
  `name_en` varchar(100) NOT NULL COMMENT '船司英文名称',
  `name_abbr` varchar(50) DEFAULT NULL COMMENT '常用简称（如MSC/COSCO/Evergreen）',
  `country_code` varchar(10) DEFAULT NULL COMMENT '注册国家代码',
  `contact_email` varchar(100) DEFAULT NULL COMMENT '联系邮箱',
  `contact_phone` varchar(50) DEFAULT NULL COMMENT '联系电话',
  `website` varchar(255) DEFAULT NULL COMMENT '官网地址',
  `tracking_url` varchar(500) DEFAULT NULL COMMENT '货物追踪URL模板（含{container_no}占位符）',
  `status` char(1) NOT NULL DEFAULT '0' COMMENT '状态（0=正常，1=停用）',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_by` bigint DEFAULT NULL COMMENT '???',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '???',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` bigint DEFAULT '0' COMMENT '逻辑删除（0=存在，1=删除）',
  `create_dept` bigint DEFAULT NULL COMMENT '????',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_code` (`tenant_id`,`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='船司管理（LOG-001）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shipping_line`
--

LOCK TABLES `shipping_line` WRITE;
/*!40000 ALTER TABLE `shipping_line` DISABLE KEYS */;
INSERT INTO `shipping_line` VALUES (3007001,'000000','MSCU','Mediterranean Shipping Company','MSC','CH',NULL,NULL,'https://www.msc.com','https://www.msc.com/en/track-a-shipment?searchValue={container_no}','0',1,NULL,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3007002,'000000','MAEU','Maersk Line','Maersk','DK',NULL,NULL,'https://www.maersk.com','https://www.maersk.com/tracking/{container_no}','0',2,NULL,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3007003,'000000','COSU','COSCO Shipping Lines','COSCO','CN',NULL,NULL,'https://www.cosco.com','https://elines.coscoshipping.com/ebusiness/cargoTracking?trackingType=CONTAINER&number={container_no}','0',3,NULL,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3007004,'000000','EGLV','Evergreen Marine Corporation','Evergreen','TW',NULL,NULL,'https://www.evergreen-marine.com','https://www.evergreen-marine.com/ct/lns0120F.do?shpbkgNo={container_no}','0',4,NULL,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3007005,'000000','HLCU','Hapag-Lloyd AG','Hapag','DE',NULL,NULL,'https://www.hapag-lloyd.com','https://www.hapag-lloyd.com/en/online-business/tracing/tracing-by-container.html?container={container_no}','0',5,NULL,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3007006,'000000','OOLU','Orient Overseas Container Line','OOCL','HK',NULL,NULL,'https://www.oocl.com','https://www.oocl.com/eng/ourservices/eservices/cargotracking/Pages/cargotracking.aspx','0',6,NULL,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3007007,'000000','YMLU','Yang Ming Marine Transport Corp','Yang Ming','TW',NULL,NULL,'https://www.yangming.com','https://www.yangming.com/e-service/schedule_inquiry/cargo_tracking.aspx','0',7,NULL,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3007008,'000000','ZIMU','Zim Integrated Shipping Services','Zim','IL',NULL,NULL,'https://www.zim.com','https://www.zim.com/tools/track-a-shipment?consnumber={container_no}','0',8,NULL,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL);
/*!40000 ALTER TABLE `shipping_line` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sj_distributed_lock`
--

DROP TABLE IF EXISTS `sj_distributed_lock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sj_distributed_lock` (
  `name` varchar(64) NOT NULL COMMENT '锁名称',
  `lock_until` timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '锁定时长',
  `locked_at` timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '锁定时间',
  `locked_by` varchar(255) NOT NULL COMMENT '锁定者',
  `create_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='锁定表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sj_distributed_lock`
--

LOCK TABLES `sj_distributed_lock` WRITE;
/*!40000 ALTER TABLE `sj_distributed_lock` DISABLE KEYS */;
/*!40000 ALTER TABLE `sj_distributed_lock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sj_group_config`
--

DROP TABLE IF EXISTS `sj_group_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sj_group_config` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `namespace_id` varchar(64) NOT NULL DEFAULT '764d604ec6fc45f68cd92514c40e9e1a' COMMENT '命名空间id',
  `group_name` varchar(64) NOT NULL DEFAULT '' COMMENT '组名称',
  `description` varchar(256) NOT NULL DEFAULT '' COMMENT '组描述',
  `token` varchar(64) NOT NULL DEFAULT 'SJ_cKqBTPzCsWA3VyuCfFoccmuIEGXjr5KT' COMMENT 'token',
  `group_status` tinyint NOT NULL DEFAULT '0' COMMENT '组状态 0、未启用 1、启用',
  `version` int NOT NULL COMMENT '版本号',
  `group_partition` int NOT NULL COMMENT '分区',
  `id_generator_mode` tinyint NOT NULL DEFAULT '1' COMMENT '唯一id生成模式 默认号段模式',
  `init_scene` tinyint NOT NULL DEFAULT '0' COMMENT '是否初始化场景 0:否 1:是',
  `create_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_namespace_id_group_name` (`namespace_id`,`group_name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='组配置';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sj_group_config`
--

LOCK TABLES `sj_group_config` WRITE;
/*!40000 ALTER TABLE `sj_group_config` DISABLE KEYS */;
INSERT INTO `sj_group_config` VALUES (1,'dev','ruoyi_group','','SJ_cKqBTPzCsWA3VyuCfFoccmuIEGXjr5KT',1,1,0,1,1,'2026-05-21 23:14:52','2026-05-21 23:14:52'),(2,'prod','ruoyi_group','','SJ_cKqBTPzCsWA3VyuCfFoccmuIEGXjr5KT',1,1,0,1,1,'2026-05-21 23:14:52','2026-05-21 23:14:52');
/*!40000 ALTER TABLE `sj_group_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sj_job`
--

DROP TABLE IF EXISTS `sj_job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sj_job` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `namespace_id` varchar(64) NOT NULL DEFAULT '764d604ec6fc45f68cd92514c40e9e1a' COMMENT '命名空间id',
  `biz_id` varchar(64) NOT NULL COMMENT '业务ID',
  `group_name` varchar(64) NOT NULL COMMENT '组名称',
  `job_name` varchar(64) NOT NULL COMMENT '名称',
  `args_str` text COMMENT '执行方法参数',
  `args_type` tinyint NOT NULL DEFAULT '1' COMMENT '参数类型 ',
  `next_trigger_at` bigint NOT NULL COMMENT '下次触发时间',
  `job_status` tinyint NOT NULL DEFAULT '1' COMMENT '任务状态 0、关闭、1、开启',
  `task_type` tinyint NOT NULL DEFAULT '1' COMMENT '任务类型 1、集群 2、广播 3、切片',
  `route_key` tinyint NOT NULL DEFAULT '4' COMMENT '路由策略',
  `executor_type` tinyint NOT NULL DEFAULT '1' COMMENT '执行器类型',
  `executor_info` varchar(255) DEFAULT NULL COMMENT '执行器名称',
  `trigger_type` tinyint NOT NULL COMMENT '触发类型 1.CRON 表达式 2. 固定时间',
  `trigger_interval` varchar(255) NOT NULL COMMENT '间隔时长',
  `block_strategy` tinyint NOT NULL DEFAULT '1' COMMENT '阻塞策略 1、丢弃 2、覆盖 3、并行 4、恢复',
  `executor_timeout` int NOT NULL DEFAULT '0' COMMENT '任务执行超时时间，单位秒',
  `max_retry_times` int NOT NULL DEFAULT '0' COMMENT '最大重试次数',
  `parallel_num` int NOT NULL DEFAULT '1' COMMENT '并行数',
  `retry_interval` int NOT NULL DEFAULT '0' COMMENT '重试间隔(s)',
  `bucket_index` int NOT NULL DEFAULT '0' COMMENT 'bucket',
  `resident` tinyint NOT NULL DEFAULT '0' COMMENT '是否是常驻任务',
  `notify_ids` varchar(128) NOT NULL DEFAULT '' COMMENT '通知告警场景配置id列表',
  `owner_id` bigint DEFAULT NULL COMMENT '负责人id',
  `labels` varchar(512) DEFAULT '' COMMENT '标签',
  `description` varchar(256) NOT NULL DEFAULT '' COMMENT '描述',
  `ext_attrs` varchar(256) DEFAULT '' COMMENT '扩展字段',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除 1、删除',
  `create_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sj_job_01` (`namespace_id`,`biz_id`),
  KEY `idx_namespace_id_group_name` (`namespace_id`,`group_name`),
  KEY `idx_job_status_bucket_index` (`job_status`,`bucket_index`),
  KEY `idx_create_dt` (`create_dt`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='任务信息';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sj_job`
--

LOCK TABLES `sj_job` WRITE;
/*!40000 ALTER TABLE `sj_job` DISABLE KEYS */;
INSERT INTO `sj_job` VALUES (1,'dev','demo-job','ruoyi_group','demo-job',NULL,1,1710344035622,1,1,4,1,'testJobExecutor',2,'60',1,60,3,1,1,116,0,'',1,'','','',0,'2026-05-21 23:14:52','2026-05-21 23:14:52');
/*!40000 ALTER TABLE `sj_job` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sj_job_executor`
--

DROP TABLE IF EXISTS `sj_job_executor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sj_job_executor` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `namespace_id` varchar(64) NOT NULL DEFAULT '764d604ec6fc45f68cd92514c40e9e1a' COMMENT '命名空间id',
  `group_name` varchar(64) NOT NULL COMMENT '组名称',
  `executor_info` varchar(256) NOT NULL COMMENT '任务执行器名称',
  `executor_type` varchar(3) NOT NULL COMMENT '1:java 2:python 3:go',
  `create_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `idx_namespace_id_group_name` (`namespace_id`,`group_name`),
  KEY `idx_create_dt` (`create_dt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='任务执行器信息';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sj_job_executor`
--

LOCK TABLES `sj_job_executor` WRITE;
/*!40000 ALTER TABLE `sj_job_executor` DISABLE KEYS */;
/*!40000 ALTER TABLE `sj_job_executor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sj_job_log_message`
--

DROP TABLE IF EXISTS `sj_job_log_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sj_job_log_message` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `namespace_id` varchar(64) NOT NULL DEFAULT '764d604ec6fc45f68cd92514c40e9e1a' COMMENT '命名空间id',
  `group_name` varchar(64) NOT NULL COMMENT '组名称',
  `job_id` bigint NOT NULL COMMENT '任务信息id',
  `task_batch_id` bigint NOT NULL COMMENT '任务批次id',
  `task_id` bigint NOT NULL COMMENT '调度任务id',
  `message` longtext NOT NULL COMMENT '调度信息',
  `log_num` int NOT NULL DEFAULT '1' COMMENT '日志数量',
  `real_time` bigint NOT NULL DEFAULT '0' COMMENT '上报时间',
  `ext_attrs` varchar(256) DEFAULT '' COMMENT '扩展字段',
  `create_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_task_batch_id_task_id` (`task_batch_id`,`task_id`),
  KEY `idx_create_dt` (`create_dt`),
  KEY `idx_namespace_id_group_name` (`namespace_id`,`group_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='调度日志';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sj_job_log_message`
--

LOCK TABLES `sj_job_log_message` WRITE;
/*!40000 ALTER TABLE `sj_job_log_message` DISABLE KEYS */;
/*!40000 ALTER TABLE `sj_job_log_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sj_job_summary`
--

DROP TABLE IF EXISTS `sj_job_summary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sj_job_summary` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `namespace_id` varchar(64) NOT NULL DEFAULT '764d604ec6fc45f68cd92514c40e9e1a' COMMENT '命名空间id',
  `group_name` varchar(64) NOT NULL DEFAULT '' COMMENT '组名称',
  `business_id` bigint NOT NULL COMMENT '业务id (job_id或workflow_id)',
  `system_task_type` tinyint NOT NULL DEFAULT '3' COMMENT '任务类型 3、JOB任务 4、WORKFLOW任务',
  `trigger_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '统计时间',
  `success_num` int NOT NULL DEFAULT '0' COMMENT '执行成功-日志数量',
  `fail_num` int NOT NULL DEFAULT '0' COMMENT '执行失败-日志数量',
  `fail_reason` varchar(512) NOT NULL DEFAULT '' COMMENT '失败原因',
  `stop_num` int NOT NULL DEFAULT '0' COMMENT '执行失败-日志数量',
  `stop_reason` varchar(512) NOT NULL DEFAULT '' COMMENT '失败原因',
  `cancel_num` int NOT NULL DEFAULT '0' COMMENT '执行失败-日志数量',
  `cancel_reason` varchar(512) NOT NULL DEFAULT '' COMMENT '失败原因',
  `create_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_trigger_at_system_task_type_business_id` (`trigger_at`,`system_task_type`,`business_id`) USING BTREE,
  KEY `idx_namespace_id_group_name_business_id` (`namespace_id`,`group_name`,`business_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='DashBoard_Job';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sj_job_summary`
--

LOCK TABLES `sj_job_summary` WRITE;
/*!40000 ALTER TABLE `sj_job_summary` DISABLE KEYS */;
/*!40000 ALTER TABLE `sj_job_summary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sj_job_task`
--

DROP TABLE IF EXISTS `sj_job_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sj_job_task` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `namespace_id` varchar(64) NOT NULL DEFAULT '764d604ec6fc45f68cd92514c40e9e1a' COMMENT '命名空间id',
  `group_name` varchar(64) NOT NULL COMMENT '组名称',
  `job_id` bigint NOT NULL COMMENT '任务信息id',
  `task_batch_id` bigint NOT NULL COMMENT '调度任务id',
  `parent_id` bigint NOT NULL DEFAULT '0' COMMENT '父执行器id',
  `task_status` tinyint NOT NULL DEFAULT '0' COMMENT '执行的状态 0、失败 1、成功',
  `retry_count` int NOT NULL DEFAULT '0' COMMENT '重试次数',
  `mr_stage` tinyint DEFAULT NULL COMMENT '动态分片所处阶段 1:map 2:reduce 3:mergeReduce',
  `leaf` tinyint NOT NULL DEFAULT '1' COMMENT '叶子节点',
  `task_name` varchar(255) NOT NULL DEFAULT '' COMMENT '任务名称',
  `client_info` varchar(128) DEFAULT NULL COMMENT '客户端地址 clientId#ip:port',
  `wf_context` text COMMENT '工作流全局上下文',
  `result_message` text NOT NULL COMMENT '执行结果',
  `args_str` text COMMENT '执行方法参数',
  `args_type` tinyint NOT NULL DEFAULT '1' COMMENT '参数类型 ',
  `ext_attrs` varchar(256) DEFAULT '' COMMENT '扩展字段',
  `create_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `idx_task_batch_id_task_status` (`task_batch_id`,`task_status`),
  KEY `idx_create_dt` (`create_dt`),
  KEY `idx_namespace_id_group_name` (`namespace_id`,`group_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='任务实例';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sj_job_task`
--

LOCK TABLES `sj_job_task` WRITE;
/*!40000 ALTER TABLE `sj_job_task` DISABLE KEYS */;
/*!40000 ALTER TABLE `sj_job_task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sj_job_task_batch`
--

DROP TABLE IF EXISTS `sj_job_task_batch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sj_job_task_batch` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `namespace_id` varchar(64) NOT NULL DEFAULT '764d604ec6fc45f68cd92514c40e9e1a' COMMENT '命名空间id',
  `group_name` varchar(64) NOT NULL COMMENT '组名称',
  `job_id` bigint NOT NULL COMMENT '任务id',
  `workflow_node_id` bigint NOT NULL DEFAULT '0' COMMENT '工作流节点id',
  `parent_workflow_node_id` bigint NOT NULL DEFAULT '0' COMMENT '工作流任务父批次id',
  `workflow_task_batch_id` bigint NOT NULL DEFAULT '0' COMMENT '工作流任务批次id',
  `task_batch_status` tinyint NOT NULL DEFAULT '0' COMMENT '任务批次状态 0、失败 1、成功',
  `operation_reason` tinyint NOT NULL DEFAULT '0' COMMENT '操作原因',
  `execution_at` bigint NOT NULL DEFAULT '0' COMMENT '任务执行时间',
  `system_task_type` tinyint NOT NULL DEFAULT '3' COMMENT '任务类型 3、JOB任务 4、WORKFLOW任务',
  `parent_id` varchar(64) NOT NULL DEFAULT '' COMMENT '父节点',
  `ext_attrs` varchar(256) DEFAULT '' COMMENT '扩展字段',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除 1、删除',
  `create_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `idx_job_id_task_batch_status` (`job_id`,`task_batch_status`),
  KEY `idx_create_dt` (`create_dt`),
  KEY `idx_namespace_id_group_name` (`namespace_id`,`group_name`),
  KEY `idx_workflow_task_batch_id_workflow_node_id` (`workflow_task_batch_id`,`workflow_node_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='任务批次';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sj_job_task_batch`
--

LOCK TABLES `sj_job_task_batch` WRITE;
/*!40000 ALTER TABLE `sj_job_task_batch` DISABLE KEYS */;
/*!40000 ALTER TABLE `sj_job_task_batch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sj_namespace`
--

DROP TABLE IF EXISTS `sj_namespace`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sj_namespace` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(64) NOT NULL COMMENT '名称',
  `unique_id` varchar(64) NOT NULL COMMENT '唯一id',
  `description` varchar(256) NOT NULL DEFAULT '' COMMENT '描述',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除 1、删除',
  `create_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unique_id` (`unique_id`),
  KEY `idx_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='命名空间';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sj_namespace`
--

LOCK TABLES `sj_namespace` WRITE;
/*!40000 ALTER TABLE `sj_namespace` DISABLE KEYS */;
INSERT INTO `sj_namespace` VALUES (1,'Development','dev','',0,'2026-05-21 23:14:52','2026-05-21 23:14:52'),(2,'Production','prod','',0,'2026-05-21 23:14:52','2026-05-21 23:14:52');
/*!40000 ALTER TABLE `sj_namespace` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sj_notify_config`
--

DROP TABLE IF EXISTS `sj_notify_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sj_notify_config` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `namespace_id` varchar(64) NOT NULL DEFAULT '764d604ec6fc45f68cd92514c40e9e1a' COMMENT '命名空间id',
  `group_name` varchar(64) NOT NULL COMMENT '组名称',
  `notify_name` varchar(64) NOT NULL DEFAULT '' COMMENT '通知名称',
  `system_task_type` tinyint NOT NULL DEFAULT '3' COMMENT '任务类型 1. 重试任务 2. 重试回调 3、JOB任务 4、WORKFLOW任务',
  `notify_status` tinyint NOT NULL DEFAULT '0' COMMENT '通知状态 0、未启用 1、启用',
  `recipient_ids` varchar(128) NOT NULL COMMENT '接收人id列表',
  `notify_threshold` int NOT NULL DEFAULT '0' COMMENT '通知阈值',
  `notify_scene` tinyint NOT NULL DEFAULT '0' COMMENT '通知场景',
  `rate_limiter_status` tinyint NOT NULL DEFAULT '0' COMMENT '限流状态 0、未启用 1、启用',
  `rate_limiter_threshold` int NOT NULL DEFAULT '0' COMMENT '每秒限流阈值',
  `description` varchar(256) NOT NULL DEFAULT '' COMMENT '描述',
  `create_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `idx_namespace_id_group_name_scene_name` (`namespace_id`,`group_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='通知配置';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sj_notify_config`
--

LOCK TABLES `sj_notify_config` WRITE;
/*!40000 ALTER TABLE `sj_notify_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `sj_notify_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sj_notify_recipient`
--

DROP TABLE IF EXISTS `sj_notify_recipient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sj_notify_recipient` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `namespace_id` varchar(64) NOT NULL DEFAULT '764d604ec6fc45f68cd92514c40e9e1a' COMMENT '命名空间id',
  `recipient_name` varchar(64) NOT NULL COMMENT '接收人名称',
  `notify_type` tinyint NOT NULL DEFAULT '0' COMMENT '通知类型 1、钉钉 2、邮件 3、企业微信 4 飞书 5 webhook',
  `notify_attribute` varchar(512) NOT NULL COMMENT '配置属性',
  `description` varchar(256) NOT NULL DEFAULT '' COMMENT '描述',
  `create_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `idx_namespace_id` (`namespace_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='告警通知接收人';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sj_notify_recipient`
--

LOCK TABLES `sj_notify_recipient` WRITE;
/*!40000 ALTER TABLE `sj_notify_recipient` DISABLE KEYS */;
/*!40000 ALTER TABLE `sj_notify_recipient` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sj_retry`
--

DROP TABLE IF EXISTS `sj_retry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sj_retry` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `namespace_id` varchar(64) NOT NULL DEFAULT '764d604ec6fc45f68cd92514c40e9e1a' COMMENT '命名空间id',
  `group_name` varchar(64) NOT NULL COMMENT '组名称',
  `group_id` bigint NOT NULL COMMENT '组Id',
  `scene_name` varchar(64) NOT NULL COMMENT '场景名称',
  `scene_id` bigint NOT NULL COMMENT '场景ID',
  `idempotent_id` varchar(64) NOT NULL COMMENT '幂等id',
  `biz_no` varchar(64) NOT NULL DEFAULT '' COMMENT '业务编号',
  `executor_name` varchar(512) NOT NULL DEFAULT '' COMMENT '执行器名称',
  `args_str` text NOT NULL COMMENT '执行方法参数',
  `ext_attrs` text NOT NULL COMMENT '扩展字段',
  `serializer_name` varchar(32) NOT NULL DEFAULT 'jackson' COMMENT '执行方法参数序列化器名称',
  `next_trigger_at` bigint NOT NULL COMMENT '下次触发时间',
  `retry_count` int NOT NULL DEFAULT '0' COMMENT '重试次数',
  `retry_status` tinyint NOT NULL DEFAULT '0' COMMENT '重试状态 0、重试中 1、成功 2、最大重试次数',
  `task_type` tinyint NOT NULL DEFAULT '1' COMMENT '任务类型 1、重试数据 2、回调数据',
  `bucket_index` int NOT NULL DEFAULT '0' COMMENT 'bucket',
  `parent_id` bigint NOT NULL DEFAULT '0' COMMENT '父节点id',
  `deleted` bigint NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  `create_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_scene_tasktype_idempotentid_deleted` (`scene_id`,`task_type`,`idempotent_id`,`deleted`),
  KEY `idx_biz_no` (`biz_no`),
  KEY `idx_idempotent_id` (`idempotent_id`),
  KEY `idx_retry_status_bucket_index` (`retry_status`,`bucket_index`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_create_dt` (`create_dt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='重试信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sj_retry`
--

LOCK TABLES `sj_retry` WRITE;
/*!40000 ALTER TABLE `sj_retry` DISABLE KEYS */;
/*!40000 ALTER TABLE `sj_retry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sj_retry_dead_letter`
--

DROP TABLE IF EXISTS `sj_retry_dead_letter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sj_retry_dead_letter` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `namespace_id` varchar(64) NOT NULL DEFAULT '764d604ec6fc45f68cd92514c40e9e1a' COMMENT '命名空间id',
  `group_name` varchar(64) NOT NULL COMMENT '组名称',
  `group_id` bigint NOT NULL COMMENT '组Id',
  `scene_name` varchar(64) NOT NULL COMMENT '场景名称',
  `scene_id` bigint NOT NULL COMMENT '场景ID',
  `idempotent_id` varchar(64) NOT NULL COMMENT '幂等id',
  `biz_no` varchar(64) NOT NULL DEFAULT '' COMMENT '业务编号',
  `executor_name` varchar(512) NOT NULL DEFAULT '' COMMENT '执行器名称',
  `serializer_name` varchar(32) NOT NULL DEFAULT 'jackson' COMMENT '执行方法参数序列化器名称',
  `args_str` text NOT NULL COMMENT '执行方法参数',
  `ext_attrs` text NOT NULL COMMENT '扩展字段',
  `create_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_namespace_id_group_name_scene_name` (`namespace_id`,`group_name`,`scene_name`),
  KEY `idx_idempotent_id` (`idempotent_id`),
  KEY `idx_biz_no` (`biz_no`),
  KEY `idx_create_dt` (`create_dt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='死信队列表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sj_retry_dead_letter`
--

LOCK TABLES `sj_retry_dead_letter` WRITE;
/*!40000 ALTER TABLE `sj_retry_dead_letter` DISABLE KEYS */;
/*!40000 ALTER TABLE `sj_retry_dead_letter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sj_retry_scene_config`
--

DROP TABLE IF EXISTS `sj_retry_scene_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sj_retry_scene_config` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `namespace_id` varchar(64) NOT NULL DEFAULT '764d604ec6fc45f68cd92514c40e9e1a' COMMENT '命名空间id',
  `scene_name` varchar(64) NOT NULL COMMENT '场景名称',
  `group_name` varchar(64) NOT NULL COMMENT '组名称',
  `scene_status` tinyint NOT NULL DEFAULT '0' COMMENT '组状态 0、未启用 1、启用',
  `max_retry_count` int NOT NULL DEFAULT '5' COMMENT '最大重试次数',
  `back_off` tinyint NOT NULL DEFAULT '1' COMMENT '1、默认等级 2、固定间隔时间 3、CRON 表达式',
  `trigger_interval` varchar(16) NOT NULL DEFAULT '' COMMENT '间隔时长',
  `notify_ids` varchar(128) NOT NULL DEFAULT '' COMMENT '通知告警场景配置id列表',
  `deadline_request` bigint unsigned NOT NULL DEFAULT '60000' COMMENT 'Deadline Request 调用链超时 单位毫秒',
  `executor_timeout` int unsigned NOT NULL DEFAULT '5' COMMENT '任务执行超时时间，单位秒',
  `route_key` tinyint NOT NULL DEFAULT '4' COMMENT '路由策略',
  `block_strategy` tinyint NOT NULL DEFAULT '1' COMMENT '阻塞策略 1、丢弃 2、覆盖 3、并行',
  `cb_status` tinyint NOT NULL DEFAULT '0' COMMENT '回调状态 0、不开启 1、开启',
  `cb_trigger_type` tinyint NOT NULL DEFAULT '1' COMMENT '1、默认等级 2、固定间隔时间 3、CRON 表达式',
  `cb_max_count` int NOT NULL DEFAULT '16' COMMENT '回调的最大执行次数',
  `cb_trigger_interval` varchar(16) NOT NULL DEFAULT '' COMMENT '回调的最大执行次数',
  `owner_id` bigint DEFAULT NULL COMMENT '负责人id',
  `labels` varchar(512) DEFAULT '' COMMENT '标签',
  `description` varchar(256) NOT NULL DEFAULT '' COMMENT '描述',
  `create_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_namespace_id_group_name_scene_name` (`namespace_id`,`group_name`,`scene_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='场景配置';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sj_retry_scene_config`
--

LOCK TABLES `sj_retry_scene_config` WRITE;
/*!40000 ALTER TABLE `sj_retry_scene_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `sj_retry_scene_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sj_retry_summary`
--

DROP TABLE IF EXISTS `sj_retry_summary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sj_retry_summary` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `namespace_id` varchar(64) NOT NULL DEFAULT '764d604ec6fc45f68cd92514c40e9e1a' COMMENT '命名空间id',
  `group_name` varchar(64) NOT NULL DEFAULT '' COMMENT '组名称',
  `scene_name` varchar(64) NOT NULL DEFAULT '' COMMENT '场景名称',
  `trigger_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '统计时间',
  `running_num` int NOT NULL DEFAULT '0' COMMENT '重试中-日志数量',
  `finish_num` int NOT NULL DEFAULT '0' COMMENT '重试完成-日志数量',
  `max_count_num` int NOT NULL DEFAULT '0' COMMENT '重试到达最大次数-日志数量',
  `suspend_num` int NOT NULL DEFAULT '0' COMMENT '暂停重试-日志数量',
  `create_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_scene_name_trigger_at` (`namespace_id`,`group_name`,`scene_name`,`trigger_at`) USING BTREE,
  KEY `idx_trigger_at` (`trigger_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='DashBoard_Retry';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sj_retry_summary`
--

LOCK TABLES `sj_retry_summary` WRITE;
/*!40000 ALTER TABLE `sj_retry_summary` DISABLE KEYS */;
/*!40000 ALTER TABLE `sj_retry_summary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sj_retry_task`
--

DROP TABLE IF EXISTS `sj_retry_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sj_retry_task` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `namespace_id` varchar(64) NOT NULL DEFAULT '764d604ec6fc45f68cd92514c40e9e1a' COMMENT '命名空间id',
  `group_name` varchar(64) NOT NULL COMMENT '组名称',
  `scene_name` varchar(64) NOT NULL COMMENT '场景名称',
  `retry_id` bigint NOT NULL COMMENT '重试信息Id',
  `ext_attrs` text NOT NULL COMMENT '扩展字段',
  `task_status` tinyint NOT NULL DEFAULT '1' COMMENT '重试状态',
  `task_type` tinyint NOT NULL DEFAULT '1' COMMENT '任务类型 1、重试数据 2、回调数据',
  `operation_reason` tinyint NOT NULL DEFAULT '0' COMMENT '操作原因',
  `client_info` varchar(128) DEFAULT NULL COMMENT '客户端地址 clientId#ip:port',
  `create_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `idx_group_name_scene_name` (`namespace_id`,`group_name`,`scene_name`),
  KEY `task_status` (`task_status`),
  KEY `idx_create_dt` (`create_dt`),
  KEY `idx_retry_id` (`retry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='重试任务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sj_retry_task`
--

LOCK TABLES `sj_retry_task` WRITE;
/*!40000 ALTER TABLE `sj_retry_task` DISABLE KEYS */;
/*!40000 ALTER TABLE `sj_retry_task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sj_retry_task_log_message`
--

DROP TABLE IF EXISTS `sj_retry_task_log_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sj_retry_task_log_message` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `namespace_id` varchar(64) NOT NULL DEFAULT '764d604ec6fc45f68cd92514c40e9e1a' COMMENT '命名空间id',
  `group_name` varchar(64) NOT NULL COMMENT '组名称',
  `retry_id` bigint NOT NULL COMMENT '重试信息Id',
  `retry_task_id` bigint NOT NULL COMMENT '重试任务Id',
  `message` longtext NOT NULL COMMENT '异常信息',
  `log_num` int NOT NULL DEFAULT '1' COMMENT '日志数量',
  `real_time` bigint NOT NULL DEFAULT '0' COMMENT '上报时间',
  `create_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_namespace_id_group_name_retry_task_id` (`namespace_id`,`group_name`,`retry_task_id`),
  KEY `idx_create_dt` (`create_dt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='任务调度日志信息记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sj_retry_task_log_message`
--

LOCK TABLES `sj_retry_task_log_message` WRITE;
/*!40000 ALTER TABLE `sj_retry_task_log_message` DISABLE KEYS */;
/*!40000 ALTER TABLE `sj_retry_task_log_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sj_server_node`
--

DROP TABLE IF EXISTS `sj_server_node`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sj_server_node` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `namespace_id` varchar(64) NOT NULL DEFAULT '764d604ec6fc45f68cd92514c40e9e1a' COMMENT '命名空间id',
  `group_name` varchar(64) NOT NULL COMMENT '组名称',
  `host_id` varchar(64) NOT NULL COMMENT '主机id',
  `host_ip` varchar(64) NOT NULL COMMENT '机器ip',
  `host_port` int NOT NULL COMMENT '机器端口',
  `expire_at` datetime NOT NULL COMMENT '过期时间',
  `node_type` tinyint NOT NULL COMMENT '节点类型 1、客户端 2、是服务端',
  `ext_attrs` varchar(256) DEFAULT '' COMMENT '扩展字段',
  `labels` varchar(512) DEFAULT '' COMMENT '标签',
  `create_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_host_id_host_ip` (`host_id`,`host_ip`),
  KEY `idx_namespace_id_group_name` (`namespace_id`,`group_name`),
  KEY `idx_expire_at_node_type` (`expire_at`,`node_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='服务器节点';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sj_server_node`
--

LOCK TABLES `sj_server_node` WRITE;
/*!40000 ALTER TABLE `sj_server_node` DISABLE KEYS */;
/*!40000 ALTER TABLE `sj_server_node` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sj_system_user`
--

DROP TABLE IF EXISTS `sj_system_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sj_system_user` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username` varchar(64) NOT NULL COMMENT '账号',
  `password` varchar(128) NOT NULL COMMENT '密码',
  `role` tinyint NOT NULL DEFAULT '0' COMMENT '角色：1-普通用户、2-管理员',
  `create_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sj_system_user`
--

LOCK TABLES `sj_system_user` WRITE;
/*!40000 ALTER TABLE `sj_system_user` DISABLE KEYS */;
INSERT INTO `sj_system_user` VALUES (1,'admin','465c194afb65670f38322df087f0a9bb225cc257e43eb4ac5a0c98ef5b3173ac',2,'2026-05-21 23:14:52','2026-05-21 23:14:52');
/*!40000 ALTER TABLE `sj_system_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sj_system_user_permission`
--

DROP TABLE IF EXISTS `sj_system_user_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sj_system_user_permission` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `group_name` varchar(64) NOT NULL COMMENT '组名称',
  `namespace_id` varchar(64) NOT NULL DEFAULT '764d604ec6fc45f68cd92514c40e9e1a' COMMENT '命名空间id',
  `system_user_id` bigint NOT NULL COMMENT '系统用户id',
  `create_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_namespace_id_group_name_system_user_id` (`namespace_id`,`group_name`,`system_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统用户权限表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sj_system_user_permission`
--

LOCK TABLES `sj_system_user_permission` WRITE;
/*!40000 ALTER TABLE `sj_system_user_permission` DISABLE KEYS */;
/*!40000 ALTER TABLE `sj_system_user_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sj_workflow`
--

DROP TABLE IF EXISTS `sj_workflow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sj_workflow` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `workflow_name` varchar(64) NOT NULL COMMENT '工作流名称',
  `namespace_id` varchar(64) NOT NULL DEFAULT '764d604ec6fc45f68cd92514c40e9e1a' COMMENT '命名空间id',
  `biz_id` varchar(64) NOT NULL COMMENT '业务ID',
  `group_name` varchar(64) NOT NULL COMMENT '组名称',
  `workflow_status` tinyint NOT NULL DEFAULT '1' COMMENT '工作流状态 0、关闭、1、开启',
  `trigger_type` tinyint NOT NULL COMMENT '触发类型 1.CRON 表达式 2. 固定时间',
  `trigger_interval` varchar(255) NOT NULL COMMENT '间隔时长',
  `next_trigger_at` bigint NOT NULL COMMENT '下次触发时间',
  `block_strategy` tinyint NOT NULL DEFAULT '1' COMMENT '阻塞策略 1、丢弃 2、覆盖 3、并行',
  `executor_timeout` int NOT NULL DEFAULT '0' COMMENT '任务执行超时时间，单位秒',
  `description` varchar(256) NOT NULL DEFAULT '' COMMENT '描述',
  `flow_info` text COMMENT '流程信息',
  `wf_context` text COMMENT '上下文',
  `notify_ids` varchar(128) NOT NULL DEFAULT '' COMMENT '通知告警场景配置id列表',
  `bucket_index` int NOT NULL DEFAULT '0' COMMENT 'bucket',
  `version` int NOT NULL COMMENT '版本号',
  `owner_id` bigint DEFAULT NULL COMMENT '负责人id',
  `ext_attrs` varchar(256) DEFAULT '' COMMENT '扩展字段',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除 1、删除',
  `create_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sj_workflow_01` (`namespace_id`,`biz_id`),
  KEY `idx_create_dt` (`create_dt`),
  KEY `idx_namespace_id_group_name` (`namespace_id`,`group_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='工作流';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sj_workflow`
--

LOCK TABLES `sj_workflow` WRITE;
/*!40000 ALTER TABLE `sj_workflow` DISABLE KEYS */;
/*!40000 ALTER TABLE `sj_workflow` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sj_workflow_node`
--

DROP TABLE IF EXISTS `sj_workflow_node`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sj_workflow_node` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `namespace_id` varchar(64) NOT NULL DEFAULT '764d604ec6fc45f68cd92514c40e9e1a' COMMENT '命名空间id',
  `node_name` varchar(64) NOT NULL COMMENT '节点名称',
  `group_name` varchar(64) NOT NULL COMMENT '组名称',
  `job_id` bigint NOT NULL COMMENT '任务信息id',
  `workflow_id` bigint NOT NULL COMMENT '工作流ID',
  `node_type` tinyint NOT NULL DEFAULT '1' COMMENT '1、任务节点 2、条件节点',
  `expression_type` tinyint NOT NULL DEFAULT '0' COMMENT '1、SpEl、2、Aviator 3、QL',
  `fail_strategy` tinyint NOT NULL DEFAULT '1' COMMENT '失败策略 1、跳过 2、阻塞',
  `workflow_node_status` tinyint NOT NULL DEFAULT '1' COMMENT '工作流节点状态 0、关闭、1、开启',
  `priority_level` int NOT NULL DEFAULT '1' COMMENT '优先级',
  `node_info` text COMMENT '节点信息 ',
  `version` int NOT NULL COMMENT '版本号',
  `ext_attrs` varchar(256) DEFAULT '' COMMENT '扩展字段',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除 1、删除',
  `create_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `idx_create_dt` (`create_dt`),
  KEY `idx_namespace_id_group_name` (`namespace_id`,`group_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='工作流节点';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sj_workflow_node`
--

LOCK TABLES `sj_workflow_node` WRITE;
/*!40000 ALTER TABLE `sj_workflow_node` DISABLE KEYS */;
/*!40000 ALTER TABLE `sj_workflow_node` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sj_workflow_task_batch`
--

DROP TABLE IF EXISTS `sj_workflow_task_batch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sj_workflow_task_batch` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `namespace_id` varchar(64) NOT NULL DEFAULT '764d604ec6fc45f68cd92514c40e9e1a' COMMENT '命名空间id',
  `group_name` varchar(64) NOT NULL COMMENT '组名称',
  `workflow_id` bigint NOT NULL COMMENT '工作流任务id',
  `task_batch_status` tinyint NOT NULL DEFAULT '0' COMMENT '任务批次状态 0、失败 1、成功',
  `operation_reason` tinyint NOT NULL DEFAULT '0' COMMENT '操作原因',
  `flow_info` text COMMENT '流程信息',
  `wf_context` text COMMENT '全局上下文',
  `execution_at` bigint NOT NULL DEFAULT '0' COMMENT '任务执行时间',
  `ext_attrs` varchar(256) DEFAULT '' COMMENT '扩展字段',
  `version` int NOT NULL DEFAULT '1' COMMENT '版本号',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除 1、删除',
  `create_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_dt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `idx_job_id_task_batch_status` (`workflow_id`,`task_batch_status`),
  KEY `idx_create_dt` (`create_dt`),
  KEY `idx_namespace_id_group_name` (`namespace_id`,`group_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='工作流批次';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sj_workflow_task_batch`
--

LOCK TABLES `sj_workflow_task_batch` WRITE;
/*!40000 ALTER TABLE `sj_workflow_task_batch` DISABLE KEYS */;
/*!40000 ALTER TABLE `sj_workflow_task_batch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `state_province`
--

DROP TABLE IF EXISTS `state_province`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `state_province` (
  `id` bigint NOT NULL COMMENT '主键（雪花ID）',
  `tenant_id` varchar(20) NOT NULL COMMENT '租户ID',
  `country_code` varchar(10) NOT NULL COMMENT '所属国家代码',
  `code` varchar(20) NOT NULL COMMENT '州/省代码（如CA/NY）',
  `name_en` varchar(100) NOT NULL COMMENT '英文名称',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序',
  `status` char(1) NOT NULL DEFAULT '0' COMMENT '状态（0=正常，1=停用）',
  `create_by` bigint DEFAULT NULL COMMENT '???',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '???',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` bigint DEFAULT '0' COMMENT '逻辑删除（0=存在，1=删除）',
  `create_dept` bigint DEFAULT NULL COMMENT '????',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_country_code` (`tenant_id`,`country_code`,`code`),
  KEY `idx_country_code` (`tenant_id`,`country_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='州/省管理（GEO-001）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `state_province`
--

LOCK TABLES `state_province` WRITE;
/*!40000 ALTER TABLE `state_province` DISABLE KEYS */;
INSERT INTO `state_province` VALUES (3001001,'000000','US','CA','California',1,'0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3001002,'000000','US','NY','New York',2,'0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3001003,'000000','US','TX','Texas',3,'0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3001004,'000000','US','FL','Florida',4,'0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3001005,'000000','US','IL','Illinois',5,'0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3001006,'000000','US','NJ','New Jersey',6,'0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3001007,'000000','US','WA','Washington',7,'0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3001008,'000000','US','GA','Georgia',8,'0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3001009,'000000','US','PA','Pennsylvania',9,'0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3001010,'000000','US','OH','Ohio',10,'0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3001011,'000000','CN','GD','Guangdong',1,'0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3001012,'000000','CN','ZJ','Zhejiang',2,'0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3001013,'000000','CN','JS','Jiangsu',3,'0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3001014,'000000','CN','SH','Shanghai',4,'0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3001015,'000000','CN','BJ','Beijing',5,'0',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL);
/*!40000 ALTER TABLE `state_province` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_client`
--

DROP TABLE IF EXISTS `sys_client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_client` (
  `id` bigint NOT NULL COMMENT 'id',
  `client_id` varchar(64) DEFAULT NULL COMMENT '客户端id',
  `client_key` varchar(32) DEFAULT NULL COMMENT '客户端key',
  `client_secret` varchar(255) DEFAULT NULL COMMENT '客户端秘钥',
  `grant_type` varchar(255) DEFAULT NULL COMMENT '授权类型',
  `device_type` varchar(32) DEFAULT NULL COMMENT '设备类型',
  `active_timeout` int DEFAULT '1800' COMMENT 'token活跃超时时间',
  `timeout` int DEFAULT '604800' COMMENT 'token固定超时',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统授权表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_client`
--

LOCK TABLES `sys_client` WRITE;
/*!40000 ALTER TABLE `sys_client` DISABLE KEYS */;
INSERT INTO `sys_client` VALUES (1,'e5cd7e4891bf95d1d19206ce24a7b32e','pc','pc123','password,social','pc',1800,604800,'0','0',103,1,'2026-05-21 23:15:05',1,'2026-05-21 23:15:05'),(2,'428a8310cd442757ae699df5d894f051','app','app123','password,sms,social','android',1800,604800,'0','0',103,1,'2026-05-21 23:15:05',1,'2026-05-21 23:15:05');
/*!40000 ALTER TABLE `sys_client` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_config`
--

DROP TABLE IF EXISTS `sys_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_config` (
  `config_id` bigint NOT NULL COMMENT '参数主键',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `config_name` varchar(100) DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='参数配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_config`
--

LOCK TABLES `sys_config` WRITE;
/*!40000 ALTER TABLE `sys_config` DISABLE KEYS */;
INSERT INTO `sys_config` VALUES (1,'000000','主框架页-默认皮肤样式名称','sys.index.skinName','skin-blue','Y',103,1,'2026-05-21 23:15:05',NULL,NULL,'蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow'),(2,'000000','用户管理-账号初始密码','sys.user.initPassword','123456','Y',103,1,'2026-05-21 23:15:05',NULL,NULL,'初始化密码 123456'),(3,'000000','主框架页-侧边栏主题','sys.index.sideTheme','theme-dark','Y',103,1,'2026-05-21 23:15:05',NULL,NULL,'深色主题theme-dark，浅色主题theme-light'),(5,'000000','账号自助-是否开启用户注册功能','sys.account.registerUser','false','Y',103,1,'2026-05-21 23:15:05',NULL,NULL,'是否开启注册用户功能（true开启，false关闭）'),(11,'000000','OSS预览列表资源开关','sys.oss.previewListResource','true','Y',103,1,'2026-05-21 23:15:05',NULL,NULL,'true:开启, false:关闭');
/*!40000 ALTER TABLE `sys_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dept`
--

DROP TABLE IF EXISTS `sys_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dept` (
  `dept_id` bigint NOT NULL COMMENT '部门id',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `parent_id` bigint DEFAULT '0' COMMENT '父部门id',
  `ancestors` varchar(500) DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) DEFAULT '' COMMENT '部门名称',
  `dept_category` varchar(100) DEFAULT NULL COMMENT '部门类别编码',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `leader` bigint DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) DEFAULT NULL COMMENT '邮箱',
  `status` char(1) DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='部门表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dept`
--

LOCK TABLES `sys_dept` WRITE;
/*!40000 ALTER TABLE `sys_dept` DISABLE KEYS */;
INSERT INTO `sys_dept` VALUES (100,'000000',0,'0','XXX科技',NULL,0,NULL,'15888888888','xxx@qq.com','0','0',103,1,'2026-05-21 23:15:03',NULL,NULL),(101,'000000',100,'0,100','深圳总公司',NULL,1,NULL,'15888888888','xxx@qq.com','0','0',103,1,'2026-05-21 23:15:03',NULL,NULL),(102,'000000',100,'0,100','长沙分公司',NULL,2,NULL,'15888888888','xxx@qq.com','0','0',103,1,'2026-05-21 23:15:03',NULL,NULL),(103,'000000',101,'0,100,101','研发部门',NULL,1,1,'15888888888','xxx@qq.com','0','0',103,1,'2026-05-21 23:15:03',NULL,NULL),(104,'000000',101,'0,100,101','市场部门',NULL,2,NULL,'15888888888','xxx@qq.com','0','0',103,1,'2026-05-21 23:15:03',NULL,NULL),(105,'000000',101,'0,100,101','测试部门',NULL,3,NULL,'15888888888','xxx@qq.com','0','0',103,1,'2026-05-21 23:15:03',NULL,NULL),(106,'000000',101,'0,100,101','财务部门',NULL,4,NULL,'15888888888','xxx@qq.com','0','0',103,1,'2026-05-21 23:15:03',NULL,NULL),(107,'000000',101,'0,100,101','运维部门',NULL,5,NULL,'15888888888','xxx@qq.com','0','0',103,1,'2026-05-21 23:15:03',NULL,NULL),(108,'000000',102,'0,100,102','市场部门',NULL,1,NULL,'15888888888','xxx@qq.com','0','0',103,1,'2026-05-21 23:15:03',NULL,NULL),(109,'000000',102,'0,100,102','财务部门',NULL,2,NULL,'15888888888','xxx@qq.com','0','0',103,1,'2026-05-21 23:15:03',NULL,NULL);
/*!40000 ALTER TABLE `sys_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_data`
--

DROP TABLE IF EXISTS `sys_dict_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_data` (
  `dict_code` bigint NOT NULL COMMENT '字典编码',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `dict_sort` int DEFAULT '0' COMMENT '字典排序',
  `dict_label` varchar(100) DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='字典数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_data`
--

LOCK TABLES `sys_dict_data` WRITE;
/*!40000 ALTER TABLE `sys_dict_data` DISABLE KEYS */;
INSERT INTO `sys_dict_data` VALUES (0,'000000',1,'分区盘点','ZONE','yms_inventory_type','','info','N',103,1,'2026-05-29 12:15:15',NULL,NULL,''),(1,'000000',1,'男','0','sys_user_sex','','','Y',103,1,'2026-05-21 23:15:04',NULL,NULL,'性别男'),(2,'000000',2,'女','1','sys_user_sex','','','N',103,1,'2026-05-21 23:15:04',NULL,NULL,'性别女'),(3,'000000',3,'未知','2','sys_user_sex','','','N',103,1,'2026-05-21 23:15:04',NULL,NULL,'性别未知'),(4,'000000',1,'显示','0','sys_show_hide','','primary','Y',103,1,'2026-05-21 23:15:04',NULL,NULL,'显示菜单'),(5,'000000',2,'隐藏','1','sys_show_hide','','danger','N',103,1,'2026-05-21 23:15:04',NULL,NULL,'隐藏菜单'),(6,'000000',1,'正常','0','sys_normal_disable','','primary','Y',103,1,'2026-05-21 23:15:04',NULL,NULL,'正常状态'),(7,'000000',2,'停用','1','sys_normal_disable','','danger','N',103,1,'2026-05-21 23:15:04',NULL,NULL,'停用状态'),(12,'000000',1,'是','Y','sys_yes_no','','primary','Y',103,1,'2026-05-21 23:15:04',NULL,NULL,'系统默认是'),(13,'000000',2,'否','N','sys_yes_no','','danger','N',103,1,'2026-05-21 23:15:04',NULL,NULL,'系统默认否'),(14,'000000',1,'通知','1','sys_notice_type','','warning','Y',103,1,'2026-05-21 23:15:04',NULL,NULL,'通知'),(15,'000000',2,'公告','2','sys_notice_type','','success','N',103,1,'2026-05-21 23:15:04',NULL,NULL,'公告'),(16,'000000',1,'正常','0','sys_notice_status','','primary','Y',103,1,'2026-05-21 23:15:04',NULL,NULL,'正常状态'),(17,'000000',2,'关闭','1','sys_notice_status','','danger','N',103,1,'2026-05-21 23:15:04',NULL,NULL,'关闭状态'),(18,'000000',1,'新增','1','sys_oper_type','','info','N',103,1,'2026-05-21 23:15:04',NULL,NULL,'新增操作'),(19,'000000',2,'修改','2','sys_oper_type','','info','N',103,1,'2026-05-21 23:15:04',NULL,NULL,'修改操作'),(20,'000000',3,'删除','3','sys_oper_type','','danger','N',103,1,'2026-05-21 23:15:04',NULL,NULL,'删除操作'),(21,'000000',4,'授权','4','sys_oper_type','','primary','N',103,1,'2026-05-21 23:15:04',NULL,NULL,'授权操作'),(22,'000000',5,'导出','5','sys_oper_type','','warning','N',103,1,'2026-05-21 23:15:04',NULL,NULL,'导出操作'),(23,'000000',6,'导入','6','sys_oper_type','','warning','N',103,1,'2026-05-21 23:15:04',NULL,NULL,'导入操作'),(24,'000000',7,'强退','7','sys_oper_type','','danger','N',103,1,'2026-05-21 23:15:04',NULL,NULL,'强退操作'),(25,'000000',8,'生成代码','8','sys_oper_type','','warning','N',103,1,'2026-05-21 23:15:04',NULL,NULL,'生成操作'),(26,'000000',9,'清空数据','9','sys_oper_type','','danger','N',103,1,'2026-05-21 23:15:04',NULL,NULL,'清空操作'),(27,'000000',1,'成功','0','sys_common_status','','primary','N',103,1,'2026-05-21 23:15:04',NULL,NULL,'正常状态'),(28,'000000',2,'失败','1','sys_common_status','','danger','N',103,1,'2026-05-21 23:15:04',NULL,NULL,'停用状态'),(29,'000000',99,'其他','0','sys_oper_type','','info','N',103,1,'2026-05-21 23:15:04',NULL,NULL,'其他操作'),(30,'000000',0,'密码认证','password','sys_grant_type','el-check-tag','default','N',103,1,'2026-05-21 23:15:04',NULL,NULL,'密码认证'),(31,'000000',0,'短信认证','sms','sys_grant_type','el-check-tag','default','N',103,1,'2026-05-21 23:15:04',NULL,NULL,'短信认证'),(32,'000000',0,'邮件认证','email','sys_grant_type','el-check-tag','default','N',103,1,'2026-05-21 23:15:04',NULL,NULL,'邮件认证'),(33,'000000',0,'小程序认证','xcx','sys_grant_type','el-check-tag','default','N',103,1,'2026-05-21 23:15:04',NULL,NULL,'小程序认证'),(34,'000000',0,'三方登录认证','social','sys_grant_type','el-check-tag','default','N',103,1,'2026-05-21 23:15:04',NULL,NULL,'三方登录认证'),(35,'000000',0,'PC','pc','sys_device_type','','default','N',103,1,'2026-05-21 23:15:04',NULL,NULL,'PC'),(36,'000000',0,'安卓','android','sys_device_type','','default','N',103,1,'2026-05-21 23:15:04',NULL,NULL,'安卓'),(37,'000000',0,'iOS','ios','sys_device_type','','default','N',103,1,'2026-05-21 23:15:04',NULL,NULL,'iOS'),(38,'000000',0,'小程序','xcx','sys_device_type','','default','N',103,1,'2026-05-21 23:15:04',NULL,NULL,'小程序'),(39,'000000',1,'已撤销','cancel','wf_business_status','','danger','N',103,1,'2026-05-21 23:15:15',NULL,NULL,'已撤销'),(40,'000000',2,'草稿','draft','wf_business_status','','info','N',103,1,'2026-05-21 23:15:15',NULL,NULL,'草稿'),(41,'000000',3,'待审核','waiting','wf_business_status','','primary','N',103,1,'2026-05-21 23:15:15',NULL,NULL,'待审核'),(42,'000000',4,'已完成','finish','wf_business_status','','success','N',103,1,'2026-05-21 23:15:15',NULL,NULL,'已完成'),(43,'000000',5,'已作废','invalid','wf_business_status','','danger','N',103,1,'2026-05-21 23:15:15',NULL,NULL,'已作废'),(44,'000000',6,'已退回','back','wf_business_status','','danger','N',103,1,'2026-05-21 23:15:15',NULL,NULL,'已退回'),(45,'000000',7,'已终止','termination','wf_business_status','','danger','N',103,1,'2026-05-21 23:15:15',NULL,NULL,'已终止'),(46,'000000',1,'自定义表单','static','wf_form_type','','success','N',103,1,'2026-05-21 23:15:15',NULL,NULL,'自定义表单'),(47,'000000',2,'动态表单','dynamic','wf_form_type','','primary','N',103,1,'2026-05-21 23:15:15',NULL,NULL,'动态表单'),(48,'000000',1,'撤销','cancel','wf_task_status','','danger','N',103,1,'2026-05-21 23:15:15',NULL,NULL,'撤销'),(49,'000000',2,'通过','pass','wf_task_status','','success','N',103,1,'2026-05-21 23:15:15',NULL,NULL,'通过'),(50,'000000',3,'待审核','waiting','wf_task_status','','primary','N',103,1,'2026-05-21 23:15:15',NULL,NULL,'待审核'),(51,'000000',4,'作废','invalid','wf_task_status','','danger','N',103,1,'2026-05-21 23:15:15',NULL,NULL,'作废'),(52,'000000',5,'退回','back','wf_task_status','','danger','N',103,1,'2026-05-21 23:15:15',NULL,NULL,'退回'),(53,'000000',6,'终止','termination','wf_task_status','','danger','N',103,1,'2026-05-21 23:15:15',NULL,NULL,'终止'),(54,'000000',7,'转办','transfer','wf_task_status','','primary','N',103,1,'2026-05-21 23:15:15',NULL,NULL,'转办'),(55,'000000',8,'委托','depute','wf_task_status','','primary','N',103,1,'2026-05-21 23:15:15',NULL,NULL,'委托'),(56,'000000',9,'抄送','copy','wf_task_status','','primary','N',103,1,'2026-05-21 23:15:15',NULL,NULL,'抄送'),(57,'000000',10,'加签','sign','wf_task_status','','primary','N',103,1,'2026-05-21 23:15:15',NULL,NULL,'加签'),(58,'000000',11,'减签','sign_off','wf_task_status','','danger','N',103,1,'2026-05-21 23:15:15',NULL,NULL,'减签'),(59,'000000',11,'超时','timeout','wf_task_status','','danger','N',103,1,'2026-05-21 23:15:15',NULL,NULL,'超时'),(100,'000000',10,'入库','INBOUND','fee_category',NULL,'info','N',103,1,'2026-05-22 00:12:19',NULL,NULL,NULL),(101,'000000',20,'出库','OUTBOUND','fee_category',NULL,'success','N',103,1,'2026-05-22 00:12:19',NULL,NULL,NULL),(102,'000000',30,'仓储','STORAGE','fee_category',NULL,'warning','N',103,1,'2026-05-22 00:12:19',NULL,NULL,NULL),(103,'000000',40,'退货','RETURN','fee_category',NULL,'error','N',103,1,'2026-05-22 00:12:19',NULL,NULL,NULL),(104,'000000',50,'运输','TRANSPORT','fee_category',NULL,'default','N',103,1,'2026-05-22 00:12:19',NULL,NULL,NULL),(105,'000000',60,'其他','OTHER','fee_category',NULL,'default','N',103,1,'2026-05-22 00:12:19',NULL,NULL,NULL),(106,'000000',10,'入库','INBOUND','fee_business_stage',NULL,'info','N',103,1,'2026-05-22 00:12:19',NULL,NULL,NULL),(107,'000000',20,'出库','OUTBOUND','fee_business_stage',NULL,'success','N',103,1,'2026-05-22 00:12:19',NULL,NULL,NULL),(108,'000000',30,'仓储','STORAGE','fee_business_stage',NULL,'warning','N',103,1,'2026-05-22 00:12:19',NULL,NULL,NULL),(109,'000000',40,'退货','RETURN','fee_business_stage',NULL,'error','N',103,1,'2026-05-22 00:12:19',NULL,NULL,NULL),(110,'000000',50,'运输','TRANSPORT','fee_business_stage',NULL,'default','N',103,1,'2026-05-22 00:12:19',NULL,NULL,NULL),(111,'000000',10,'一件代发','DROPSHIP','fulfillment_type',NULL,'info','N',103,1,'2026-05-22 00:12:19',NULL,NULL,NULL),(112,'000000',20,'FBA头程','FBA','fulfillment_type',NULL,'success','N',103,1,'2026-05-22 00:12:19',NULL,NULL,NULL),(113,'000000',30,'自提','SELF_PICKUP','fulfillment_type',NULL,'warning','N',103,1,'2026-05-22 00:12:19',NULL,NULL,NULL),(114,'000000',40,'转运','TRANSIT','fulfillment_type',NULL,'default','N',103,1,'2026-05-22 00:12:19',NULL,NULL,NULL),(115,'000000',10,'自营仓','SELF_OP','warehouse_type',NULL,'success','N',103,1,'2026-05-22 00:12:20',NULL,NULL,NULL),(116,'000000',20,'合作仓','PARTNER','warehouse_type',NULL,'info','N',103,1,'2026-05-22 00:12:20',NULL,NULL,NULL),(117,'000000',30,'中转仓','TRANSIT','warehouse_type',NULL,'warning','N',103,1,'2026-05-22 00:12:20',NULL,NULL,NULL),(118,'000000',40,'客户指定仓','CUSTOMER','warehouse_type',NULL,'default','N',103,1,'2026-05-22 00:12:20',NULL,NULL,NULL),(5000201,'000000',1,'海运','SEA','channel_type','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000202,'000000',2,'空运','AIR','channel_type','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000203,'000000',3,'快递','EXPRESS','channel_type','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000204,'000000',4,'铁运','RAIL','channel_type','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000205,'000000',5,'整车','TRUCK','channel_type','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000206,'000000',6,'本土散板','LOCAL_BULK','channel_type','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000207,'000000',7,'同行散板','PEER_BULK','channel_type','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000211,'000000',1,'整柜','FCL','container_mode','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000212,'000000',2,'拼柜','LCL','container_mode','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000213,'000000',3,'散货','BULK','container_mode','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000221,'000000',1,'仓储业务','WAREHOUSE','business_category','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000222,'000000',2,'运输业务','TRANSPORT','business_category','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000223,'000000',3,'增值服务','VAS','business_category','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000224,'000000',4,'售后业务','AFTER_SALES','business_category','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000231,'000000',1,'入库型','INBOUND','operation_flow_type','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000232,'000000',2,'出库型','OUTBOUND','operation_flow_type','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000233,'000000',3,'入出库型','INBOUND_OUTBOUND','operation_flow_type','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000234,'000000',4,'服务型','SERVICE','operation_flow_type','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000251,'000000',1,'按字段分货','FIELD_BASED','sorting_strategy','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000252,'000000',2,'不分货','NONE','sorting_strategy','','default','Y',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000261,'000000',1,'仓库代码','warehouse_code','sorting_field','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000262,'000000',2,'订单号','order_no','sorting_field','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000263,'000000',3,'SKU','sku','sorting_field','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000264,'000000',4,'PO号','po_no','sorting_field','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000265,'000000',5,'批次号','batch_no','sorting_field','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000266,'000000',6,'柜号','container_no','sorting_field','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000267,'000000',7,'目的仓代码','dest_warehouse','sorting_field','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000271,'000000',1,'标签类','LABEL','service_category','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000272,'000000',2,'包装类','PACKAGE','service_category','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000273,'000000',3,'质检类','QC','service_category','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000274,'000000',4,'拍照类','PHOTO','service_category','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000275,'000000',5,'打托类','PALLET','service_category','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000276,'000000',6,'销毁类','DESTROY','service_category','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000277,'000000',7,'暂存类','STORAGE','service_category','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000281,'000000',1,'按件','BY_ITEM','billing_mode_vas','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000282,'000000',2,'按箱','BY_CARTON','billing_mode_vas','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000283,'000000',3,'按板','BY_PALLET','billing_mode_vas','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000284,'000000',4,'按订单','BY_ORDER','billing_mode_vas','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000285,'000000',5,'按小时','BY_HOUR','billing_mode_vas','','default','N',103,1,'2026-05-22 01:18:15',NULL,NULL,''),(5000291,'000000',1,'õ║║ÕÀÑµïåµƒ£','MANUAL','oms_devanning_method','','default','N',103,1,'2026-05-25 12:45:06',NULL,NULL,''),(5000292,'000000',2,'ÕÅëÞ¢ªµïåµƒ£','FORKLIFT','oms_devanning_method','','default','N',103,1,'2026-05-25 12:45:06',NULL,NULL,''),(5000293,'000000',3,'µÁüµ░┤þ║┐µïåµƒ£','CONVEYOR','oms_devanning_method','','default','N',103,1,'2026-05-25 12:45:06',NULL,NULL,''),(5000294,'000000',4,'µÀÀÕÉêµïåµƒ£','MIXED','oms_devanning_method','','default','N',103,1,'2026-05-25 12:45:06',NULL,NULL,''),(5000301,'000000',1,'按箱','BY_CARTON','oms_cargo_forecast_qty_unit','','default','N',103,1,'2026-05-24 02:45:40',NULL,NULL,''),(5000302,'000000',2,'按板','BY_PALLET','oms_cargo_forecast_qty_unit','','default','N',103,1,'2026-05-24 02:45:40',NULL,NULL,''),(5000311,'000000',1,'FLOOR','FLOOR','oms_loading_type','','default','N',103,1,'2026-05-25 12:46:36',1,'2026-05-26 04:23:03',''),(5000312,'000000',2,'PALLET','PALLET','oms_loading_type','','default','N',103,1,'2026-05-25 12:46:36',1,'2026-05-26 04:23:08',''),(5000313,'000000',3,'MIXED','MIXED','oms_loading_type','','default','N',103,1,'2026-05-25 12:45:06',1,'2026-05-26 04:23:15',''),(5000321,'000000',1,'海关Hold','CUSTOMS','oms_container_hold_type','','error','N',103,1,'2026-05-25 14:12:48',NULL,NULL,''),(5000322,'000000',2,'船公司Hold','CARRIER','oms_container_hold_type','','warning','N',103,1,'2026-05-25 14:12:48',NULL,NULL,''),(5000323,'000000',3,'码头Hold','TERMINAL','oms_container_hold_type','','warning','N',103,1,'2026-05-25 14:12:48',NULL,NULL,''),(5000324,'000000',4,'费用Hold','FEE','oms_container_hold_type','','default','N',103,1,'2026-05-25 14:12:48',NULL,NULL,''),(5000331,'000000',1,'X-Ray','X_RAY','oms_container_exam_type','','default','N',103,1,'2026-05-25 14:12:48',NULL,NULL,''),(5000332,'000000',2,'Tailgate','TAILGATE','oms_container_exam_type','','default','N',103,1,'2026-05-25 14:12:48',NULL,NULL,''),(5000333,'000000',3,'Intensive','INTENSIVE','oms_container_exam_type','','warning','N',103,1,'2026-05-25 14:12:48',NULL,NULL,''),(5000334,'000000',4,'CES','CES','oms_container_exam_type','','default','N',103,1,'2026-05-25 14:12:48',NULL,NULL,''),(5000340,'000000',1,'DO','DO','oms_attachment_type','','primary','N',103,1,'2026-05-25 15:06:42',NULL,NULL,'海柜DO，客户可见'),(5000341,'000000',2,'BOL/提单','BOL','oms_attachment_type','','default','N',103,1,'2026-05-25 15:06:42',NULL,NULL,''),(5000342,'000000',3,'POD','POD','oms_attachment_type','','success','N',103,1,'2026-05-25 15:06:42',NULL,NULL,''),(5000343,'000000',4,'发票','INVOICE','oms_attachment_type','','default','N',103,1,'2026-05-25 15:06:42',NULL,NULL,''),(5000344,'000000',5,'异常图片','EXCEPTION_IMAGE','oms_attachment_type','','error','N',103,1,'2026-05-25 15:06:42',NULL,NULL,''),(5000345,'000000',6,'客户文件','CUSTOMER_FILE','oms_attachment_type','','info','N',103,1,'2026-05-25 15:06:42',NULL,NULL,'客户可见'),(5000346,'000000',99,'其他','OTHER','oms_attachment_type','','default','Y',103,1,'2026-05-25 15:06:42',NULL,NULL,''),(9003101,'000000',1,'草稿','DRAFT','oms_container_status','','default','N',NULL,1,'2026-05-22 02:21:52',1,'2026-05-22 02:21:52',NULL),(9003102,'000000',2,'待受理','PENDING_ACCEPT','oms_container_status','','warning','Y',NULL,1,'2026-05-22 02:21:52',1,'2026-05-22 02:21:52',NULL),(9003103,'000000',3,'在途','IN_TRANSIT','oms_container_status','','info','N',NULL,1,'2026-05-22 02:21:52',1,'2026-05-22 02:21:52',NULL),(9003104,'000000',4,'已到港','ARRIVED_PORT','oms_container_status','','info','N',NULL,1,'2026-05-22 02:21:52',1,'2026-05-22 02:21:52',NULL),(9003105,'000000',5,'HOLD中','HOLDING','oms_container_status','','error','N',NULL,1,'2026-05-22 02:21:52',1,'2026-05-22 02:21:52',NULL),(9003106,'000000',6,'查验中','EXAMINING','oms_container_status','','warning','N',NULL,1,'2026-05-22 02:21:52',1,'2026-05-22 02:21:52',NULL),(9003107,'000000',7,'已可提','AVAILABLE_FOR_PICKUP','oms_container_status','','success','N',NULL,1,'2026-05-22 02:21:52',1,'2026-05-22 02:21:52',NULL),(9003108,'000000',8,'已预约提柜','PICKUP_APPOINTED','oms_container_status','','info','N',NULL,1,'2026-05-22 02:21:52',1,'2026-05-22 02:21:52',NULL),(9003109,'000000',9,'已提柜','PICKED_UP','oms_container_status','','success','N',NULL,1,'2026-05-22 02:21:52',1,'2026-05-22 02:21:52',NULL),(9003110,'000000',10,'已到仓','ARRIVED_WAREHOUSE','oms_container_status','','success','N',NULL,1,'2026-05-22 02:21:52',1,'2026-05-22 02:21:52',NULL),(9003111,'000000',11,'拆柜中','DEVANNING','oms_container_status','','warning','N',NULL,1,'2026-05-22 02:21:52',1,'2026-05-22 02:21:52',NULL),(9003112,'000000',12,'拆柜完成','DEVANNED','oms_container_status','','success','N',NULL,1,'2026-05-22 02:21:52',1,'2026-05-22 02:21:52',NULL),(9003113,'000000',13,'已还柜','EMPTY_RETURNED','oms_container_status','','success','N',NULL,1,'2026-05-22 02:21:52',1,'2026-05-22 02:21:52',NULL),(9003114,'000000',14,'已完成','COMPLETED','oms_container_status','','success','N',NULL,1,'2026-05-22 02:21:52',1,'2026-05-22 02:21:52',NULL),(9003115,'000000',15,'已取消','CANCELLED','oms_container_status','','default','N',NULL,1,'2026-05-22 02:21:52',1,'2026-05-22 02:21:52',NULL),(9003201,'000000',1,'20GP','20GP','oms_container_type','','default','N',NULL,1,'2026-05-22 02:21:52',1,'2026-05-22 02:21:52',NULL),(9003202,'000000',2,'40GP','40GP','oms_container_type','','default','N',NULL,1,'2026-05-22 02:21:52',1,'2026-05-22 02:21:52',NULL),(9003203,'000000',3,'40HQ','40HQ','oms_container_type','','default','Y',NULL,1,'2026-05-22 02:21:52',1,'2026-05-22 02:21:52',NULL),(9003204,'000000',4,'45HQ','45HQ','oms_container_type','','default','N',NULL,1,'2026-05-22 02:21:52',1,'2026-05-22 02:21:52',NULL),(9003301,'000000',1,'未知','UNKNOWN','oms_terminal_release_status','','default','Y',NULL,1,'2026-05-22 02:21:52',1,'2026-05-22 02:21:52',NULL),(9003302,'000000',2,'已释放','RELEASED','oms_terminal_release_status','','success','N',NULL,1,'2026-05-22 02:21:52',1,'2026-05-22 02:21:52',NULL),(9003303,'000000',3,'HOLD中','HOLDING','oms_terminal_release_status','','error','N',NULL,1,'2026-05-22 02:21:52',1,'2026-05-22 02:21:52',NULL),(9004101,'000000',1,'待受理','PENDING_ACCEPT','oms_cargo_fulfillment_status','','default','N',NULL,1,'2026-05-22 16:30:54',1,'2026-05-22 16:30:54',NULL),(9004102,'000000',2,'已受理','ACCEPTED','oms_cargo_fulfillment_status','','info','N',NULL,1,'2026-05-22 16:30:54',1,'2026-05-22 16:30:54',NULL),(9004103,'000000',3,'在途','IN_TRANSIT','oms_cargo_fulfillment_status','','info','N',NULL,1,'2026-05-22 16:30:54',1,'2026-05-22 16:30:54',NULL),(9004104,'000000',4,'已到港','ARRIVED_PORT','oms_cargo_fulfillment_status','','warning','N',NULL,1,'2026-05-22 16:30:54',1,'2026-05-22 16:30:54',NULL),(9004105,'000000',5,'已提柜','PICKED_UP','oms_cargo_fulfillment_status','','warning','N',NULL,1,'2026-05-22 16:30:54',1,'2026-05-22 16:30:54',NULL),(9004106,'000000',6,'已到仓','ARRIVED_WAREHOUSE','oms_cargo_fulfillment_status','','warning','N',NULL,1,'2026-05-22 16:30:54',1,'2026-05-22 16:30:54',NULL),(9004107,'000000',7,'拆柜中','DEVANNING','oms_cargo_fulfillment_status','','warning','N',NULL,1,'2026-05-22 16:30:54',1,'2026-05-22 16:30:54',NULL),(9004108,'000000',8,'拆柜完成','DEVANNED','oms_cargo_fulfillment_status','','warning','N',NULL,1,'2026-05-22 16:30:54',1,'2026-05-22 16:30:54',NULL),(9004109,'000000',9,'已入库','INBOUNDED','oms_cargo_fulfillment_status','','success','N',NULL,1,'2026-05-22 16:30:54',1,'2026-05-22 16:30:54',NULL),(9004110,'000000',10,'已出单','OUTBOUND_ORDERED','oms_cargo_fulfillment_status','','success','N',NULL,1,'2026-05-22 16:30:54',1,'2026-05-22 16:30:54',NULL),(9004111,'000000',11,'已预约派送','DELIVERY_APPOINTED','oms_cargo_fulfillment_status','','success','N',NULL,1,'2026-05-22 16:30:54',1,'2026-05-22 16:30:54',NULL),(9004112,'000000',12,'已出库','OUTBOUNDED','oms_cargo_fulfillment_status','','success','N',NULL,1,'2026-05-22 16:30:54',1,'2026-05-22 16:30:54',NULL),(9004113,'000000',13,'派送中','DELIVERING','oms_cargo_fulfillment_status','','primary','N',NULL,1,'2026-05-22 16:30:54',1,'2026-05-22 16:30:54',NULL),(9004114,'000000',14,'已签收','DELIVERED','oms_cargo_fulfillment_status','','success','N',NULL,1,'2026-05-22 16:30:54',1,'2026-05-22 16:30:54',NULL),(9004115,'000000',15,'POD已回传','POD_UPLOADED','oms_cargo_fulfillment_status','','success','N',NULL,1,'2026-05-22 16:30:54',1,'2026-05-22 16:30:54',NULL),(9004116,'000000',16,'已出账单','BILLED','oms_cargo_fulfillment_status','','success','N',NULL,1,'2026-05-22 16:30:54',1,'2026-05-22 16:30:54',NULL),(9004117,'000000',17,'已完成','COMPLETED','oms_cargo_fulfillment_status','','success','N',NULL,1,'2026-05-22 16:30:54',1,'2026-05-22 16:30:54',NULL),(9004118,'000000',18,'异常中','EXCEPTION','oms_cargo_fulfillment_status','','error','N',NULL,1,'2026-05-22 16:30:54',1,'2026-05-22 16:30:54',NULL),(9004119,'000000',19,'已取消','CANCELLED','oms_cargo_fulfillment_status','','default','N',NULL,1,'2026-05-22 16:30:54',1,'2026-05-22 16:30:54',NULL),(9004121,'000000',1,'未出账单','UNBILLED','oms_cargo_billing_status','','warning','Y',NULL,1,'2026-05-22 16:30:55',1,'2026-05-22 16:30:55',NULL),(9004122,'000000',2,'已出账单','BILLED','oms_cargo_billing_status','','success','N',NULL,1,'2026-05-22 16:30:55',1,'2026-05-22 16:30:55',NULL),(9004123,'000000',3,'已作废','VOIDED','oms_cargo_billing_status','','default','N',NULL,1,'2026-05-22 16:30:55',1,'2026-05-22 16:30:55',NULL),(9004131,'000000',1,'无预出单','NONE','oms_cargo_pre_outbound_status','','default','Y',NULL,1,'2026-05-22 16:30:55',1,'2026-05-22 16:30:55',NULL),(9004132,'000000',2,'已预出单','PRE_CREATED','oms_cargo_pre_outbound_status','','warning','N',NULL,1,'2026-05-22 16:30:55',1,'2026-05-22 16:30:55',NULL),(9004133,'000000',3,'已转正式','CONVERTED','oms_cargo_pre_outbound_status','','success','N',NULL,1,'2026-05-22 16:30:55',1,'2026-05-22 16:30:55',NULL),(9004134,'000000',4,'已取消','CANCELLED','oms_cargo_pre_outbound_status','','error','N',NULL,1,'2026-05-22 16:30:55',1,'2026-05-22 16:30:55',NULL),(9004200,'000000',1,'集装箱船','CONTAINER','base_vessel_type','','success','Y',NULL,1,'2026-05-24 00:23:03',NULL,NULL,'Container vessel'),(9004201,'000000',2,'散货船','BULK','base_vessel_type','','info','N',NULL,1,'2026-05-24 00:23:03',NULL,NULL,'Bulk vessel'),(9004202,'000000',3,'冷藏船','REEFER','base_vessel_type','','warning','N',NULL,1,'2026-05-24 00:23:03',NULL,NULL,'Reefer vessel'),(9004204,'000000',5,'其他','OTHER','base_vessel_type','','default','N',NULL,1,'2026-05-24 00:23:03',NULL,NULL,'Other vessel'),(9005200,'000000',1,'道口','DOCK','yard_location_type','','info','Y',NULL,1,'2026-05-24 03:13:21',NULL,NULL,'Dock'),(9005201,'000000',2,'停车位','PARKING','yard_location_type','','default','N',NULL,1,'2026-05-24 03:13:21',1,'2026-05-26 04:22:16','Parking space'),(9005202,'000000',3,'海柜堆位','CONTAINER_SLOT','yard_location_type',NULL,'primary','N',NULL,1,'2026-05-29 12:33:49',NULL,NULL,'Container slot'),(9005203,'000000',4,'空柜堆位','EMPTY_CONTAINER_SLOT','yard_location_type',NULL,'info','N',NULL,1,'2026-05-29 12:33:49',NULL,NULL,'Empty container slot'),(9005204,'000000',5,'车厢堆位','TRAILER_SLOT','yard_location_type',NULL,'success','N',NULL,1,'2026-05-29 12:33:49',NULL,NULL,'Trailer slot'),(9005205,'000000',6,'等待位','WAITING_SLOT','yard_location_type',NULL,'warning','N',NULL,1,'2026-05-29 12:33:49',NULL,NULL,'Waiting slot'),(9005206,'000000',7,'禁入位','BLOCKED_SLOT','yard_location_type',NULL,'error','N',NULL,1,'2026-05-29 12:33:49',NULL,NULL,'Blocked slot'),(9005210,'000000',1,'前院道口','FRONT_YARD_DOCK','yard_dock_location','','success','N',NULL,1,'2026-05-24 03:13:21',NULL,NULL,'Front yard dock'),(9005211,'000000',2,'后院道口','BACK_YARD_DOCK','yard_dock_location','','info','Y',NULL,1,'2026-05-24 03:13:21',NULL,NULL,'Back yard dock'),(9005212,'000000',3,'前院停车位','FRONT_YARD_PARKING','yard_dock_location','','warning','N',NULL,1,'2026-05-24 03:13:21',NULL,NULL,'Front yard parking'),(9005213,'000000',4,'后院停车位','BACK_YARD_PARKING','yard_dock_location','','default','N',NULL,1,'2026-05-24 03:13:21',NULL,NULL,'Back yard parking'),(9005220,'000000',1,'海柜区','CONTAINER','yard_zone_type',NULL,'primary','Y',NULL,1,'2026-05-29 12:33:49',NULL,NULL,NULL),(9005221,'000000',2,'车厢区','TRUCK','yard_zone_type',NULL,'success','N',NULL,1,'2026-05-29 12:33:49',NULL,NULL,NULL),(9005222,'000000',3,'自提区','SELF_PICKUP','yard_zone_type',NULL,'info','N',NULL,1,'2026-05-29 12:33:49',NULL,NULL,NULL),(9005223,'000000',4,'停车区','PARKING','yard_zone_type',NULL,'default','N',NULL,1,'2026-05-29 12:33:49',NULL,NULL,NULL),(6000001101,'000000',1,'派送','DELIVERY','oms_outbound_direction',NULL,'primary','Y',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-24 12:43:37',NULL),(6000001102,'000000',2,'调拨','TRANSFER','oms_outbound_direction',NULL,'info','N',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-24 12:43:37',NULL),(6000001201,'000000',1,'未入库','NOT_INBOUNDED','oms_outbound_readiness',NULL,'warning','N',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-24 12:43:37',NULL),(6000001202,'000000',2,'拆柜中','DEVANNING','oms_outbound_readiness',NULL,'info','N',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-24 12:43:37',NULL),(6000001203,'000000',3,'已入库','INBOUNDED','oms_outbound_readiness',NULL,'success','N',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-24 12:43:37',NULL),(6000001301,'000000',1,'待入库','PENDING_INBOUND','oms_pre_outbound_status',NULL,'warning','N',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-24 12:43:37',NULL),(6000001302,'000000',2,'拆柜中','DEVANNING','oms_pre_outbound_status',NULL,'info','N',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-24 12:43:37',NULL),(6000001303,'000000',3,'可转出库','READY_TO_CONVERT','oms_pre_outbound_status',NULL,'success','N',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-24 12:43:37',NULL),(6000001304,'000000',4,'已转出库','CONVERTED','oms_pre_outbound_status',NULL,'success','N',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-24 12:43:37',NULL),(6000001305,'000000',5,'已取消','CANCELLED','oms_pre_outbound_status',NULL,'default','N',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-24 12:43:37',NULL),(6000001401,'000000',1,'已创建','CREATED','oms_outbound_status',NULL,'info','N',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-24 12:43:37',NULL),(6000001402,'000000',2,'已派发','DISPATCHED','oms_outbound_status',NULL,'info','N',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-24 12:43:37',NULL),(6000001403,'000000',3,'已出库','OUTBOUNDED','oms_outbound_status',NULL,'success','N',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-24 12:43:37',NULL),(6000001404,'000000',4,'派送中','DELIVERING','oms_outbound_status',NULL,'info','N',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-24 12:43:37',NULL),(6000001405,'000000',5,'已签收','DELIVERED','oms_outbound_status',NULL,'success','N',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-24 12:43:37',NULL),(6000001406,'000000',6,'已完成','COMPLETED','oms_outbound_status',NULL,'success','N',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-24 12:43:37',NULL),(6000001407,'000000',7,'已取消','CANCELLED','oms_outbound_status',NULL,'default','N',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-24 12:43:37',NULL),(6000003101,'000000',1,'启用','enabled','oms_cargo_grouping_rule_status',NULL,'success','Y',NULL,NULL,'2026-05-27 17:34:49',NULL,'2026-05-27 19:01:15',NULL),(6000003102,'000000',2,'停用','disabled','oms_cargo_grouping_rule_status',NULL,'default','N',NULL,NULL,'2026-05-27 17:34:49',NULL,'2026-05-27 19:01:15',NULL),(6000003201,'000000',1,'文本','STRING','oms_cargo_grouping_field_data_type',NULL,'default','N',NULL,NULL,'2026-05-27 17:34:49',NULL,'2026-05-27 19:01:15',NULL),(6000003202,'000000',2,'数字','NUMBER','oms_cargo_grouping_field_data_type',NULL,'default','N',NULL,NULL,'2026-05-27 17:34:49',NULL,'2026-05-27 19:01:15',NULL),(6000003203,'000000',3,'日期','DATE','oms_cargo_grouping_field_data_type',NULL,'default','N',NULL,NULL,'2026-05-27 17:34:49',NULL,'2026-05-27 19:01:15',NULL),(6000003204,'000000',4,'枚举','ENUM','oms_cargo_grouping_field_data_type',NULL,'info','N',NULL,NULL,'2026-05-27 17:34:49',NULL,'2026-05-27 19:01:15',NULL),(6000003205,'000000',5,'基础资料','REF','oms_cargo_grouping_field_data_type',NULL,'info','N',NULL,NULL,'2026-05-27 17:34:49',NULL,'2026-05-27 19:01:15',NULL),(6000003301,'000000',1,'等于','EQ','oms_cargo_grouping_condition_op',NULL,'default','Y',NULL,NULL,'2026-05-27 17:34:49',NULL,'2026-05-27 19:01:15',NULL),(6000003302,'000000',2,'不等于','NEQ','oms_cargo_grouping_condition_op',NULL,'default','N',NULL,NULL,'2026-05-27 17:34:49',NULL,'2026-05-27 19:01:15',NULL),(6000003303,'000000',3,'包含于','IN','oms_cargo_grouping_condition_op',NULL,'default','N',NULL,NULL,'2026-05-27 17:34:49',NULL,'2026-05-27 19:01:15',NULL),(6000003304,'000000',4,'不包含于','NOT_IN','oms_cargo_grouping_condition_op',NULL,'default','N',NULL,NULL,'2026-05-27 17:34:49',NULL,'2026-05-27 19:01:15',NULL),(6000003305,'000000',5,'为空','IS_NULL','oms_cargo_grouping_condition_op',NULL,'default','N',NULL,NULL,'2026-05-27 17:34:49',NULL,'2026-05-27 19:01:15',NULL),(6000003306,'000000',6,'不为空','IS_NOT_NULL','oms_cargo_grouping_condition_op',NULL,'default','N',NULL,NULL,'2026-05-27 17:34:49',NULL,'2026-05-27 19:01:15',NULL),(6000003401,'000000',1,'UPS','UPS','oms_parcel_carrier',NULL,'primary','Y',NULL,NULL,'2026-05-27 19:01:15',NULL,NULL,NULL),(6000003402,'000000',2,'FedEx','FedEx','oms_parcel_carrier',NULL,'info','N',NULL,NULL,'2026-05-27 19:01:15',NULL,NULL,NULL),(6000003403,'000000',3,'USPS','USPS','oms_parcel_carrier',NULL,'success','N',NULL,NULL,'2026-05-27 19:01:15',NULL,NULL,NULL),(6000003404,'000000',4,'DHL','DHL','oms_parcel_carrier',NULL,'warning','N',NULL,NULL,'2026-05-27 19:01:15',NULL,NULL,NULL),(6000003405,'000000',5,'OnTrac','OnTrac','oms_parcel_carrier',NULL,'default','N',NULL,NULL,'2026-05-27 19:01:15',NULL,NULL,NULL),(6000003406,'000000',6,'LaserShip','LaserShip','oms_parcel_carrier',NULL,'default','N',NULL,NULL,'2026-05-27 19:01:15',NULL,NULL,NULL),(6000003407,'000000',7,'Amazon Shipping','Amazon Shipping','oms_parcel_carrier',NULL,'default','N',NULL,NULL,'2026-05-27 19:01:15',NULL,NULL,NULL),(6000003408,'000000',1,'草稿','draft','wms_inbound_plan_status',NULL,'default','N',NULL,NULL,'2026-05-27 20:36:13',NULL,NULL,NULL),(6000003409,'000000',2,'作业中','in_progress','wms_inbound_plan_status',NULL,'info','N',NULL,NULL,'2026-05-27 20:36:13',NULL,NULL,NULL),(6000003410,'000000',3,'已完结','completed','wms_inbound_plan_status',NULL,'success','N',NULL,NULL,'2026-05-27 20:36:13',NULL,NULL,NULL),(6000003411,'000000',4,'已取消','cancelled','wms_inbound_plan_status',NULL,'default','N',NULL,NULL,'2026-05-27 20:36:13',NULL,NULL,NULL),(6000003412,'000000',1,'自动分组','auto_group','wms_group_change_type',NULL,'info','N',NULL,NULL,'2026-05-27 20:36:13',NULL,NULL,NULL),(6000003413,'000000',2,'快速配置','quick_config','wms_group_change_type',NULL,'warning','N',NULL,NULL,'2026-05-27 20:36:13',NULL,NULL,NULL),(6000003414,'000000',3,'手动编辑','manual','wms_group_change_type',NULL,'default','N',NULL,NULL,'2026-05-27 20:36:13',NULL,NULL,NULL),(6000003415,'000000',1,'平台仓','PLATFORM_WH','oms_address_type','','success','N',103,1,'2026-05-27 21:50:34',NULL,NULL,'平台仓库'),(6000003416,'000000',2,'私人地址','PRIVATE','oms_address_type','','warning','N',103,1,'2026-05-27 21:50:34',NULL,NULL,'私人地址'),(6000003417,'000000',3,'商业地址','COMMERCIAL','oms_address_type','','info','N',103,1,'2026-05-27 21:50:34',NULL,NULL,'商业地址'),(6000003418,'000000',0,'否','0','yes_no_int','','default','N',103,1,'2026-05-28 01:04:40',1,'2026-05-28 01:04:40',NULL),(6000003419,'000000',1,'是','1','yes_no_int','','success','N',103,1,'2026-05-28 01:04:40',1,'2026-05-28 01:04:40',NULL);
/*!40000 ALTER TABLE `sys_dict_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_type`
--

DROP TABLE IF EXISTS `sys_dict_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_type` (
  `dict_id` bigint NOT NULL COMMENT '字典主键',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `dict_name` varchar(100) DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) DEFAULT '' COMMENT '字典类型',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`),
  UNIQUE KEY `tenant_id` (`tenant_id`,`dict_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='字典类型表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_type`
--

LOCK TABLES `sys_dict_type` WRITE;
/*!40000 ALTER TABLE `sys_dict_type` DISABLE KEYS */;
INSERT INTO `sys_dict_type` VALUES (0,'000000','园区盘点类型','yms_inventory_type',103,1,'2026-05-29 12:15:15',NULL,NULL,'YMS园区盘点类型'),(1,'000000','用户性别','sys_user_sex',103,1,'2026-05-21 23:15:04',NULL,NULL,'用户性别列表'),(2,'000000','菜单状态','sys_show_hide',103,1,'2026-05-21 23:15:04',NULL,NULL,'菜单状态列表'),(3,'000000','系统开关','sys_normal_disable',103,1,'2026-05-21 23:15:04',NULL,NULL,'系统开关列表'),(6,'000000','系统是否','sys_yes_no',103,1,'2026-05-21 23:15:04',NULL,NULL,'系统是否列表'),(7,'000000','通知类型','sys_notice_type',103,1,'2026-05-21 23:15:04',NULL,NULL,'通知类型列表'),(8,'000000','通知状态','sys_notice_status',103,1,'2026-05-21 23:15:04',NULL,NULL,'通知状态列表'),(9,'000000','操作类型','sys_oper_type',103,1,'2026-05-21 23:15:04',NULL,NULL,'操作类型列表'),(10,'000000','系统状态','sys_common_status',103,1,'2026-05-21 23:15:04',NULL,NULL,'登录状态列表'),(11,'000000','授权类型','sys_grant_type',103,1,'2026-05-21 23:15:04',NULL,NULL,'认证授权类型'),(12,'000000','设备类型','sys_device_type',103,1,'2026-05-21 23:15:04',NULL,NULL,'客户端设备类型'),(13,'000000','业务状态','wf_business_status',103,1,'2026-05-21 23:15:15',NULL,NULL,'业务状态列表'),(14,'000000','表单类型','wf_form_type',103,1,'2026-05-21 23:15:15',NULL,NULL,'表单类型列表'),(15,'000000','任务状态','wf_task_status',103,1,'2026-05-21 23:15:15',NULL,NULL,'任务状态'),(100,'000000','费项类别','fee_category',103,1,'2026-05-22 00:12:19',NULL,NULL,NULL),(101,'000000','业务阶段','fee_business_stage',103,1,'2026-05-22 00:12:19',NULL,NULL,NULL),(102,'000000','业务类型','fulfillment_type',103,1,'2026-05-22 00:12:19',NULL,NULL,NULL),(103,'000000','仓库类型','warehouse_type',103,1,'2026-05-22 00:12:20',NULL,NULL,NULL),(5000101,'000000','渠道类型','channel_type',103,1,'2026-05-22 01:18:15',NULL,NULL,'渠道基础资料'),(5000102,'000000','装载模式','container_mode',103,1,'2026-05-22 01:18:15',NULL,NULL,'渠道基础资料'),(5000103,'000000','业务大类','business_category',103,1,'2026-05-22 01:18:15',NULL,NULL,'业务类型基础资料'),(5000104,'000000','作业流程类型','operation_flow_type',103,1,'2026-05-22 01:18:15',NULL,NULL,'业务类型基础资料'),(5000106,'000000','分货策略','sorting_strategy',103,1,'2026-05-22 01:18:15',NULL,NULL,'业务类型基础资料'),(5000107,'000000','分货字段','sorting_field',103,1,'2026-05-22 01:18:15',NULL,NULL,'业务类型基础资料'),(5000108,'000000','增值服务分类','service_category',103,1,'2026-05-22 01:18:15',NULL,NULL,'增值服务基础资料'),(5000109,'000000','增值服务计费方式','billing_mode_vas',103,1,'2026-05-22 01:18:15',NULL,NULL,'增值服务基础资料'),(5000110,'000000','µÁÀµƒ£µïåµƒ£µû╣Õ╝Å','oms_devanning_method',103,1,'2026-05-25 12:45:06',NULL,NULL,'µÁÀµƒ£Þ«óÕìòµïåµƒ£µû╣Õ╝Å'),(5000111,'000000','装车类型','oms_loading_type',103,1,'2026-05-25 12:45:06',1,'2026-05-26 04:23:34','装车类型'),(5000112,'000000','海柜Hold类型','oms_container_hold_type',103,1,'2026-05-25 14:12:47',NULL,NULL,'海柜订单Hold类型'),(5000113,'000000','海柜查验类型','oms_container_exam_type',103,1,'2026-05-25 14:12:48',NULL,NULL,'海柜订单查验类型'),(5000114,'000000','OMS附件类型','oms_attachment_type',103,1,'2026-05-25 15:06:42',NULL,NULL,'货物/海柜文件管理上传类型'),(5000300,'000000','货物预报计量单位','oms_cargo_forecast_qty_unit',103,1,'2026-05-24 02:45:40',NULL,NULL,'BY_CARTON/BY_PALLET'),(9003001,'000000','海柜状态','oms_container_status',NULL,1,'2026-05-22 02:21:52',1,'2026-05-22 02:21:52','OMS海柜订单生命周期状态'),(9003002,'000000','柜型','oms_container_type',NULL,1,'2026-05-22 02:21:52',1,'2026-05-22 02:21:52','OMS海柜柜型'),(9003003,'000000','码头释放状态','oms_terminal_release_status',NULL,1,'2026-05-22 02:21:52',1,'2026-05-22 02:21:52','码头释放/Hold状态'),(9004001,'000000','货物订单主履约状态','oms_cargo_fulfillment_status',NULL,1,'2026-05-22 16:30:54',1,'2026-05-22 16:30:54',''),(9004002,'000000','货物订单账单状态','oms_cargo_billing_status',NULL,1,'2026-05-22 16:30:54',1,'2026-05-22 16:30:54',''),(9004003,'000000','货物订单预出单状态','oms_cargo_pre_outbound_status',NULL,1,'2026-05-22 16:30:55',1,'2026-05-22 16:30:55',''),(9004100,'000000','船舶类型','base_vessel_type',NULL,1,'2026-05-24 00:23:03',NULL,NULL,'Vessel type dictionary'),(9005100,'000000','月台位置类型','yard_location_type',NULL,1,'2026-05-24 03:13:21',NULL,NULL,'Dock location type'),(9005101,'000000','月台位置','yard_dock_location',NULL,1,'2026-05-24 03:13:21',NULL,NULL,'Dock yard position'),(9005102,'000000','堆场分区类型','yard_zone_type',NULL,1,'2026-05-29 12:33:49',NULL,NULL,'Yard zone type'),(6000001001,'000000','出单方向','oms_outbound_direction',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-24 12:43:37','OMS????????????'),(6000001002,'000000','出单准备状态','oms_outbound_readiness',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-24 12:43:37','???????????????????????????'),(6000001003,'000000','预出单状态','oms_pre_outbound_status',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-24 12:43:37','???????????????'),(6000001004,'000000','出库订单状态','oms_outbound_status',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-24 12:43:37','??????????????????'),(6000003001,'000000','OMS分组规则状态','oms_cargo_grouping_rule_status',NULL,NULL,'2026-05-27 17:34:49',NULL,'2026-05-27 19:01:15','OMS??????????????????????????????'),(6000003002,'000000','OMS分组字段数据类型','oms_cargo_grouping_field_data_type',NULL,NULL,'2026-05-27 17:34:49',NULL,'2026-05-27 19:01:15','OMS????????????????????????'),(6000003003,'000000','OMS分组规则匹配操作符','oms_cargo_grouping_condition_op',NULL,NULL,'2026-05-27 17:34:49',NULL,'2026-05-27 19:01:15','OMS???????????????????????????'),(6000003004,'000000','OMS快递商','oms_parcel_carrier',NULL,NULL,'2026-05-27 19:01:15',NULL,NULL,'OMS快递派送承运商'),(6000003005,'000000','入库计划状态','wms_inbound_plan_status',NULL,NULL,'2026-05-27 20:36:13',NULL,NULL,''),(6000003006,'000000','分组变更类型','wms_group_change_type',NULL,NULL,'2026-05-27 20:36:13',NULL,NULL,''),(6000003007,'000000','地址类型','oms_address_type',NULL,1,'2026-05-27 21:43:54',1,'2026-05-27 21:43:54','货物订单地址类型'),(6000003008,'000000','是/否（整数）','yes_no_int',103,1,'2026-05-28 01:04:40',1,'2026-05-28 01:04:40','0=否 1=是，字段类型为tinyint/int');
/*!40000 ALTER TABLE `sys_dict_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_logininfor`
--

DROP TABLE IF EXISTS `sys_logininfor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_logininfor` (
  `info_id` bigint NOT NULL COMMENT '访问ID',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `user_name` varchar(50) DEFAULT '' COMMENT '用户账号',
  `client_key` varchar(32) DEFAULT '' COMMENT '客户端',
  `device_type` varchar(32) DEFAULT '' COMMENT '设备类型',
  `ipaddr` varchar(128) DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) DEFAULT '' COMMENT '操作系统',
  `status` char(1) DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) DEFAULT '' COMMENT '提示消息',
  `login_time` datetime DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`),
  KEY `idx_sys_logininfor_s` (`status`),
  KEY `idx_sys_logininfor_lt` (`login_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统访问记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_logininfor`
--

LOCK TABLES `sys_logininfor` WRITE;
/*!40000 ALTER TABLE `sys_logininfor` DISABLE KEYS */;
INSERT INTO `sys_logininfor` VALUES (2057722669951148033,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-22 15:18:10'),(2057744998445965313,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','退出成功','2026-05-22 16:46:53'),(2057745030393978882,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-22 16:47:01'),(2057872536421847041,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-23 01:13:41'),(2057968599153606657,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-23 07:35:24'),(2057974406117093377,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-23 07:58:28'),(2057988311090507778,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-23 08:53:44'),(2058074594378821634,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-23 14:36:35'),(2058080623439208450,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','退出成功','2026-05-23 15:00:33'),(2058080638240907265,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-23 15:00:36'),(2058254538731991042,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-24 02:31:37'),(2058400932264456193,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-24 12:13:20'),(2058427047322365953,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-24 13:57:06'),(2058450074558832641,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-24 15:28:37'),(2058450109983924225,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','1','验证码已失效','2026-05-24 15:28:45'),(2058450127440617473,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-24 15:28:49'),(2058484952176324610,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-24 17:47:12'),(2058632987111911425,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-25 03:35:26'),(2058634442178883586,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','退出成功','2026-05-25 03:41:13'),(2058634461015502850,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-25 03:41:18'),(2058707443175976962,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-25 08:31:18'),(2058954186325028866,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','1','验证码错误','2026-05-26 00:51:46'),(2058954213235683330,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-26 00:51:53'),(2058978979866800129,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-26 02:30:17'),(2059020200354041858,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-26 05:14:05'),(2059021117530857473,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-26 05:17:44'),(2059049670641270785,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','1','验证码已失效','2026-05-26 07:11:11'),(2059049704011153409,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-26 07:11:19'),(2059065841386008577,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-26 08:15:27'),(2059515248472502273,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-27 14:01:14'),(2059551557731762177,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-27 16:25:31'),(2059558734064361473,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-27 16:54:02'),(2059684401808515073,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-28 01:13:23'),(2059695985826045953,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-28 01:59:25'),(2059724125520633858,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-28 03:51:14'),(2059786250188333058,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-28 07:58:06'),(2059787152307625986,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','退出成功','2026-05-28 08:01:41'),(2059796850939371522,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-28 08:40:13'),(2059808288516947969,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','退出成功','2026-05-28 09:25:40'),(2059808309056454658,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-28 09:25:45'),(2059841203833487362,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-28 11:36:28'),(2059886037088657409,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-28 14:34:37'),(2059906803226173442,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-28 15:57:08'),(2060038993733787649,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','1','验证码已失效','2026-05-29 00:42:24'),(2060039012109033474,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-29 00:42:29'),(2060055040117481474,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-29 01:46:10'),(2060075766438432770,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-29 03:08:32'),(2060105365671211009,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-29 05:06:09'),(2060154036710334465,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-29 08:19:33'),(2060401711250726914,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','1','验证码已失效','2026-05-30 00:43:43'),(2060401731324665858,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-30 00:43:48'),(2060428411036557314,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-30 02:29:49'),(2060450467899838466,'000000','admin','pc','pc','0:0:0:0:0:0:0:1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-05-30 03:57:28');
/*!40000 ALTER TABLE `sys_logininfor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_menu`
--

DROP TABLE IF EXISTS `sys_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_menu` (
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  `menu_name` varchar(50) NOT NULL COMMENT '菜单名称',
  `parent_id` bigint DEFAULT '0' COMMENT '父菜单ID',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `path` varchar(200) DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) DEFAULT NULL COMMENT '组件路径',
  `query_param` varchar(255) DEFAULT NULL COMMENT '路由参数',
  `is_frame` int DEFAULT '1' COMMENT '是否为外链（0是 1否）',
  `is_cache` int DEFAULT '0' COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) DEFAULT '0' COMMENT '显示状态（0显示 1隐藏）',
  `status` char(1) DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) DEFAULT '#' COMMENT '菜单图标',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='菜单权限表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_menu`
--

LOCK TABLES `sys_menu` WRITE;
/*!40000 ALTER TABLE `sys_menu` DISABLE KEYS */;
INSERT INTO `sys_menu` VALUES (1,'系统管理',0,1,'system',NULL,'',1,0,'M','0','0','','system',103,1,'2026-05-21 23:15:03',NULL,NULL,'系统管理目录'),(2,'系统监控',0,3,'monitor',NULL,'',1,0,'M','0','0','','monitor',103,1,'2026-05-21 23:15:03',NULL,NULL,'系统监控目录'),(3,'系统工具',0,4,'tool',NULL,'',1,0,'M','0','0','','tool',103,1,'2026-05-21 23:15:03',NULL,NULL,'系统工具目录'),(5,'测试菜单',0,5,'demo','Layout','',1,0,'M','1','0','','star',103,1,'2026-05-21 23:15:03',1,'2026-05-23 02:08:06','测试菜单'),(6,'租户管理',0,2,'tenant',NULL,'',1,0,'M','0','0','','chart',103,1,'2026-05-21 23:15:03',NULL,NULL,'租户管理目录'),(100,'用户管理',1,1,'user','system/user/index','',1,0,'C','0','0','system:user:list','user',103,1,'2026-05-21 23:15:03',NULL,NULL,'用户管理菜单'),(101,'角色管理',1,2,'role','system/role/index','',1,0,'C','0','0','system:role:list','peoples',103,1,'2026-05-21 23:15:03',NULL,NULL,'角色管理菜单'),(102,'菜单管理',1,3,'menu','system/menu/index','',1,0,'C','0','0','system:menu:list','tree-table',103,1,'2026-05-21 23:15:03',NULL,NULL,'菜单管理菜单'),(103,'部门管理',1,4,'dept','system/dept/index','',1,0,'C','0','0','system:dept:list','tree',103,1,'2026-05-21 23:15:03',NULL,NULL,'部门管理菜单'),(104,'岗位管理',1,5,'post','system/post/index','',1,0,'C','0','0','system:post:list','post',103,1,'2026-05-21 23:15:03',NULL,NULL,'岗位管理菜单'),(105,'字典管理',1,6,'dict','system/dict/index','',1,0,'C','0','0','system:dict:list','dict',103,1,'2026-05-21 23:15:03',NULL,NULL,'字典管理菜单'),(106,'参数设置',1,7,'config','system/config/index','',1,0,'C','0','0','system:config:list','edit',103,1,'2026-05-21 23:15:03',NULL,NULL,'参数设置菜单'),(107,'通知公告',1,8,'notice','system/notice/index','',1,0,'C','0','0','system:notice:list','message',103,1,'2026-05-21 23:15:03',NULL,NULL,'通知公告菜单'),(108,'日志管理',1,9,'log','','',1,0,'M','0','0','','log',103,1,'2026-05-21 23:15:03',NULL,NULL,'日志管理菜单'),(109,'在线用户',2,1,'online','monitor/online/index','',1,0,'C','0','0','monitor:online:list','online',103,1,'2026-05-21 23:15:03',NULL,NULL,'在线用户菜单'),(113,'缓存监控',2,5,'cache','monitor/cache/index','',1,0,'C','0','0','monitor:cache:list','redis',103,1,'2026-05-21 23:15:03',NULL,NULL,'缓存监控菜单'),(115,'代码生成',3,2,'gen','tool/gen/index','',1,0,'C','0','0','tool:gen:list','code',103,1,'2026-05-21 23:15:03',NULL,NULL,'代码生成菜单'),(116,'修改生成配置',3,2,'gen-edit/index/:tableId','tool/gen/editTable','',1,1,'C','1','0','tool:gen:edit','#',103,1,'2026-05-21 23:15:03',NULL,NULL,'/tool/gen'),(117,'Admin监控',2,5,'Admin','monitor/admin/index','',1,0,'C','0','0','monitor:admin:list','dashboard',103,1,'2026-05-21 23:15:03',NULL,NULL,'Admin监控菜单'),(118,'文件管理',1,10,'oss','system/oss/index','',1,0,'C','0','0','system:oss:list','upload',103,1,'2026-05-21 23:15:03',NULL,NULL,'文件管理菜单'),(120,'任务调度中心',2,6,'snailjob','monitor/snailjob/index','',1,0,'C','0','0','monitor:snailjob:list','job',103,1,'2026-05-21 23:15:03',NULL,NULL,'SnailJob控制台菜单'),(121,'租户管理',6,1,'tenant','system/tenant/index','',1,0,'C','0','0','system:tenant:list','list',103,1,'2026-05-21 23:15:03',NULL,NULL,'租户管理菜单'),(122,'租户套餐管理',6,2,'tenantPackage','system/tenantPackage/index','',1,0,'C','0','0','system:tenantPackage:list','form',103,1,'2026-05-21 23:15:03',NULL,NULL,'租户套餐管理菜单'),(123,'客户端管理',1,11,'client','system/client/index','',1,0,'C','0','0','system:client:list','international',103,1,'2026-05-21 23:15:03',NULL,NULL,'客户端管理菜单'),(130,'分配用户',1,2,'role-auth/user/:roleId','system/role/authUser','',1,1,'C','1','0','system:role:edit','#',103,1,'2026-05-21 23:15:03',NULL,NULL,'/system/role'),(131,'分配角色',1,1,'user-auth/role/:userId','system/user/authRole','',1,1,'C','1','0','system:user:edit','#',103,1,'2026-05-21 23:15:03',NULL,NULL,'/system/user'),(132,'字典数据',1,6,'dict-data/index/:dictId','system/dict/data','',1,1,'C','1','0','system:dict:list','#',103,1,'2026-05-21 23:15:03',NULL,NULL,'/system/dict'),(133,'文件配置管理',1,10,'oss-config/index','system/oss/config','',1,1,'C','1','0','system:ossConfig:list','#',103,1,'2026-05-21 23:15:03',NULL,NULL,'/system/oss'),(500,'操作日志',108,1,'operlog','monitor/operlog/index','',1,0,'C','0','0','monitor:operlog:list','form',103,1,'2026-05-21 23:15:03',NULL,NULL,'操作日志菜单'),(501,'登录日志',108,2,'logininfor','monitor/logininfor/index','',1,0,'C','0','0','monitor:logininfor:list','logininfor',103,1,'2026-05-21 23:15:03',NULL,NULL,'登录日志菜单'),(1001,'用户查询',100,1,'','','',1,0,'F','0','0','system:user:query','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1002,'用户新增',100,2,'','','',1,0,'F','0','0','system:user:add','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1003,'用户修改',100,3,'','','',1,0,'F','0','0','system:user:edit','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1004,'用户删除',100,4,'','','',1,0,'F','0','0','system:user:remove','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1005,'用户导出',100,5,'','','',1,0,'F','0','0','system:user:export','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1006,'用户导入',100,6,'','','',1,0,'F','0','0','system:user:import','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1007,'重置密码',100,7,'','','',1,0,'F','0','0','system:user:resetPwd','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1008,'角色查询',101,1,'','','',1,0,'F','0','0','system:role:query','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1009,'角色新增',101,2,'','','',1,0,'F','0','0','system:role:add','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1010,'角色修改',101,3,'','','',1,0,'F','0','0','system:role:edit','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1011,'角色删除',101,4,'','','',1,0,'F','0','0','system:role:remove','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1012,'角色导出',101,5,'','','',1,0,'F','0','0','system:role:export','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1013,'菜单查询',102,1,'','','',1,0,'F','0','0','system:menu:query','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1014,'菜单新增',102,2,'','','',1,0,'F','0','0','system:menu:add','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1015,'菜单修改',102,3,'','','',1,0,'F','0','0','system:menu:edit','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1016,'菜单删除',102,4,'','','',1,0,'F','0','0','system:menu:remove','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1017,'部门查询',103,1,'','','',1,0,'F','0','0','system:dept:query','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1018,'部门新增',103,2,'','','',1,0,'F','0','0','system:dept:add','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1019,'部门修改',103,3,'','','',1,0,'F','0','0','system:dept:edit','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1020,'部门删除',103,4,'','','',1,0,'F','0','0','system:dept:remove','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1021,'岗位查询',104,1,'','','',1,0,'F','0','0','system:post:query','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1022,'岗位新增',104,2,'','','',1,0,'F','0','0','system:post:add','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1023,'岗位修改',104,3,'','','',1,0,'F','0','0','system:post:edit','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1024,'岗位删除',104,4,'','','',1,0,'F','0','0','system:post:remove','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1025,'岗位导出',104,5,'','','',1,0,'F','0','0','system:post:export','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1026,'字典查询',105,1,'#','','',1,0,'F','0','0','system:dict:query','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1027,'字典新增',105,2,'#','','',1,0,'F','0','0','system:dict:add','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1028,'字典修改',105,3,'#','','',1,0,'F','0','0','system:dict:edit','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1029,'字典删除',105,4,'#','','',1,0,'F','0','0','system:dict:remove','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1030,'字典导出',105,5,'#','','',1,0,'F','0','0','system:dict:export','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1031,'参数查询',106,1,'#','','',1,0,'F','0','0','system:config:query','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1032,'参数新增',106,2,'#','','',1,0,'F','0','0','system:config:add','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1033,'参数修改',106,3,'#','','',1,0,'F','0','0','system:config:edit','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1034,'参数删除',106,4,'#','','',1,0,'F','0','0','system:config:remove','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1035,'参数导出',106,5,'#','','',1,0,'F','0','0','system:config:export','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1036,'公告查询',107,1,'#','','',1,0,'F','0','0','system:notice:query','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1037,'公告新增',107,2,'#','','',1,0,'F','0','0','system:notice:add','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1038,'公告修改',107,3,'#','','',1,0,'F','0','0','system:notice:edit','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1039,'公告删除',107,4,'#','','',1,0,'F','0','0','system:notice:remove','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1040,'操作查询',500,1,'#','','',1,0,'F','0','0','monitor:operlog:query','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1041,'操作删除',500,2,'#','','',1,0,'F','0','0','monitor:operlog:remove','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1042,'日志导出',500,4,'#','','',1,0,'F','0','0','monitor:operlog:export','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1043,'登录查询',501,1,'#','','',1,0,'F','0','0','monitor:logininfor:query','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1044,'登录删除',501,2,'#','','',1,0,'F','0','0','monitor:logininfor:remove','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1045,'日志导出',501,3,'#','','',1,0,'F','0','0','monitor:logininfor:export','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1046,'在线查询',109,1,'#','','',1,0,'F','0','0','monitor:online:query','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1047,'批量强退',109,2,'#','','',1,0,'F','0','0','monitor:online:batchLogout','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1048,'单条强退',109,3,'#','','',1,0,'F','0','0','monitor:online:forceLogout','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1050,'账户解锁',501,4,'#','','',1,0,'F','0','0','monitor:logininfor:unlock','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1055,'生成查询',115,1,'#','','',1,0,'F','0','0','tool:gen:query','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1056,'生成修改',115,2,'#','','',1,0,'F','0','0','tool:gen:edit','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1057,'生成删除',115,3,'#','','',1,0,'F','0','0','tool:gen:remove','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1058,'导入代码',115,2,'#','','',1,0,'F','0','0','tool:gen:import','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1059,'预览代码',115,4,'#','','',1,0,'F','0','0','tool:gen:preview','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1060,'生成代码',115,5,'#','','',1,0,'F','0','0','tool:gen:code','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1061,'客户端管理查询',123,1,'#','','',1,0,'F','0','0','system:client:query','#',103,1,'2026-05-21 23:15:04',NULL,NULL,''),(1062,'客户端管理新增',123,2,'#','','',1,0,'F','0','0','system:client:add','#',103,1,'2026-05-21 23:15:04',NULL,NULL,''),(1063,'客户端管理修改',123,3,'#','','',1,0,'F','0','0','system:client:edit','#',103,1,'2026-05-21 23:15:04',NULL,NULL,''),(1064,'客户端管理删除',123,4,'#','','',1,0,'F','0','0','system:client:remove','#',103,1,'2026-05-21 23:15:04',NULL,NULL,''),(1065,'客户端管理导出',123,5,'#','','',1,0,'F','0','0','system:client:export','#',103,1,'2026-05-21 23:15:04',NULL,NULL,''),(1500,'测试单表',5,1,'demo','demo/demo/index','',1,0,'C','0','0','demo:demo:list','#',103,1,'2026-05-21 23:15:04',NULL,NULL,'测试单表菜单'),(1501,'测试单表查询',1500,1,'#','','',1,0,'F','0','0','demo:demo:query','#',103,1,'2026-05-21 23:15:04',NULL,NULL,''),(1502,'测试单表新增',1500,2,'#','','',1,0,'F','0','0','demo:demo:add','#',103,1,'2026-05-21 23:15:04',NULL,NULL,''),(1503,'测试单表修改',1500,3,'#','','',1,0,'F','0','0','demo:demo:edit','#',103,1,'2026-05-21 23:15:04',NULL,NULL,''),(1504,'测试单表删除',1500,4,'#','','',1,0,'F','0','0','demo:demo:remove','#',103,1,'2026-05-21 23:15:04',NULL,NULL,''),(1505,'测试单表导出',1500,5,'#','','',1,0,'F','0','0','demo:demo:export','#',103,1,'2026-05-21 23:15:04',NULL,NULL,''),(1506,'测试树表',5,1,'tree','demo/tree/index','',1,0,'C','0','0','demo:tree:list','#',103,1,'2026-05-21 23:15:04',NULL,NULL,'测试树表菜单'),(1507,'测试树表查询',1506,1,'#','','',1,0,'F','0','0','demo:tree:query','#',103,1,'2026-05-21 23:15:04',NULL,NULL,''),(1508,'测试树表新增',1506,2,'#','','',1,0,'F','0','0','demo:tree:add','#',103,1,'2026-05-21 23:15:04',NULL,NULL,''),(1509,'测试树表修改',1506,3,'#','','',1,0,'F','0','0','demo:tree:edit','#',103,1,'2026-05-21 23:15:04',NULL,NULL,''),(1510,'测试树表删除',1506,4,'#','','',1,0,'F','0','0','demo:tree:remove','#',103,1,'2026-05-21 23:15:04',NULL,NULL,''),(1511,'测试树表导出',1506,5,'#','','',1,0,'F','0','0','demo:tree:export','#',103,1,'2026-05-21 23:15:04',NULL,NULL,''),(1600,'文件查询',118,1,'#','','',1,0,'F','0','0','system:oss:query','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1601,'文件上传',118,2,'#','','',1,0,'F','0','0','system:oss:upload','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1602,'文件下载',118,3,'#','','',1,0,'F','0','0','system:oss:download','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1603,'文件删除',118,4,'#','','',1,0,'F','0','0','system:oss:remove','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1606,'租户查询',121,1,'#','','',1,0,'F','0','0','system:tenant:query','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1607,'租户新增',121,2,'#','','',1,0,'F','0','0','system:tenant:add','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1608,'租户修改',121,3,'#','','',1,0,'F','0','0','system:tenant:edit','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1609,'租户删除',121,4,'#','','',1,0,'F','0','0','system:tenant:remove','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1610,'租户导出',121,5,'#','','',1,0,'F','0','0','system:tenant:export','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1611,'租户套餐查询',122,1,'#','','',1,0,'F','0','0','system:tenantPackage:query','#',103,1,'2026-05-21 23:15:04',NULL,NULL,''),(1612,'租户套餐新增',122,2,'#','','',1,0,'F','0','0','system:tenantPackage:add','#',103,1,'2026-05-21 23:15:04',NULL,NULL,''),(1613,'租户套餐修改',122,3,'#','','',1,0,'F','0','0','system:tenantPackage:edit','#',103,1,'2026-05-21 23:15:04',NULL,NULL,''),(1614,'租户套餐删除',122,4,'#','','',1,0,'F','0','0','system:tenantPackage:remove','#',103,1,'2026-05-21 23:15:04',NULL,NULL,''),(1615,'租户套餐导出',122,5,'#','','',1,0,'F','0','0','system:tenantPackage:export','#',103,1,'2026-05-21 23:15:04',NULL,NULL,''),(1620,'配置列表',118,5,'#','','',1,0,'F','0','0','system:ossConfig:list','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1621,'配置添加',118,6,'#','','',1,0,'F','0','0','system:ossConfig:add','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1622,'配置编辑',118,6,'#','','',1,0,'F','0','0','system:ossConfig:edit','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(1623,'配置删除',118,6,'#','','',1,0,'F','0','0','system:ossConfig:remove','#',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(2000,'基础数据',0,10,'base',NULL,'',1,0,'M','0','0','','server',103,1,'2026-05-22 00:21:34',NULL,NULL,'基础数据目录'),(2001,'主体管理',2400,1,'company','base/company/index','',1,0,'C','0','0','base:company:list','dict',103,1,'2026-05-22 00:21:34',NULL,NULL,'主体管理菜单'),(2002,'仓库管理',2400,2,'warehouse','base/warehouse/index','',1,0,'C','0','0','base:warehouse:list','logininfor',103,1,'2026-05-22 00:21:34',NULL,NULL,'仓库管理菜单'),(2003,'费项管理',2008,3,'fee-item','base/fee-item/index','',1,0,'C','0','0','base:feeItem:list','money',103,1,'2026-05-22 00:21:34',NULL,NULL,'费项管理菜单'),(2004,'商品资料',2000,2,'goods',NULL,'',1,0,'M','0','0','','form',103,1,'2026-05-22 00:21:34',NULL,NULL,'商品资料目录'),(2005,'SKU管理',2004,1,'sku','base/sku/index','',1,0,'C','0','0','base:sku:list','list',103,1,'2026-05-22 00:21:34',NULL,NULL,'SKU管理菜单'),(2006,'平台管理',2000,3,'platform','','',1,0,'M','0','0','','international',103,1,'2026-05-22 00:21:34',NULL,NULL,'平台管理目录'),(2007,'地理资料',2000,4,'geo',NULL,'',1,0,'M','0','0','','earth',103,1,'2026-05-22 00:32:43',NULL,NULL,'地理资料目录'),(2008,'财务资料',2000,5,'finance',NULL,'',1,0,'M','0','0','','dollar',103,1,'2026-05-22 00:32:43',NULL,NULL,'财务资料目录'),(2009,'海运资料',2000,6,'logistics','Layout','',1,0,'M','0','0','','car',103,1,'2026-05-22 00:32:43',1,'2026-05-24 15:34:18','物流基础目录'),(2010,'主体查询',2001,1,'#','','',1,0,'F','0','0','base:company:query','#',103,1,'2026-05-22 00:21:34',NULL,NULL,''),(2011,'主体新增',2001,2,'#','','',1,0,'F','0','0','base:company:add','#',103,1,'2026-05-22 00:21:34',NULL,NULL,''),(2012,'主体修改',2001,3,'#','','',1,0,'F','0','0','base:company:edit','#',103,1,'2026-05-22 00:21:34',NULL,NULL,''),(2013,'主体删除',2001,4,'#','','',1,0,'F','0','0','base:company:remove','#',103,1,'2026-05-22 00:21:34',NULL,NULL,''),(2014,'主体导出',2001,5,'#','','',1,0,'F','0','0','base:company:export','#',103,1,'2026-05-22 00:21:34',NULL,NULL,''),(2020,'仓库查询',2002,1,'#','','',1,0,'F','0','0','base:warehouse:query','#',103,1,'2026-05-22 00:21:34',NULL,NULL,''),(2021,'仓库新增',2002,2,'#','','',1,0,'F','0','0','base:warehouse:add','#',103,1,'2026-05-22 00:21:34',NULL,NULL,''),(2022,'仓库修改',2002,3,'#','','',1,0,'F','0','0','base:warehouse:edit','#',103,1,'2026-05-22 00:21:34',NULL,NULL,''),(2023,'仓库删除',2002,4,'#','','',1,0,'F','0','0','base:warehouse:remove','#',103,1,'2026-05-22 00:21:34',NULL,NULL,''),(2024,'仓库导出',2002,5,'#','','',1,0,'F','0','0','base:warehouse:export','#',103,1,'2026-05-22 00:21:34',NULL,NULL,''),(2030,'费项查询',2003,1,'#','','',1,0,'F','0','0','base:feeItem:query','#',103,1,'2026-05-22 00:21:34',NULL,NULL,''),(2031,'费项新增',2003,2,'#','','',1,0,'F','0','0','base:feeItem:add','#',103,1,'2026-05-22 00:21:34',NULL,NULL,''),(2032,'费项修改',2003,3,'#','','',1,0,'F','0','0','base:feeItem:edit','#',103,1,'2026-05-22 00:21:34',NULL,NULL,''),(2033,'费项删除',2003,4,'#','','',1,0,'F','0','0','base:feeItem:remove','#',103,1,'2026-05-22 00:21:34',NULL,NULL,''),(2034,'费项导出',2003,5,'#','','',1,0,'F','0','0','base:feeItem:export','#',103,1,'2026-05-22 00:21:34',NULL,NULL,''),(2050,'SKU查询',2005,1,'#','','',1,0,'F','0','0','base:sku:query','#',103,1,'2026-05-22 00:21:34',NULL,NULL,''),(2051,'SKU新增',2005,2,'#','','',1,0,'F','0','0','base:sku:add','#',103,1,'2026-05-22 00:21:34',NULL,NULL,''),(2052,'SKU修改',2005,3,'#','','',1,0,'F','0','0','base:sku:edit','#',103,1,'2026-05-22 00:21:34',NULL,NULL,''),(2053,'SKU删除',2005,4,'#','','',1,0,'F','0','0','base:sku:remove','#',103,1,'2026-05-22 00:21:34',NULL,NULL,''),(2054,'SKU导出',2005,5,'#','','',1,0,'F','0','0','base:sku:export','#',103,1,'2026-05-22 00:21:34',NULL,NULL,''),(2060,'平台查询',2067,1,'#','','',1,0,'F','0','0','base:platform:query','#',103,1,'2026-05-22 00:21:34',NULL,NULL,''),(2061,'平台新增',2067,2,'#','','',1,0,'F','0','0','base:platform:add','#',103,1,'2026-05-22 00:21:34',NULL,NULL,''),(2062,'平台修改',2067,3,'#','','',1,0,'F','0','0','base:platform:edit','#',103,1,'2026-05-22 00:21:34',NULL,NULL,''),(2063,'平台删除',2067,4,'#','','',1,0,'F','0','0','base:platform:remove','#',103,1,'2026-05-22 00:21:34',NULL,NULL,''),(2064,'平台导出',2067,5,'#','','',1,0,'F','0','0','base:platform:export','#',103,1,'2026-05-22 00:21:34',NULL,NULL,''),(2067,'平台配置',2006,1,'config','base/platform/index','',1,0,'C','0','0','base:platform:list','setting',103,1,'2026-05-22 00:35:20',NULL,NULL,'平台配置菜单'),(2068,'平台地址',2006,2,'address','base/platform-address/index','',1,0,'C','0','0','base:platformAddress:list','environment',103,1,'2026-05-22 00:35:20',NULL,NULL,'平台地址菜单'),(2080,'平台地址查询',2068,1,'#','','',1,0,'F','0','0','base:platformAddress:query','#',103,1,'2026-05-22 00:35:20',NULL,NULL,''),(2081,'平台地址新增',2068,2,'#','','',1,0,'F','0','0','base:platformAddress:add','#',103,1,'2026-05-22 00:35:20',NULL,NULL,''),(2082,'平台地址修改',2068,3,'#','','',1,0,'F','0','0','base:platformAddress:edit','#',103,1,'2026-05-22 00:35:20',NULL,NULL,''),(2083,'平台地址删除',2068,4,'#','','',1,0,'F','0','0','base:platformAddress:remove','#',103,1,'2026-05-22 00:35:20',NULL,NULL,''),(2084,'平台地址导出',2068,5,'#','','',1,0,'F','0','0','base:platformAddress:export','#',103,1,'2026-05-22 00:35:20',NULL,NULL,''),(2101,'国家管理',2007,1,'country','base/country/index','',1,0,'C','0','0','base:country:list','flag',103,1,'2026-05-22 00:32:43',NULL,NULL,'国家管理菜单'),(2102,'州省管理',2007,2,'state-province','base/state-province/index','',1,0,'C','0','0','base:stateProvince:list','tree',103,1,'2026-05-22 00:32:43',NULL,NULL,'州省管理菜单'),(2103,'城市管理',2007,3,'city','base/city/index','',1,0,'C','0','0','base:city:list','city',103,1,'2026-05-22 00:32:43',NULL,NULL,'城市管理菜单'),(2104,'时区管理',2007,4,'timezone','base/timezone/index','',1,0,'C','0','0','base:timezone:list','time-circle',103,1,'2026-05-22 00:32:43',NULL,NULL,'时区管理菜单'),(2110,'国家查询',2101,1,'#','','',1,0,'F','0','0','base:country:query','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2111,'国家新增',2101,2,'#','','',1,0,'F','0','0','base:country:add','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2112,'国家修改',2101,3,'#','','',1,0,'F','0','0','base:country:edit','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2113,'国家删除',2101,4,'#','','',1,0,'F','0','0','base:country:remove','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2114,'国家导出',2101,5,'#','','',1,0,'F','0','0','base:country:export','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2120,'州省查询',2102,1,'#','','',1,0,'F','0','0','base:stateProvince:query','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2121,'州省新增',2102,2,'#','','',1,0,'F','0','0','base:stateProvince:add','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2122,'州省修改',2102,3,'#','','',1,0,'F','0','0','base:stateProvince:edit','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2123,'州省删除',2102,4,'#','','',1,0,'F','0','0','base:stateProvince:remove','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2124,'州省导出',2102,5,'#','','',1,0,'F','0','0','base:stateProvince:export','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2130,'城市查询',2103,1,'#','','',1,0,'F','0','0','base:city:query','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2131,'城市新增',2103,2,'#','','',1,0,'F','0','0','base:city:add','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2132,'城市修改',2103,3,'#','','',1,0,'F','0','0','base:city:edit','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2133,'城市删除',2103,4,'#','','',1,0,'F','0','0','base:city:remove','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2134,'城市导出',2103,5,'#','','',1,0,'F','0','0','base:city:export','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2140,'时区查询',2104,1,'#','','',1,0,'F','0','0','base:timezone:query','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2141,'时区新增',2104,2,'#','','',1,0,'F','0','0','base:timezone:add','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2142,'时区修改',2104,3,'#','','',1,0,'F','0','0','base:timezone:edit','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2143,'时区删除',2104,4,'#','','',1,0,'F','0','0','base:timezone:remove','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2144,'时区导出',2104,5,'#','','',1,0,'F','0','0','base:timezone:export','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2201,'币种管理',2008,1,'currency','base/currency/index','',1,0,'C','0','0','base:currency:list','money',103,1,'2026-05-22 00:32:43',NULL,NULL,'币种管理菜单'),(2202,'汇率管理',2008,2,'exchange-rate','base/exchange-rate/index','',1,0,'C','0','0','base:exchangeRate:list','swap',103,1,'2026-05-22 00:32:43',NULL,NULL,'汇率管理菜单'),(2210,'币种查询',2201,1,'#','','',1,0,'F','0','0','base:currency:query','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2211,'币种新增',2201,2,'#','','',1,0,'F','0','0','base:currency:add','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2212,'币种修改',2201,3,'#','','',1,0,'F','0','0','base:currency:edit','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2213,'币种删除',2201,4,'#','','',1,0,'F','0','0','base:currency:remove','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2214,'币种导出',2201,5,'#','','',1,0,'F','0','0','base:currency:export','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2220,'汇率查询',2202,1,'#','','',1,0,'F','0','0','base:exchangeRate:query','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2221,'汇率新增',2202,2,'#','','',1,0,'F','0','0','base:exchangeRate:add','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2222,'汇率修改',2202,3,'#','','',1,0,'F','0','0','base:exchangeRate:edit','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2223,'汇率删除',2202,4,'#','','',1,0,'F','0','0','base:exchangeRate:remove','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2224,'汇率导出',2202,5,'#','','',1,0,'F','0','0','base:exchangeRate:export','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2301,'港口管理',2009,1,'port','base/port/index','',1,0,'C','0','0','base:port:list','environment',103,1,'2026-05-22 00:32:43',NULL,NULL,'港口管理菜单'),(2302,'船司管理',2009,3,'shipping-line','base/shipping-line/index','',1,0,'C','0','0','base:shippingLine:list','deployment-unit',103,1,'2026-05-22 00:32:43',NULL,'2026-05-23 23:50:21','船司管理菜单'),(2303,'邮编库管理',2007,5,'zip-code','base/zip-code/index','',1,0,'C','0','0','base:zipCode:list','mail',103,1,'2026-05-22 00:32:43',NULL,NULL,'邮编库管理菜单'),(2304,'码头管理',2009,2,'terminal','base/terminal/index','',1,0,'C','0','0','base:terminal:list','map',103,1,'2026-05-23 23:50:21',1,'2026-05-24 15:34:34','??????????????????'),(2305,'航线管理',2009,4,'shipping-route','base/shipping-route/index','',1,0,'C','0','0','base:shippingRoute:list','branches',103,1,'2026-05-24 00:07:56',NULL,NULL,'??????????????????'),(2306,'船舶管理',2009,5,'vessel','base/vessel/index','',1,0,'C','0','0','base:vessel:list','directions-boat',103,1,'2026-05-24 00:23:03',NULL,NULL,'Vessel menu'),(2310,'港口查询',2301,1,'#','','',1,0,'F','0','0','base:port:query','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2311,'港口新增',2301,2,'#','','',1,0,'F','0','0','base:port:add','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2312,'港口修改',2301,3,'#','','',1,0,'F','0','0','base:port:edit','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2313,'港口删除',2301,4,'#','','',1,0,'F','0','0','base:port:remove','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2314,'港口导出',2301,5,'#','','',1,0,'F','0','0','base:port:export','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2320,'船司查询',2302,1,'#','','',1,0,'F','0','0','base:shippingLine:query','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2321,'船司新增',2302,2,'#','','',1,0,'F','0','0','base:shippingLine:add','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2322,'船司修改',2302,3,'#','','',1,0,'F','0','0','base:shippingLine:edit','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2323,'船司删除',2302,4,'#','','',1,0,'F','0','0','base:shippingLine:remove','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2324,'船司导出',2302,5,'#','','',1,0,'F','0','0','base:shippingLine:export','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2330,'邮编查询',2303,1,'#','','',1,0,'F','0','0','base:zipCode:query','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2331,'邮编新增',2303,2,'#','','',1,0,'F','0','0','base:zipCode:add','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2332,'邮编修改',2303,3,'#','','',1,0,'F','0','0','base:zipCode:edit','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2333,'邮编删除',2303,4,'#','','',1,0,'F','0','0','base:zipCode:remove','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2334,'邮编导出',2303,5,'#','','',1,0,'F','0','0','base:zipCode:export','#',103,1,'2026-05-22 00:32:43',NULL,NULL,''),(2340,'????????????',2304,1,'#','','',1,0,'F','0','0','base:terminal:query','#',103,1,'2026-05-23 23:50:21',NULL,NULL,''),(2341,'????????????',2304,2,'#','','',1,0,'F','0','0','base:terminal:add','#',103,1,'2026-05-23 23:50:21',NULL,NULL,''),(2342,'????????????',2304,3,'#','','',1,0,'F','0','0','base:terminal:edit','#',103,1,'2026-05-23 23:50:21',NULL,NULL,''),(2343,'????????????',2304,4,'#','','',1,0,'F','0','0','base:terminal:remove','#',103,1,'2026-05-23 23:50:21',NULL,NULL,''),(2344,'????????????',2304,5,'#','','',1,0,'F','0','0','base:terminal:export','#',103,1,'2026-05-23 23:50:21',NULL,NULL,''),(2350,'航线查询',2305,1,'#','','',1,0,'F','0','0','base:shippingRoute:query','#',103,1,'2026-05-24 00:07:56',NULL,NULL,''),(2351,'航线新增',2305,2,'#','','',1,0,'F','0','0','base:shippingRoute:add','#',103,1,'2026-05-24 00:07:56',NULL,NULL,''),(2352,'航线修改',2305,3,'#','','',1,0,'F','0','0','base:shippingRoute:edit','#',103,1,'2026-05-24 00:07:56',NULL,NULL,''),(2353,'航线删除',2305,4,'#','','',1,0,'F','0','0','base:shippingRoute:remove','#',103,1,'2026-05-24 00:07:56',NULL,NULL,''),(2354,'航线导出',2305,5,'#','','',1,0,'F','0','0','base:shippingRoute:export','#',103,1,'2026-05-24 00:07:56',NULL,NULL,''),(2360,'船舶查询',2306,1,'#','','',1,0,'F','0','0','base:vessel:query','#',103,1,'2026-05-24 00:23:03',NULL,NULL,''),(2361,'船舶新增',2306,2,'#','','',1,0,'F','0','0','base:vessel:add','#',103,1,'2026-05-24 00:23:03',NULL,NULL,''),(2362,'船舶修改',2306,3,'#','','',1,0,'F','0','0','base:vessel:edit','#',103,1,'2026-05-24 00:23:03',NULL,NULL,''),(2363,'船舶删除',2306,4,'#','','',1,0,'F','0','0','base:vessel:remove','#',103,1,'2026-05-24 00:23:03',NULL,NULL,''),(2364,'船舶导出',2306,5,'#','','',1,0,'F','0','0','base:vessel:export','#',103,1,'2026-05-24 00:23:03',NULL,NULL,''),(2400,'组织资料',2000,1,'organization',NULL,'',1,0,'M','0','0','','tree-table',103,1,'2026-05-22 00:59:13',NULL,NULL,'组织资料目录'),(2500,'业务资料',2000,4,'business-data',NULL,'',1,0,'M','0','0','','tree-table',103,1,'2026-05-22 01:18:15',NULL,NULL,'业务资料目录'),(2501,'渠道管理',2500,1,'channel','base/channel/index','',1,0,'C','0','0','base:channel:list','branches',103,1,'2026-05-22 01:18:15',NULL,NULL,'渠道管理菜单'),(2502,'业务类型管理',2500,2,'business-type','base/business-type/index','',1,0,'C','0','0','base:businessType:list','list',103,1,'2026-05-22 01:18:15',NULL,NULL,'业务类型管理菜单'),(2503,'增值服务管理',2500,3,'value-added-service','base/value-added-service/index','',1,0,'C','0','0','base:vas:list','form',103,1,'2026-05-22 01:18:15',NULL,NULL,'增值服务管理菜单'),(2510,'渠道查询',2501,1,'#','','',1,0,'F','0','0','base:channel:query','#',103,1,'2026-05-22 01:18:16',NULL,NULL,''),(2511,'渠道新增',2501,2,'#','','',1,0,'F','0','0','base:channel:add','#',103,1,'2026-05-22 01:18:16',NULL,NULL,''),(2512,'渠道修改',2501,3,'#','','',1,0,'F','0','0','base:channel:edit','#',103,1,'2026-05-22 01:18:16',NULL,NULL,''),(2513,'渠道删除',2501,4,'#','','',1,0,'F','0','0','base:channel:remove','#',103,1,'2026-05-22 01:18:16',NULL,NULL,''),(2514,'渠道导出',2501,5,'#','','',1,0,'F','0','0','base:channel:export','#',103,1,'2026-05-22 01:18:16',NULL,NULL,''),(2520,'业务类型查询',2502,1,'#','','',1,0,'F','0','0','base:businessType:query','#',103,1,'2026-05-22 01:18:16',NULL,NULL,''),(2521,'业务类型新增',2502,2,'#','','',1,0,'F','0','0','base:businessType:add','#',103,1,'2026-05-22 01:18:16',NULL,NULL,''),(2522,'业务类型修改',2502,3,'#','','',1,0,'F','0','0','base:businessType:edit','#',103,1,'2026-05-22 01:18:16',NULL,NULL,''),(2523,'业务类型删除',2502,4,'#','','',1,0,'F','0','0','base:businessType:remove','#',103,1,'2026-05-22 01:18:16',NULL,NULL,''),(2524,'业务类型导出',2502,5,'#','','',1,0,'F','0','0','base:businessType:export','#',103,1,'2026-05-22 01:18:16',NULL,NULL,''),(2530,'增值服务查询',2503,1,'#','','',1,0,'F','0','0','base:vas:query','#',103,1,'2026-05-22 01:18:16',NULL,NULL,''),(2531,'增值服务新增',2503,2,'#','','',1,0,'F','0','0','base:vas:add','#',103,1,'2026-05-22 01:18:16',NULL,NULL,''),(2532,'增值服务修改',2503,3,'#','','',1,0,'F','0','0','base:vas:edit','#',103,1,'2026-05-22 01:18:16',NULL,NULL,''),(2533,'增值服务删除',2503,4,'#','','',1,0,'F','0','0','base:vas:remove','#',103,1,'2026-05-22 01:18:16',NULL,NULL,''),(2534,'增值服务导出',2503,5,'#','','',1,0,'F','0','0','base:vas:export','#',103,1,'2026-05-22 01:18:16',NULL,NULL,''),(2600,'园区管理',2000,7,'yard',NULL,'',1,0,'M','0','0','','warehouse',103,1,'2026-05-24 00:07:56',NULL,NULL,'??????????????????'),(2601,'月台与堆位',2600,1,'dock','yard/dock/index','',1,0,'C','0','0','yard:dock:list','home',103,1,'2026-05-24 00:07:56',NULL,NULL,'?????????????????? [含道口/停车位/堆场堆位]'),(2610,'月台查询',2601,1,'#','','',1,0,'F','0','0','yard:dock:query','#',103,1,'2026-05-24 00:07:56',NULL,NULL,''),(2611,'月台新增',2601,2,'#','','',1,0,'F','0','0','yard:dock:add','#',103,1,'2026-05-24 00:07:56',NULL,NULL,''),(2612,'月台修改',2601,3,'#','','',1,0,'F','0','0','yard:dock:edit','#',103,1,'2026-05-24 00:07:56',NULL,NULL,''),(2613,'月台删除',2601,4,'#','','',1,0,'F','0','0','yard:dock:remove','#',103,1,'2026-05-24 00:07:56',NULL,NULL,''),(2614,'月台导出',2601,5,'#','','',1,0,'F','0','0','yard:dock:export','#',103,1,'2026-05-24 00:07:56',NULL,NULL,''),(2620,'堆场分区',2600,2,'zone','yard/zone/index','',1,0,'C','1','0','yard:zone:list','grid',103,1,'2026-05-29 12:39:22',NULL,NULL,'Yard zone master [已收敛至BASE yard/zone + yard/dock]'),(2621,'堆场分区查询',2620,1,'#','','',1,0,'F','0','0','yard:zone:query','#',103,1,'2026-05-29 12:39:22',NULL,NULL,''),(2622,'堆场分区新增',2620,2,'#','','',1,0,'F','0','0','yard:zone:add','#',103,1,'2026-05-29 12:39:22',NULL,NULL,''),(2623,'堆场分区编辑',2620,3,'#','','',1,0,'F','0','0','yard:zone:edit','#',103,1,'2026-05-29 12:39:22',NULL,NULL,''),(2624,'堆场分区删除',2620,4,'#','','',1,0,'F','0','0','yard:zone:remove','#',103,1,'2026-05-29 12:39:22',NULL,NULL,''),(3000,'OMS系统',0,20,'oms','Layout','',1,0,'M','0','0','','appstore',103,1,'2026-05-22 02:21:52',1,'2026-05-23 02:08:18','OMS业务目录'),(3001,'海柜订单',3000,1,'container-order','oms/container-order/index','',1,0,'C','0','0','oms:containerOrder:list','container',103,1,'2026-05-22 02:21:52',NULL,NULL,'海柜订单菜单'),(3002,'货物订单',3000,2,'cargo-order','oms/cargo-order/index','',1,0,'C','0','0','oms:cargoOrder:list','shopping',103,1,'2026-05-22 16:38:45',NULL,NULL,'货物订单菜单'),(3010,'出单工作台',3000,3,'outbound-pool','oms/outbound-pool/index','',1,0,'C','0','0','oms:outboundPool:list','list',103,1,'2026-05-22 02:21:52',NULL,'2026-05-24 12:43:37',''),(3011,'预出单管理',3000,4,'pre-outbound','oms/pre-outbound/index','',1,0,'C','0','0','oms:preOutbound:list','calendar',103,1,'2026-05-22 02:21:52',NULL,'2026-05-24 12:43:37',''),(3012,'出库订单',3000,5,'outbound-order','oms/outbound-order/index','',1,0,'C','0','0','oms:outboundOrder:list','truck',103,1,'2026-05-22 02:21:52',NULL,'2026-05-24 12:43:37',''),(3013,'海柜订单删除',3001,4,'#','','',1,0,'F','0','0','oms:containerOrder:remove','#',103,1,'2026-05-22 02:21:52',NULL,NULL,''),(3014,'海柜订单导出',3001,5,'#','','',1,0,'F','0','0','oms:containerOrder:export','#',103,1,'2026-05-22 02:21:52',NULL,NULL,''),(3015,'海柜状态动作',3001,6,'#','','',1,0,'F','0','0','oms:containerOrder:updateStatus','#',103,1,'2026-05-22 02:21:52',NULL,NULL,''),(3016,'上传DO',3001,7,'#','','',1,0,'F','0','0','oms:containerOrder:uploadDo','#',103,1,'2026-05-23 11:31:23',NULL,NULL,''),(3017,'上传海柜附件',3001,8,'#','','',1,0,'F','0','0','oms:containerOrder:attachmentUpload','#',103,1,'2026-05-23 11:31:23',NULL,NULL,''),(3018,'删除海柜附件',3001,9,'#','','',1,0,'F','0','0','oms:containerOrder:attachmentRemove','#',103,1,'2026-05-23 11:31:23',NULL,NULL,''),(3019,'入库计划',3001,10,'#','','',1,0,'F','0','0','oms:containerOrder:inboundPlan','#',103,1,'2026-05-23 11:31:23',NULL,NULL,''),(3020,'货物订单查询',3002,1,'#','','',1,0,'F','0','0','oms:cargoOrder:query','#',103,1,'2026-05-22 16:38:45',NULL,NULL,''),(3021,'货物订单新增',3002,2,'#','','',1,0,'F','0','0','oms:cargoOrder:add','#',103,1,'2026-05-22 16:38:45',NULL,NULL,''),(3022,'货物订单编辑',3002,3,'#','','',1,0,'F','0','0','oms:cargoOrder:edit','#',103,1,'2026-05-22 16:38:45',NULL,NULL,''),(3023,'货物订单删除',3002,4,'#','','',1,0,'F','0','0','oms:cargoOrder:remove','#',103,1,'2026-05-22 16:38:45',NULL,NULL,''),(3024,'货物订单导出',3002,5,'#','','',1,0,'F','0','0','oms:cargoOrder:export','#',103,1,'2026-05-22 16:38:45',NULL,NULL,''),(3025,'受理订单',3002,10,'#','','',1,0,'F','0','0','oms:cargoOrder:accept','#',103,1,'2026-05-22 16:38:45',NULL,NULL,''),(3026,'标记在途',3002,11,'#','','',1,0,'F','0','0','oms:cargoOrder:markInTransit','#',103,1,'2026-05-22 16:38:45',NULL,NULL,''),(3027,'确认到港',3002,12,'#','','',1,0,'F','0','0','oms:cargoOrder:confirmArrivedPort','#',103,1,'2026-05-22 16:38:45',NULL,NULL,''),(3028,'确认提柜',3002,13,'#','','',1,0,'F','0','0','oms:cargoOrder:confirmPickedUp','#',103,1,'2026-05-22 16:38:45',NULL,NULL,''),(3029,'确认到仓',3002,14,'#','','',1,0,'F','0','0','oms:cargoOrder:confirmArrivedWarehouse','#',103,1,'2026-05-22 16:38:45',NULL,NULL,''),(3030,'开始拆柜',3002,15,'#','','',1,0,'F','0','0','oms:cargoOrder:startDevanning','#',103,1,'2026-05-22 16:38:45',NULL,NULL,''),(3031,'拆柜完成',3002,16,'#','','',1,0,'F','0','0','oms:cargoOrder:finishDevanning','#',103,1,'2026-05-22 16:38:45',NULL,NULL,''),(3032,'确认入库',3002,17,'#','','',1,0,'F','0','0','oms:cargoOrder:confirmInbounded','#',103,1,'2026-05-22 16:38:45',NULL,NULL,''),(3033,'正式出单',3002,18,'#','','',1,0,'F','0','0','oms:cargoOrder:createOutboundOrder','#',103,1,'2026-05-22 16:38:45',NULL,NULL,''),(3034,'预约派送',3002,19,'#','','',1,0,'F','0','0','oms:cargoOrder:appointDelivery','#',103,1,'2026-05-22 16:38:45',NULL,NULL,''),(3035,'确认出库',3002,20,'#','','',1,0,'F','0','0','oms:cargoOrder:confirmOutbounded','#',103,1,'2026-05-22 16:38:45',NULL,NULL,''),(3036,'标记派送中',3002,21,'#','','',1,0,'F','0','0','oms:cargoOrder:markDelivering','#',103,1,'2026-05-22 16:38:45',NULL,NULL,''),(3037,'确认签收',3002,22,'#','','',1,0,'F','0','0','oms:cargoOrder:confirmDelivered','#',103,1,'2026-05-22 16:38:45',NULL,NULL,''),(3038,'上传POD',3002,23,'#','','',1,0,'F','0','0','oms:cargoOrder:uploadPod','#',103,1,'2026-05-22 16:38:45',NULL,NULL,''),(3039,'出账单',3002,24,'#','','',1,0,'F','0','0','oms:cargoOrder:confirmBilled','#',103,1,'2026-05-22 16:38:45',NULL,NULL,''),(3040,'完结订单',3002,25,'#','','',1,0,'F','0','0','oms:cargoOrder:complete','#',103,1,'2026-05-22 16:38:45',NULL,NULL,''),(3041,'取消订单',3002,26,'#','','',1,0,'F','0','0','oms:cargoOrder:cancel','#',103,1,'2026-05-22 16:38:45',NULL,NULL,''),(3042,'创建预出单',3002,30,'#','','',1,0,'F','0','0','oms:cargoOrder:createPreOutbound','#',103,1,'2026-05-22 16:38:45',NULL,NULL,''),(3043,'转正式出单',3002,31,'#','','',1,0,'F','0','0','oms:cargoOrder:convertPreOutbound','#',103,1,'2026-05-22 16:38:45',NULL,NULL,''),(3044,'取消预出单',3002,32,'#','','',1,0,'F','0','0','oms:cargoOrder:cancelPreOutbound','#',103,1,'2026-05-22 16:38:45',NULL,NULL,''),(3045,'修改入库仓',3002,40,'#','','',1,0,'F','0','0','oms:cargoOrder:changeInboundWarehouse','#',103,1,'2026-05-22 16:38:45',NULL,NULL,''),(3046,'上传货物附件',3002,41,'#','','',1,0,'F','0','0','oms:cargoOrder:attachmentUpload','#',103,1,'2026-05-23 11:31:23',NULL,NULL,''),(3047,'删除货物附件',3002,42,'#','','',1,0,'F','0','0','oms:cargoOrder:attachmentRemove','#',103,1,'2026-05-23 11:31:23',NULL,NULL,''),(3048,'货物暂扣',3002,43,'#','','',1,0,'F','0','0','oms:cargoOrder:hold','#',103,1,'2026-05-23 11:31:24',NULL,NULL,''),(3049,'货物放行',3002,44,'#','','',1,0,'F','0','0','oms:cargoOrder:releaseHold','#',103,1,'2026-05-23 11:31:24',NULL,NULL,''),(3050,'货物拆单',3002,45,'#','','',1,0,'F','0','0','oms:cargoOrder:split','#',103,1,'2026-05-23 11:31:24',NULL,NULL,''),(3051,'回并原单',3002,46,'#','','',1,0,'F','0','0','oms:cargoOrder:mergeBack','#',103,1,'2026-05-23 11:31:24',NULL,NULL,''),(3052,'取消转仓',3002,47,'#','','',1,0,'F','0','0','oms:cargoOrder:cancelTransfer','#',103,1,'2026-05-24 02:45:40',NULL,NULL,''),(3053,'修改转仓',3002,48,'#','','',1,0,'F','0','0','oms:cargoOrder:modifyTransfer','#',103,1,'2026-05-24 02:45:40',NULL,NULL,''),(3054,'导入货物订单',3002,49,'#','','',1,0,'F','0','0','oms:cargoOrder:import','#',103,1,'2026-05-24 02:45:40',NULL,NULL,''),(3055,'海柜导入货物订单',3001,11,'#','','',1,0,'F','0','0','oms:containerOrder:importCargo','#',103,1,'2026-05-24 02:45:40',NULL,NULL,''),(3060,'分组规则配置',3000,8,'cargo-grouping-rule','oms/cargo-grouping-rule/index',NULL,1,0,'C','0','0','oms:cargoGroupingRule:list','tree',NULL,NULL,'2026-05-27 17:34:49',NULL,'2026-05-27 19:01:15','??????????????????????????????'),(3061,'分组规则查询',3060,1,'','',NULL,1,0,'F','0','0','oms:cargoGroupingRule:query','#',NULL,NULL,'2026-05-27 17:34:49',NULL,'2026-05-27 19:01:15',''),(3062,'分组规则新增',3060,2,'','',NULL,1,0,'F','0','0','oms:cargoGroupingRule:add','#',NULL,NULL,'2026-05-27 17:34:49',NULL,'2026-05-27 19:01:15',''),(3063,'分组规则编辑',3060,3,'','',NULL,1,0,'F','0','0','oms:cargoGroupingRule:edit','#',NULL,NULL,'2026-05-27 17:34:49',NULL,'2026-05-27 19:01:15',''),(3064,'分组规则删除',3060,4,'','',NULL,1,0,'F','0','0','oms:cargoGroupingRule:remove','#',NULL,NULL,'2026-05-27 17:34:49',NULL,'2026-05-27 19:01:15',''),(3065,'分组规则启用',3060,5,'','',NULL,1,0,'F','0','0','oms:cargoGroupingRule:enable','#',NULL,NULL,'2026-05-27 17:34:49',NULL,'2026-05-27 19:01:15',''),(3066,'分组规则停用',3060,6,'','',NULL,1,0,'F','0','0','oms:cargoGroupingRule:disable','#',NULL,NULL,'2026-05-27 17:34:49',NULL,'2026-05-27 19:01:15',''),(3067,'分组规则复制',3060,7,'','',NULL,1,0,'F','0','0','oms:cargoGroupingRule:copy','#',NULL,NULL,'2026-05-27 17:34:49',NULL,'2026-05-27 19:01:15',''),(3068,'分组规则优先级',3060,8,'','',NULL,1,0,'F','0','0','oms:cargoGroupingRule:priority','#',NULL,NULL,'2026-05-27 17:34:49',NULL,'2026-05-27 19:01:15',''),(3069,'分组规则试算',3060,9,'','',NULL,1,0,'F','0','0','oms:cargoGroupingRule:test','#',NULL,NULL,'2026-05-27 17:34:49',NULL,'2026-05-27 19:01:15',''),(3070,'分组字段查询',3060,10,'','',NULL,1,0,'F','0','0','oms:cargoGroupingFieldMeta:list','#',NULL,NULL,'2026-05-27 17:34:49',NULL,'2026-05-27 19:01:15',''),(3071,'分组字段新增',3060,11,'','',NULL,1,0,'F','0','0','oms:cargoGroupingFieldMeta:add','#',NULL,NULL,'2026-05-27 17:34:49',NULL,'2026-05-27 19:01:15',''),(3072,'分组字段编辑',3060,12,'','',NULL,1,0,'F','0','0','oms:cargoGroupingFieldMeta:edit','#',NULL,NULL,'2026-05-27 17:34:49',NULL,'2026-05-27 19:01:15',''),(3080,'入库计划',3000,9,'inbound-plan','oms/inbound-plan/index',NULL,1,0,'C','1','0','wms:inboundPlan:list','#',NULL,NULL,'2026-05-27 20:38:52',NULL,NULL,'入库计划页面'),(3081,'入库计划查询',3080,1,'','',NULL,1,0,'F','0','0','wms:inboundPlan:list','#',NULL,NULL,'2026-05-27 20:38:52',NULL,NULL,''),(3082,'入库计划自动分组',3080,2,'','',NULL,1,0,'F','0','0','wms:inboundPlan:autoGroup','#',NULL,NULL,'2026-05-27 20:38:52',NULL,NULL,''),(3083,'入库计划快速配置',3080,3,'','',NULL,1,0,'F','0','0','wms:inboundPlan:applyRule','#',NULL,NULL,'2026-05-27 20:38:52',NULL,NULL,''),(3084,'入库计划编辑明细',3080,4,'','',NULL,1,0,'F','0','0','wms:inboundPlan:edit','#',NULL,NULL,'2026-05-27 20:38:52',NULL,NULL,''),(3085,'入库计划开始作业',3080,5,'','',NULL,1,0,'F','0','0','wms:inboundPlan:startWork','#',NULL,NULL,'2026-05-27 20:38:52',NULL,NULL,''),(3086,'入库计划完结',3080,6,'','',NULL,1,0,'F','0','0','wms:inboundPlan:complete','#',NULL,NULL,'2026-05-27 20:38:52',NULL,NULL,''),(3087,'入库计划取消',3080,7,'','',NULL,1,0,'F','0','0','wms:inboundPlan:cancel','#',NULL,NULL,'2026-05-27 20:38:52',NULL,NULL,''),(5000,'园区管理',0,50,'yms',NULL,'',1,0,'M','0','0','','fork',103,1,'2026-05-28 11:17:58',NULL,NULL,'YMS园区管理目录'),(5001,'园区调度',5192,1,'dispatch','yms/dispatch/index','',1,0,'C','0','0','yms:yard:view','monitor',103,1,'2026-05-28 11:17:58',NULL,NULL,'园区调度总览'),(5002,'任务详情',5000,2,'dispatch-detail','yms/dispatch-detail/index','',1,0,'C','1','0','yms:yard:view','#',103,1,'2026-05-28 11:17:58',NULL,NULL,'园区任务详情页（隐藏）'),(5003,'新建任务',5000,3,'dispatch-create','yms/dispatch-create/index','',1,0,'C','1','0','yms:yard:create','#',103,1,'2026-05-28 11:17:58',NULL,NULL,'手动新建园区任务页（隐藏）'),(5004,'任务管理',5192,2,'task','yms/task/index','',1,0,'C','0','0','yms:yard:view','list',103,1,'2026-05-28 12:53:44',NULL,NULL,'园区任务管理列表'),(5005,'拆柜调度',5192,3,'devanning','yms/devanning/index','',1,0,'C','0','0','yms:yard:view','unpack',103,1,'2026-05-28 15:06:34',NULL,NULL,'拆柜调度页面'),(5006,'装车调度',5192,4,'loading','yms/loading/index','',1,0,'C','0','0','yms:yard:view','car',103,1,'2026-05-28 15:06:34',NULL,NULL,'装车调度页面'),(5010,'查看任务',5001,1,'#','','',1,0,'F','0','0','yms:yard:view','#',103,1,'2026-05-28 11:17:58',NULL,NULL,''),(5011,'新建任务',5001,2,'#','','',1,0,'F','0','0','yms:yard:create','#',103,1,'2026-05-28 11:17:58',NULL,NULL,''),(5012,'OMS推送',5001,3,'#','','',1,0,'F','0','0','yms:yard:push','#',103,1,'2026-05-28 11:17:58',NULL,NULL,''),(5013,'签到',5001,4,'#','','',1,0,'F','0','0','yms:yard:checkin','#',103,1,'2026-05-28 11:17:58',NULL,NULL,''),(5014,'分配Dock',5001,5,'#','','',1,0,'F','0','0','yms:yard:assignDock','#',103,1,'2026-05-28 11:17:58',NULL,NULL,''),(5015,'开始作业',5001,6,'#','','',1,0,'F','0','0','yms:yard:start','#',103,1,'2026-05-28 11:17:58',NULL,NULL,''),(5016,'完成作业',5001,7,'#','','',1,0,'F','0','0','yms:yard:finish','#',103,1,'2026-05-28 11:17:58',NULL,NULL,''),(5017,'放行',5001,8,'#','','',1,0,'F','0','0','yms:yard:release','#',103,1,'2026-05-28 11:17:58',NULL,NULL,''),(5018,'异常处理',5001,9,'#','','',1,0,'F','0','0','yms:yard:exception','#',103,1,'2026-05-28 11:17:58',NULL,NULL,''),(5019,'离园',5001,10,'#','','',1,0,'F','0','0','yms:yard:leave','#',103,1,'2026-05-28 12:53:44',NULL,NULL,''),(5020,'取消任务',5001,11,'#','','',1,0,'F','0','0','yms:yard:cancel','#',103,1,'2026-05-28 12:53:44',NULL,NULL,''),(5021,'调整优先级',5001,12,'#','','',1,0,'F','0','0','yms:yard:priority','#',103,1,'2026-05-29 12:42:12',NULL,NULL,''),(5022,'WMS备货回写',5001,13,'#','','',1,0,'F','0','0','yms:yard:wmsSync','#',103,1,'2026-05-29 12:42:12',NULL,NULL,''),(5030,'堆场位管理',5195,3,'yard-position','yms/yard-position/index','',1,0,'C','1','0','yms:yardPosition:list','location',103,1,'2026-05-29 11:37:11',NULL,NULL,'YMS堆场位管理 [已收敛至BASE yard/zone + yard/dock]'),(5031,'堆场位查询',5030,1,'#','','',1,0,'F','0','0','yms:yardPosition:query','#',103,1,'2026-05-29 11:37:12',NULL,NULL,''),(5032,'堆场位新增',5030,2,'#','','',1,0,'F','0','0','yms:yardPosition:add','#',103,1,'2026-05-29 11:37:12',NULL,NULL,''),(5033,'堆场位编辑',5030,3,'#','','',1,0,'F','0','0','yms:yardPosition:edit','#',103,1,'2026-05-29 11:37:12',NULL,NULL,''),(5034,'堆场位删除',5030,4,'#','','',1,0,'F','0','0','yms:yardPosition:remove','#',103,1,'2026-05-29 11:37:12',NULL,NULL,''),(5040,'海柜资源',5195,1,'container','yms/container/index','',1,0,'C','0','0','yms:containerResource:list','box',103,1,'2026-05-29 11:37:12',NULL,NULL,'YMS海柜资源管理'),(5041,'海柜资源查询',5040,1,'#','','',1,0,'F','0','0','yms:containerResource:query','#',103,1,'2026-05-29 11:37:12',NULL,NULL,''),(5042,'海柜资源新增',5040,2,'#','','',1,0,'F','0','0','yms:containerResource:add','#',103,1,'2026-05-29 11:37:12',NULL,NULL,''),(5043,'海柜资源编辑',5040,3,'#','','',1,0,'F','0','0','yms:containerResource:edit','#',103,1,'2026-05-29 11:37:12',NULL,NULL,''),(5044,'海柜资源删除',5040,4,'#','','',1,0,'F','0','0','yms:containerResource:remove','#',103,1,'2026-05-29 11:37:12',NULL,NULL,''),(5045,'海柜分配堆场位',5040,5,'#','','',1,0,'F','0','0','yms:containerResource:assignPosition','#',103,1,'2026-05-29 11:37:12',NULL,NULL,''),(5046,'海柜叫号',5040,6,'#','','',1,0,'F','0','0','yms:containerResource:call','#',103,1,'2026-05-29 11:37:12',NULL,NULL,''),(5050,'车厢资源',5195,2,'trailer','yms/trailer/index','',1,0,'C','0','0','yms:trailerResource:list','truck',103,1,'2026-05-29 11:37:12',NULL,NULL,'YMS车厢资源管理'),(5051,'车厢资源查询',5050,1,'#','','',1,0,'F','0','0','yms:trailerResource:query','#',103,1,'2026-05-29 11:37:12',NULL,NULL,''),(5052,'车厢资源新增',5050,2,'#','','',1,0,'F','0','0','yms:trailerResource:add','#',103,1,'2026-05-29 11:37:12',NULL,NULL,''),(5053,'车厢资源编辑',5050,3,'#','','',1,0,'F','0','0','yms:trailerResource:edit','#',103,1,'2026-05-29 11:37:12',NULL,NULL,''),(5054,'车厢资源删除',5050,4,'#','','',1,0,'F','0','0','yms:trailerResource:remove','#',103,1,'2026-05-29 11:37:12',NULL,NULL,''),(5055,'车厢分配堆场位',5050,5,'#','','',1,0,'F','0','0','yms:trailerResource:assignPosition','#',103,1,'2026-05-29 11:37:12',NULL,NULL,''),(5056,'车厢叫号',5050,6,'#','','',1,0,'F','0','0','yms:trailerResource:call','#',103,1,'2026-05-29 11:37:12',NULL,NULL,''),(5060,'院内任务',5196,1,'internal-task','yms/internal-task/index','',1,0,'C','0','0','yms:internalTask:list','list',103,1,'2026-05-29 11:42:13',NULL,NULL,'YMS院内任务中心'),(5061,'院内任务查询',5060,1,'#','','',1,0,'F','0','0','yms:internalTask:query','#',103,1,'2026-05-29 11:42:13',NULL,NULL,''),(5062,'院内任务新增',5060,2,'#','','',1,0,'F','0','0','yms:internalTask:add','#',103,1,'2026-05-29 11:42:13',NULL,NULL,''),(5063,'分配执行人',5060,3,'#','','',1,0,'F','0','0','yms:internalTask:assign','#',103,1,'2026-05-29 11:42:13',NULL,NULL,''),(5064,'执行任务',5060,4,'#','','',1,0,'F','0','0','yms:internalTask:operate','#',103,1,'2026-05-29 11:42:13',NULL,NULL,''),(5065,'完成任务',5060,5,'#','','',1,0,'F','0','0','yms:internalTask:complete','#',103,1,'2026-05-29 11:42:13',NULL,NULL,''),(5066,'取消任务',5060,6,'#','','',1,0,'F','0','0','yms:internalTask:cancel','#',103,1,'2026-05-29 11:42:13',NULL,NULL,''),(5070,'海柜Check-in',5193,1,'gate-container-checkin','yms/gate-container-checkin/index','',1,0,'C','0','0','yms:gate:containerCheckIn','check-square',103,1,'2026-05-29 11:58:20',NULL,NULL,'门卫海柜 Check-in 操作台'),(5071,'装车Check-in',5193,2,'gate-loading-checkin','yms/gate-loading-checkin/index','',1,0,'C','0','0','yms:gate:loadingCheckIn','check-square',103,1,'2026-05-29 11:58:20',NULL,NULL,'门卫装车 Check-in 操作台'),(5072,'海柜Check-in-办理',5070,1,'#','','',1,0,'F','0','0','yms:gate:containerCheckIn','#',103,1,'2026-05-29 11:58:20',NULL,NULL,''),(5073,'海柜Check-in-手动放行',5070,2,'#','','',1,0,'F','0','0','yms:gate:manualPass','#',103,1,'2026-05-29 11:58:20',NULL,NULL,''),(5074,'装车Check-in-办理',5071,1,'#','','',1,0,'F','0','0','yms:gate:loadingCheckIn','#',103,1,'2026-05-29 11:58:20',NULL,NULL,''),(5075,'装车Check-in-手动放行',5071,2,'#','','',1,0,'F','0','0','yms:gate:manualPass','#',103,1,'2026-05-29 11:58:20',NULL,NULL,''),(5076,'在场列表',5193,3,'gate-in-yard','yms/gate-in-yard/index','',1,0,'C','0','0','yms:gate:inYard','team',103,1,'2026-05-29 12:02:20',NULL,NULL,'当前在场车辆/海柜/车厢'),(5077,'在场列表查询',5076,1,'#','','',1,0,'F','0','0','yms:gate:inYard','#',103,1,'2026-05-29 12:02:20',NULL,NULL,''),(5078,'Check-out离场',5193,4,'gate-check-out','yms/gate-check-out/index','',1,0,'C','0','0','yms:gate:checkout','logout',103,1,'2026-05-29 12:04:54',NULL,NULL,'门卫 Check-out 离场操作台'),(5079,'Check-out办理',5078,1,'#','','',1,0,'F','0','0','yms:gate:checkout','#',103,1,'2026-05-29 12:04:54',NULL,NULL,''),(5080,'园区总览',5191,1,'overview','yms/overview/index','',1,0,'C','0','0','yms:dashboard:view','dashboard',103,1,'2026-05-29 12:08:09',NULL,NULL,'YMS园区总览大屏'),(5081,'园区总览查看',5080,1,'#','','',1,0,'F','0','0','yms:dashboard:view','#',103,1,'2026-05-29 12:08:09',NULL,NULL,''),(5090,'预约规则',5194,3,'appointment-rule','yms/appointment-rule/index','',1,0,'C','0','0','yms:appointmentRule:list','setting',103,1,'2026-05-29 12:15:14',NULL,NULL,'YMS预约规则配置'),(5091,'预约规则查询',5090,1,'#','','',1,0,'F','0','0','yms:appointmentRule:query','#',103,1,'2026-05-29 12:15:14',NULL,NULL,''),(5092,'预约规则新增',5090,2,'#','','',1,0,'F','0','0','yms:appointmentRule:add','#',103,1,'2026-05-29 12:15:14',NULL,NULL,''),(5093,'预约规则编辑',5090,3,'#','','',1,0,'F','0','0','yms:appointmentRule:edit','#',103,1,'2026-05-29 12:15:14',NULL,NULL,''),(5094,'预约规则删除',5090,4,'#','','',1,0,'F','0','0','yms:appointmentRule:remove','#',103,1,'2026-05-29 12:15:14',NULL,NULL,''),(5100,'预约看板',5194,4,'appointment-board','yms/appointment-board/index','',1,0,'C','0','0','yms:appointment:list','calendar',103,1,'2026-05-29 12:15:14',NULL,NULL,'预约日历时段看板'),(5110,'叫号规则',5197,1,'call-rule','yms/call-rule/index','',1,0,'C','0','0','yms:callRule:list','phone',103,1,'2026-05-29 12:15:14',NULL,NULL,'YMS叫号规则配置'),(5111,'叫号规则查询',5110,1,'#','','',1,0,'F','0','0','yms:callRule:query','#',103,1,'2026-05-29 12:15:14',NULL,NULL,''),(5112,'叫号规则新增',5110,2,'#','','',1,0,'F','0','0','yms:callRule:add','#',103,1,'2026-05-29 12:15:14',NULL,NULL,''),(5113,'叫号规则编辑',5110,3,'#','','',1,0,'F','0','0','yms:callRule:edit','#',103,1,'2026-05-29 12:15:14',NULL,NULL,''),(5114,'叫号规则删除',5110,4,'#','','',1,0,'F','0','0','yms:callRule:remove','#',103,1,'2026-05-29 12:15:14',NULL,NULL,''),(5115,'叫号规则启用禁用',5110,5,'#','','',1,0,'F','0','0','yms:callRule:toggle','#',103,1,'2026-05-29 12:25:41',NULL,NULL,''),(5120,'等待池',5192,5,'waiting-pool','yms/waiting-pool/index','',1,0,'C','0','0','yms:waitingPool:view','hourglass',103,1,'2026-05-29 12:15:15',NULL,NULL,'园区等待池'),(5121,'等待池查看',5120,1,'#','','',1,0,'F','0','0','yms:waitingPool:view','#',103,1,'2026-05-29 12:15:15',NULL,NULL,''),(5130,'异常中心',5198,1,'exception-center','yms/exception-center/index','',1,0,'C','0','0','yms:exception:list','warning',103,1,'2026-05-29 12:15:15',NULL,NULL,'园区异常中心'),(5131,'异常查询',5130,1,'#','','',1,0,'F','0','0','yms:exception:list','#',103,1,'2026-05-29 12:15:15',NULL,NULL,''),(5132,'异常处理',5130,2,'#','','',1,0,'F','0','0','yms:exception:handle','#',103,1,'2026-05-29 12:15:15',NULL,NULL,''),(5140,'园区盘点',5198,2,'yard-inventory','yms/yard-inventory/index','',1,0,'C','0','0','yms:inventory:list','audit',103,1,'2026-05-29 12:15:15',NULL,NULL,'YMS园区盘点'),(5141,'盘点查询',5140,1,'#','','',1,0,'F','0','0','yms:inventory:query','#',103,1,'2026-05-29 12:15:15',NULL,NULL,''),(5142,'盘点创建',5140,2,'#','','',1,0,'F','0','0','yms:inventory:add','#',103,1,'2026-05-29 12:15:15',NULL,NULL,''),(5143,'盘点执行',5140,3,'#','','',1,0,'F','0','0','yms:inventory:execute','#',103,1,'2026-05-29 12:15:15',NULL,NULL,''),(5150,'堆场地图',5191,2,'yard-map','yms/yard-map/index','',1,0,'C','0','0','yms:yardMap:view','map',103,1,'2026-05-29 12:15:15',NULL,NULL,'YMS堆场地图'),(5151,'堆场地图查看',5150,1,'#','','',1,0,'F','0','0','yms:yardMap:view','#',103,1,'2026-05-29 12:15:15',NULL,NULL,''),(5191,'监控总览',5000,1,'monitor',NULL,'',1,0,'M','0','0','','dashboard',103,1,'2026-05-29 13:16:10',NULL,NULL,'园区大屏与堆场可视化'),(5192,'调度作业',5000,2,'dispatch-work',NULL,'',1,0,'M','0','0','','monitor',103,1,'2026-05-29 13:16:10',NULL,NULL,'Dock调度与园区任务'),(5193,'门岗出入',5000,3,'gate-work',NULL,'',1,0,'M','0','0','','login',103,1,'2026-05-29 13:16:10',NULL,NULL,'Check-in / Check-out 与在场'),(5194,'预约管理',5000,4,'appointment-work',NULL,'',1,0,'M','0','0','','calendar',103,1,'2026-05-29 13:16:10',NULL,NULL,'预约、时段与看板'),(5195,'堆场资源',5000,5,'yard-resource',NULL,'',1,0,'M','0','0','','box',103,1,'2026-05-29 13:16:10',NULL,NULL,'海柜/车厢与堆位'),(5196,'场内作业',5000,6,'yard-operation',NULL,'',1,0,'M','0','0','','tool',103,1,'2026-05-29 13:16:10',NULL,NULL,'院内任务与机器人'),(5197,'规则风控',5000,7,'rule-control',NULL,'',1,0,'M','0','0','','setting',103,1,'2026-05-29 13:16:10',NULL,NULL,'叫号规则与黑名单'),(5198,'异常盘点',5000,8,'exception-audit',NULL,'',1,0,'M','0','0','','warning',103,1,'2026-05-29 13:16:10',NULL,NULL,'异常中心与园区盘点'),(11616,'工作流',0,6,'workflow','','',1,0,'M','0','0','','workflow',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11618,'我的任务',0,7,'task','','',1,0,'M','0','0','','my-task',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11619,'我的待办',11618,2,'taskWaiting','workflow/task/taskWaiting','',1,1,'C','0','0','','waiting',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11620,'流程定义',11616,3,'processDefinition','workflow/processDefinition/index','',1,1,'C','0','0','workflow:definition:list','process-definition',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11621,'流程实例',11630,1,'processInstance','workflow/processInstance/index','',1,1,'C','0','0','workflow:instance:list','tree-table',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11622,'流程分类',11616,1,'category','workflow/category/index','',1,0,'C','0','0','workflow:category:list','category',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11623,'流程分类查询',11622,1,'#','','',1,0,'F','0','0','workflow:category:query','#',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11624,'流程分类新增',11622,2,'#','','',1,0,'F','0','0','workflow:category:add','#',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11625,'流程分类修改',11622,3,'#','','',1,0,'F','0','0','workflow:category:edit','#',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11626,'流程分类删除',11622,4,'#','','',1,0,'F','0','0','workflow:category:remove','#',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11627,'流程分类导出',11622,5,'#','','',1,0,'F','0','0','workflow:category:export','#',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11629,'我发起的',11618,1,'myDocument','workflow/task/myDocument','',1,1,'C','0','0','workflow:instance:currentList','guide',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11630,'流程监控',11616,4,'processMonitor','','',1,0,'M','0','0','','monitor',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11631,'待办任务',11630,2,'allTaskWaiting','workflow/task/allTaskWaiting','',1,1,'C','0','0','','waiting',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11632,'我的已办',11618,3,'taskFinish','workflow/task/taskFinish','',1,1,'C','0','0','','finish',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11633,'我的抄送',11618,4,'taskCopyList','workflow/task/taskCopyList','',1,1,'C','0','0','','my-copy',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11638,'请假申请',5,1,'leave','workflow/leave/index','',1,0,'C','0','0','workflow:leave:list','#',103,1,'2026-05-21 23:15:15',NULL,NULL,'请假申请菜单'),(11639,'请假申请查询',11638,1,'#','','',1,0,'F','0','0','workflow:leave:query','#',103,1,'2026-05-21 23:15:15',NULL,NULL,''),(11640,'请假申请新增',11638,2,'#','','',1,0,'F','0','0','workflow:leave:add','#',103,1,'2026-05-21 23:15:15',NULL,NULL,''),(11641,'请假申请修改',11638,3,'#','','',1,0,'F','0','0','workflow:leave:edit','#',103,1,'2026-05-21 23:15:15',NULL,NULL,''),(11642,'请假申请删除',11638,4,'#','','',1,0,'F','0','0','workflow:leave:remove','#',103,1,'2026-05-21 23:15:15',NULL,NULL,''),(11643,'请假申请导出',11638,5,'#','','',1,0,'F','0','0','workflow:leave:export','#',103,1,'2026-05-21 23:15:15',NULL,NULL,''),(11644,'流程定义查询',11620,1,'#','','',1,0,'F','0','0','workflow:definition:query','#',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11645,'流程定义新增',11620,2,'#','','',1,0,'F','0','0','workflow:definition:add','#',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11646,'流程定义修改',11620,3,'#','','',1,0,'F','0','0','workflow:definition:edit','#',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11647,'流程定义删除',11620,4,'#','','',1,0,'F','0','0','workflow:definition:remove','#',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11648,'流程定义导出',11620,5,'#','','',1,0,'F','0','0','workflow:definition:export','#',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11649,'流程定义导入',11620,6,'#','','',1,0,'F','0','0','workflow:definition:import','#',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11650,'流程定义发布/取消发布',11620,7,'#','','',1,0,'F','0','0','workflow:definition:publish','#',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11651,'流程定义复制',11620,8,'#','','',1,0,'F','0','0','workflow:definition:copy','#',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11652,'流程定义激活/挂起',11620,9,'#','','',1,0,'F','0','0','workflow:definition:active','#',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11653,'流程实例查询',11621,1,'#','','',1,0,'F','0','0','workflow:instance:query','#',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11654,'流程变量查询',11621,2,'#','','',1,0,'F','0','0','workflow:instance:variableQuery','#',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11655,'流程变量修改',11621,3,'#','','',1,0,'F','0','0','workflow:instance:variable','#',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11656,'流程实例激活/挂起',11621,4,'#','','',1,0,'F','0','0','workflow:instance:active','#',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11657,'流程实例删除',11621,5,'#','','',1,0,'F','0','0','workflow:instance:remove','#',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11658,'流程实例作废',11621,6,'#','','',1,0,'F','0','0','workflow:instance:invalid','#',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11659,'流程实例撤销',11621,7,'#','','',1,0,'F','0','0','workflow:instance:cancel','#',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11700,'流程设计',11616,5,'design/index','workflow/processDefinition/design','',1,1,'C','1','0','workflow:leave:edit','#',103,1,'2026-05-21 23:15:14',NULL,NULL,'/workflow/processDefinition'),(11701,'请假申请',11616,6,'leaveEdit/index','workflow/leave/leaveEdit','',1,1,'C','1','0','workflow:leave:edit','#',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11801,'流程表达式',11616,2,'spel','workflow/spel/index','',1,0,'C','0','0','workflow:spel:list','input',103,1,'2026-05-21 23:15:14',1,'2026-05-21 23:15:14','流程达式定义菜单'),(11802,'流程达式定义查询',11801,1,'#','',NULL,1,0,'F','0','0','workflow:spel:query','#',103,1,'2026-05-21 23:15:14',NULL,NULL,''),(11803,'流程达式定义新增',11801,2,'#','',NULL,1,0,'F','0','0','workflow:spel:add','#',103,1,'2026-05-21 23:15:15',NULL,NULL,''),(11804,'流程达式定义修改',11801,3,'#','',NULL,1,0,'F','0','0','workflow:spel:edit','#',103,1,'2026-05-21 23:15:15',NULL,NULL,''),(11805,'流程达式定义删除',11801,4,'#','',NULL,1,0,'F','0','0','workflow:spel:remove','#',103,1,'2026-05-21 23:15:15',NULL,NULL,''),(11806,'流程达式定义导出',11801,5,'#','',NULL,1,0,'F','0','0','workflow:spel:export','#',103,1,'2026-05-21 23:15:15',NULL,NULL,''),(301010,'创建预出单',3010,1,'','',NULL,1,0,'F','1','0','oms:outboundPool:createPreOutbound','#',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-26 22:44:01',''),(301011,'创建出库订单',3010,2,'','',NULL,1,0,'F','1','0','oms:outboundPool:createOutboundOrder','#',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-26 22:44:01',''),(301012,'创建预出单',3010,1,'','',NULL,1,0,'F','0','0','oms:outboundPool:batchCreatePreOutbound','#',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-26 22:44:01',''),(301013,'创建出库单',3010,2,'','',NULL,1,0,'F','0','0','oms:outboundPool:batchCreateOutboundOrder','#',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-26 22:44:01',''),(301110,'预出单查询',3011,1,'','',NULL,1,0,'F','0','0','oms:preOutbound:query','#',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-24 12:43:37',''),(301111,'预出单取消',3011,2,'','',NULL,1,0,'F','0','0','oms:preOutbound:cancel','#',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-24 12:43:37',''),(301112,'预出单转出库',3011,3,'','',NULL,1,0,'F','0','0','oms:preOutbound:convert','#',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-24 12:43:37',''),(301113,'预出单导出',3011,4,'','',NULL,1,0,'F','0','0','oms:preOutbound:export','#',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-24 12:43:37',''),(301210,'出库订单查询',3012,1,'','',NULL,1,0,'F','0','0','oms:outboundOrder:query','#',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-24 12:43:37',''),(301211,'出库订单编辑',3012,2,'','',NULL,1,0,'F','0','0','oms:outboundOrder:edit','#',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-24 12:43:37',''),(301212,'出库订单取消',3012,3,'','',NULL,1,0,'F','0','0','oms:outboundOrder:cancel','#',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-24 12:43:37',''),(301213,'出库订单完成',3012,4,'','',NULL,1,0,'F','0','0','oms:outboundOrder:complete','#',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-24 12:43:37',''),(301214,'出库订单导出',3012,5,'','',NULL,1,0,'F','0','0','oms:outboundOrder:export','#',NULL,NULL,'2026-05-24 04:04:23',NULL,'2026-05-24 12:43:37',''),(301215,'????',3012,6,'','',NULL,1,0,'F','0','0','oms:outboundOrder:confirmAppointment','#',NULL,NULL,'2026-05-27 01:22:53',NULL,NULL,''),(301216,'????',3012,7,'','',NULL,1,0,'F','0','0','oms:outboundOrder:confirmOutbounded','#',NULL,NULL,'2026-05-27 01:22:53',NULL,NULL,''),(301217,'????',3012,8,'','',NULL,1,0,'F','0','0','oms:outboundOrder:confirmSigned','#',NULL,NULL,'2026-05-27 01:22:53',NULL,NULL,''),(301218,'????',3012,9,'','',NULL,1,0,'F','0','0','oms:outboundOrder:attachmentUpload','#',NULL,NULL,'2026-05-27 01:22:53',NULL,NULL,''),(301219,'????',3012,10,'','',NULL,1,0,'F','0','0','oms:outboundOrder:attachmentRemove','#',NULL,NULL,'2026-05-27 01:22:53',NULL,NULL,'');
/*!40000 ALTER TABLE `sys_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_notice`
--

DROP TABLE IF EXISTS `sys_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_notice` (
  `notice_id` bigint NOT NULL COMMENT '公告ID',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `notice_title` varchar(50) NOT NULL COMMENT '公告标题',
  `notice_type` char(1) NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob COMMENT '公告内容',
  `status` char(1) DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='通知公告表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_notice`
--

LOCK TABLES `sys_notice` WRITE;
/*!40000 ALTER TABLE `sys_notice` DISABLE KEYS */;
INSERT INTO `sys_notice` VALUES (1,'000000','温馨提醒：2018-07-01 新版本发布啦','2',_binary '新版本内容','0',103,1,'2026-05-21 23:15:05',NULL,NULL,'管理员'),(2,'000000','维护通知：2018-07-01 系统凌晨维护','1',_binary '维护内容','0',103,1,'2026-05-21 23:15:05',NULL,NULL,'管理员');
/*!40000 ALTER TABLE `sys_notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_oper_log`
--

DROP TABLE IF EXISTS `sys_oper_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_oper_log` (
  `oper_id` bigint NOT NULL COMMENT '日志主键',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `title` varchar(50) DEFAULT '' COMMENT '模块标题',
  `business_type` int DEFAULT '0' COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(100) DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) DEFAULT '' COMMENT '请求方式',
  `operator_type` int DEFAULT '0' COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(4000) DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(4000) DEFAULT '' COMMENT '返回参数',
  `status` int DEFAULT '0' COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(4000) DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint DEFAULT '0' COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`),
  KEY `idx_sys_oper_log_bt` (`business_type`),
  KEY `idx_sys_oper_log_s` (`status`),
  KEY `idx_sys_oper_log_ot` (`oper_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='操作日志记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_oper_log`
--

LOCK TABLES `sys_oper_log` WRITE;
/*!40000 ALTER TABLE `sys_oper_log` DISABLE KEYS */;
INSERT INTO `sys_oper_log` VALUES (2057886188956848129,'000000','菜单管理',3,'org.dromara.system.controller.system.SysMenuController.remove()','DELETE',1,'admin','研发部门','/system/menu/4','0:0:0:0:0:0:0:1','内网IP','4','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-23 02:07:56',323),(2057886233261281282,'000000','菜单管理',2,'org.dromara.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"menuId\":5,\"parentId\":0,\"menuName\":\"测试菜单\",\"orderNum\":5,\"path\":\"demo\",\"component\":\"Layout\",\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"0\",\"perms\":\"\",\"icon\":\"star\",\"remark\":\"测试菜单\"}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-23 02:08:06',93),(2057886281625800706,'000000','菜单管理',2,'org.dromara.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"menuId\":3000,\"parentId\":0,\"menuName\":\"OMS系统\",\"orderNum\":20,\"path\":\"oms\",\"component\":\"Layout\",\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"0\",\"status\":\"0\",\"perms\":\"\",\"icon\":\"appstore\",\"remark\":\"OMS业务目录\"}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-23 02:08:18',21),(2057901906767216641,'000000','海柜订单',5,'org.dromara.oms.controller.ContainerOrderController.export()','POST',1,'admin','研发部门','/oms/container-order/export','0:0:0:0:0:0:0:1','内网IP','{\"t\":\"1779477019070\",\"pageSize\":\"10\",\"pageNum\":\"1\"}','',0,'','2026-05-23 03:10:23',3755),(2058084768548155394,'000000','货物订单',2,'org.dromara.oms.controller.CargoOrderController.edit()','PUT',1,'admin','研发部门','/oms/cargo-order','0:0:0:0:0:0:0:1','内网IP','{\"id\":9200002,\"cargoOrderNo\":\"CO202605150002\",\"externalOrderNo\":\"PHG-2026-05-002\",\"orderSource\":\"MANUAL\",\"customerId\":8001001,\"customerName\":\"Pacific Home Goods LLC\",\"businessTypeId\":5002001,\"businessTypeName\":\"FBA头程\",\"channelId\":5001001,\"channelName\":\"Amazon US\",\"platformId\":null,\"platformName\":null,\"customerServiceId\":1,\"customerServiceName\":\"Amy\",\"inboundWarehouseId\":4001001,\"inboundWarehouseName\":\"Los Angeles Central Warehouse\",\"addressType\":\"PRIVATE\",\"platformWarehouseCode\":null,\"consigneeName\":\"PHG Warehouse LA\",\"addressLine1\":\"12500 S Figueroa St\",\"addressLine2\":\"Suite 200\",\"city\":\"Los Angeles\",\"state\":\"CA\",\"zipCode\":\"90061\",\"country\":\"US\",\"contactName\":\"Jack Wong\",\"contactPhone\":\"+1-310-555-0101\",\"contactEmail\":\"warehouse@phg.com\",\"parcelCarrierName\":null,\"parcelTrackingNo\":null,\"transferFlag\":0,\"transferWarehouseCode\":null,\"declaredCartonQty\":\"430.00\",\"declaredPieceQty\":\"5160.00\",\"declaredWeight\":\"5590.000\",\"declaredCbm\":\"24.900\",\"weightUnit\":\"KG\",\"volumeUnit\":\"CBM\",\"eta\":\"2026-05-22 18:30:00\",\"ata\":null,\"customerRemark\":null,\"internalRemark\":\"与CO001同柜，分拆派送\",\"operationRemark\":null,\"shipments\":[{\"id\":9210003,\"shipmentNo\":\"PH-LAX-002A\",\"poNo\":\"PO-PHG-2026-3303\",\"shippingMark\":\"PHG/LAX/PRIV\",\"cartonQty\":\"430.00\",\"weight\":\"5590.000\",\"cbm\":\"24.900\",\"dwTime\":\"2026-05-27 09:00:00\",\"remark\":\"私仓LA，整票\",\"skuItems\":[]}]}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-23 15:17:01',296),(2058427913647476737,'000000','货物订单-拆单',1,'org.dromara.oms.controller.CargoOrderController.split()','POST',1,'admin','研发部门','/oms/cargo-order/1005/split','0:0:0:0:0:0:0:1','内网IP','1005 {\"splitSource\":\"INTERNAL\",\"customerVisibleFlag\":0,\"splitRequestedBy\":\"OPERATION\",\"customerSplitReason\":null,\"internalSplitReason\":\"内部作业拆单\",\"splitMode\":\"BY_QTY\",\"remark\":null,\"children\":[{\"cargoOrderNoSuffix\":\"-1\",\"shipmentIds\":null,\"cartonQty\":\"0\",\"weight\":\"0\",\"cbm\":\"0\",\"holdFlag\":null,\"holdReason\":null,\"customerVisibleFlag\":0,\"remark\":null},{\"cargoOrderNoSuffix\":\"-2\",\"shipmentIds\":null,\"cartonQty\":\"0\",\"weight\":\"0\",\"cbm\":\"0\",\"holdFlag\":null,\"holdReason\":null,\"customerVisibleFlag\":0,\"remark\":null}]}','',1,'已完成或已取消的订单不能拆单','2026-05-24 14:00:33',73),(2058428178295476226,'000000','货物订单-拆单',1,'org.dromara.oms.controller.CargoOrderController.split()','POST',1,'admin','研发部门','/oms/cargo-order/1001/split','0:0:0:0:0:0:0:1','内网IP','1001 {\"splitSource\":\"INTERNAL\",\"customerVisibleFlag\":0,\"splitRequestedBy\":\"OPERATION\",\"customerSplitReason\":null,\"internalSplitReason\":\"内部作业拆单\",\"splitMode\":\"BY_QTY\",\"remark\":null,\"children\":[{\"cargoOrderNoSuffix\":\"-1\",\"shipmentIds\":null,\"cartonQty\":\"0\",\"weight\":\"0\",\"cbm\":\"0\",\"holdFlag\":null,\"holdReason\":null,\"customerVisibleFlag\":0,\"remark\":null},{\"cargoOrderNoSuffix\":\"-2\",\"shipmentIds\":null,\"cartonQty\":\"0\",\"weight\":\"0\",\"cbm\":\"0\",\"holdFlag\":null,\"holdReason\":null,\"customerVisibleFlag\":0,\"remark\":null}]}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-24 14:01:36',122),(2058429386959671297,'000000','货物订单',3,'org.dromara.oms.controller.CargoOrderController.remove()','DELETE',1,'admin','研发部门','/oms/cargo-order/2058428178035429378','0:0:0:0:0:0:0:1','内网IP','[\"2058428178035429378\"]','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-24 14:06:24',125),(2058429402684116994,'000000','货物订单',3,'org.dromara.oms.controller.CargoOrderController.remove()','DELETE',1,'admin','研发部门','/oms/cargo-order/2058428177838297090','0:0:0:0:0:0:0:1','内网IP','[\"2058428177838297090\"]','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-24 14:06:28',33),(2058430355210575874,'000000','货物订单-暂扣',2,'org.dromara.oms.controller.CargoOrderController.hold()','POST',1,'admin','研发部门','/oms/cargo-order/1002/hold','0:0:0:0:0:0:0:1','内网IP','1002 {\"holdType\":\"OPERATION_HOLD\",\"holdReason\":\"运营暂扣\",\"remark\":null}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-24 14:10:15',290),(2058430440543690753,'000000','货物订单-暂扣',2,'org.dromara.oms.controller.CargoOrderController.hold()','POST',1,'admin','研发部门','/oms/cargo-order/1002/hold','0:0:0:0:0:0:0:1','内网IP','1002 {\"holdType\":\"OPERATION_HOLD\",\"holdReason\":\"运营暂扣\",\"remark\":null}','',1,'该货物订单已处于HOLD中','2026-05-24 14:10:35',27),(2058434196190576642,'000000','货物订单-暂扣',2,'org.dromara.oms.controller.CargoOrderController.hold()','POST',1,'admin','研发部门','/oms/cargo-order/1005/hold','0:0:0:0:0:0:0:1','内网IP','1005 {\"holdType\":\"OPERATION_HOLD\",\"holdReason\":\"运营暂扣\",\"remark\":null}','',1,'已完成或已取消的订单不能暂扣','2026-05-24 14:25:31',59),(2058434243078701057,'000000','货物订单-放行',2,'org.dromara.oms.controller.CargoOrderController.releaseHold()','POST',1,'admin','研发部门','/oms/cargo-order/1002/release-hold','0:0:0:0:0:0:0:1','内网IP','1002 {\"releaseReason\":\"运营放行\",\"remark\":null}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-24 14:25:42',106),(2058434260426342401,'000000','货物订单-暂扣',2,'org.dromara.oms.controller.CargoOrderController.hold()','POST',1,'admin','研发部门','/oms/cargo-order/1002/hold','0:0:0:0:0:0:0:1','内网IP','1002 {\"holdType\":\"OPERATION_HOLD\",\"holdReason\":\"运营暂扣\",\"remark\":null}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-24 14:25:46',40),(2058451509132435457,'000000','菜单管理',2,'org.dromara.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"menuId\":2009,\"parentId\":2000,\"menuName\":\"海运资料\",\"orderNum\":6,\"path\":\"logistics\",\"component\":\"Layout\",\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"0\",\"status\":\"0\",\"perms\":\"\",\"icon\":\"car\",\"remark\":\"物流基础目录\"}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-24 15:34:19',170),(2058451572252516353,'000000','菜单管理',2,'org.dromara.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','0:0:0:0:0:0:0:1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"menuId\":2304,\"parentId\":2009,\"menuName\":\"码头管理\",\"orderNum\":2,\"path\":\"terminal\",\"component\":\"base/terminal/index\",\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"0\",\"status\":\"0\",\"perms\":\"base:terminal:list\",\"icon\":\"map\",\"remark\":\"??????????????????\"}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-24 15:34:34',108),(2059007162053877761,'000000','字典数据',2,'org.dromara.system.controller.system.SysDictDataController.edit()','PUT',1,'admin','研发部门','/system/dict/data','0:0:0:0:0:0:0:1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"dictCode\":9005201,\"dictSort\":2,\"dictLabel\":\"停车位\",\"dictValue\":\"PARKING\",\"dictType\":\"yard_location_type\",\"cssClass\":\"\",\"listClass\":\"default\",\"isDefault\":\"N\",\"remark\":\"Parking space\"}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-26 04:22:17',132),(2059007201111236609,'000000','字典数据',3,'org.dromara.system.controller.system.SysDictDataController.remove()','DELETE',1,'admin','研发部门','/system/dict/data/9004203','0:0:0:0:0:0:0:1','内网IP','[9004203]','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-26 04:22:26',166),(2059007356170461185,'000000','字典数据',2,'org.dromara.system.controller.system.SysDictDataController.edit()','PUT',1,'admin','研发部门','/system/dict/data','0:0:0:0:0:0:0:1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"dictCode\":5000311,\"dictSort\":1,\"dictLabel\":\"FLOOR\",\"dictValue\":\"FLOOR\",\"dictType\":\"oms_loading_type\",\"cssClass\":\"\",\"listClass\":\"default\",\"isDefault\":\"N\",\"remark\":\"\"}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-26 04:23:03',33),(2059007378958114818,'000000','字典数据',2,'org.dromara.system.controller.system.SysDictDataController.edit()','PUT',1,'admin','研发部门','/system/dict/data','0:0:0:0:0:0:0:1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"dictCode\":5000312,\"dictSort\":2,\"dictLabel\":\"PALLET\",\"dictValue\":\"PALLET\",\"dictType\":\"oms_loading_type\",\"cssClass\":\"\",\"listClass\":\"default\",\"isDefault\":\"N\",\"remark\":\"\"}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-26 04:23:08',37),(2059007407290638338,'000000','字典数据',2,'org.dromara.system.controller.system.SysDictDataController.edit()','PUT',1,'admin','研发部门','/system/dict/data','0:0:0:0:0:0:0:1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"dictCode\":5000313,\"dictSort\":3,\"dictLabel\":\"MIXED\",\"dictValue\":\"MIXED\",\"dictType\":\"oms_loading_type\",\"cssClass\":\"\",\"listClass\":\"default\",\"isDefault\":\"N\",\"remark\":\"\"}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-26 04:23:15',31),(2059007484860096513,'000000','字典类型',2,'org.dromara.system.controller.system.SysDictTypeController.edit()','PUT',1,'admin','研发部门','/system/dict/type','0:0:0:0:0:0:0:1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"dictId\":5000111,\"dictName\":\"装车类型\",\"dictType\":\"oms_loading_type\",\"remark\":\"装车类型\"}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-26 04:23:34',147),(2059008463923896321,'000000','业务类型管理',2,'org.dromara.base.controller.BaseBusinessTypeController.edit()','PUT',1,'admin','研发部门','/base/business-type','0:0:0:0:0:0:0:1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":\"2026-05-21 10:18:15\",\"updateBy\":null,\"updateTime\":null,\"id\":5002001,\"keyword\":null,\"businessTypeCode\":\"TRUCK_DELIVERY\",\"businessTypeName\":\"卡车派送\",\"businessCategory\":\"TRANSPORT\",\"operationFlowType\":\"OUTBOUND\",\"receiveRequired\":\"1\",\"inboundRequired\":\"0\",\"putawayRequired\":\"0\",\"storageRequired\":\"0\",\"pickingRequired\":\"1\",\"outboundRequired\":\"1\",\"deliveryRequired\":\"1\",\"appointmentRequired\":\"1\",\"vasSupported\":\"0\",\"billingMode\":\"PALLET\",\"sortingStrategy\":\"FIELD_BASED\",\"sortingField\":\"warehouse_code\",\"sortOrder\":1,\"status\":\"0\"}','',1,'cannot find converter from BaseBusinessTypeBo to BaseBusinessType','2026-05-26 04:27:27',103),(2059010773303480322,'000000','业务类型管理',2,'org.dromara.base.controller.BaseBusinessTypeController.edit()','PUT',1,'admin','研发部门','/base/business-type','0:0:0:0:0:0:0:1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":\"2026-05-21 10:18:15\",\"updateBy\":null,\"updateTime\":null,\"id\":5002001,\"keyword\":null,\"businessTypeCode\":\"TRUCK_DELIVERY\",\"businessTypeName\":\"卡车派送\",\"businessCategory\":\"TRANSPORT\",\"operationFlowType\":\"OUTBOUND\",\"receiveRequired\":\"1\",\"inboundRequired\":\"0\",\"putawayRequired\":\"0\",\"storageRequired\":\"0\",\"pickingRequired\":\"1\",\"outboundRequired\":\"1\",\"deliveryRequired\":\"1\",\"appointmentRequired\":\"1\",\"vasSupported\":\"0\",\"sortingStrategy\":\"FIELD_BASED\",\"sortingField\":\"warehouse_code\",\"sortOrder\":1,\"status\":\"0\"}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-26 04:36:38',107),(2059010809173168130,'000000','业务类型管理',2,'org.dromara.base.controller.BaseBusinessTypeController.edit()','PUT',1,'admin','研发部门','/base/business-type','0:0:0:0:0:0:0:1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":\"2026-05-21 10:18:15\",\"updateBy\":null,\"updateTime\":null,\"id\":5002002,\"keyword\":null,\"businessTypeCode\":\"EXPRESS_DELIVERY\",\"businessTypeName\":\"快递派送\",\"businessCategory\":\"TRANSPORT\",\"operationFlowType\":\"OUTBOUND\",\"receiveRequired\":\"1\",\"inboundRequired\":\"0\",\"putawayRequired\":\"0\",\"storageRequired\":\"0\",\"pickingRequired\":\"1\",\"outboundRequired\":\"1\",\"deliveryRequired\":\"1\",\"appointmentRequired\":\"0\",\"vasSupported\":\"0\",\"sortingStrategy\":\"NONE\",\"sortingField\":null,\"sortOrder\":2,\"status\":\"0\"}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-26 04:36:46',26),(2059010844816363522,'000000','业务类型管理',2,'org.dromara.base.controller.BaseBusinessTypeController.edit()','PUT',1,'admin','研发部门','/base/business-type','0:0:0:0:0:0:0:1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":\"2026-05-21 10:18:15\",\"updateBy\":null,\"updateTime\":null,\"id\":5002003,\"keyword\":null,\"businessTypeCode\":\"CUSTOMER_PICKUP\",\"businessTypeName\":\"客户自提\",\"businessCategory\":\"TRANSPORT\",\"operationFlowType\":\"OUTBOUND\",\"receiveRequired\":\"1\",\"inboundRequired\":\"0\",\"putawayRequired\":\"0\",\"storageRequired\":\"0\",\"pickingRequired\":\"1\",\"outboundRequired\":\"1\",\"deliveryRequired\":\"0\",\"appointmentRequired\":\"0\",\"vasSupported\":\"0\",\"sortingStrategy\":\"NONE\",\"sortingField\":null,\"sortOrder\":3,\"status\":\"0\"}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-26 04:36:55',25),(2059010890953707522,'000000','业务类型管理',2,'org.dromara.base.controller.BaseBusinessTypeController.edit()','PUT',1,'admin','研发部门','/base/business-type','0:0:0:0:0:0:0:1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":\"2026-05-24 21:32:22\",\"updateBy\":null,\"updateTime\":null,\"id\":5002005,\"keyword\":null,\"businessTypeCode\":\"BULK_TRANSFER\",\"businessTypeName\":\"大货中转\",\"businessCategory\":\"WAREHOUSE\",\"operationFlowType\":\"INBOUND_OUTBOUND\",\"receiveRequired\":\"0\",\"inboundRequired\":\"1\",\"putawayRequired\":\"1\",\"storageRequired\":\"1\",\"pickingRequired\":\"1\",\"outboundRequired\":\"1\",\"deliveryRequired\":\"0\",\"appointmentRequired\":\"0\",\"vasSupported\":\"0\",\"sortingStrategy\":\"FIELD_BASED\",\"sortingField\":\"warehouse_code\",\"sortOrder\":5,\"status\":\"0\"}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-26 04:37:06',29),(2059010931399380994,'000000','业务类型管理',2,'org.dromara.base.controller.BaseBusinessTypeController.edit()','PUT',1,'admin','研发部门','/base/business-type','0:0:0:0:0:0:0:1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":\"2026-05-24 21:32:22\",\"updateBy\":null,\"updateTime\":null,\"id\":5002006,\"keyword\":null,\"businessTypeCode\":\"DROPSHIP\",\"businessTypeName\":\"一件代发\",\"businessCategory\":\"WAREHOUSE\",\"operationFlowType\":\"OUTBOUND\",\"receiveRequired\":\"1\",\"inboundRequired\":\"0\",\"putawayRequired\":\"0\",\"storageRequired\":\"1\",\"pickingRequired\":\"1\",\"outboundRequired\":\"1\",\"deliveryRequired\":\"1\",\"appointmentRequired\":\"0\",\"vasSupported\":\"1\",\"sortingStrategy\":\"FIELD_BASED\",\"sortingField\":\"sku\",\"sortOrder\":6,\"status\":\"0\"}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-26 04:37:15',23),(2059010997405143041,'000000','业务类型管理',2,'org.dromara.base.controller.BaseBusinessTypeController.edit()','PUT',1,'admin','研发部门','/base/business-type','0:0:0:0:0:0:0:1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":\"2026-05-24 21:32:22\",\"updateBy\":null,\"updateTime\":null,\"id\":5002007,\"keyword\":null,\"businessTypeCode\":\"WAREHOUSE_SUPPLIES\",\"businessTypeName\":\"仓库物资\",\"businessCategory\":\"WAREHOUSE\",\"operationFlowType\":\"SERVICE\",\"receiveRequired\":\"0\",\"inboundRequired\":\"1\",\"putawayRequired\":\"1\",\"storageRequired\":\"1\",\"pickingRequired\":\"0\",\"outboundRequired\":\"0\",\"deliveryRequired\":\"0\",\"appointmentRequired\":\"0\",\"vasSupported\":\"0\",\"sortingStrategy\":\"NONE\",\"sortingField\":null,\"sortOrder\":7,\"status\":\"0\"}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-26 04:37:31',24),(2059022066454388737,'000000','海柜订单',2,'org.dromara.oms.controller.ContainerOrderController.edit()','PUT',1,'admin','研发部门','/oms/container-order','0:0:0:0:0:0:0:1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":\"2026-05-21 19:18:35\",\"updateBy\":null,\"updateTime\":\"2026-05-21 19:18:35\",\"id\":9100003,\"containerOrderNo\":\"SO202605220003\",\"companyId\":4000001,\"customerId\":8001003,\"customerName\":\"East Market Supply Co.\",\"channelId\":5001001,\"businessTypeId\":5002002,\"ownerUserId\":1,\"ownerUserName\":\"Nina Wang\",\"customerServiceId\":1,\"customerServiceName\":\"Tom\",\"warehouseId\":4001002,\"inboundWarehouseName\":\"New Jersey East Coast Warehouse\",\"orderSource\":\"API\",\"containerNo\":\"OOLU4567890\",\"containerType\":\"45HQ\",\"sealNo\":\"SEAL66333\",\"shippingLineId\":230203,\"shippingLineName\":\"OOCL\",\"vesselName\":\"OOCL BERLIN\",\"voyageNo\":\"096E\",\"routeCode\":\"EC2\",\"mblNo\":\"OOLU112233445\",\"hblNo\":\"HBL-NJ-003\",\"dischargePortId\":230102,\"dischargePortName\":\"USNYC\",\"terminalId\":230503,\"terminalName\":\"APM Terminals Elizabeth\",\"eta\":\"2026-05-17 16:00:00\",\"ata\":\"2026-05-17 18:10:00\",\"pickupLfd\":\"2026-05-22 00:00:00\",\"emptyReturnLfd\":\"2026-05-29 00:00:00\",\"availableTime\":null,\"terminalReleaseStatus\":\"RELEASED\",\"holdFlag\":0,\"holdTypes\":null,\"holdRemark\":null,\"examFlag\":0,\"examTypes\":null,\"examType\":null,\"examRemark\":null,\"drayageVendorId\":7001003,\"drayageVendorName\":\"NJ Port Drayage\",\"pickupAppointmentNo\":\"PU-NJ-20260520-02\",\"pickupAppointmentTime\":\"2026-05-19 23:00:00\",\"actualPickupTime\":\"2026-05-20 00:30:00\",\"pickupRemark\":\"已提柜，预约到仓\",\"expectedArrivalTime\":\"2026-05-20 18:00:00\",\"requiredArrivalTime\":null,\"actualArrivalTime\":\"2026-05-20 18:35:00\",\"containerLocation\":\"YARD-A-08\",\"arrivalRemark\":\"已到仓等待拆柜\",\"devanningNo\":\"DEV202605220003\",\"devanningMethod\":\"MANUAL\",\"expectedDevanningTime\":\"2026-05-21 19:00:00\",\"devanningAppointmentTime\":null,\"devanningStartTime\":\"2026-05-21 19:15:00\",\"devanningFinishTime\":null,\"loadingType\":\"PALLET\",\"sortingMethod\":\"BY_ORDER\",\"devanningRemark\":\"拆柜进行中\",\"emptyReturnLocation\":\"Maher Empty Return Depot\",\"emptyReturnAppointmentNo\":null,\"emptyReturnTime\":null,\"emptyReturnRemark\":null,\"containerStatus\":\"DEVANNING\",\"internalRemark\":\"模拟已到仓拆柜中\",\"status\":\"0\",\"cargoOrders\":[{\"id\":1004,\"cargoOrderNo\":\"CO-2026-000004\",\"externalOrderNo\":null,\"orderSource\":\"PORTAL\",\"customerId\":200,\"customerName\":\"测试客户A\",\"businessTypeId\":10,\"businessTypeName\":\"FBA头程\",\"channelId\":null,\"channelName\":null,\"platformId\":20,\"platformName\":\"Amazon US\",\"customerServiceId\":30,\"customerServiceName\":\"张客服\",\"inboundWarehouseId\":41,\"inboundWarehouseName\":\"纽约仓(JFK)\",\"addressType\":\"PLATFORM_WH\",\"platformWarehouseCode\":\"JFK7\",\"consigneeName\":\"Amazon Fulfillment Center JFK7\",\"addressLine1\":\"600 Outer Road\",\"addressLine2\":null,\"city\":\"Jamaica\",\"state\":\"NY\",\"zipCode\":\"11430\",\"country\":\"US\",\"contactName\":\"Amazon Receiving\",\"contactPhone\":\"+1-718-555-0004\",\"contactEmail\":null,\"parcelCarrierName\":null,\"parcelTrackingNo\":null,\"transferFlag\":0,\"transferWarehouseCode\":null,\"forecastQtyUnit\":\"BY_CARTON\",\"declaredCartonQty\":\"50.00\",\"declaredPalletQty\":null,\"declaredPieceQty\":null,\"declaredWeight\":\"380.000\",\"declaredCbm\":\"2.900\",\"weightUnit\":\"KG\",\"volumeUnit\":\"CBM\",\"eta\":\"2026-05-07 09:00:00\",\"ata\":\"2026-05-08 20:00:00\",\"customerRemark\":null,\"internalRemark\":null,\"operationRemark\":\"已出单，快递追踪正常\",\"shipments\":[{\"id\":10041,\"shipmentNo\":\"SC-007\",\"poNo\":\"PO-20260504-001\",\"shippingMark\":\"MARK-D\",\"cartonQty\":\"50.00\",\"palletQty\":null,\"weight\":\"380.000\",\"cbm\":\"2.900\",\"dwTime\":\"2026-05-09 09:00:00\",\"remark\":null,\"skuItems\":[]}]}]}','',1,'\r\n### Error updating database.  Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'CO-2026-000004-000000\' for key \'oms_cargo_order.uk_cargo_order_no_tenant\'\r\n### The error may exist in org/dromara/oms/mapper/CargoOrderMapper.java (best guess)\r\n### The error may involve org.dromara.oms.mapper.CargoOrderMapper.insert-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO oms_cargo_order (id, biz_root_id, company_id, shipment_codes, po_nos, marks, cargo_order_no, order_source, customer_id, customer_name, business_type_id, business_type_name, channel_id, platform_id, platform_name, customer_service_id, customer_service_name, container_order_id, container_no, inbound_warehouse_id, inbound_warehouse_name, address_type, platform_warehouse_code, consignee_name, address_line1, city, state, zip_code, country, contact_name, contact_phone, transfer_flag, forecast_qty_unit, declared_carton_qty, declared_weight, declared_cbm, weight_unit, volume_unit, pre_outbound_status, fulfillment_status, billing_status, earliest_dw_time, eta, ata, operation_remark, deleted, create_dept, create_by, create_time, update_by, update_time, tenant_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, \'000000\')\r\n### Cause: java.sql.SQLIntegrityConstraintViolationException: Duplicate entry \'CO-2026-000004-000000\' for key \'oms_cargo_order.uk_cargo_order_no_tenant\'\n; Duplicate entry \'CO-2026-000004-000000\' for key \'oms_cargo_order.uk_cargo_order_no_tenant\'','2026-05-26 05:21:30',456),(2059517417598758914,'000000','pre-outbound-update',2,'org.dromara.oms.controller.PreOutboundController.update()','PUT',1,'admin','研发部门','/oms/pre-outbound/6000002001','0:0:0:0:0:0:0:1','内网IP','6000002001 {\"outboundDirection\":\"DELIVERY\",\"appointmentNo\":null,\"appointmentTime\":null,\"deliveryTruck\":null,\"loadingType\":\"PALLET\",\"transportType\":\"FTL\",\"deliveryTag\":null,\"followRecord\":null,\"remark\":\"mock pre outbound\"}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-27 14:09:51',441),(2059517421365243905,'000000','pre-outbound-convert',2,'org.dromara.oms.controller.PreOutboundController.convert()','POST',1,'admin','研发部门','/oms/pre-outbound/6000002001/convert','0:0:0:0:0:0:0:1','内网IP','6000002001 {\"cargoOrderId\":null,\"cargoOrderIds\":null,\"outboundDirection\":\"DELIVERY\",\"outboundWarehouseId\":4001001,\"outboundWarehouseName\":\"Los Angeles Central Warehouse\",\"transferInWarehouseId\":null,\"deliveryMethod\":null,\"appointmentStatus\":\"UNCONFIRMED\",\"appointmentNo\":null,\"appointmentTime\":null,\"deliveryTruck\":null,\"loadingType\":\"PALLET\",\"transportType\":\"FTL\",\"deliveryTag\":null,\"destination\":\"Los Angeles Central Warehouse\",\"followRecord\":null,\"transferReason\":null,\"transferMethod\":null,\"transferFlag\":null,\"transferWarehouseCode\":null,\"remark\":\"mock pre outbound\"}','{\"code\":200,\"msg\":\"操作成功\",\"data\":{\"id\":\"2059517419800768514\",\"cargoOrderId\":1003,\"preOutboundId\":6000002001,\"preOutboundNo\":\"POB202605240001\",\"outboundOrderNo\":\"OB2059517419632996352\",\"cargoOrderNo\":\"CO-2026-000003\",\"outboundStatus\":\"CREATED\",\"outboundDirection\":\"DELIVERY\",\"outboundWarehouseId\":4001001,\"outboundWarehouseName\":\"Los Angeles Central Warehouse\",\"customerName\":\"测试客户C\",\"containerNo\":\"MSCU7654321\",\"shipmentCodes\":\"SC-004,SC-005,SC-006\",\"actualCartonQty\":\"200.00\",\"actualPalletQty\":\"10.00\",\"actualWeight\":\"1445.000\",\"actualCbm\":\"11.480\",\"deliveryMethod\":null,\"appointmentStatus\":\"UNCONFIRMED\",\"appointmentTime\":null,\"deliveryLfd\":null,\"contactName\":null,\"contactPhone\":null,\"contactEmail\":null,\"addressLine1\":null,\"addressLine2\":null,\"city\":null,\"state\":null,\"zipCode\":null,\"country\":null,\"transferInWarehouseId\":null,\"transferReason\":null,\"transferMethod\":null,\"estimatedTransferTime\":null,\"estimatedArrivalTime\":null,\"carrier\":null,\"trackingNo\":null,\"actualOutboundTime\":null,\"actualSignedTime\":null,\"actualArrivalTime\":null,\"podStatus\":\"PENDING\",\"podUploadTime\":null,\"completedTime\":null,\"dispatchRemark\":null,\"operationRemark\":null,\"remark\":\"mock pre outbound\",\"createTime\":\"2026-05-26 23:09:52\"}}',0,'','2026-05-27 14:09:52',484),(2059517552143642625,'000000','outbound-order-cancel',2,'org.dromara.oms.controller.OutboundOrderController.cancel()','POST',1,'admin','研发部门','/oms/outbound-order/6000003001/cancel','0:0:0:0:0:0:0:1','内网IP','{\"remark\":\"前端取消\"}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-27 14:10:23',71),(2059519300262440961,'000000','outbound-order-cancel',2,'org.dromara.oms.controller.OutboundOrderController.cancel()','POST',1,'admin','研发部门','/oms/outbound-order/2059517419800768514/cancel','0:0:0:0:0:0:0:1','内网IP','{\"remark\":\"前端取消\"}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-27 14:17:20',157),(2059521672497901570,'000000','outbound-pool-batch-create-pre-outbound',1,'org.dromara.oms.controller.OutboundPoolController.batchCreatePreOutbound()','POST',1,'admin','研发部门','/oms/outbound-pool/batch-create-pre-outbound','0:0:0:0:0:0:0:1','内网IP','{\"cargoOrderId\":null,\"cargoOrderIds\":[1004,1002],\"outboundDirection\":\"DELIVERY\",\"outboundWarehouseId\":41,\"outboundWarehouseName\":\"纽约仓(JFK)\",\"transferInWarehouseId\":null,\"deliveryMethod\":null,\"appointmentStatus\":\"UNCONFIRMED\",\"appointmentNo\":\"\",\"appointmentTime\":null,\"deliveryTruck\":\"\",\"loadingType\":\"PALLET\",\"transportType\":\"FTL\",\"deliveryTag\":\"\",\"destination\":\"JFK7\",\"followRecord\":\"\",\"transferReason\":null,\"transferMethod\":null,\"transferFlag\":0,\"transferWarehouseCode\":null,\"remark\":null}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-27 14:26:45',746),(2059523676196614146,'000000','pre-outbound-delete',3,'org.dromara.oms.controller.PreOutboundController.delete()','DELETE',1,'admin','研发部门','/oms/pre-outbound/2059521670472052738','0:0:0:0:0:0:0:1','内网IP','\"2059521670472052738\"','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-27 14:34:43',526),(2059563692079816705,'000000','outbound-pool-batch-create-pre-outbound',1,'org.dromara.oms.controller.OutboundPoolController.batchCreatePreOutbound()','POST',1,'admin','研发部门','/oms/outbound-pool/batch-create-pre-outbound','0:0:0:0:0:0:0:1','内网IP','{\"cargoOrderId\":null,\"cargoOrderIds\":[1004,1002],\"outboundDirection\":\"DELIVERY\",\"outboundWarehouseId\":41,\"outboundWarehouseName\":\"纽约仓(JFK)\",\"transferInWarehouseId\":null,\"deliveryMethod\":null,\"appointmentStatus\":\"UNCONFIRMED\",\"appointmentNo\":\"\",\"appointmentTime\":null,\"deliveryTruck\":\"\",\"loadingType\":\"PALLET\",\"transportType\":\"FTL\",\"deliveryTag\":\"\",\"destination\":\"JFK7\",\"followRecord\":\"\",\"transferReason\":null,\"transferMethod\":null,\"transferFlag\":0,\"transferWarehouseCode\":null,\"remark\":null}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-27 17:13:44',669),(2059566105260040193,'000000','pre-outbound-remove-item',3,'org.dromara.oms.controller.PreOutboundController.removeItem()','DELETE',1,'admin','研发部门','/oms/pre-outbound/2059563689777143809/items/2059563690360152065','0:0:0:0:0:0:0:1','内网IP','\"2059563689777143809\" \"2059563690360152065\"','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-27 17:23:19',657),(2059566116718878722,'000000','pre-outbound-update',2,'org.dromara.oms.controller.PreOutboundController.update()','PUT',1,'admin','研发部门','/oms/pre-outbound/2059563689777143809','0:0:0:0:0:0:0:1','内网IP','\"2059563689777143809\" {\"outboundDirection\":\"DELIVERY\",\"appointmentNo\":null,\"appointmentTime\":null,\"deliveryTruck\":null,\"loadingType\":\"PALLET\",\"transportType\":\"FTL\",\"deliveryTag\":null,\"followRecord\":null,\"remark\":null}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-27 17:23:22',26),(2059566141096173570,'000000','pre-outbound-update',2,'org.dromara.oms.controller.PreOutboundController.update()','PUT',1,'admin','研发部门','/oms/pre-outbound/2059563689777143809','0:0:0:0:0:0:0:1','内网IP','\"2059563689777143809\" {\"outboundDirection\":\"DELIVERY\",\"appointmentNo\":null,\"appointmentTime\":null,\"deliveryTruck\":null,\"loadingType\":\"PALLET\",\"transportType\":\"FTL\",\"deliveryTag\":null,\"followRecord\":null,\"remark\":null}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-27 17:23:28',29),(2059566144472588290,'000000','pre-outbound-convert',2,'org.dromara.oms.controller.PreOutboundController.convert()','POST',1,'admin','研发部门','/oms/pre-outbound/2059563689777143809/convert','0:0:0:0:0:0:0:1','内网IP','\"2059563689777143809\" {\"cargoOrderId\":null,\"cargoOrderIds\":null,\"outboundDirection\":\"DELIVERY\",\"outboundWarehouseId\":41,\"outboundWarehouseName\":\"纽约仓(JFK)\",\"transferInWarehouseId\":null,\"deliveryMethod\":null,\"appointmentStatus\":\"UNCONFIRMED\",\"appointmentNo\":null,\"appointmentTime\":null,\"deliveryTruck\":null,\"loadingType\":\"PALLET\",\"transportType\":\"FTL\",\"deliveryTag\":null,\"destination\":\"JFK7\",\"followRecord\":null,\"transferReason\":null,\"transferMethod\":null,\"transferFlag\":null,\"transferWarehouseCode\":null,\"remark\":null}','{\"code\":200,\"msg\":\"操作成功\",\"data\":{\"id\":\"2059566142723563522\",\"cargoOrderId\":null,\"preOutboundId\":\"2059563689777143809\",\"preOutboundNo\":\"POB2059563689638731776\",\"outboundOrderNo\":\"OB2059566142677426176\",\"cargoOrderNo\":null,\"outboundStatus\":\"CREATED\",\"outboundDirection\":\"DELIVERY\",\"outboundWarehouseId\":41,\"outboundWarehouseName\":\"纽约仓(JFK)\",\"customerName\":\"测试客户A\",\"containerNo\":\"OOLU4567890\",\"shipmentCodes\":\"SC-007\",\"actualCartonQty\":\"50.00\",\"actualPalletQty\":\"3.00\",\"actualWeight\":\"379.500\",\"actualCbm\":\"2.890\",\"deliveryMethod\":null,\"appointmentStatus\":\"UNCONFIRMED\",\"appointmentTime\":null,\"deliveryLfd\":null,\"contactName\":null,\"contactPhone\":null,\"contactEmail\":null,\"addressLine1\":null,\"addressLine2\":null,\"city\":null,\"state\":null,\"zipCode\":null,\"country\":null,\"transferInWarehouseId\":null,\"transferReason\":null,\"transferMethod\":null,\"estimatedTransferTime\":null,\"estimatedArrivalTime\":null,\"carrier\":null,\"trackingNo\":null,\"actualOutboundTime\":null,\"actualSignedTime\":null,\"actualArrivalTime\":null,\"podStatus\":\"PENDING\",\"podUploadTime\":null,\"completedTime\":null,\"dispatchRemark\":null,\"operationRemark\":null,\"remark\":null,\"createTime\":\"2026-05-27 02:23:28\"}}',0,'','2026-05-27 17:23:28',455),(2059707781630763009,'000000','outbound-order-delete',3,'org.dromara.oms.controller.OutboundOrderController.delete()','DELETE',1,'admin','研发部门','/oms/outbound-order/2059566142723563522','0:0:0:0:0:0:0:1','内网IP','\"2059566142723563522\"','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 02:46:17',437),(2059707991232716801,'000000','outbound-pool-batch-create-outbound-order',1,'org.dromara.oms.controller.OutboundPoolController.batchCreateOutboundOrder()','POST',1,'admin','研发部门','/oms/outbound-pool/batch-create-outbound-order','0:0:0:0:0:0:0:1','内网IP','{\"cargoOrderId\":null,\"cargoOrderIds\":[9200014,1004],\"outboundDirection\":\"DELIVERY\",\"outboundWarehouseId\":4001002,\"outboundWarehouseName\":\"New Jersey East Coast Warehouse\",\"transferInWarehouseId\":null,\"deliveryMethod\":\"卡车派送\",\"appointmentStatus\":\"UNCONFIRMED\",\"appointmentNo\":\"\",\"appointmentTime\":null,\"deliveryTruck\":\"\",\"loadingType\":\"PALLET\",\"transportType\":\"FTL\",\"deliveryTag\":\"\",\"destination\":\"EWR9\",\"followRecord\":\"\",\"transferReason\":null,\"transferMethod\":null,\"transferFlag\":0,\"transferWarehouseCode\":null,\"remark\":null}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 02:47:07',348),(2059708018038513666,'000000','outbound-order-delete',3,'org.dromara.oms.controller.OutboundOrderController.delete()','DELETE',1,'admin','研发部门','/oms/outbound-order/2059707990268026881','0:0:0:0:0:0:0:1','内网IP','\"2059707990268026881\"','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 02:47:14',234),(2059808935786135553,'000000','停用货物订单分组规则',2,'org.dromara.oms.controller.CargoGroupingRuleController.disable()','POST',1,'admin','研发部门','/oms/cargoGroupingRule/9302001/disable','0:0:0:0:0:0:0:1','内网IP','9302001','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 09:28:14',806),(2059808955105099777,'000000','停用货物订单分组规则',2,'org.dromara.oms.controller.CargoGroupingRuleController.disable()','POST',1,'admin','研发部门','/oms/cargoGroupingRule/9302101/disable','0:0:0:0:0:0:0:1','内网IP','9302101','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 09:28:19',25),(2059808962940059650,'000000','停用货物订单分组规则',2,'org.dromara.oms.controller.CargoGroupingRuleController.disable()','POST',1,'admin','研发部门','/oms/cargoGroupingRule/9302002/disable','0:0:0:0:0:0:0:1','内网IP','9302002','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 09:28:21',21),(2059808970955374594,'000000','停用货物订单分组规则',2,'org.dromara.oms.controller.CargoGroupingRuleController.disable()','POST',1,'admin','研发部门','/oms/cargoGroupingRule/9302003/disable','0:0:0:0:0:0:0:1','内网IP','9302003','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 09:28:23',29),(2059808978949718017,'000000','停用货物订单分组规则',2,'org.dromara.oms.controller.CargoGroupingRuleController.disable()','POST',1,'admin','研发部门','/oms/cargoGroupingRule/9302102/disable','0:0:0:0:0:0:0:1','内网IP','9302102','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 09:28:25',17),(2059808987317354498,'000000','停用货物订单分组规则',2,'org.dromara.oms.controller.CargoGroupingRuleController.disable()','POST',1,'admin','研发部门','/oms/cargoGroupingRule/9302201/disable','0:0:0:0:0:0:0:1','内网IP','9302201','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 09:28:27',51),(2059814468878417921,'000000','货物订单分组规则',1,'org.dromara.oms.controller.CargoGroupingRuleController.add()','POST',1,'admin','研发部门','/oms/cargoGroupingRule','0:0:0:0:0:0:0:1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"id\":null,\"warehouseId\":4001001,\"warehouseName\":\"Los Angeles Central Warehouse\",\"ruleName\":\"LA-亚马逊分组\",\"conditionConfig\":\"{\\\"mode\\\":\\\"VALUE_MATCH\\\",\\\"logic\\\":\\\"AND\\\",\\\"conditions\\\":[{\\\"field\\\":\\\"order.order_type\\\",\\\"op\\\":\\\"EQ\\\",\\\"value\\\":\\\"卡车派送\\\"},{\\\"field\\\":\\\"order.address_type\\\",\\\"op\\\":\\\"EQ\\\",\\\"value\\\":\\\"PLATFORM_WH\\\"},{\\\"field\\\":\\\"order.platform_id\\\",\\\"op\\\":\\\"EQ\\\",\\\"value\\\":\\\"2000001\\\"}]}\",\"groupKeyConfig\":\"{\\\"separator\\\":\\\"-\\\",\\\"fields\\\":[{\\\"field\\\":\\\"order.platform_id\\\"},{\\\"field\\\":\\\"order.platform_code\\\"}]}\",\"priority\":0,\"isDefault\":0,\"status\":\"enabled\",\"version\":null,\"remark\":null}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 09:50:14',152),(2059814689536557058,'000000','货物订单分组规则',1,'org.dromara.oms.controller.CargoGroupingRuleController.add()','POST',1,'admin','研发部门','/oms/cargoGroupingRule','0:0:0:0:0:0:0:1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"id\":null,\"warehouseId\":4001001,\"warehouseName\":\"Los Angeles Central Warehouse\",\"ruleName\":\"LA仓-商业地址\",\"conditionConfig\":\"{\\\"mode\\\":\\\"VALUE_MATCH\\\",\\\"logic\\\":\\\"AND\\\",\\\"conditions\\\":[{\\\"field\\\":\\\"order.order_type\\\",\\\"op\\\":\\\"EQ\\\",\\\"value\\\":\\\"卡车派送\\\"},{\\\"field\\\":\\\"order.address_type\\\",\\\"op\\\":\\\"EQ\\\",\\\"value\\\":\\\"COMMERCIAL\\\"}]}\",\"groupKeyConfig\":\"{\\\"separator\\\":\\\"-\\\",\\\"fields\\\":[{\\\"field\\\":\\\"order.address_type\\\"},{\\\"field\\\":\\\"order.order_no\\\"}]}\",\"priority\":0,\"isDefault\":0,\"status\":\"enabled\",\"version\":null,\"remark\":null}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 09:51:06',20),(2059814887398653953,'000000','货物订单分组规则',1,'org.dromara.oms.controller.CargoGroupingRuleController.add()','POST',1,'admin','研发部门','/oms/cargoGroupingRule','0:0:0:0:0:0:0:1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"id\":null,\"warehouseId\":4001001,\"warehouseName\":\"Los Angeles Central Warehouse\",\"ruleName\":\"LA仓-私人地址\",\"conditionConfig\":\"{\\\"mode\\\":\\\"VALUE_MATCH\\\",\\\"logic\\\":\\\"AND\\\",\\\"conditions\\\":[{\\\"field\\\":\\\"order.order_type\\\",\\\"op\\\":\\\"EQ\\\",\\\"value\\\":\\\"卡车派送\\\"},{\\\"field\\\":\\\"order.address_type\\\",\\\"op\\\":\\\"EQ\\\",\\\"value\\\":\\\"PRIVATE\\\"}]}\",\"groupKeyConfig\":\"{\\\"separator\\\":\\\"-\\\",\\\"fields\\\":[{\\\"field\\\":\\\"order.address_type\\\"},{\\\"field\\\":\\\"order.order_no\\\"}]}\",\"priority\":0,\"isDefault\":0,\"status\":\"enabled\",\"version\":null,\"remark\":null}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 09:51:53',21),(2059815112842493954,'000000','货物订单分组规则',2,'org.dromara.oms.controller.CargoGroupingRuleController.edit()','PUT',1,'admin','研发部门','/oms/cargoGroupingRule','0:0:0:0:0:0:0:1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"id\":\"2059814468601593857\",\"warehouseId\":4001001,\"warehouseName\":\"Los Angeles Central Warehouse\",\"ruleName\":\"LA-平台仓分组\",\"conditionConfig\":\"{\\\"mode\\\":\\\"VALUE_MATCH\\\",\\\"logic\\\":\\\"AND\\\",\\\"conditions\\\":[{\\\"field\\\":\\\"order.order_type\\\",\\\"op\\\":\\\"EQ\\\",\\\"value\\\":\\\"卡车派送\\\"},{\\\"field\\\":\\\"order.address_type\\\",\\\"op\\\":\\\"EQ\\\",\\\"value\\\":\\\"PLATFORM_WH\\\"}]}\",\"groupKeyConfig\":\"{\\\"separator\\\":\\\"-\\\",\\\"fields\\\":[{\\\"field\\\":\\\"order.platform_id\\\"},{\\\"field\\\":\\\"order.platform_code\\\"}]}\",\"priority\":0,\"isDefault\":0,\"status\":\"enabled\",\"version\":0,\"remark\":null}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 09:52:47',141),(2059818115204988929,'000000','货物订单分组规则',1,'org.dromara.oms.controller.CargoGroupingRuleController.add()','POST',1,'admin','研发部门','/oms/cargoGroupingRule','0:0:0:0:0:0:0:1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"id\":null,\"warehouseId\":4001001,\"warehouseName\":\"Los Angeles Central Warehouse\",\"ruleName\":\"LA仓-快递派送\",\"conditionConfig\":\"{\\\"mode\\\":\\\"VALUE_MATCH\\\",\\\"logic\\\":\\\"AND\\\",\\\"conditions\\\":[{\\\"field\\\":\\\"order.order_type\\\",\\\"op\\\":\\\"EQ\\\",\\\"value\\\":\\\"快递派送\\\"}]}\",\"groupKeyConfig\":\"{\\\"separator\\\":\\\"-\\\",\\\"fields\\\":[{\\\"field\\\":\\\"order.parcel_carrier_name\\\"}]}\",\"priority\":0,\"isDefault\":0,\"status\":\"enabled\",\"version\":null,\"remark\":null}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 10:04:43',129),(2059818230640623618,'000000','货物订单分组规则',1,'org.dromara.oms.controller.CargoGroupingRuleController.add()','POST',1,'admin','研发部门','/oms/cargoGroupingRule','0:0:0:0:0:0:0:1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"id\":null,\"warehouseId\":4001001,\"warehouseName\":\"Los Angeles Central Warehouse\",\"ruleName\":\"LA仓-客户自提\",\"conditionConfig\":\"{\\\"mode\\\":\\\"VALUE_MATCH\\\",\\\"logic\\\":\\\"AND\\\",\\\"conditions\\\":[{\\\"field\\\":\\\"order.order_type\\\",\\\"op\\\":\\\"EQ\\\",\\\"value\\\":\\\"客户自提\\\"}]}\",\"groupKeyConfig\":\"{\\\"separator\\\":\\\"-\\\",\\\"fields\\\":[{\\\"field\\\":\\\"order.order_type\\\"},{\\\"field\\\":\\\"order.order_no\\\"}]}\",\"priority\":0,\"isDefault\":0,\"status\":\"enabled\",\"version\":null,\"remark\":null}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 10:05:10',29),(2059818382327627777,'000000','货物订单分组规则',1,'org.dromara.oms.controller.CargoGroupingRuleController.add()','POST',1,'admin','研发部门','/oms/cargoGroupingRule','0:0:0:0:0:0:0:1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"id\":null,\"warehouseId\":4001001,\"warehouseName\":\"Los Angeles Central Warehouse\",\"ruleName\":\"LA仓-大货中转\",\"conditionConfig\":\"{\\\"mode\\\":\\\"VALUE_MATCH\\\",\\\"logic\\\":\\\"AND\\\",\\\"conditions\\\":[{\\\"field\\\":\\\"order.order_type\\\",\\\"op\\\":\\\"EQ\\\",\\\"value\\\":\\\"大货中转\\\"}]}\",\"groupKeyConfig\":\"{\\\"separator\\\":\\\"-\\\",\\\"fields\\\":[{\\\"field\\\":\\\"order.order_type\\\"},{\\\"field\\\":\\\"order.order_no\\\"}]}\",\"priority\":0,\"isDefault\":0,\"status\":\"enabled\",\"version\":null,\"remark\":null}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 10:05:47',26),(2059818546241028097,'000000','货物订单分组规则',1,'org.dromara.oms.controller.CargoGroupingRuleController.add()','POST',1,'admin','研发部门','/oms/cargoGroupingRule','0:0:0:0:0:0:0:1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"id\":null,\"warehouseId\":4001001,\"warehouseName\":\"Los Angeles Central Warehouse\",\"ruleName\":\"LA仓-一件代发\",\"conditionConfig\":\"{\\\"mode\\\":\\\"VALUE_MATCH\\\",\\\"logic\\\":\\\"AND\\\",\\\"conditions\\\":[{\\\"field\\\":\\\"order.order_type\\\",\\\"op\\\":\\\"EQ\\\",\\\"value\\\":\\\"一件代发\\\"}]}\",\"groupKeyConfig\":\"{\\\"separator\\\":\\\"-\\\",\\\"fields\\\":[{\\\"field\\\":\\\"order.order_type\\\"},{\\\"field\\\":\\\"shipment.shipment_no\\\"}]}\",\"priority\":0,\"isDefault\":0,\"status\":\"enabled\",\"version\":null,\"remark\":null}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 10:06:26',130),(2059846524345864194,'000000','入库计划-自动分组',2,'org.dromara.oms.controller.InboundPlanController.autoGroup()','POST',1,'admin','研发部门','/wms/inbound-plan/2059846458965053442/auto-group','0:0:0:0:0:0:0:1','内网IP','\"2059846458965053442\"','',1,'\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'plan_id\' doesn\'t have a default value\r\n### The error may exist in org/dromara/oms/mapper/InboundPlanChangeLogMapper.java (best guess)\r\n### The error may involve org.dromara.oms.mapper.InboundPlanChangeLogMapper.insert-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO wms_inbound_plan_change_log (id, plan_item_id, shipment_id, new_group_code, change_type, change_by, change_time, tenant_id) VALUES (?, ?, ?, ?, ?, ?, ?, \'000000\')\r\n### Cause: java.sql.SQLException: Field \'plan_id\' doesn\'t have a default value\n; Field \'plan_id\' doesn\'t have a default value','2026-05-28 11:57:36',512),(2059851552821444610,'000000','入库计划-自动分组',2,'org.dromara.oms.controller.InboundPlanController.autoGroup()','POST',1,'admin','研发部门','/wms/inbound-plan/2059848614686326785/auto-group','0:0:0:0:0:0:0:1','内网IP','\"2059848614686326785\"','',1,'\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'plan_id\' doesn\'t have a default value\r\n### The error may exist in org/dromara/oms/mapper/InboundPlanChangeLogMapper.java (best guess)\r\n### The error may involve org.dromara.oms.mapper.InboundPlanChangeLogMapper.insert-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO wms_inbound_plan_change_log (id, plan_item_id, shipment_id, new_group_code, change_type, change_by, change_time, tenant_id) VALUES (?, ?, ?, ?, ?, ?, ?, \'000000\')\r\n### Cause: java.sql.SQLException: Field \'plan_id\' doesn\'t have a default value\n; Field \'plan_id\' doesn\'t have a default value','2026-05-28 12:17:35',781),(2059851576775114754,'000000','入库计划-自动分组',2,'org.dromara.oms.controller.InboundPlanController.autoGroup()','POST',1,'admin','研发部门','/wms/inbound-plan/2059848614686326785/auto-group','0:0:0:0:0:0:0:1','内网IP','\"2059848614686326785\"','',1,'\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'plan_id\' doesn\'t have a default value\r\n### The error may exist in org/dromara/oms/mapper/InboundPlanChangeLogMapper.java (best guess)\r\n### The error may involve org.dromara.oms.mapper.InboundPlanChangeLogMapper.insert-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO wms_inbound_plan_change_log (id, plan_item_id, shipment_id, new_group_code, change_type, change_by, change_time, tenant_id) VALUES (?, ?, ?, ?, ?, ?, ?, \'000000\')\r\n### Cause: java.sql.SQLException: Field \'plan_id\' doesn\'t have a default value\n; Field \'plan_id\' doesn\'t have a default value','2026-05-28 12:17:41',174),(2059852840619511810,'000000','入库计划-自动分组',2,'org.dromara.oms.controller.InboundPlanController.autoGroup()','POST',1,'admin','研发部门','/wms/inbound-plan/2059848614686326785/auto-group','0:0:0:0:0:0:0:1','内网IP','\"2059848614686326785\"','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 12:22:42',356),(2059853581966938113,'000000','货物订单',2,'org.dromara.oms.controller.CargoOrderController.edit()','PUT',1,'admin','研发部门','/oms/cargo-order','0:0:0:0:0:0:0:1','内网IP','{\"id\":1001,\"cargoOrderNo\":\"CO-2026-000001\",\"externalOrderNo\":\"EXT-REF-001\",\"orderSource\":\"MANUAL\",\"customerId\":200,\"customerName\":\"测试客户A\",\"businessTypeId\":5002001,\"businessTypeName\":\"卡车派送\",\"channelId\":null,\"channelName\":null,\"platformId\":20,\"platformName\":\"Amazon US\",\"customerServiceId\":30,\"customerServiceName\":\"张客服\",\"inboundWarehouseId\":4001001,\"inboundWarehouseName\":\"Los Angeles Central Warehouse\",\"addressType\":\"PLATFORM_WH\",\"platformWarehouseCode\":\"ONT8\",\"consigneeName\":\"Amazon Fulfillment Center\",\"addressLine1\":\"1 Fulfillment Way\",\"addressLine2\":null,\"city\":\"Ontario\",\"state\":\"CA\",\"zipCode\":\"91761\",\"country\":\"US\",\"contactName\":\"John Smith\",\"contactPhone\":\"+1-909-555-0001\",\"contactEmail\":\"john.smith@amazon.com\",\"parcelCarrierName\":null,\"parcelTrackingNo\":null,\"transferFlag\":0,\"transferWarehouseCode\":null,\"forecastQtyUnit\":\"BY_CARTON\",\"declaredCartonQty\":\"120.00\",\"declaredPalletQty\":\"0.00\",\"declaredPieceQty\":null,\"declaredWeight\":\"860.500\",\"declaredCbm\":\"6.800\",\"weightUnit\":\"KG\",\"volumeUnit\":\"CBM\",\"eta\":\"2026-05-27 09:00:00\",\"ata\":null,\"customerRemark\":\"请注意FBA入仓要求\",\"internalRemark\":null,\"operationRemark\":null,\"shipments\":[{\"id\":10011,\"shipmentNo\":\"SC-001\",\"poNo\":\"PO-20260501-001\",\"shippingMark\":\"MARK-A\",\"cartonQty\":\"60.00\",\"palletQty\":null,\"weight\":\"430.000\",\"cbm\":\"3.400\",\"dwTime\":\"2026-05-31 09:00:00\",\"remark\":null,\"skuItems\":[{\"id\":100111,\"shipmentId\":10011,\"shipmentNo\":\"SC-001\",\"poNo\":\"PO-20260501-001\",\"shippingMark\":\"MARK-A\",\"sku\":\"SKU-A001\",\"fnsku\":\"X001FNSKU1\",\"productName\":\"Wireless Earbuds Pro\",\"qty\":\"600.00\",\"cartonQty\":\"60.00\",\"weight\":null,\"cbm\":null,\"remark\":null}]},{\"id\":10012,\"shipmentNo\":\"SC-002\",\"poNo\":\"PO-20260501-002\",\"shippingMark\":\"MARK-A\",\"cartonQty\":\"60.00\",\"palletQty\":null,\"weight\":\"430.500\",\"cbm\":\"3.400\",\"dwTime\":\"2026-05-31 09:00:00\",\"remark\":null,\"skuItems\":[{\"id\":100121,\"shipmentId\":10012,\"shipmentNo\":\"SC-002\",\"poNo\":\"PO-20260501-002\",\"shippingMark\":\"MARK-A\",\"sku\":\"SKU-A002\",\"fnsku\":\"X001FNSKU2\",\"productName\":\"Phone Case Pack\",\"qty\":\"1200.00\",\"cartonQty\":\"60.00\",\"weight\":null,\"cbm\":null,\"remark\":null}]}]}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 12:25:39',77),(2059853583615299585,'000000','货物订单-货件',1,'org.dromara.oms.controller.CargoOrderController.saveShipment()','POST',1,'admin','研发部门','/oms/cargo-order/1001/shipments','0:0:0:0:0:0:0:1','内网IP','1001 {\"id\":10011,\"shipmentNo\":\"SC-001\",\"poNo\":\"PO-20260501-001\",\"shippingMark\":\"MARK-A\",\"cartonQty\":\"60.00\",\"palletQty\":null,\"weight\":\"430.000\",\"cbm\":\"3.400\",\"dwTime\":\"2026-05-31 09:00:00\",\"remark\":null,\"skuItems\":[{\"id\":100111,\"shipmentId\":10011,\"shipmentNo\":\"SC-001\",\"poNo\":\"PO-20260501-001\",\"shippingMark\":\"MARK-A\",\"sku\":\"SKU-A001\",\"fnsku\":\"X001FNSKU1\",\"productName\":\"Wireless Earbuds Pro\",\"qty\":\"600.00\",\"cartonQty\":\"60.00\",\"weight\":null,\"cbm\":null,\"remark\":null}]}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 12:25:39',54),(2059853585217523713,'000000','货物订单-货件',1,'org.dromara.oms.controller.CargoOrderController.saveShipment()','POST',1,'admin','研发部门','/oms/cargo-order/1001/shipments','0:0:0:0:0:0:0:1','内网IP','1001 {\"id\":10012,\"shipmentNo\":\"SC-002\",\"poNo\":\"PO-20260501-002\",\"shippingMark\":\"MARK-A\",\"cartonQty\":\"60.00\",\"palletQty\":null,\"weight\":\"430.500\",\"cbm\":\"3.400\",\"dwTime\":\"2026-05-31 09:00:00\",\"remark\":null,\"skuItems\":[{\"id\":100121,\"shipmentId\":10012,\"shipmentNo\":\"SC-002\",\"poNo\":\"PO-20260501-002\",\"shippingMark\":\"MARK-A\",\"sku\":\"SKU-A002\",\"fnsku\":\"X001FNSKU2\",\"productName\":\"Phone Case Pack\",\"qty\":\"1200.00\",\"cartonQty\":\"60.00\",\"weight\":null,\"cbm\":null,\"remark\":null}]}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 12:25:40',47),(2059853588300337153,'000000','货物订单-SKU',1,'org.dromara.oms.controller.CargoOrderController.saveSkuItem()','POST',1,'admin','研发部门','/oms/cargo-order/1001/sku-items','0:0:0:0:0:0:0:1','内网IP','1001 {\"id\":100111,\"shipmentId\":10011,\"shipmentNo\":\"SC-001\",\"poNo\":\"PO-20260501-001\",\"shippingMark\":\"MARK-A\",\"sku\":\"SKU-A001\",\"fnsku\":\"X001FNSKU1\",\"productName\":\"Wireless Earbuds Pro\",\"qty\":\"600.00\",\"cartonQty\":\"60.00\",\"weight\":null,\"cbm\":null,\"remark\":null}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 12:25:40',21),(2059853589835452418,'000000','货物订单-SKU',1,'org.dromara.oms.controller.CargoOrderController.saveSkuItem()','POST',1,'admin','研发部门','/oms/cargo-order/1001/sku-items','0:0:0:0:0:0:0:1','内网IP','1001 {\"id\":100121,\"shipmentId\":10012,\"shipmentNo\":\"SC-002\",\"poNo\":\"PO-20260501-002\",\"shippingMark\":\"MARK-A\",\"sku\":\"SKU-A002\",\"fnsku\":\"X001FNSKU2\",\"productName\":\"Phone Case Pack\",\"qty\":\"1200.00\",\"cartonQty\":\"60.00\",\"weight\":null,\"cbm\":null,\"remark\":null}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 12:25:41',19),(2059853731057668097,'000000','货物订单',2,'org.dromara.oms.controller.CargoOrderController.edit()','PUT',1,'admin','研发部门','/oms/cargo-order','0:0:0:0:0:0:0:1','内网IP','{\"id\":1002,\"cargoOrderNo\":\"CO-2026-000002\",\"externalOrderNo\":\"EXT-REF-002\",\"orderSource\":\"IMPORT\",\"customerId\":201,\"customerName\":\"测试客户B\",\"businessTypeId\":5002001,\"businessTypeName\":\"卡车派送\",\"channelId\":null,\"channelName\":null,\"platformId\":null,\"platformName\":null,\"customerServiceId\":30,\"customerServiceName\":\"张客服\",\"inboundWarehouseId\":4001001,\"inboundWarehouseName\":\"Los Angeles Central Warehouse\",\"addressType\":\"PRIVATE\",\"platformWarehouseCode\":null,\"consigneeName\":\"Private Warehouse LLC\",\"addressLine1\":\"2500 Industrial Blvd\",\"addressLine2\":\"Suite 300\",\"city\":\"Los Angeles\",\"state\":\"CA\",\"zipCode\":\"90001\",\"country\":\"US\",\"contactName\":\"Mike Johnson\",\"contactPhone\":\"+1-323-555-0002\",\"contactEmail\":\"mike@private-wh.com\",\"parcelCarrierName\":null,\"parcelTrackingNo\":null,\"transferFlag\":1,\"transferWarehouseCode\":\"RNO1\",\"forecastQtyUnit\":\"BY_CARTON\",\"declaredCartonQty\":\"80.00\",\"declaredPalletQty\":\"0.00\",\"declaredPieceQty\":null,\"declaredWeight\":\"560.000\",\"declaredCbm\":\"4.200\",\"weightUnit\":\"KG\",\"volumeUnit\":\"CBM\",\"eta\":\"2026-05-17 09:00:00\",\"ata\":\"2026-05-18 19:30:00\",\"customerRemark\":null,\"internalRemark\":\"转仓至RNO1，需重新预约\",\"operationRemark\":\"已联系转仓仓库确认接收\",\"shipments\":[{\"id\":10021,\"shipmentNo\":\"SC-003\",\"poNo\":\"PO-20260502-001\",\"shippingMark\":\"MARK-B\",\"cartonQty\":\"80.00\",\"palletQty\":null,\"weight\":\"560.000\",\"cbm\":\"4.200\",\"dwTime\":\"2026-05-19 09:00:00\",\"remark\":null,\"skuItems\":[{\"id\":100211,\"shipmentId\":10021,\"shipmentNo\":\"SC-003\",\"poNo\":\"PO-20260502-001\",\"shippingMark\":\"MARK-B\",\"sku\":\"SKU-B001\",\"fnsku\":null,\"productName\":\"Storage Shelf Unit\",\"qty\":\"80.00\",\"cartonQty\":\"80.00\",\"weight\":null,\"cbm\":null,\"remark\":null}]}]}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 12:26:14',23),(2059853732710223873,'000000','货物订单-货件',1,'org.dromara.oms.controller.CargoOrderController.saveShipment()','POST',1,'admin','研发部门','/oms/cargo-order/1002/shipments','0:0:0:0:0:0:0:1','内网IP','1002 {\"id\":10021,\"shipmentNo\":\"SC-003\",\"poNo\":\"PO-20260502-001\",\"shippingMark\":\"MARK-B\",\"cartonQty\":\"80.00\",\"palletQty\":null,\"weight\":\"560.000\",\"cbm\":\"4.200\",\"dwTime\":\"2026-05-19 09:00:00\",\"remark\":null,\"skuItems\":[{\"id\":100211,\"shipmentId\":10021,\"shipmentNo\":\"SC-003\",\"poNo\":\"PO-20260502-001\",\"shippingMark\":\"MARK-B\",\"sku\":\"SKU-B001\",\"fnsku\":null,\"productName\":\"Storage Shelf Unit\",\"qty\":\"80.00\",\"cartonQty\":\"80.00\",\"weight\":null,\"cbm\":null,\"remark\":null}]}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 12:26:15',49),(2059853735646236674,'000000','货物订单-SKU',1,'org.dromara.oms.controller.CargoOrderController.saveSkuItem()','POST',1,'admin','研发部门','/oms/cargo-order/1002/sku-items','0:0:0:0:0:0:0:1','内网IP','1002 {\"id\":100211,\"shipmentId\":10021,\"shipmentNo\":\"SC-003\",\"poNo\":\"PO-20260502-001\",\"shippingMark\":\"MARK-B\",\"sku\":\"SKU-B001\",\"fnsku\":null,\"productName\":\"Storage Shelf Unit\",\"qty\":\"80.00\",\"cartonQty\":\"80.00\",\"weight\":null,\"cbm\":null,\"remark\":null}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 12:26:15',9),(2059853807725350914,'000000','入库计划-自动分组',2,'org.dromara.oms.controller.InboundPlanController.autoGroup()','POST',1,'admin','研发部门','/wms/inbound-plan/2059848614686326785/auto-group','0:0:0:0:0:0:0:1','内网IP','\"2059848614686326785\"','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 12:26:33',118),(2059855177719283713,'000000','入库计划-自动分组',2,'org.dromara.oms.controller.InboundPlanController.autoGroup()','POST',1,'admin','研发部门','/wms/inbound-plan/2059848614686326785/auto-group','0:0:0:0:0:0:0:1','内网IP','\"2059848614686326785\"','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 12:31:59',428),(2059856085307949058,'000000','货物订单',2,'org.dromara.oms.controller.CargoOrderController.edit()','PUT',1,'admin','研发部门','/oms/cargo-order','0:0:0:0:0:0:0:1','内网IP','{\"id\":1001,\"cargoOrderNo\":\"CO-2026-000001\",\"externalOrderNo\":\"EXT-REF-001\",\"orderSource\":\"MANUAL\",\"customerId\":200,\"customerName\":\"测试客户A\",\"businessTypeId\":5002001,\"businessTypeName\":\"卡车派送\",\"channelId\":null,\"channelName\":null,\"platformId\":2000001,\"platformName\":\"Amazon\",\"customerServiceId\":30,\"customerServiceName\":\"张客服\",\"inboundWarehouseId\":4001001,\"inboundWarehouseName\":\"Los Angeles Central Warehouse\",\"addressType\":\"PLATFORM_WH\",\"platformWarehouseCode\":\"ONT8\",\"consigneeName\":\"Amazon Fulfillment Center\",\"addressLine1\":\"1 Fulfillment Way\",\"addressLine2\":null,\"city\":\"Ontario\",\"state\":\"CA\",\"zipCode\":\"91761\",\"country\":\"US\",\"contactName\":\"John Smith\",\"contactPhone\":\"+1-909-555-0001\",\"contactEmail\":\"john.smith@amazon.com\",\"parcelCarrierName\":null,\"parcelTrackingNo\":null,\"transferFlag\":0,\"transferWarehouseCode\":null,\"forecastQtyUnit\":\"BY_CARTON\",\"declaredCartonQty\":\"120.00\",\"declaredPalletQty\":\"0.00\",\"declaredPieceQty\":null,\"declaredWeight\":\"860.500\",\"declaredCbm\":\"6.800\",\"weightUnit\":\"KG\",\"volumeUnit\":\"CBM\",\"eta\":\"2026-05-27 09:00:00\",\"ata\":null,\"customerRemark\":\"请注意FBA入仓要求\",\"internalRemark\":null,\"operationRemark\":null,\"shipments\":[{\"id\":10011,\"shipmentNo\":\"SC-001\",\"poNo\":\"PO-20260501-001\",\"shippingMark\":\"MARK-A\",\"cartonQty\":\"60.00\",\"palletQty\":null,\"weight\":\"430.000\",\"cbm\":\"3.400\",\"dwTime\":\"2026-05-31 09:00:00\",\"remark\":null,\"skuItems\":[{\"id\":100111,\"shipmentId\":10011,\"shipmentNo\":\"SC-001\",\"poNo\":\"PO-20260501-001\",\"shippingMark\":\"MARK-A\",\"sku\":\"SKU-A001\",\"fnsku\":\"X001FNSKU1\",\"productName\":\"Wireless Earbuds Pro\",\"qty\":\"600.00\",\"cartonQty\":\"60.00\",\"weight\":null,\"cbm\":null,\"remark\":null}]},{\"id\":10012,\"shipmentNo\":\"SC-002\",\"poNo\":\"PO-20260501-002\",\"shippingMark\":\"MARK-A\",\"cartonQty\":\"60.00\",\"palletQty\":null,\"weight\":\"430.500\",\"cbm\":\"3.400\",\"dwTime\":\"2026-05-31 09:00:00\",\"remark\":null,\"skuItems\":[{\"id\":100121,\"shipmentId\":10012,\"shipmentNo\":\"SC-002\",\"poNo\":\"PO-20260501-002\",\"shippingMark\":\"MARK-A\",\"sku\":\"SKU-A002\",\"fnsku\":\"X001FNSKU2\",\"productName\":\"Phone Case Pack\",\"qty\":\"1200.00\",\"cartonQty\":\"60.00\",\"weight\":null,\"cbm\":null,\"remark\":null}]}]}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 12:35:36',50),(2059856086859841538,'000000','货物订单-货件',1,'org.dromara.oms.controller.CargoOrderController.saveShipment()','POST',1,'admin','研发部门','/oms/cargo-order/1001/shipments','0:0:0:0:0:0:0:1','内网IP','1001 {\"id\":10011,\"shipmentNo\":\"SC-001\",\"poNo\":\"PO-20260501-001\",\"shippingMark\":\"MARK-A\",\"cartonQty\":\"60.00\",\"palletQty\":null,\"weight\":\"430.000\",\"cbm\":\"3.400\",\"dwTime\":\"2026-05-31 09:00:00\",\"remark\":null,\"skuItems\":[{\"id\":100111,\"shipmentId\":10011,\"shipmentNo\":\"SC-001\",\"poNo\":\"PO-20260501-001\",\"shippingMark\":\"MARK-A\",\"sku\":\"SKU-A001\",\"fnsku\":\"X001FNSKU1\",\"productName\":\"Wireless Earbuds Pro\",\"qty\":\"600.00\",\"cartonQty\":\"60.00\",\"weight\":null,\"cbm\":null,\"remark\":null}]}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 12:35:36',52),(2059856087891640321,'000000','货物订单-货件',1,'org.dromara.oms.controller.CargoOrderController.saveShipment()','POST',1,'admin','研发部门','/oms/cargo-order/1001/shipments','0:0:0:0:0:0:0:1','内网IP','1001 {\"id\":10012,\"shipmentNo\":\"SC-002\",\"poNo\":\"PO-20260501-002\",\"shippingMark\":\"MARK-A\",\"cartonQty\":\"60.00\",\"palletQty\":null,\"weight\":\"430.500\",\"cbm\":\"3.400\",\"dwTime\":\"2026-05-31 09:00:00\",\"remark\":null,\"skuItems\":[{\"id\":100121,\"shipmentId\":10012,\"shipmentNo\":\"SC-002\",\"poNo\":\"PO-20260501-002\",\"shippingMark\":\"MARK-A\",\"sku\":\"SKU-A002\",\"fnsku\":\"X001FNSKU2\",\"productName\":\"Phone Case Pack\",\"qty\":\"1200.00\",\"cartonQty\":\"60.00\",\"weight\":null,\"cbm\":null,\"remark\":null}]}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 12:35:36',29),(2059856089363841025,'000000','货物订单-SKU',1,'org.dromara.oms.controller.CargoOrderController.saveSkuItem()','POST',1,'admin','研发部门','/oms/cargo-order/1001/sku-items','0:0:0:0:0:0:0:1','内网IP','1001 {\"id\":100111,\"shipmentId\":10011,\"shipmentNo\":\"SC-001\",\"poNo\":\"PO-20260501-001\",\"shippingMark\":\"MARK-A\",\"sku\":\"SKU-A001\",\"fnsku\":\"X001FNSKU1\",\"productName\":\"Wireless Earbuds Pro\",\"qty\":\"600.00\",\"cartonQty\":\"60.00\",\"weight\":null,\"cbm\":null,\"remark\":null}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 12:35:37',12),(2059856089783271425,'000000','货物订单-SKU',1,'org.dromara.oms.controller.CargoOrderController.saveSkuItem()','POST',1,'admin','研发部门','/oms/cargo-order/1001/sku-items','0:0:0:0:0:0:0:1','内网IP','1001 {\"id\":100121,\"shipmentId\":10012,\"shipmentNo\":\"SC-002\",\"poNo\":\"PO-20260501-002\",\"shippingMark\":\"MARK-A\",\"sku\":\"SKU-A002\",\"fnsku\":\"X001FNSKU2\",\"productName\":\"Phone Case Pack\",\"qty\":\"1200.00\",\"cartonQty\":\"60.00\",\"weight\":null,\"cbm\":null,\"remark\":null}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 12:35:37',11),(2059856506537705474,'000000','入库计划-自动分组',2,'org.dromara.oms.controller.InboundPlanController.autoGroup()','POST',1,'admin','研发部门','/wms/inbound-plan/2059848614686326785/auto-group','0:0:0:0:0:0:0:1','内网IP','\"2059848614686326785\"','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 12:37:16',262),(2059859924585086977,'000000','字典数据',3,'org.dromara.system.controller.system.SysDictDataController.remove()','DELETE',1,'admin','研发部门','/system/dict/data/6000003418','0:0:0:0:0:0:0:1','内网IP','[6000003418]','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 12:50:51',104),(2059863463394852866,'000000','入库计划-自动分组',2,'org.dromara.oms.controller.InboundPlanController.autoGroup()','POST',1,'admin','研发部门','/wms/inbound-plan/2059848614686326785/auto-group','0:0:0:0:0:0:0:1','内网IP','\"2059848614686326785\"','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 13:04:55',317),(2059909718699466753,'000000','货物订单分组规则',1,'org.dromara.oms.controller.CargoGroupingRuleController.add()','POST',1,'admin','研发部门','/oms/cargoGroupingRule','0:0:0:0:0:0:0:1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"id\":null,\"warehouseId\":4001001,\"warehouseName\":\"Los Angeles Central Warehouse\",\"ruleName\":\"LA-快递\",\"conditionConfig\":\"{\\\"mode\\\":\\\"VALUE_MATCH\\\",\\\"logic\\\":\\\"AND\\\",\\\"conditions\\\":[{\\\"field\\\":\\\"order.order_type\\\",\\\"op\\\":\\\"EQ\\\",\\\"value\\\":\\\"快递派送\\\"}]}\",\"groupKeyConfig\":\"{\\\"separator\\\":\\\"-\\\",\\\"fields\\\":[{\\\"field\\\":\\\"order.parcel_carrier_name\\\"}]}\",\"priority\":0,\"isDefault\":0,\"status\":\"enabled\",\"version\":null,\"remark\":null}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 16:08:43',247),(2059909756913770497,'000000','货物订单分组规则',2,'org.dromara.oms.controller.CargoGroupingRuleController.edit()','PUT',1,'admin','研发部门','/oms/cargoGroupingRule','0:0:0:0:0:0:0:1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"id\":\"2059818545750294529\",\"warehouseId\":4001001,\"warehouseName\":\"Los Angeles Central Warehouse\",\"ruleName\":\"LA-一件代发\",\"conditionConfig\":\"{\\\"mode\\\":\\\"VALUE_MATCH\\\",\\\"logic\\\":\\\"AND\\\",\\\"conditions\\\":[{\\\"field\\\":\\\"order.order_type\\\",\\\"op\\\":\\\"EQ\\\",\\\"value\\\":\\\"一件代发\\\"}]}\",\"groupKeyConfig\":\"{\\\"separator\\\":\\\"-\\\",\\\"fields\\\":[{\\\"field\\\":\\\"order.order_type\\\"},{\\\"field\\\":\\\"shipment.shipment_no\\\"}]}\",\"priority\":0,\"isDefault\":0,\"status\":\"enabled\",\"version\":0,\"remark\":null}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 16:08:52',59),(2059909790354956289,'000000','货物订单分组规则',2,'org.dromara.oms.controller.CargoGroupingRuleController.edit()','PUT',1,'admin','研发部门','/oms/cargoGroupingRule','0:0:0:0:0:0:0:1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"id\":\"2059818382247936002\",\"warehouseId\":4001001,\"warehouseName\":\"Los Angeles Central Warehouse\",\"ruleName\":\"LA-大货中转\",\"conditionConfig\":\"{\\\"mode\\\":\\\"VALUE_MATCH\\\",\\\"logic\\\":\\\"AND\\\",\\\"conditions\\\":[{\\\"field\\\":\\\"order.order_type\\\",\\\"op\\\":\\\"EQ\\\",\\\"value\\\":\\\"大货中转\\\"}]}\",\"groupKeyConfig\":\"{\\\"separator\\\":\\\"-\\\",\\\"fields\\\":[{\\\"field\\\":\\\"order.order_type\\\"},{\\\"field\\\":\\\"order.order_no\\\"}]}\",\"priority\":0,\"isDefault\":0,\"status\":\"enabled\",\"version\":0,\"remark\":null}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 16:09:00',21),(2059925163406041089,'000000','入库计划-保存分组',2,'org.dromara.oms.controller.InboundPlanController.saveGroupChanges()','POST',1,'admin','研发部门','/wms/inbound-plan/2059848614686326785/save-group','0:0:0:0:0:0:0:1','内网IP','\"2059848614686326785\" [{\"itemId\":\"2059848615726514177\",\"groupCode\":\"Amazon-ONT8\"},{\"itemId\":\"2059848615760068610\",\"groupCode\":\"Amazon-ONT8\"},{\"itemId\":\"2059848615760068611\",\"groupCode\":\"PRIVATE-CO-2026-000002\"}]','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-28 17:10:05',389),(2060117836180058113,'000000','园区任务-签到',2,'org.dromara.yms.controller.YmsDispatchController.checkIn()','POST',1,'admin','研发部门','/yms/dispatch/9200006/check-in','0:0:0:0:0:0:0:1','内网IP','9200006','',1,'当前状态[DOCK_ASSIGNED]不允许签到','2026-05-29 05:55:42',914),(2060128932353896449,'000000','outbound-pool-batch-create-pre-outbound',1,'org.dromara.oms.controller.OutboundPoolController.batchCreatePreOutbound()','POST',1,'admin','研发部门','/oms/outbound-pool/batch-create-pre-outbound','0:0:0:0:0:0:0:1','内网IP','{\"cargoOrderId\":null,\"cargoOrderIds\":[1001],\"outboundDirection\":\"DELIVERY\",\"outboundWarehouseId\":4001001,\"outboundWarehouseName\":\"Los Angeles Central Warehouse\",\"transferInWarehouseId\":null,\"deliveryMethod\":\"卡车派送\",\"appointmentStatus\":\"UNCONFIRMED\",\"appointmentNo\":\"\",\"appointmentTime\":null,\"deliveryTruck\":\"\",\"loadingType\":\"PALLET\",\"transportType\":\"FTL\",\"deliveryTag\":\"\",\"destination\":\"Amazon-ONT8\",\"followRecord\":\"\",\"transferReason\":null,\"transferMethod\":null,\"transferFlag\":0,\"transferWarehouseCode\":null,\"remark\":null}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-05-29 06:39:47',627);
/*!40000 ALTER TABLE `sys_oper_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_oss`
--

DROP TABLE IF EXISTS `sys_oss`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_oss` (
  `oss_id` bigint NOT NULL COMMENT '对象存储主键',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `file_name` varchar(255) NOT NULL DEFAULT '' COMMENT '文件名',
  `original_name` varchar(255) NOT NULL DEFAULT '' COMMENT '原名',
  `file_suffix` varchar(10) NOT NULL DEFAULT '' COMMENT '文件后缀名',
  `url` varchar(500) NOT NULL COMMENT 'URL地址',
  `ext1` text COMMENT '扩展字段',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` bigint DEFAULT NULL COMMENT '上传人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `service` varchar(20) NOT NULL DEFAULT 'minio' COMMENT '服务商',
  PRIMARY KEY (`oss_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='OSS对象存储表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_oss`
--

LOCK TABLES `sys_oss` WRITE;
/*!40000 ALTER TABLE `sys_oss` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_oss` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_oss_config`
--

DROP TABLE IF EXISTS `sys_oss_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_oss_config` (
  `oss_config_id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `config_key` varchar(20) NOT NULL DEFAULT '' COMMENT '配置key',
  `access_key` varchar(255) DEFAULT '' COMMENT 'accessKey',
  `secret_key` varchar(255) DEFAULT '' COMMENT '秘钥',
  `bucket_name` varchar(255) DEFAULT '' COMMENT '桶名称',
  `prefix` varchar(255) DEFAULT '' COMMENT '前缀',
  `endpoint` varchar(255) DEFAULT '' COMMENT '访问站点',
  `domain` varchar(255) DEFAULT '' COMMENT '自定义域名',
  `is_https` char(1) DEFAULT 'N' COMMENT '是否https（Y=是,N=否）',
  `region` varchar(255) DEFAULT '' COMMENT '域',
  `access_policy` char(1) NOT NULL DEFAULT '1' COMMENT '桶权限类型(0=private 1=public 2=custom)',
  `status` char(1) DEFAULT '1' COMMENT '是否默认（0=是,1=否）',
  `ext1` varchar(255) DEFAULT '' COMMENT '扩展字段',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`oss_config_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='对象存储配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_oss_config`
--

LOCK TABLES `sys_oss_config` WRITE;
/*!40000 ALTER TABLE `sys_oss_config` DISABLE KEYS */;
INSERT INTO `sys_oss_config` VALUES (1,'000000','minio','ruoyi','ruoyi123','ruoyi','','127.0.0.1:9000','','N','','1','0','',103,1,'2026-05-21 23:15:05',1,'2026-05-21 23:15:05',NULL),(2,'000000','qiniu','XXXXXXXXXXXXXXX','XXXXXXXXXXXXXXX','ruoyi','','s3-cn-north-1.qiniucs.com','','N','','1','1','',103,1,'2026-05-21 23:15:05',1,'2026-05-21 23:15:05',NULL),(3,'000000','aliyun','XXXXXXXXXXXXXXX','XXXXXXXXXXXXXXX','ruoyi','','oss-cn-beijing.aliyuncs.com','','N','','1','1','',103,1,'2026-05-21 23:15:05',1,'2026-05-21 23:15:05',NULL),(4,'000000','qcloud','XXXXXXXXXXXXXXX','XXXXXXXXXXXXXXX','ruoyi-1240000000','','cos.ap-beijing.myqcloud.com','','N','ap-beijing','1','1','',103,1,'2026-05-21 23:15:05',1,'2026-05-21 23:15:05',NULL),(5,'000000','image','ruoyi','ruoyi123','ruoyi','image','127.0.0.1:9000','','N','','1','1','',103,1,'2026-05-21 23:15:05',1,'2026-05-21 23:15:05',NULL);
/*!40000 ALTER TABLE `sys_oss_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_post`
--

DROP TABLE IF EXISTS `sys_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_post` (
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `dept_id` bigint NOT NULL COMMENT '部门id',
  `post_code` varchar(64) NOT NULL COMMENT '岗位编码',
  `post_category` varchar(100) DEFAULT NULL COMMENT '岗位类别编码',
  `post_name` varchar(50) NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) NOT NULL COMMENT '状态（0正常 1停用）',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='岗位信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_post`
--

LOCK TABLES `sys_post` WRITE;
/*!40000 ALTER TABLE `sys_post` DISABLE KEYS */;
INSERT INTO `sys_post` VALUES (1,'000000',103,'ceo',NULL,'董事长',1,'0',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(2,'000000',100,'se',NULL,'项目经理',2,'0',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(3,'000000',100,'hr',NULL,'人力资源',3,'0',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(4,'000000',100,'user',NULL,'普通员工',4,'0',103,1,'2026-05-21 23:15:03',NULL,NULL,'');
/*!40000 ALTER TABLE `sys_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role`
--

DROP TABLE IF EXISTS `sys_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `role_name` varchar(30) NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限 5：仅本人数据权限 6：部门及以下或本人数据权限）',
  `menu_check_strictly` tinyint(1) DEFAULT '1' COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) DEFAULT '1' COMMENT '部门树选择项是否关联显示',
  `status` char(1) NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role`
--

LOCK TABLES `sys_role` WRITE;
/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;
INSERT INTO `sys_role` VALUES (1,'000000','超级管理员','superadmin',1,'1',1,1,'0','0',103,1,'2026-05-21 23:15:03',NULL,NULL,'超级管理员'),(3,'000000','本部门及以下','test1',3,'4',1,1,'0','0',103,1,'2026-05-21 23:15:03',NULL,NULL,''),(4,'000000','仅本人','test2',4,'5',1,1,'0','0',103,1,'2026-05-21 23:15:03',NULL,NULL,'');
/*!40000 ALTER TABLE `sys_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_company_scope`
--

DROP TABLE IF EXISTS `sys_role_company_scope`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_company_scope` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `company_id` bigint NOT NULL COMMENT '主体ID',
  PRIMARY KEY (`role_id`,`company_id`),
  KEY `idx_role_company_scope_company` (`tenant_id`,`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色主体数据范围';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_company_scope`
--

LOCK TABLES `sys_role_company_scope` WRITE;
/*!40000 ALTER TABLE `sys_role_company_scope` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_role_company_scope` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_dept`
--

DROP TABLE IF EXISTS `sys_role_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_dept` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`,`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色和部门关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_dept`
--

LOCK TABLES `sys_role_dept` WRITE;
/*!40000 ALTER TABLE `sys_role_dept` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_role_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_menu`
--

DROP TABLE IF EXISTS `sys_role_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_menu` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`,`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色和菜单关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_menu`
--

LOCK TABLES `sys_role_menu` WRITE;
/*!40000 ALTER TABLE `sys_role_menu` DISABLE KEYS */;
INSERT INTO `sys_role_menu` VALUES (1,3000),(1,3010),(1,3011),(1,3012),(1,3060),(1,3061),(1,3062),(1,3063),(1,3064),(1,3065),(1,3066),(1,3067),(1,3068),(1,3069),(1,3070),(1,3071),(1,3072),(1,3080),(1,3081),(1,3082),(1,3083),(1,3084),(1,3085),(1,3086),(1,3087),(1,301010),(1,301011),(1,301012),(1,301013),(1,301110),(1,301111),(1,301112),(1,301113),(1,301210),(1,301211),(1,301212),(1,301213),(1,301214),(3,1),(3,5),(3,100),(3,101),(3,102),(3,103),(3,104),(3,105),(3,106),(3,107),(3,108),(3,118),(3,123),(3,130),(3,131),(3,132),(3,133),(3,500),(3,501),(3,1001),(3,1002),(3,1003),(3,1004),(3,1005),(3,1006),(3,1007),(3,1008),(3,1009),(3,1010),(3,1011),(3,1012),(3,1013),(3,1014),(3,1015),(3,1016),(3,1017),(3,1018),(3,1019),(3,1020),(3,1021),(3,1022),(3,1023),(3,1024),(3,1025),(3,1026),(3,1027),(3,1028),(3,1029),(3,1030),(3,1031),(3,1032),(3,1033),(3,1034),(3,1035),(3,1036),(3,1037),(3,1038),(3,1039),(3,1040),(3,1041),(3,1042),(3,1043),(3,1044),(3,1045),(3,1050),(3,1061),(3,1062),(3,1063),(3,1064),(3,1065),(3,1500),(3,1501),(3,1502),(3,1503),(3,1504),(3,1505),(3,1506),(3,1507),(3,1508),(3,1509),(3,1510),(3,1511),(3,1600),(3,1601),(3,1602),(3,1603),(3,1620),(3,1621),(3,1622),(3,1623),(3,3000),(3,3010),(3,3011),(3,3012),(3,11616),(3,11618),(3,11619),(3,11622),(3,11623),(3,11629),(3,11632),(3,11633),(3,11638),(3,11639),(3,11640),(3,11641),(3,11642),(3,11643),(3,11701),(3,301010),(3,301011),(3,301012),(3,301013),(3,301110),(3,301111),(3,301112),(3,301113),(3,301210),(3,301211),(3,301212),(3,301213),(3,301214),(4,5),(4,1500),(4,1501),(4,1502),(4,1503),(4,1504),(4,1505),(4,1506),(4,1507),(4,1508),(4,1509),(4,1510),(4,1511),(4,3000),(4,3010),(4,3011),(4,3012),(4,301010),(4,301011),(4,301012),(4,301013),(4,301110),(4,301111),(4,301112),(4,301113),(4,301210),(4,301211),(4,301212),(4,301213),(4,301214);
/*!40000 ALTER TABLE `sys_role_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_org_scope`
--

DROP TABLE IF EXISTS `sys_role_org_scope`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_org_scope` (
  `role_id` bigint NOT NULL COMMENT 'role id',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT 'tenant id',
  `org_scope` varchar(30) NOT NULL DEFAULT 'ALL' COMMENT 'org scope',
  `remark` varchar(500) DEFAULT NULL COMMENT 'remark',
  `create_dept` bigint DEFAULT NULL COMMENT 'create dept',
  `create_by` bigint DEFAULT NULL COMMENT 'create by',
  `create_time` datetime DEFAULT NULL COMMENT 'create time',
  `update_by` bigint DEFAULT NULL COMMENT 'update by',
  `update_time` datetime DEFAULT NULL COMMENT 'update time',
  PRIMARY KEY (`role_id`),
  KEY `idx_role_org_scope_tenant` (`tenant_id`,`org_scope`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='role org data scope';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_org_scope`
--

LOCK TABLES `sys_role_org_scope` WRITE;
/*!40000 ALTER TABLE `sys_role_org_scope` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_role_org_scope` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_warehouse_scope`
--

DROP TABLE IF EXISTS `sys_role_warehouse_scope`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_warehouse_scope` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `warehouse_id` bigint NOT NULL COMMENT '仓库ID',
  PRIMARY KEY (`role_id`,`warehouse_id`),
  KEY `idx_role_warehouse_scope_warehouse` (`tenant_id`,`warehouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色仓库数据范围';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_warehouse_scope`
--

LOCK TABLES `sys_role_warehouse_scope` WRITE;
/*!40000 ALTER TABLE `sys_role_warehouse_scope` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_role_warehouse_scope` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_social`
--

DROP TABLE IF EXISTS `sys_social`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_social` (
  `id` bigint NOT NULL COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户id',
  `auth_id` varchar(255) NOT NULL COMMENT '平台+平台唯一id',
  `source` varchar(255) NOT NULL COMMENT '用户来源',
  `open_id` varchar(255) DEFAULT NULL COMMENT '平台编号唯一id',
  `user_name` varchar(30) NOT NULL COMMENT '登录账号',
  `nick_name` varchar(30) DEFAULT '' COMMENT '用户昵称',
  `email` varchar(255) DEFAULT '' COMMENT '用户邮箱',
  `avatar` varchar(500) DEFAULT '' COMMENT '头像地址',
  `access_token` varchar(2000) NOT NULL COMMENT '用户的授权令牌',
  `expire_in` int DEFAULT NULL COMMENT '用户的授权令牌的有效期，部分平台可能没有',
  `refresh_token` varchar(255) DEFAULT NULL COMMENT '刷新令牌，部分平台可能没有',
  `access_code` varchar(2000) DEFAULT NULL COMMENT '平台的授权信息，部分平台可能没有',
  `union_id` varchar(255) DEFAULT NULL COMMENT '用户的 unionid',
  `scope` varchar(255) DEFAULT NULL COMMENT '授予的权限，部分平台可能没有',
  `token_type` varchar(255) DEFAULT NULL COMMENT '个别平台的授权信息，部分平台可能没有',
  `id_token` varchar(2000) DEFAULT NULL COMMENT 'id token，部分平台可能没有',
  `mac_algorithm` varchar(255) DEFAULT NULL COMMENT '小米平台用户的附带属性，部分平台可能没有',
  `mac_key` varchar(255) DEFAULT NULL COMMENT '小米平台用户的附带属性，部分平台可能没有',
  `code` varchar(255) DEFAULT NULL COMMENT '用户的授权code，部分平台可能没有',
  `oauth_token` varchar(255) DEFAULT NULL COMMENT 'Twitter平台用户的附带属性，部分平台可能没有',
  `oauth_token_secret` varchar(255) DEFAULT NULL COMMENT 'Twitter平台用户的附带属性，部分平台可能没有',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='社会化关系表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_social`
--

LOCK TABLES `sys_social` WRITE;
/*!40000 ALTER TABLE `sys_social` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_social` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_tenant`
--

DROP TABLE IF EXISTS `sys_tenant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_tenant` (
  `id` bigint NOT NULL COMMENT 'id',
  `tenant_id` varchar(20) NOT NULL COMMENT '租户编号',
  `contact_user_name` varchar(20) DEFAULT NULL COMMENT '联系人',
  `contact_phone` varchar(20) DEFAULT NULL COMMENT '联系电话',
  `company_name` varchar(30) DEFAULT NULL COMMENT '企业名称',
  `license_number` varchar(30) DEFAULT NULL COMMENT '统一社会信用代码',
  `address` varchar(200) DEFAULT NULL COMMENT '地址',
  `intro` varchar(200) DEFAULT NULL COMMENT '企业简介',
  `domain` varchar(200) DEFAULT NULL COMMENT '域名',
  `remark` varchar(200) DEFAULT NULL COMMENT '备注',
  `package_id` bigint DEFAULT NULL COMMENT '租户套餐编号',
  `expire_time` datetime DEFAULT NULL COMMENT '过期时间',
  `account_count` int DEFAULT '-1' COMMENT '用户数量（-1不限制）',
  `status` char(1) DEFAULT '0' COMMENT '租户状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='租户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_tenant`
--

LOCK TABLES `sys_tenant` WRITE;
/*!40000 ALTER TABLE `sys_tenant` DISABLE KEYS */;
INSERT INTO `sys_tenant` VALUES (1,'000000','管理组','15888888888','XXX有限公司',NULL,NULL,'多租户通用后台管理管理系统',NULL,NULL,NULL,NULL,-1,'0','0',103,1,'2026-05-21 23:15:03',NULL,NULL);
/*!40000 ALTER TABLE `sys_tenant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_tenant_package`
--

DROP TABLE IF EXISTS `sys_tenant_package`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_tenant_package` (
  `package_id` bigint NOT NULL COMMENT '租户套餐id',
  `package_name` varchar(20) DEFAULT NULL COMMENT '套餐名称',
  `menu_ids` varchar(3000) DEFAULT NULL COMMENT '关联菜单id',
  `remark` varchar(200) DEFAULT NULL COMMENT '备注',
  `menu_check_strictly` tinyint(1) DEFAULT '1' COMMENT '菜单树选择项是否关联显示',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`package_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='租户套餐表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_tenant_package`
--

LOCK TABLES `sys_tenant_package` WRITE;
/*!40000 ALTER TABLE `sys_tenant_package` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_tenant_package` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `dept_id` bigint DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) NOT NULL COMMENT '用户昵称',
  `user_type` varchar(10) DEFAULT 'sys_user' COMMENT '用户类型（sys_user系统用户）',
  `email` varchar(50) DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) DEFAULT '' COMMENT '手机号码',
  `sex` char(1) DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` bigint DEFAULT NULL COMMENT '头像地址',
  `password` varchar(100) DEFAULT '' COMMENT '密码',
  `status` char(1) DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  `login_ip` varchar(128) DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` VALUES (1,'000000',103,'admin','疯狂的狮子Li','sys_user','crazyLionLi@163.com','15888888888','1',NULL,'$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','0:0:0:0:0:0:0:1','2026-05-30 03:57:28',103,1,'2026-05-21 23:15:03',-1,'2026-05-30 03:57:28','管理员'),(3,'000000',108,'test','本部门及以下 密码666666','sys_user','','','0',NULL,'$2a$10$b8yUzN0C71sbz.PhNOCgJe.Tu1yWC3RNrTyjSQ8p1W0.aaUXUJ.Ne','0','0','127.0.0.1','2026-05-21 23:15:03',103,1,'2026-05-21 23:15:03',3,'2026-05-21 23:15:03',NULL),(4,'000000',102,'test1','仅本人 密码666666','sys_user','','','0',NULL,'$2a$10$b8yUzN0C71sbz.PhNOCgJe.Tu1yWC3RNrTyjSQ8p1W0.aaUXUJ.Ne','0','0','127.0.0.1','2026-05-21 23:15:03',103,1,'2026-05-21 23:15:03',4,'2026-05-21 23:15:03',NULL);
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_post`
--

DROP TABLE IF EXISTS `sys_user_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_post` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`,`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户与岗位关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_post`
--

LOCK TABLES `sys_user_post` WRITE;
/*!40000 ALTER TABLE `sys_user_post` DISABLE KEYS */;
INSERT INTO `sys_user_post` VALUES (1,1);
/*!40000 ALTER TABLE `sys_user_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_role`
--

DROP TABLE IF EXISTS `sys_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_role` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户和角色关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_role`
--

LOCK TABLES `sys_user_role` WRITE;
/*!40000 ALTER TABLE `sys_user_role` DISABLE KEYS */;
INSERT INTO `sys_user_role` VALUES (1,1),(3,3),(4,4);
/*!40000 ALTER TABLE `sys_user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `test_demo`
--

DROP TABLE IF EXISTS `test_demo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_demo` (
  `id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `dept_id` bigint DEFAULT NULL COMMENT '部门id',
  `user_id` bigint DEFAULT NULL COMMENT '用户id',
  `order_num` int DEFAULT '0' COMMENT '排序号',
  `test_key` varchar(255) DEFAULT NULL COMMENT 'key键',
  `value` varchar(255) DEFAULT NULL COMMENT '值',
  `version` int DEFAULT '0' COMMENT '版本',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `del_flag` int DEFAULT '0' COMMENT '删除标志',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='测试单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `test_demo`
--

LOCK TABLES `test_demo` WRITE;
/*!40000 ALTER TABLE `test_demo` DISABLE KEYS */;
INSERT INTO `test_demo` VALUES (1,'000000',102,4,1,'测试数据权限','测试',0,103,'2026-05-21 23:15:05',1,NULL,NULL,0),(2,'000000',102,3,2,'子节点1','111',0,103,'2026-05-21 23:15:05',1,NULL,NULL,0),(3,'000000',102,3,3,'子节点2','222',0,103,'2026-05-21 23:15:05',1,NULL,NULL,0),(4,'000000',108,4,4,'测试数据','demo',0,103,'2026-05-21 23:15:05',1,NULL,NULL,0),(5,'000000',108,3,13,'子节点11','1111',0,103,'2026-05-21 23:15:05',1,NULL,NULL,0),(6,'000000',108,3,12,'子节点22','2222',0,103,'2026-05-21 23:15:05',1,NULL,NULL,0),(7,'000000',108,3,11,'子节点33','3333',0,103,'2026-05-21 23:15:05',1,NULL,NULL,0),(8,'000000',108,3,10,'子节点44','4444',0,103,'2026-05-21 23:15:05',1,NULL,NULL,0),(9,'000000',108,3,9,'子节点55','5555',0,103,'2026-05-21 23:15:05',1,NULL,NULL,0),(10,'000000',108,3,8,'子节点66','6666',0,103,'2026-05-21 23:15:05',1,NULL,NULL,0),(11,'000000',108,3,7,'子节点77','7777',0,103,'2026-05-21 23:15:05',1,NULL,NULL,0),(12,'000000',108,3,6,'子节点88','8888',0,103,'2026-05-21 23:15:05',1,NULL,NULL,0),(13,'000000',108,3,5,'子节点99','9999',0,103,'2026-05-21 23:15:05',1,NULL,NULL,0);
/*!40000 ALTER TABLE `test_demo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `test_leave`
--

DROP TABLE IF EXISTS `test_leave`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_leave` (
  `id` bigint NOT NULL COMMENT 'id',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `apply_code` varchar(50) NOT NULL COMMENT '申请编号',
  `leave_type` varchar(255) NOT NULL COMMENT '请假类型',
  `start_date` datetime NOT NULL COMMENT '开始时间',
  `end_date` datetime NOT NULL COMMENT '结束时间',
  `leave_days` int NOT NULL COMMENT '请假天数',
  `remark` varchar(255) DEFAULT NULL COMMENT '请假原因',
  `status` varchar(255) DEFAULT NULL COMMENT '状态',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='请假申请表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `test_leave`
--

LOCK TABLES `test_leave` WRITE;
/*!40000 ALTER TABLE `test_leave` DISABLE KEYS */;
/*!40000 ALTER TABLE `test_leave` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `test_tree`
--

DROP TABLE IF EXISTS `test_tree`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_tree` (
  `id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `parent_id` bigint DEFAULT '0' COMMENT '父id',
  `dept_id` bigint DEFAULT NULL COMMENT '部门id',
  `user_id` bigint DEFAULT NULL COMMENT '用户id',
  `tree_name` varchar(255) DEFAULT NULL COMMENT '值',
  `version` int DEFAULT '0' COMMENT '版本',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `del_flag` int DEFAULT '0' COMMENT '删除标志',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='测试树表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `test_tree`
--

LOCK TABLES `test_tree` WRITE;
/*!40000 ALTER TABLE `test_tree` DISABLE KEYS */;
INSERT INTO `test_tree` VALUES (1,'000000',0,102,4,'测试数据权限',0,103,'2026-05-21 23:15:05',1,NULL,NULL,0),(2,'000000',1,102,3,'子节点1',0,103,'2026-05-21 23:15:05',1,NULL,NULL,0),(3,'000000',2,102,3,'子节点2',0,103,'2026-05-21 23:15:05',1,NULL,NULL,0),(4,'000000',0,108,4,'测试树1',0,103,'2026-05-21 23:15:05',1,NULL,NULL,0),(5,'000000',4,108,3,'子节点11',0,103,'2026-05-21 23:15:05',1,NULL,NULL,0),(6,'000000',4,108,3,'子节点22',0,103,'2026-05-21 23:15:05',1,NULL,NULL,0),(7,'000000',4,108,3,'子节点33',0,103,'2026-05-21 23:15:05',1,NULL,NULL,0),(8,'000000',5,108,3,'子节点44',0,103,'2026-05-21 23:15:05',1,NULL,NULL,0),(9,'000000',6,108,3,'子节点55',0,103,'2026-05-21 23:15:05',1,NULL,NULL,0),(10,'000000',7,108,3,'子节点66',0,103,'2026-05-21 23:15:05',1,NULL,NULL,0),(11,'000000',7,108,3,'子节点77',0,103,'2026-05-21 23:15:05',1,NULL,NULL,0),(12,'000000',10,108,3,'子节点88',0,103,'2026-05-21 23:15:05',1,NULL,NULL,0),(13,'000000',10,108,3,'子节点99',0,103,'2026-05-21 23:15:05',1,NULL,NULL,0);
/*!40000 ALTER TABLE `test_tree` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `timezone`
--

DROP TABLE IF EXISTS `timezone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `timezone` (
  `id` bigint NOT NULL COMMENT '主键（雪花ID）',
  `tenant_id` varchar(20) NOT NULL COMMENT '租户ID',
  `tz_code` varchar(100) NOT NULL COMMENT '时区代码（如America/Los_Angeles）',
  `name_en` varchar(100) NOT NULL COMMENT '英文名称（如Pacific Time）',
  `utc_offset` varchar(20) NOT NULL COMMENT 'UTC偏移（如UTC-8）',
  `country_code` varchar(10) DEFAULT NULL COMMENT '所属国家代码（NULL=全球，如UTC）',
  `is_dst` tinyint NOT NULL DEFAULT '0' COMMENT '是否有夏令时（1=有，0=无）',
  `status` char(1) NOT NULL DEFAULT '0' COMMENT '状态（0=正常，1=停用）',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序',
  `create_by` bigint DEFAULT NULL COMMENT '???',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '???',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` bigint DEFAULT '0' COMMENT '逻辑删除（0=存在，1=删除）',
  `create_dept` bigint DEFAULT NULL COMMENT '????',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_tz_code` (`tenant_id`,`tz_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='时区管理（GEO-001）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `timezone`
--

LOCK TABLES `timezone` WRITE;
/*!40000 ALTER TABLE `timezone` DISABLE KEYS */;
INSERT INTO `timezone` VALUES (3003001,'000000','UTC','Coordinated Universal Time','UTC+0',NULL,0,'0',1,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3003002,'000000','America/Los_Angeles','Pacific Time','UTC-8','US',1,'0',2,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3003003,'000000','America/Denver','Mountain Time','UTC-7','US',1,'0',3,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3003004,'000000','America/Chicago','Central Time','UTC-6','US',1,'0',4,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3003005,'000000','America/New_York','Eastern Time','UTC-5','US',1,'0',5,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3003006,'000000','America/Toronto','Eastern Time (Canada)','UTC-5','CA',1,'0',6,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3003007,'000000','America/Mexico_City','Central Time (Mexico)','UTC-6','MX',1,'0',7,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3003008,'000000','Europe/London','Greenwich Mean Time','UTC+0','GB',1,'0',8,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3003009,'000000','Europe/Berlin','Central European Time','UTC+1','DE',1,'0',9,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3003010,'000000','Europe/Amsterdam','Central European Time','UTC+1','NL',1,'0',10,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3003011,'000000','Europe/Paris','Central European Time','UTC+1','FR',1,'0',11,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3003012,'000000','Asia/Shanghai','China Standard Time','UTC+8','CN',0,'0',12,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3003013,'000000','Asia/Tokyo','Japan Standard Time','UTC+9','JP',0,'0',13,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3003014,'000000','Australia/Sydney','Australian Eastern Time','UTC+10','AU',1,'0',14,1,'2026-05-22 00:41:18',NULL,NULL,0,NULL);
/*!40000 ALTER TABLE `timezone` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_inbound_plan`
--

DROP TABLE IF EXISTS `wms_inbound_plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_inbound_plan` (
  `id` bigint NOT NULL COMMENT '主键ID（雪花）',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `warehouse_id` bigint NOT NULL COMMENT '仓库ID',
  `container_order_id` bigint NOT NULL COMMENT '海柜订单ID',
  `container_order_no` varchar(64) DEFAULT NULL COMMENT '海柜订单编号（冗余展示）',
  `plan_no` varchar(64) NOT NULL COMMENT '入库计划编号（系统生成）',
  `status` varchar(20) NOT NULL DEFAULT 'draft' COMMENT '状态：draft/in_progress/completed/cancelled',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_plan_no_tenant` (`plan_no`,`tenant_id`),
  UNIQUE KEY `uk_container_order` (`container_order_id`,`tenant_id`,`deleted`),
  KEY `idx_tenant_warehouse` (`tenant_id`,`warehouse_id`),
  KEY `idx_status` (`status`),
  KEY `idx_container_order_id` (`container_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='入库计划主表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_inbound_plan`
--

LOCK TABLES `wms_inbound_plan` WRITE;
/*!40000 ALTER TABLE `wms_inbound_plan` DISABLE KEYS */;
INSERT INTO `wms_inbound_plan` VALUES (2059846458965053442,'000000',4001002,9100003,'SO202605220003','IP-20260527-973442048','draft',NULL,103,1,'2026-05-28 11:57:21',1,'2026-05-28 11:57:21',0),(2059848614686326785,'000000',4001001,9100001,'SO202605220001','IP-20260527-556303360','draft',NULL,103,1,'2026-05-28 12:05:55',1,'2026-05-28 12:05:55',0);
/*!40000 ALTER TABLE `wms_inbound_plan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_inbound_plan_change_log`
--

DROP TABLE IF EXISTS `wms_inbound_plan_change_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_inbound_plan_change_log` (
  `id` bigint NOT NULL COMMENT '主键ID（雪花）',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `plan_id` bigint NOT NULL COMMENT '入库计划ID',
  `plan_item_id` bigint NOT NULL COMMENT '计划明细ID',
  `shipment_id` bigint NOT NULL COMMENT '货件ID',
  `old_group_code` varchar(100) DEFAULT NULL COMMENT '变更前分组',
  `new_group_code` varchar(100) DEFAULT NULL COMMENT '变更后分组',
  `change_type` varchar(30) NOT NULL COMMENT '变更类型：auto_group/quick_config/manual',
  `change_by` bigint DEFAULT NULL COMMENT '操作人',
  `change_time` datetime DEFAULT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`),
  KEY `idx_plan_id` (`plan_id`),
  KEY `idx_plan_item_id` (`plan_item_id`),
  KEY `idx_shipment_id` (`shipment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='入库计划分组变更日志';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_inbound_plan_change_log`
--

LOCK TABLES `wms_inbound_plan_change_log` WRITE;
/*!40000 ALTER TABLE `wms_inbound_plan_change_log` DISABLE KEYS */;
INSERT INTO `wms_inbound_plan_change_log` VALUES (2059852839906480130,'000000',2059848614686326785,2059848615726514177,10011,NULL,'FBA头程-ONT8','auto_group',1,'2026-05-28 12:22:42'),(2059852840233635841,'000000',2059848614686326785,2059848615760068610,10012,NULL,'FBA头程-ONT8','auto_group',1,'2026-05-28 12:22:42'),(2059852840422379521,'000000',2059848614686326785,2059848615760068611,10021,NULL,'私仓派送-UNKNOWN','auto_group',1,'2026-05-28 12:22:42'),(2059853807515635713,'000000',2059848614686326785,2059848615726514177,10011,'FBA头程-ONT8','卡车派送-ONT8','auto_group',1,'2026-05-28 12:26:33'),(2059853807582744578,'000000',2059848614686326785,2059848615760068610,10012,'FBA头程-ONT8','卡车派送-ONT8','auto_group',1,'2026-05-28 12:26:33'),(2059853807725350913,'000000',2059848614686326785,2059848615760068611,10021,'私仓派送-UNKNOWN','卡车派送-UNKNOWN','auto_group',1,'2026-05-28 12:26:33'),(2059855176813314050,'000000',2059848614686326785,2059848615726514177,10011,'卡车派送-ONT8','20-ONT8','auto_group',1,'2026-05-28 12:31:59'),(2059855177090138113,'000000',2059848614686326785,2059848615760068610,10012,'卡车派送-ONT8','20-ONT8','auto_group',1,'2026-05-28 12:31:59'),(2059855177299853314,'000000',2059848614686326785,2059848615760068611,10021,'卡车派送-UNKNOWN','PRIVATE-CO-2026-000002','auto_group',1,'2026-05-28 12:31:59'),(2059856506055360513,'000000',2059848614686326785,2059848615726514177,10011,'20-ONT8','2000001-ONT8','auto_group',1,'2026-05-28 12:37:16'),(2059856506252492801,'000000',2059848614686326785,2059848615760068610,10012,'20-ONT8','2000001-ONT8','auto_group',1,'2026-05-28 12:37:16'),(2059856506470596610,'000000',2059848614686326785,2059848615760068611,10021,'PRIVATE-CO-2026-000002','PRIVATE-CO-2026-000002','auto_group',1,'2026-05-28 12:37:16'),(2059863462786678785,'000000',2059848614686326785,2059848615726514177,10011,'2000001-ONT8','Amazon-ONT8','auto_group',1,'2026-05-28 13:04:55'),(2059863462983811074,'000000',2059848614686326785,2059848615760068610,10012,'2000001-ONT8','Amazon-ONT8','auto_group',1,'2026-05-28 13:04:55'),(2059863463122223105,'000000',2059848614686326785,2059848615760068611,10021,'PRIVATE-CO-2026-000002','PRIVATE-CO-2026-000002','auto_group',1,'2026-05-28 13:04:55'),(2059925162646872066,'000000',2059848614686326785,2059848615726514177,10011,'Amazon-ONT8','Amazon-ONT8','auto_group',1,'2026-05-28 17:10:05'),(2059925162839810049,'000000',2059848614686326785,2059848615760068610,10012,'Amazon-ONT8','Amazon-ONT8','auto_group',1,'2026-05-28 17:10:05'),(2059925162982416385,'000000',2059848614686326785,2059848615760068611,10021,'PRIVATE-CO-2026-000002','PRIVATE-CO-2026-000002','auto_group',1,'2026-05-28 17:10:05');
/*!40000 ALTER TABLE `wms_inbound_plan_change_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wms_inbound_plan_item`
--

DROP TABLE IF EXISTS `wms_inbound_plan_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wms_inbound_plan_item` (
  `id` bigint NOT NULL COMMENT '主键ID（雪花）',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `plan_id` bigint NOT NULL COMMENT '入库计划ID',
  `cargo_order_id` bigint NOT NULL COMMENT '货物订单ID',
  `shipment_id` bigint NOT NULL COMMENT '货件ID',
  `group_code` varchar(100) DEFAULT NULL COMMENT '分组',
  `pre_location` varchar(100) DEFAULT NULL COMMENT '系统预库位',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_plan_shipment` (`plan_id`,`shipment_id`,`deleted`),
  KEY `idx_plan_id` (`plan_id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`),
  KEY `idx_shipment_id` (`shipment_id`),
  KEY `idx_group_code` (`group_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='入库计划明细（货件维度）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wms_inbound_plan_item`
--

LOCK TABLES `wms_inbound_plan_item` WRITE;
/*!40000 ALTER TABLE `wms_inbound_plan_item` DISABLE KEYS */;
INSERT INTO `wms_inbound_plan_item` VALUES (2059846459220905986,'000000',103,2059846458965053442,1004,10041,NULL,NULL,1,'2026-05-28 11:57:21',1,'2026-05-28 11:57:21',0),(2059848615726514177,'000000',103,2059848614686326785,1001,10011,'Amazon-ONT8',NULL,1,'2026-05-28 12:05:55',1,'2026-05-28 17:10:05',0),(2059848615760068610,'000000',103,2059848614686326785,1001,10012,'Amazon-ONT8',NULL,1,'2026-05-28 12:05:55',1,'2026-05-28 17:10:05',0),(2059848615760068611,'000000',103,2059848614686326785,1002,10021,'PRIVATE-CO-2026-000002',NULL,1,'2026-05-28 12:05:55',1,'2026-05-28 17:10:05',0);
/*!40000 ALTER TABLE `wms_inbound_plan_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yard_dock`
--

DROP TABLE IF EXISTS `yard_dock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `yard_dock` (
  `id` bigint NOT NULL COMMENT '??????ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '??????ID',
  `dock_code` varchar(64) NOT NULL COMMENT '????????????',
  `dock_name` varchar(128) NOT NULL COMMENT '????????????',
  `location_type` varchar(32) NOT NULL DEFAULT 'DOCK' COMMENT '位置类型：DOCK道口/PARKING停车位',
  `warehouse_id` bigint NOT NULL COMMENT '????????????ID',
  `warehouse_code` varchar(64) DEFAULT NULL COMMENT '????????????',
  `warehouse_name` varchar(128) DEFAULT NULL COMMENT '????????????',
  `zone_id` bigint DEFAULT NULL COMMENT '堆场分区ID（yard_zone.id）',
  `zone_code` varchar(30) DEFAULT NULL COMMENT '堆场分区编码（冗余）',
  `business_type_id` bigint DEFAULT NULL COMMENT '适合业务类型ID',
  `business_type_code` varchar(64) DEFAULT NULL COMMENT '适合业务类型编码',
  `business_type_name` varchar(128) DEFAULT NULL COMMENT '适合业务类型名称',
  `dock_location` varchar(64) DEFAULT NULL COMMENT '????????????',
  `grid_row` int DEFAULT NULL COMMENT '行',
  `grid_col` int DEFAULT NULL COMMENT '列',
  `allowed_vehicle_types` varchar(255) DEFAULT NULL COMMENT '????????????',
  `appointment_supported` tinyint NOT NULL DEFAULT '1' COMMENT '??????????????????',
  `max_concurrent` int NOT NULL DEFAULT '1' COMMENT '????????????',
  `dock_status` varchar(32) NOT NULL DEFAULT 'IDLE' COMMENT 'IDLE/OCCUPIED/MAINTENANCE/DISABLED',
  `occupied_object_type` varchar(20) DEFAULT NULL COMMENT '占用对象类型 CONTAINER/TRAILER/...',
  `occupied_object_id` bigint DEFAULT NULL COMMENT '占用对象ID',
  `occupied_object_no` varchar(64) DEFAULT NULL COMMENT '占用对象编号快照',
  `occupied_since` datetime DEFAULT NULL COMMENT '占用开始时间',
  `legacy_yard_position_id` bigint DEFAULT NULL COMMENT '迁移映射：原 yms_yard_position.id',
  `enabled_flag` tinyint NOT NULL DEFAULT '1' COMMENT '????????????',
  `sort_order` int DEFAULT '0' COMMENT '??????',
  `dispatch_priority` int NOT NULL DEFAULT '1' COMMENT '调度优先级',
  `dock_type` varchar(30) DEFAULT NULL COMMENT 'Dock类型：DEVANNING卸柜/LOADING装车/MIXED混用',
  `enable_queue` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否允许排队(0否1是)',
  `max_queue_count` int DEFAULT NULL COMMENT '最大排队数量',
  `remark` varchar(500) DEFAULT NULL COMMENT '??????',
  `create_dept` bigint DEFAULT NULL COMMENT '????????????',
  `create_by` bigint DEFAULT NULL COMMENT '?????????',
  `create_time` datetime DEFAULT NULL COMMENT '????????????',
  `update_by` bigint DEFAULT NULL COMMENT '?????????',
  `update_time` datetime DEFAULT NULL COMMENT '????????????',
  `del_flag` bigint NOT NULL DEFAULT '0' COMMENT '????????????',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_dock_code_tenant` (`dock_code`,`tenant_id`),
  KEY `idx_dock_warehouse` (`tenant_id`,`warehouse_id`),
  KEY `idx_dock_status` (`dock_status`,`enabled_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='????????????';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yard_dock`
--

LOCK TABLES `yard_dock` WRITE;
/*!40000 ALTER TABLE `yard_dock` DISABLE KEYS */;
INSERT INTO `yard_dock` VALUES (3010001,'000000','DOC-LA-001','LA Dock 1','DOCK',4001001,'LA01','Los Angeles Central Warehouse',NULL,NULL,NULL,NULL,NULL,'A区',NULL,NULL,'53FT,40HQ',1,1,'IDLE',NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,0,NULL,'Standard dock',NULL,1,'2026-05-24 00:07:56',1,'2026-05-24 00:07:56',0),(3010002,'000000','DOC-LA-002','LA Dock 2','DOCK',4001001,'LA01','Los Angeles Central Warehouse',NULL,NULL,NULL,NULL,NULL,'A区',NULL,NULL,'53FT,40HQ',1,1,'OCCUPIED',NULL,NULL,NULL,NULL,NULL,1,2,1,NULL,0,NULL,'Hydraulic plate',NULL,1,'2026-05-24 00:07:56',1,'2026-05-24 00:07:56',0),(3010003,'000000','DOC-NJ-001','NJ Dock 1','DOCK',4001002,'NJ01','New Jersey East Coast Warehouse',NULL,NULL,NULL,NULL,NULL,'B-01',NULL,NULL,'53FT,40HQ',1,1,'MAINTENANCE',NULL,NULL,NULL,NULL,NULL,1,3,1,NULL,0,NULL,'Under maintenance',NULL,1,'2026-05-24 00:07:56',1,'2026-05-24 00:07:56',0),(3010004,'000000','DOC-LA-A03','LA A区3号','DOCK',4001001,'LA01','Los Angeles Central Warehouse',NULL,NULL,NULL,NULL,NULL,'A区',1,3,'53FT,40HQ',1,1,'IDLE',NULL,NULL,NULL,NULL,NULL,1,3,1,'DEVANNING',1,3,'A区卸柜道口，支持排队',NULL,1,'2026-05-28 12:27:31',1,'2026-05-28 12:27:31',0),(3010005,'000000','DOC-LA-B01','LA B区1号','DOCK',4001001,'LA01','Los Angeles Central Warehouse',NULL,NULL,NULL,NULL,NULL,'B区',2,1,'53FT,40HQ,20GP',1,1,'IDLE',NULL,NULL,NULL,NULL,NULL,1,4,1,'LOADING',0,NULL,'B区装车道口',NULL,1,'2026-05-28 12:27:31',1,'2026-05-28 12:27:31',0),(3010006,'000000','DOC-LA-B02','LA B区2号','DOCK',4001001,'LA01','Los Angeles Central Warehouse',NULL,NULL,NULL,NULL,NULL,'B区',2,2,'53FT,40HQ',1,1,'IDLE',NULL,NULL,NULL,NULL,NULL,1,5,1,'LOADING',1,2,'B区装车，启用排队',NULL,1,'2026-05-28 12:27:31',1,'2026-05-28 12:27:31',0),(3010007,'000000','DOC-LA-B03','LA B区3号','DOCK',4001001,'LA01','Los Angeles Central Warehouse',NULL,NULL,NULL,NULL,NULL,'B区',2,3,'53FT',1,1,'MAINTENANCE',NULL,NULL,NULL,NULL,NULL,1,6,2,'LOADING',0,NULL,'B区3号维护中',NULL,1,'2026-05-28 12:27:31',1,'2026-05-28 12:27:31',0),(3010008,'000000','DOC-LA-C01','LA C区1号','DOCK',4001001,'LA01','Los Angeles Central Warehouse',NULL,NULL,NULL,NULL,NULL,'C区',3,1,'53FT,40HQ',1,1,'IDLE',NULL,NULL,NULL,NULL,NULL,1,7,3,NULL,1,2,'C区混合道口，启用排队',NULL,1,'2026-05-28 12:27:31',1,'2026-05-28 12:27:31',0),(3010009,'000000','DOC-LA-C02','LA C区2号','DOCK',4001001,'LA01','Los Angeles Central Warehouse',NULL,NULL,NULL,NULL,NULL,'C区',3,2,'40HQ,20GP',1,1,'IDLE',NULL,NULL,NULL,NULL,NULL,1,8,3,NULL,0,NULL,'C区混合道口',NULL,1,'2026-05-28 12:27:31',1,'2026-05-28 12:27:31',0);
/*!40000 ALTER TABLE `yard_dock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yard_zone`
--

DROP TABLE IF EXISTS `yard_zone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `yard_zone` (
  `id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `warehouse_id` bigint NOT NULL COMMENT '仓库ID',
  `zone_code` varchar(30) NOT NULL COMMENT '分区编码',
  `zone_name` varchar(100) NOT NULL COMMENT '分区名称',
  `zone_type` varchar(30) NOT NULL DEFAULT 'CONTAINER' COMMENT 'CONTAINER/TRUCK/SELF_PICKUP/PARKING',
  `sort_order` int DEFAULT NULL COMMENT '排序',
  `remark` varchar(500) DEFAULT NULL,
  `create_dept` bigint DEFAULT NULL,
  `create_by` bigint DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_by` bigint DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_yard_zone_code_tenant` (`zone_code`,`tenant_id`,`deleted`),
  KEY `idx_yard_zone_warehouse` (`warehouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='堆场分区（BASE主数据）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yard_zone`
--

LOCK TABLES `yard_zone` WRITE;
/*!40000 ALTER TABLE `yard_zone` DISABLE KEYS */;
/*!40000 ALTER TABLE `yard_zone` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yms_appointment`
--

DROP TABLE IF EXISTS `yms_appointment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `yms_appointment` (
  `id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `apt_no` varchar(64) NOT NULL COMMENT '预约编号（APT+日期+序号）',
  `warehouse_id` bigint NOT NULL COMMENT '仓库ID',
  `slot_template_id` bigint DEFAULT NULL COMMENT '时段模板ID',
  `appointment_rule_id` bigint DEFAULT NULL COMMENT '预约规则ID',
  `apt_date` date NOT NULL COMMENT '预约日期（yyyy-MM-dd）',
  `apt_slot` varchar(20) NOT NULL COMMENT '时段（HH:mm-HH:mm）',
  `slot_start_time` time DEFAULT NULL COMMENT '预约时段开始时间',
  `slot_end_time` time DEFAULT NULL COMMENT '预约时段结束时间',
  `task_type` varchar(30) NOT NULL COMMENT '任务类型：DEVANNING/LOADING',
  `business_type` varchar(30) DEFAULT NULL COMMENT '业务类型',
  `vehicle_source` varchar(30) DEFAULT NULL COMMENT '车辆来源',
  `plate_no` varchar(30) NOT NULL COMMENT '车牌号',
  `driver_name` varchar(50) DEFAULT NULL COMMENT '司机姓名',
  `driver_phone` varchar(30) DEFAULT NULL COMMENT '司机电话',
  `container_no` varchar(64) DEFAULT NULL COMMENT '柜号（可选）',
  `trailer_no` varchar(64) DEFAULT NULL COMMENT '车厢号',
  `source_order_no` varchar(64) DEFAULT NULL COMMENT '关联订单号（可选）',
  `status` varchar(20) NOT NULL DEFAULT 'PENDING' COMMENT '状态：PENDING/CONFIRMED/CANCELLED/COMPLETED/NO_SHOW',
  `yard_task_id` bigint DEFAULT NULL COMMENT '关联园区任务ID（签到后关联）',
  `cancel_reason` varchar(500) DEFAULT NULL COMMENT '取消原因',
  `remark` varchar(500) DEFAULT NULL,
  `create_dept` bigint DEFAULT NULL,
  `create_by` bigint DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_by` bigint DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_apt_no_tenant` (`apt_no`,`tenant_id`),
  KEY `idx_warehouse_date_slot` (`warehouse_id`,`apt_date`,`apt_slot`),
  KEY `idx_plate_no_status` (`plate_no`,`status`),
  KEY `idx_status` (`status`),
  KEY `idx_apt_date` (`apt_date`),
  KEY `idx_yard_task_id` (`yard_task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='YMS预约表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yms_appointment`
--

LOCK TABLES `yms_appointment` WRITE;
/*!40000 ALTER TABLE `yms_appointment` DISABLE KEYS */;
/*!40000 ALTER TABLE `yms_appointment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yms_appointment_rule`
--

DROP TABLE IF EXISTS `yms_appointment_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `yms_appointment_rule` (
  `id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `rule_name` varchar(100) NOT NULL COMMENT '规则名称',
  `warehouse_id` bigint NOT NULL COMMENT '仓库/园区ID',
  `business_type` varchar(30) DEFAULT NULL COMMENT '业务类型：DEVANNING/DELIVERY_LOADING/TRANSFER_LOADING/PICKUP_LOADING/RETURN_LOADING（NULL=ALL）',
  `vehicle_source` varchar(30) DEFAULT NULL COMMENT '车辆来源（NULL=ALL）',
  `dock_type` varchar(30) DEFAULT NULL COMMENT 'Dock类型（NULL=ALL）',
  `customer_level` varchar(30) DEFAULT NULL COMMENT '客户等级（NULL=ALL）',
  `advance_days_min` int NOT NULL DEFAULT '1' COMMENT '最少提前预约天数',
  `advance_days_max` int NOT NULL DEFAULT '7' COMMENT '最多提前预约天数',
  `cancel_deadline_minutes` int NOT NULL DEFAULT '60' COMMENT '最晚取消时间（预约时段前N分钟）',
  `late_grace_minutes` int NOT NULL DEFAULT '30' COMMENT '迟到宽限时间（分钟）',
  `no_show_minutes` int NOT NULL DEFAULT '60' COMMENT '爽约判定时间（超过预约时段N分钟未签到）',
  `auto_confirm` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否自动确认（0否1是）',
  `holiday_flag` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否适用节假日（0否1是）',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `sort_order` int DEFAULT '0' COMMENT '规则优先级（值越小越先匹配）',
  `remark` varchar(500) DEFAULT NULL,
  `create_dept` bigint DEFAULT NULL,
  `create_by` bigint DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_by` bigint DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_warehouse_enabled` (`warehouse_id`,`enabled`),
  KEY `idx_business_type` (`business_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='YMS预约规则配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yms_appointment_rule`
--

LOCK TABLES `yms_appointment_rule` WRITE;
/*!40000 ALTER TABLE `yms_appointment_rule` DISABLE KEYS */;
/*!40000 ALTER TABLE `yms_appointment_rule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yms_appointment_rule_slot`
--

DROP TABLE IF EXISTS `yms_appointment_rule_slot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `yms_appointment_rule_slot` (
  `id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `rule_id` bigint NOT NULL COMMENT '预约规则ID',
  `weekday` tinyint NOT NULL COMMENT '星期（1=周一...7=周日）',
  `start_time` varchar(10) NOT NULL COMMENT '时段开始时间（HH:mm）',
  `end_time` varchar(10) NOT NULL COMMENT '时段结束时间（HH:mm）',
  `slot_minutes` int NOT NULL DEFAULT '60' COMMENT '时段粒度（分钟）',
  `capacity` int NOT NULL DEFAULT '4' COMMENT '每时段容量',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  PRIMARY KEY (`id`),
  KEY `idx_rule_weekday` (`rule_id`,`weekday`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='YMS预约时段配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yms_appointment_rule_slot`
--

LOCK TABLES `yms_appointment_rule_slot` WRITE;
/*!40000 ALTER TABLE `yms_appointment_rule_slot` DISABLE KEYS */;
/*!40000 ALTER TABLE `yms_appointment_rule_slot` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yms_blacklist`
--

DROP TABLE IF EXISTS `yms_blacklist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `yms_blacklist` (
  `id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `target_type` varchar(20) NOT NULL COMMENT '对象类型：DRIVER/VEHICLE',
  `target_id` bigint DEFAULT NULL COMMENT '对象ID（yms_driver.id 或 yms_vehicle.id）',
  `target_name` varchar(100) NOT NULL COMMENT '对象名称/车牌（快照）',
  `target_identity` varchar(100) DEFAULT NULL COMMENT '唯一标识（身份证号/车牌号）',
  `reason` varchar(500) NOT NULL COMMENT '加入黑名单原因',
  `blacklist_time` datetime DEFAULT NULL COMMENT '加入黑名单时间',
  `expire_time` datetime DEFAULT NULL COMMENT '过期时间（NULL=永久）',
  `status` varchar(20) NOT NULL DEFAULT 'ACTIVE' COMMENT '状态：ACTIVE有效/EXPIRED已过期/REMOVED已移出',
  `remark` varchar(500) DEFAULT NULL,
  `create_dept` bigint DEFAULT NULL,
  `create_by` bigint DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_by` bigint DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_target_identity` (`target_identity`),
  KEY `idx_target_type_status` (`target_type`,`status`),
  KEY `idx_status` (`status`),
  KEY `idx_expire_time` (`expire_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='YMS黑名单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yms_blacklist`
--

LOCK TABLES `yms_blacklist` WRITE;
/*!40000 ALTER TABLE `yms_blacklist` DISABLE KEYS */;
/*!40000 ALTER TABLE `yms_blacklist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yms_call_record`
--

DROP TABLE IF EXISTS `yms_call_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `yms_call_record` (
  `id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `warehouse_id` bigint NOT NULL COMMENT '仓库/园区ID',
  `yard_task_id` bigint NOT NULL COMMENT '园区任务ID',
  `yard_task_no` varchar(64) DEFAULT NULL COMMENT '园区任务号（快照）',
  `call_rule_id` bigint DEFAULT NULL COMMENT '叫号规则ID',
  `call_no` int NOT NULL DEFAULT '1' COMMENT '第几次叫号',
  `call_status` varchar(20) NOT NULL DEFAULT 'CALLED' COMMENT '叫号状态：CALLED已叫号/RESPONDED已响应/TIMEOUT超时/CANCELLED已取消',
  `call_type` varchar(20) NOT NULL DEFAULT 'AUTO' COMMENT '叫号方式：AUTO自动/MANUAL人工',
  `caller_id` bigint DEFAULT NULL COMMENT '叫号操作员ID（人工叫号时）',
  `caller_name` varchar(50) DEFAULT NULL COMMENT '叫号操作员姓名',
  `dock_id` bigint DEFAULT NULL COMMENT '分配 Dock ID',
  `dock_code` varchar(30) DEFAULT NULL COMMENT '分配 Dock 编号（快照）',
  `call_time` datetime NOT NULL COMMENT '叫号时间',
  `respond_time` datetime DEFAULT NULL COMMENT '响应时间',
  `timeout_time` datetime DEFAULT NULL COMMENT '超时时间',
  `cancel_time` datetime DEFAULT NULL COMMENT '取消时间',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_yard_task_id` (`yard_task_id`),
  KEY `idx_warehouse_status` (`warehouse_id`,`call_status`),
  KEY `idx_call_time` (`call_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='YMS叫号记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yms_call_record`
--

LOCK TABLES `yms_call_record` WRITE;
/*!40000 ALTER TABLE `yms_call_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `yms_call_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yms_call_rule`
--

DROP TABLE IF EXISTS `yms_call_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `yms_call_rule` (
  `id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `rule_name` varchar(100) NOT NULL COMMENT '规则名称',
  `warehouse_id` bigint NOT NULL COMMENT '仓库/园区ID',
  `task_type` varchar(30) NOT NULL COMMENT '适用任务类型：DEVANNING/DELIVERY_LOADING/TRANSFER_LOADING/PICKUP_LOADING/RETURN_LOADING',
  `dock_type` varchar(30) DEFAULT NULL COMMENT '适用Dock类型（NULL=ALL）',
  `wms_ready_required` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否要求WMS备货完成（装车类任务用）',
  `appointment_required` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否要求有预约',
  `allow_manual_insert` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否允许人工插队',
  `auto_call_enabled` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否自动叫号',
  `require_dispatch_confirm` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否需要调度员确认',
  `max_call_count` int NOT NULL DEFAULT '3' COMMENT '最大叫号次数（超过则标记超时）',
  `call_timeout_minutes` int NOT NULL DEFAULT '15' COMMENT '叫号超时时间（分钟）',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `sort_order` int DEFAULT '0',
  `remark` varchar(500) DEFAULT NULL,
  `create_dept` bigint DEFAULT NULL,
  `create_by` bigint DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_by` bigint DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_warehouse_task_type` (`warehouse_id`,`task_type`,`enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='YMS叫号规则配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yms_call_rule`
--

LOCK TABLES `yms_call_rule` WRITE;
/*!40000 ALTER TABLE `yms_call_rule` DISABLE KEYS */;
/*!40000 ALTER TABLE `yms_call_rule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yms_call_rule_condition`
--

DROP TABLE IF EXISTS `yms_call_rule_condition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `yms_call_rule_condition` (
  `id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `rule_id` bigint NOT NULL COMMENT '叫号规则ID',
  `condition_field` varchar(50) NOT NULL COMMENT '条件字段（如 container_status/wms_status）',
  `operator` varchar(10) NOT NULL COMMENT '运算符：EQ/NEQ/IN/GTE/LTE',
  `condition_value` varchar(200) NOT NULL COMMENT '条件值',
  `sort_order` int NOT NULL DEFAULT '1' COMMENT '排序',
  PRIMARY KEY (`id`),
  KEY `idx_rule_id` (`rule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='YMS叫号前置条件表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yms_call_rule_condition`
--

LOCK TABLES `yms_call_rule_condition` WRITE;
/*!40000 ALTER TABLE `yms_call_rule_condition` DISABLE KEYS */;
/*!40000 ALTER TABLE `yms_call_rule_condition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yms_call_rule_sort`
--

DROP TABLE IF EXISTS `yms_call_rule_sort`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `yms_call_rule_sort` (
  `id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `rule_id` bigint NOT NULL COMMENT '叫号规则ID',
  `sort_field` varchar(50) NOT NULL COMMENT '排序字段：appointment_time/arrive_time/wms_ready_time/lfd_return/customer_level/priority/waiting_minutes',
  `sort_direction` varchar(4) NOT NULL DEFAULT 'ASC' COMMENT '排序方向：ASC/DESC',
  `priority_order` int NOT NULL DEFAULT '1' COMMENT '排序优先级（1=最高优先级）',
  PRIMARY KEY (`id`),
  KEY `idx_rule_id` (`rule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='YMS叫号排序规则表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yms_call_rule_sort`
--

LOCK TABLES `yms_call_rule_sort` WRITE;
/*!40000 ALTER TABLE `yms_call_rule_sort` DISABLE KEYS */;
/*!40000 ALTER TABLE `yms_call_rule_sort` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yms_check_in`
--

DROP TABLE IF EXISTS `yms_check_in`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `yms_check_in` (
  `id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `warehouse_id` bigint NOT NULL COMMENT '仓库ID',
  `check_in_type` varchar(20) DEFAULT 'TRUCK_TRAILER' COMMENT '签到类型：CONTAINER/TRUCK_TRAILER',
  `apt_id` bigint DEFAULT NULL COMMENT '预约ID（有预约时）',
  `apt_no` varchar(64) DEFAULT NULL COMMENT '预约编号（快照）',
  `yard_task_id` bigint DEFAULT NULL COMMENT '关联园区任务ID',
  `container_resource_id` bigint DEFAULT NULL COMMENT '生成/关联的海柜资源ID',
  `trailer_resource_id` bigint DEFAULT NULL COMMENT '生成/关联的车厢资源ID',
  `yard_task_no` varchar(64) DEFAULT NULL COMMENT '园区任务号（快照）',
  `plate_no` varchar(30) NOT NULL COMMENT '车牌号',
  `driver_name` varchar(50) DEFAULT NULL COMMENT '司机姓名',
  `driver_phone` varchar(30) DEFAULT NULL COMMENT '司机电话',
  `id_card_no` varchar(30) DEFAULT NULL COMMENT '身份证号',
  `container_no` varchar(64) DEFAULT NULL COMMENT '柜号',
  `trailer_no` varchar(64) DEFAULT NULL COMMENT '车厢号',
  `vehicle_source` varchar(30) DEFAULT NULL COMMENT '车辆来源',
  `task_type` varchar(30) DEFAULT NULL COMMENT '任务类型',
  `check_result` varchar(20) NOT NULL DEFAULT 'PENDING' COMMENT '检查结果：PASSED/REJECTED/BLACKLISTED/PENDING',
  `reject_reason` varchar(500) DEFAULT NULL COMMENT '拒绝原因',
  `match_type` varchar(20) NOT NULL DEFAULT 'WALK_IN' COMMENT '匹配方式：APT_MATCH/WALK_IN/MANUAL',
  `check_in_time` datetime DEFAULT NULL COMMENT '签到时间',
  `check_out_time` datetime DEFAULT NULL COMMENT '离场时间',
  `stay_minutes` int DEFAULT NULL COMMENT '在场时长（分钟）',
  `operator_id` bigint DEFAULT NULL COMMENT '操作员ID',
  `operator_name` varchar(50) DEFAULT NULL COMMENT '操作员姓名',
  `remark` varchar(500) DEFAULT NULL,
  `photo_urls` text COMMENT '现场照片URL（JSON数组）',
  `receipt_no` varchar(32) DEFAULT NULL COMMENT '入场小票号',
  `create_dept` bigint DEFAULT NULL,
  `create_by` bigint DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_by` bigint DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_warehouse_result` (`warehouse_id`,`check_result`),
  KEY `idx_plate_no` (`plate_no`),
  KEY `idx_check_in_time` (`check_in_time`),
  KEY `idx_yard_task_id` (`yard_task_id`),
  KEY `idx_apt_id` (`apt_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='YMS门卫签到记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yms_check_in`
--

LOCK TABLES `yms_check_in` WRITE;
/*!40000 ALTER TABLE `yms_check_in` DISABLE KEYS */;
/*!40000 ALTER TABLE `yms_check_in` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yms_container_resource`
--

DROP TABLE IF EXISTS `yms_container_resource`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `yms_container_resource` (
  `id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `company_id` bigint DEFAULT NULL COMMENT '主体公司ID',
  `warehouse_id` bigint NOT NULL COMMENT '仓库/园区ID',
  `container_no` varchar(64) NOT NULL COMMENT '柜号',
  `container_type` varchar(30) DEFAULT NULL COMMENT '柜型：40HQ/45HQ/53FT/20GP/40GP',
  `carrier` varchar(100) DEFAULT NULL COMMENT '船司（MAERSK/COSCO等）',
  `seal_no` varchar(64) DEFAULT NULL COMMENT '封条号',
  `related_order_id` bigint DEFAULT NULL COMMENT '关联海柜订单ID',
  `related_order_no` varchar(64) DEFAULT NULL COMMENT '关联海柜订单号（快照）',
  `biz_root_id` bigint DEFAULT NULL COMMENT '业务主线ID',
  `container_status` varchar(30) NOT NULL DEFAULT 'EXPECTED_ARRIVAL' COMMENT '柜状态',
  `empty_status` varchar(20) NOT NULL DEFAULT 'FULL' COMMENT '重空状态：FULL重柜/EMPTY空柜',
  `yard_position_id` bigint DEFAULT NULL COMMENT '当前堆场位ID',
  `yard_zone_id` bigint DEFAULT NULL COMMENT '当前堆场区ID（冗余）',
  `dock_id` bigint DEFAULT NULL COMMENT '当前 Dock ID（上口时）',
  `dock_code` varchar(30) DEFAULT NULL COMMENT 'Dock 编号（快照）',
  `eta_time` datetime DEFAULT NULL COMMENT '预计到仓时间',
  `arrived_time` datetime DEFAULT NULL COMMENT '实际到达时间',
  `devanning_start_time` datetime DEFAULT NULL COMMENT '拆柜开始时间',
  `devanning_finish_time` datetime DEFAULT NULL COMMENT '拆柜完成时间',
  `leave_time` datetime DEFAULT NULL COMMENT '离场时间',
  `lfd_pickup` date DEFAULT NULL COMMENT '提柜 LFD（最晚提柜日期）',
  `lfd_return` date DEFAULT NULL COMMENT '还柜 LFD（最晚还柜日期）',
  `tractor_no` varchar(30) DEFAULT NULL COMMENT '车头号',
  `plate_no` varchar(30) DEFAULT NULL COMMENT '车牌号',
  `driver_name` varchar(50) DEFAULT NULL COMMENT '司机姓名',
  `driver_phone` varchar(20) DEFAULT NULL COMMENT '司机电话',
  `exception_flag` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否异常',
  `exception_reason` varchar(500) DEFAULT NULL COMMENT '异常原因',
  `remark` varchar(500) DEFAULT NULL,
  `create_dept` bigint DEFAULT NULL,
  `create_by` bigint DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_by` bigint DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_container_no_tenant` (`container_no`,`tenant_id`,`deleted`),
  KEY `idx_warehouse_status` (`warehouse_id`,`container_status`),
  KEY `idx_company_id` (`company_id`),
  KEY `idx_related_order` (`related_order_id`),
  KEY `idx_yard_position` (`yard_position_id`),
  KEY `idx_lfd_return` (`lfd_return`),
  KEY `idx_biz_root_id` (`biz_root_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='YMS海柜资源表（海柜在园区的全生命周期）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yms_container_resource`
--

LOCK TABLES `yms_container_resource` WRITE;
/*!40000 ALTER TABLE `yms_container_resource` DISABLE KEYS */;
/*!40000 ALTER TABLE `yms_container_resource` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yms_dock_queue`
--

DROP TABLE IF EXISTS `yms_dock_queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `yms_dock_queue` (
  `id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户',
  `dock_id` bigint NOT NULL COMMENT 'Dock ID（yard_dock.id）',
  `yard_task_id` bigint NOT NULL COMMENT '园区任务ID',
  `container_no` varchar(64) DEFAULT NULL COMMENT '柜号/来源单号（快照）',
  `queue_no` int NOT NULL COMMENT '排队序号',
  `queue_status` varchar(30) NOT NULL DEFAULT 'WAITING' COMMENT '排队状态：WAITING/ENTERED/CANCELLED',
  `queued_time` datetime DEFAULT NULL COMMENT '加入排队时间',
  `enter_dock_time` datetime DEFAULT NULL COMMENT '进入Dock时间',
  `cancel_time` datetime DEFAULT NULL COMMENT '取消时间',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_dock_status` (`dock_id`,`queue_status`),
  KEY `idx_yard_task` (`yard_task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Dock排队表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yms_dock_queue`
--

LOCK TABLES `yms_dock_queue` WRITE;
/*!40000 ALTER TABLE `yms_dock_queue` DISABLE KEYS */;
INSERT INTO `yms_dock_queue` VALUES (9202001,'000000',3010006,9200012,'CA-TRK-202',1,'WAITING','2026-05-28 09:16:00',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `yms_dock_queue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yms_driver`
--

DROP TABLE IF EXISTS `yms_driver`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `yms_driver` (
  `id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `name` varchar(50) NOT NULL COMMENT '姓名',
  `phone` varchar(30) NOT NULL COMMENT '手机号',
  `id_card_no` varchar(30) DEFAULT NULL COMMENT '身份证号',
  `license_no` varchar(50) DEFAULT NULL COMMENT '驾驶证号',
  `license_type` varchar(10) DEFAULT NULL COMMENT '驾照类型：A1/A2/B1/B2/C1等',
  `license_expire` date DEFAULT NULL COMMENT '驾照有效期',
  `fleet_id` bigint DEFAULT NULL COMMENT '所属车队ID',
  `fleet_name` varchar(100) DEFAULT NULL COMMENT '车队名称（冗余）',
  `blacklisted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否黑名单(0否1是)',
  `blacklist_reason` varchar(500) DEFAULT NULL COMMENT '黑名单原因',
  `remark` varchar(500) DEFAULT NULL,
  `create_dept` bigint DEFAULT NULL,
  `create_by` bigint DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_by` bigint DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_phone` (`phone`),
  KEY `idx_id_card_no` (`id_card_no`),
  KEY `idx_fleet_id` (`fleet_id`),
  KEY `idx_blacklisted` (`blacklisted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='YMS司机表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yms_driver`
--

LOCK TABLES `yms_driver` WRITE;
/*!40000 ALTER TABLE `yms_driver` DISABLE KEYS */;
/*!40000 ALTER TABLE `yms_driver` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yms_fleet`
--

DROP TABLE IF EXISTS `yms_fleet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `yms_fleet` (
  `id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `fleet_name` varchar(100) NOT NULL COMMENT '车队名称',
  `contact_person` varchar(50) DEFAULT NULL COMMENT '联系人',
  `contact_phone` varchar(30) DEFAULT NULL COMMENT '联系电话',
  `address` varchar(300) DEFAULT NULL COMMENT '地址',
  `remark` varchar(500) DEFAULT NULL,
  `create_dept` bigint DEFAULT NULL,
  `create_by` bigint DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_by` bigint DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_fleet_name` (`fleet_name`),
  KEY `idx_tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='YMS车队表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yms_fleet`
--

LOCK TABLES `yms_fleet` WRITE;
/*!40000 ALTER TABLE `yms_fleet` DISABLE KEYS */;
/*!40000 ALTER TABLE `yms_fleet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yms_internal_task`
--

DROP TABLE IF EXISTS `yms_internal_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `yms_internal_task` (
  `id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `warehouse_id` bigint NOT NULL COMMENT '仓库/园区ID',
  `task_no` varchar(64) NOT NULL COMMENT '院内任务编号（IT+日期+序号）',
  `parent_yard_task_id` bigint DEFAULT NULL COMMENT '关联园区主任务ID（yms_yard_task.id）',
  `parent_yard_task_no` varchar(64) DEFAULT NULL COMMENT '园区主任务号（快照）',
  `internal_task_type` varchar(30) NOT NULL COMMENT '院内任务类型：CONTAINER_TO_DOCK/CONTAINER_OFF_DOCK/TRAILER_TO_DOCK/TRAILER_OFF_DOCK/CONTAINER_MOVE/TRAILER_MOVE/EMPTY_CONTAINER_RETURN/YARD_INVENTORY_SCAN',
  `object_type` varchar(20) NOT NULL COMMENT '操作对象类型：CONTAINER/TRAILER',
  `object_id` bigint DEFAULT NULL COMMENT '操作对象ID',
  `object_no` varchar(64) DEFAULT NULL COMMENT '操作对象编号（柜号/车厢号，快照）',
  `from_position_id` bigint DEFAULT NULL COMMENT '起始位置ID',
  `from_position_code` varchar(30) DEFAULT NULL COMMENT '起始位置编码（快照）',
  `to_position_id` bigint DEFAULT NULL COMMENT '目标位置ID（移动任务）',
  `to_position_code` varchar(30) DEFAULT NULL COMMENT '目标位置编码（快照）',
  `to_dock_id` bigint DEFAULT NULL COMMENT '目标 Dock ID（上口任务）',
  `to_dock_code` varchar(30) DEFAULT NULL COMMENT '目标 Dock 编号（快照）',
  `executor_type` varchar(20) DEFAULT NULL COMMENT '执行者类型：MANUAL/FORKLIFT/YARDGOAT',
  `executor_id` bigint DEFAULT NULL COMMENT '执行者ID（用户ID或设备ID）',
  `executor_name` varchar(50) DEFAULT NULL COMMENT '执行者名称（快照）',
  `task_status` varchar(20) NOT NULL DEFAULT 'PENDING' COMMENT '任务状态：PENDING/ASSIGNED/ACCEPTED/IN_PROGRESS/COMPLETED/FAILED/CANCELLED',
  `priority` int NOT NULL DEFAULT '5' COMMENT '优先级（1-10）',
  `assign_time` datetime DEFAULT NULL COMMENT '分配时间',
  `accept_time` datetime DEFAULT NULL COMMENT '接单时间',
  `start_time` datetime DEFAULT NULL COMMENT '开始执行时间',
  `finish_time` datetime DEFAULT NULL COMMENT '完成时间',
  `deadline_time` datetime DEFAULT NULL COMMENT '截止时间（SLA）',
  `fail_reason` varchar(500) DEFAULT NULL COMMENT '失败原因',
  `photo_urls` text COMMENT '现场照片URL（JSON数组）',
  `remark` varchar(500) DEFAULT NULL,
  `create_dept` bigint DEFAULT NULL,
  `create_by` bigint DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_by` bigint DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_task_no_tenant` (`task_no`,`tenant_id`),
  KEY `idx_parent_yard_task` (`parent_yard_task_id`),
  KEY `idx_warehouse_type_status` (`warehouse_id`,`internal_task_type`,`task_status`),
  KEY `idx_executor` (`executor_id`,`task_status`),
  KEY `idx_object` (`object_type`,`object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='YMS院内任务表（上口/下口/挪柜/盘点）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yms_internal_task`
--

LOCK TABLES `yms_internal_task` WRITE;
/*!40000 ALTER TABLE `yms_internal_task` DISABLE KEYS */;
/*!40000 ALTER TABLE `yms_internal_task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yms_slot_template`
--

DROP TABLE IF EXISTS `yms_slot_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `yms_slot_template` (
  `id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `warehouse_id` bigint NOT NULL COMMENT '仓库ID',
  `weekdays` varchar(20) NOT NULL COMMENT '适用星期（逗号分隔，1=周一...7=周日，如 1,2,3,4,5）',
  `slot_start` varchar(10) NOT NULL COMMENT '开始时间（HH:mm）',
  `slot_end` varchar(10) NOT NULL COMMENT '结束时间（HH:mm）',
  `capacity` int NOT NULL DEFAULT '10' COMMENT '容量（该时段最大预约数）',
  `task_type` varchar(30) NOT NULL DEFAULT 'ALL' COMMENT '适用任务类型：DEVANNING/LOADING/ALL',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用(0否1是)',
  `remark` varchar(500) DEFAULT NULL,
  `create_dept` bigint DEFAULT NULL,
  `create_by` bigint DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_by` bigint DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_warehouse_enabled` (`warehouse_id`,`enabled`),
  KEY `idx_task_type` (`task_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='YMS预约时段模板';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yms_slot_template`
--

LOCK TABLES `yms_slot_template` WRITE;
/*!40000 ALTER TABLE `yms_slot_template` DISABLE KEYS */;
/*!40000 ALTER TABLE `yms_slot_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yms_trailer_resource`
--

DROP TABLE IF EXISTS `yms_trailer_resource`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `yms_trailer_resource` (
  `id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `company_id` bigint DEFAULT NULL COMMENT '主体公司ID',
  `warehouse_id` bigint NOT NULL COMMENT '仓库/园区ID',
  `trailer_no` varchar(64) DEFAULT NULL COMMENT '车厢号',
  `tractor_no` varchar(30) DEFAULT NULL COMMENT '车头号',
  `plate_no` varchar(30) DEFAULT NULL COMMENT '车牌号（整车）',
  `driver_name` varchar(50) DEFAULT NULL COMMENT '司机姓名',
  `driver_phone` varchar(20) DEFAULT NULL COMMENT '司机电话',
  `driver_id_no` varchar(30) DEFAULT NULL COMMENT '司机身份证号',
  `vehicle_source` varchar(30) NOT NULL DEFAULT 'SUPPLIER_TRUCK' COMMENT '车辆来源：SUPPLIER_TRUCK/RENTED_TRAILER/OWN_TRAILER/TEMP_TRUCK',
  `supplier_id` bigint DEFAULT NULL COMMENT '供应商ID（SUPPLIER_TRUCK时）',
  `supplier_name` varchar(100) DEFAULT NULL COMMENT '供应商名称（快照）',
  `related_loading_task_id` bigint DEFAULT NULL COMMENT '关联装车园区任务ID',
  `related_order_no` varchar(64) DEFAULT NULL COMMENT '关联出库/派送单号',
  `biz_root_id` bigint DEFAULT NULL COMMENT '业务主线ID',
  `trailer_status` varchar(30) NOT NULL DEFAULT 'EXPECTED_ARRIVAL' COMMENT '车厢状态',
  `yard_position_id` bigint DEFAULT NULL COMMENT '当前堆场位ID',
  `yard_zone_id` bigint DEFAULT NULL COMMENT '当前堆场区ID（冗余）',
  `dock_id` bigint DEFAULT NULL COMMENT '当前 Dock ID（上口时）',
  `dock_code` varchar(30) DEFAULT NULL COMMENT 'Dock 编号（快照）',
  `arrive_time` datetime DEFAULT NULL COMMENT '到仓时间',
  `loading_start_time` datetime DEFAULT NULL COMMENT '装车开始时间',
  `loading_finish_time` datetime DEFAULT NULL COMMENT '装车完成时间',
  `leave_time` datetime DEFAULT NULL COMMENT '离场时间',
  `wms_ready_status` varchar(30) NOT NULL DEFAULT 'NOT_REQUIRED' COMMENT 'WMS备货状态：NOT_REQUIRED/PENDING/READY',
  `wms_ready_time` datetime DEFAULT NULL COMMENT 'WMS备货完成时间',
  `exception_flag` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否异常',
  `exception_reason` varchar(500) DEFAULT NULL COMMENT '异常原因',
  `remark` varchar(500) DEFAULT NULL,
  `create_dept` bigint DEFAULT NULL,
  `create_by` bigint DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_by` bigint DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_warehouse_status` (`warehouse_id`,`trailer_status`),
  KEY `idx_plate_no` (`plate_no`),
  KEY `idx_trailer_no` (`trailer_no`),
  KEY `idx_vehicle_source` (`vehicle_source`),
  KEY `idx_related_loading_task` (`related_loading_task_id`),
  KEY `idx_biz_root_id` (`biz_root_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='YMS车厢资源表（供应商车辆/租赁车厢/自有车厢）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yms_trailer_resource`
--

LOCK TABLES `yms_trailer_resource` WRITE;
/*!40000 ALTER TABLE `yms_trailer_resource` DISABLE KEYS */;
/*!40000 ALTER TABLE `yms_trailer_resource` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yms_vehicle`
--

DROP TABLE IF EXISTS `yms_vehicle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `yms_vehicle` (
  `id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `plate_no` varchar(30) NOT NULL COMMENT '车牌号',
  `vehicle_type` varchar(30) NOT NULL COMMENT '车辆类型：CONTAINER/TRUCK/SELF_PICKUP',
  `fleet_id` bigint DEFAULT NULL COMMENT '所属车队ID',
  `fleet_name` varchar(100) DEFAULT NULL COMMENT '车队名称（冗余）',
  `brand` varchar(50) DEFAULT NULL COMMENT '品牌',
  `model` varchar(50) DEFAULT NULL COMMENT '型号',
  `blacklisted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否黑名单(0否1是)',
  `blacklist_reason` varchar(500) DEFAULT NULL COMMENT '黑名单原因',
  `remark` varchar(500) DEFAULT NULL,
  `create_dept` bigint DEFAULT NULL,
  `create_by` bigint DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_by` bigint DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_plate_no_tenant` (`plate_no`,`tenant_id`),
  KEY `idx_vehicle_type` (`vehicle_type`),
  KEY `idx_fleet_id` (`fleet_id`),
  KEY `idx_blacklisted` (`blacklisted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='YMS车辆表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yms_vehicle`
--

LOCK TABLES `yms_vehicle` WRITE;
/*!40000 ALTER TABLE `yms_vehicle` DISABLE KEYS */;
/*!40000 ALTER TABLE `yms_vehicle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yms_yard_inventory_item`
--

DROP TABLE IF EXISTS `yms_yard_inventory_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `yms_yard_inventory_item` (
  `id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `inventory_id` bigint NOT NULL COMMENT '盘点任务ID',
  `object_type` varchar(20) NOT NULL COMMENT 'CONTAINER/TRAILER',
  `object_no` varchar(64) NOT NULL COMMENT '柜号/车厢号',
  `system_position_id` bigint DEFAULT NULL COMMENT '系统位置ID',
  `system_position_code` varchar(50) DEFAULT NULL COMMENT '系统位置编码',
  `actual_position_id` bigint DEFAULT NULL COMMENT '实盘位置ID',
  `actual_position_code` varchar(50) DEFAULT NULL COMMENT '实盘位置编码',
  `scan_status` varchar(20) NOT NULL DEFAULT 'PENDING' COMMENT 'PENDING/SCANNED/MISSING/EXTRA',
  `diff_type` varchar(30) DEFAULT NULL COMMENT 'MISSING/EXTRA/POSITION_MISMATCH/STATUS_MISMATCH',
  `photo_urls` text COMMENT '照片JSON',
  `remark` varchar(500) DEFAULT NULL,
  `scan_time` datetime DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_inventory_id` (`inventory_id`),
  KEY `idx_object_no` (`object_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='YMS园区盘点明细';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yms_yard_inventory_item`
--

LOCK TABLES `yms_yard_inventory_item` WRITE;
/*!40000 ALTER TABLE `yms_yard_inventory_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `yms_yard_inventory_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yms_yard_inventory_task`
--

DROP TABLE IF EXISTS `yms_yard_inventory_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `yms_yard_inventory_task` (
  `id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `warehouse_id` bigint NOT NULL COMMENT '仓库ID',
  `inventory_no` varchar(64) NOT NULL COMMENT '盘点任务号',
  `inventory_type` varchar(30) NOT NULL COMMENT 'ZONE/FULL/CONTAINER_LIST',
  `zone_id` bigint DEFAULT NULL COMMENT '盘点区域ID',
  `zone_code` varchar(50) DEFAULT NULL COMMENT '区域编码快照',
  `expected_count` int NOT NULL DEFAULT '0' COMMENT '应盘数量',
  `actual_count` int NOT NULL DEFAULT '0' COMMENT '实盘数量',
  `diff_count` int NOT NULL DEFAULT '0' COMMENT '差异数量',
  `status` varchar(20) NOT NULL DEFAULT 'PENDING' COMMENT 'PENDING/IN_PROGRESS/COMPLETED/DIFF_FOUND',
  `start_time` datetime DEFAULT NULL,
  `finish_time` datetime DEFAULT NULL,
  `operator_id` bigint DEFAULT NULL,
  `operator_name` varchar(50) DEFAULT NULL,
  `remark` varchar(500) DEFAULT NULL,
  `create_dept` bigint DEFAULT NULL,
  `create_by` bigint DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_by` bigint DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_inventory_no` (`inventory_no`),
  KEY `idx_warehouse_status` (`warehouse_id`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='YMS园区盘点任务';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yms_yard_inventory_task`
--

LOCK TABLES `yms_yard_inventory_task` WRITE;
/*!40000 ALTER TABLE `yms_yard_inventory_task` DISABLE KEYS */;
/*!40000 ALTER TABLE `yms_yard_inventory_task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yms_yard_position`
--

DROP TABLE IF EXISTS `yms_yard_position`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `yms_yard_position` (
  `id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `warehouse_id` bigint NOT NULL COMMENT '仓库/园区ID',
  `zone_id` bigint NOT NULL COMMENT '所属堆场区ID（yms_yard_zone.id）',
  `zone_code` varchar(30) DEFAULT NULL COMMENT '堆场区编码（冗余）',
  `position_code` varchar(30) NOT NULL COMMENT '位置编码（如 A-01, B-03）',
  `position_name` varchar(100) DEFAULT NULL COMMENT '位置名称',
  `position_type` varchar(30) NOT NULL DEFAULT 'CONTAINER_SLOT' COMMENT '位置类型：CONTAINER_SLOT/EMPTY_CONTAINER_SLOT/TRAILER_SLOT/WAITING_SLOT/BLOCKED_SLOT',
  `position_status` varchar(20) NOT NULL DEFAULT 'FREE' COMMENT '位置状态：FREE/OCCUPIED/RESERVED/DISABLED',
  `grid_row` int DEFAULT NULL COMMENT '行坐标',
  `grid_col` int DEFAULT NULL COMMENT '列坐标',
  `occupied_object_type` varchar(20) DEFAULT NULL COMMENT '占用对象类型：CONTAINER/EMPTY_CONTAINER/TRAILER',
  `occupied_object_id` bigint DEFAULT NULL COMMENT '占用对象ID',
  `occupied_object_no` varchar(64) DEFAULT NULL COMMENT '占用对象编号（柜号/车厢号，快照）',
  `occupied_since` datetime DEFAULT NULL COMMENT '占用开始时间',
  `remark` varchar(500) DEFAULT NULL,
  `create_dept` bigint DEFAULT NULL,
  `create_by` bigint DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_by` bigint DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_position_code_zone` (`position_code`,`zone_id`,`deleted`),
  KEY `idx_zone_id` (`zone_id`),
  KEY `idx_warehouse_type_status` (`warehouse_id`,`position_type`,`position_status`),
  KEY `idx_occupied_object` (`occupied_object_type`,`occupied_object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='YMS堆场位表（园区物理位置管理）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yms_yard_position`
--

LOCK TABLES `yms_yard_position` WRITE;
/*!40000 ALTER TABLE `yms_yard_position` DISABLE KEYS */;
/*!40000 ALTER TABLE `yms_yard_position` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yms_yard_task`
--

DROP TABLE IF EXISTS `yms_yard_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `yms_yard_task` (
  `id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户',
  `yard_task_no` varchar(64) NOT NULL COMMENT '园区任务号（YT+日期+序号）',
  `task_type` varchar(30) NOT NULL COMMENT '任务类型：DEVANNING/DELIVERY_LOADING/TRANSFER_LOADING/PICKUP_LOADING/RETURN_LOADING/OTHER',
  `warehouse_id` bigint DEFAULT NULL COMMENT '仓库ID',
  `source_order_type` varchar(30) DEFAULT NULL COMMENT '来源单据类型：CONTAINER_ORDER/DELIVERY_ORDER/TRANSFER_ORDER/etc',
  `source_order_id` bigint DEFAULT NULL COMMENT '来源单据ID',
  `source_order_no` varchar(64) DEFAULT NULL COMMENT '来源单据号（快照）',
  `container_no` varchar(64) DEFAULT NULL COMMENT '柜号（快照）',
  `container_resource_id` bigint DEFAULT NULL COMMENT '海柜资源ID（DEVANNING任务）',
  `trailer_resource_id` bigint DEFAULT NULL COMMENT '车厢资源ID（LOADING任务）',
  `wms_ready_status` varchar(30) NOT NULL DEFAULT 'NOT_REQUIRED' COMMENT 'WMS备货状态：NOT_REQUIRED/PENDING/READY',
  `wms_ready_time` datetime DEFAULT NULL COMMENT 'WMS备货完成时间',
  `appointment_id` bigint DEFAULT NULL COMMENT '预约ID',
  `dock_assign_time` datetime DEFAULT NULL COMMENT 'Dock分配时间',
  `call_time` datetime DEFAULT NULL COMMENT '叫号时间',
  `priority` int NOT NULL DEFAULT '5' COMMENT '优先级（1-10，越小越高）',
  `truck_no` varchar(30) DEFAULT NULL COMMENT '车牌号',
  `driver_name` varchar(50) DEFAULT NULL COMMENT '司机姓名',
  `driver_phone` varchar(20) DEFAULT NULL COMMENT '司机电话',
  `eta_yard_time` datetime DEFAULT NULL COMMENT '预计到园区时间',
  `gate_in_time` datetime DEFAULT NULL COMMENT '到园区时间（签到）',
  `dock_start_time` datetime DEFAULT NULL COMMENT 'Dock作业开始时间',
  `dock_finish_time` datetime DEFAULT NULL COMMENT 'Dock作业完成时间',
  `release_time` datetime DEFAULT NULL COMMENT '放行时间',
  `gate_out_time` datetime DEFAULT NULL COMMENT '离园时间',
  `dock_id` bigint DEFAULT NULL COMMENT '当前Dock ID（yard_dock.id）',
  `dock_code` varchar(30) DEFAULT NULL COMMENT 'Dock编号（快照）',
  `operation_task_id` bigint DEFAULT NULL COMMENT 'WMS作业任务ID',
  `operation_status` varchar(30) DEFAULT NULL COMMENT 'WMS作业状态',
  `operation_progress` decimal(5,2) DEFAULT NULL COMMENT '作业进度百分比',
  `operation_start_time` datetime DEFAULT NULL COMMENT '作业开始时间',
  `operation_finish_time` datetime DEFAULT NULL COMMENT '作业完成时间',
  `estimated_finish_time` datetime DEFAULT NULL COMMENT '预计完成时间',
  `loaded_qty` decimal(10,0) DEFAULT NULL COMMENT '已装数量',
  `total_qty` decimal(10,0) DEFAULT NULL COMMENT '应装数量',
  `loaded_pallet_qty` decimal(10,0) DEFAULT NULL COMMENT '已装板数',
  `total_pallet_qty` decimal(10,0) DEFAULT NULL COMMENT '应装板数',
  `yard_status` varchar(30) NOT NULL DEFAULT 'CREATED' COMMENT '园区状态',
  `visit_no` int NOT NULL DEFAULT '1' COMMENT '第几次到仓',
  `unload_round_no` int NOT NULL DEFAULT '1' COMMENT '作业轮次',
  `active_task_key` varchar(100) DEFAULT NULL COMMENT '活跃任务唯一键(source_order_type:source_order_id)，终态置NULL',
  `is_reentry` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否重复到仓',
  `reentry_reason` varchar(200) DEFAULT NULL COMMENT '重复到仓原因',
  `parent_task_id` bigint DEFAULT NULL COMMENT '上一次任务ID',
  `exception_flag` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否异常',
  `exception_reason` varchar(500) DEFAULT NULL COMMENT '异常原因',
  `source` varchar(30) NOT NULL DEFAULT 'OMS_PUSH' COMMENT '任务来源：OMS_PUSH/MANUAL',
  `remark` varchar(500) DEFAULT NULL,
  `create_dept` bigint DEFAULT NULL,
  `create_by` bigint DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_by` bigint DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_yard_task_no` (`yard_task_no`,`tenant_id`),
  UNIQUE KEY `uk_active_task_key` (`active_task_key`),
  KEY `idx_source_order` (`source_order_type`,`source_order_id`),
  KEY `idx_warehouse_status` (`warehouse_id`,`yard_status`),
  KEY `idx_task_type_status` (`task_type`,`yard_status`),
  KEY `idx_dock_status` (`dock_id`,`yard_status`),
  KEY `idx_container_no` (`container_no`),
  KEY `idx_gate_in_time` (`gate_in_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='YMS园区任务主表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yms_yard_task`
--

LOCK TABLES `yms_yard_task` WRITE;
/*!40000 ALTER TABLE `yms_yard_task` DISABLE KEYS */;
INSERT INTO `yms_yard_task` VALUES (9200001,'000000','YT20260524001','DEVANNING',4001001,'CONTAINER_ORDER',9100001,'SO202605220001','TGHU1234567',NULL,NULL,'NOT_REQUIRED',NULL,NULL,NULL,NULL,5,'CA-TRK-001','张伟','310-555-0101','2026-05-28 16:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'PRE_ARRIVAL',1,1,'CONTAINER_ORDER:9100001',0,NULL,NULL,0,NULL,'OMS_PUSH','ETA 5/28 到仓',NULL,1,'2026-05-24 09:00:00',1,'2026-05-24 09:00:00',0),(9200002,'000000','YT20260524002','DEVANNING',4001001,'CONTAINER_ORDER',9100002,'SO202605220002','MSCU7654321',NULL,NULL,'NOT_REQUIRED',NULL,NULL,NULL,NULL,5,NULL,NULL,NULL,'2026-05-23 10:30:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'CREATED',1,1,'CONTAINER_ORDER:9100002',0,NULL,NULL,0,NULL,'OMS_PUSH','Hold中，等待码头放行',NULL,1,'2026-05-24 10:00:00',1,'2026-05-24 10:00:00',0),(9200003,'000000','YT20260525001','DEVANNING',4001001,'CONTAINER_ORDER',9100004,'SO202605280004','HLCU9876543',NULL,NULL,'NOT_REQUIRED',NULL,NULL,NULL,NULL,5,NULL,NULL,NULL,'2026-06-02 14:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'PRE_ARRIVAL',1,1,'CONTAINER_ORDER:9100004',0,NULL,NULL,0,NULL,'OMS_PUSH','ETA 6/1 到仓',NULL,1,'2026-05-25 08:00:00',1,'2026-05-25 08:00:00',0),(9200004,'000000','YT20260525002','DEVANNING',4001001,'CONTAINER_ORDER',9100005,'SO202605280005','EVYU1122334',NULL,NULL,'NOT_REQUIRED',NULL,NULL,NULL,NULL,5,NULL,NULL,NULL,'2026-06-01 10:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'PRE_ARRIVAL',1,1,'CONTAINER_ORDER:9100005',0,NULL,NULL,1,NULL,'OMS_PUSH','有Hold，等待海关放行',NULL,1,'2026-05-25 09:00:00',1,'2026-05-25 09:00:00',0),(9200005,'000000','YT20260526001','DEVANNING',4001001,'CONTAINER_ORDER',9100006,'SO202605260006','KMTU5566778',NULL,NULL,'NOT_REQUIRED',NULL,NULL,NULL,NULL,5,'CA-TRK-006','李刚','310-555-0106','2026-05-26 08:00:00','2026-05-26 09:15:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'ARRIVED',1,1,'CONTAINER_ORDER:9100006',0,NULL,NULL,0,NULL,'OMS_PUSH','已到仓，等待分配Dock',NULL,1,'2026-05-26 09:00:00',1,'2026-05-26 09:15:00',0),(9200006,'000000','YT20260526002','DEVANNING',4001001,'CONTAINER_ORDER',9100007,'SO202605270007','APLU2233445',NULL,NULL,'NOT_REQUIRED',NULL,NULL,NULL,NULL,5,'CA-TRK-007','王五','310-555-0107','2026-05-27 07:30:00','2026-05-27 08:45:00',NULL,NULL,NULL,NULL,3010004,'DOC-LA-A03',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'DOCK_ASSIGNED',1,1,'CONTAINER_ORDER:9100007',0,NULL,NULL,0,NULL,'OMS_PUSH','已分配 A区3号 Dock',NULL,1,'2026-05-26 10:00:00',1,'2026-05-27 08:50:00',0),(9200007,'000000','YT20260527001','DEVANNING',4001001,'CONTAINER_ORDER',9100008,'SO202605270008','TCKU8899001',NULL,NULL,'NOT_REQUIRED',NULL,NULL,NULL,NULL,5,'CA-TRK-008','陈三','310-555-0108','2026-05-25 14:00:00','2026-05-25 15:20:00','2026-05-27 09:15:00',NULL,NULL,NULL,3010001,'DOC-LA-001',NULL,'IN_PROGRESS',45.00,'2026-05-27 09:15:00',NULL,NULL,NULL,NULL,NULL,NULL,'DEVANNING',1,1,'CONTAINER_ORDER:9100008',0,NULL,NULL,0,NULL,'OMS_PUSH','拆柜中，进度45%',NULL,1,'2026-05-27 08:00:00',1,'2026-05-27 09:15:00',0),(9200008,'000000','YT20260527002','DEVANNING',4001001,'CONTAINER_ORDER',9100009,'SO202605270009','HJCU4455667',NULL,NULL,'NOT_REQUIRED',NULL,NULL,NULL,NULL,5,'CA-TRK-009','赵六','310-555-0109','2026-05-24 10:00:00','2026-05-24 11:35:00','2026-05-27 13:10:00',NULL,NULL,NULL,3010002,'DOC-LA-002',NULL,'IN_PROGRESS',20.00,'2026-05-27 13:10:00',NULL,NULL,NULL,NULL,NULL,NULL,'DOCK_WORKING',1,1,'CONTAINER_ORDER:9100009',0,NULL,NULL,0,NULL,'OMS_PUSH','Dock作业中，进度20%',NULL,1,'2026-05-27 12:00:00',1,'2026-05-27 13:10:00',0),(9200009,'000000','YT20260527003','DEVANNING',4001001,'CONTAINER_ORDER',9100010,'SO202605260010','SEGU3344556',NULL,NULL,'NOT_REQUIRED',NULL,NULL,NULL,NULL,5,'CA-TRK-010','孙七','310-555-0110','2026-05-22 08:00:00','2026-05-22 09:00:00','2026-05-24 10:20:00','2026-05-26 17:30:00',NULL,NULL,NULL,NULL,NULL,'FINISHED',100.00,'2026-05-24 10:20:00','2026-05-26 17:30:00',NULL,1680,1680,NULL,NULL,'OPERATION_FINISHED',1,1,NULL,0,NULL,NULL,0,NULL,'OMS_PUSH','拆柜完成100%，待放行',NULL,1,'2026-05-26 08:00:00',1,'2026-05-26 17:30:00',0),(9200010,'000000','YT20260528001','DEVANNING',4001001,'CONTAINER_ORDER',9100013,'SO202605280013','YMLU6677889',NULL,NULL,'NOT_REQUIRED',NULL,NULL,NULL,NULL,5,NULL,NULL,NULL,'2026-05-28 16:00:00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'CREATED',1,1,'CONTAINER_ORDER:9100013',0,NULL,NULL,0,NULL,'OMS_PUSH','已提柜，预计今日到仓',NULL,1,'2026-05-28 07:00:00',1,'2026-05-28 07:00:00',0),(9200011,'000000','YT20260528002','DELIVERY_LOADING',4001001,'MANUAL',NULL,NULL,NULL,NULL,NULL,'NOT_REQUIRED',NULL,NULL,NULL,NULL,5,'CA-TRK-201','周八','310-555-0201','2026-05-28 07:00:00','2026-05-28 07:30:00',NULL,NULL,NULL,NULL,3010005,'DOC-LA-B01',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'DOCK_ASSIGNED',1,1,NULL,0,NULL,NULL,0,NULL,'MANUAL','FBA派送装车，分配B区1号',NULL,1,'2026-05-28 06:00:00',1,'2026-05-28 07:35:00',0),(9200012,'000000','YT20260528003','TRANSFER_LOADING',4001001,'MANUAL',NULL,NULL,NULL,NULL,NULL,'NOT_REQUIRED',NULL,NULL,NULL,NULL,5,'CA-TRK-202','吴九','310-555-0202','2026-05-28 09:00:00','2026-05-28 09:15:00',NULL,NULL,NULL,NULL,3010006,'DOC-LA-B02',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'QUEUED',1,1,NULL,0,NULL,NULL,0,NULL,'MANUAL','调拨装车，B区2号排队等待',NULL,1,'2026-05-28 08:30:00',1,'2026-05-28 09:16:00',0),(9200013,'000000','YT20260522001','DEVANNING',4001001,'CONTAINER_ORDER',NULL,'SO202605220003','OOLU4567890',NULL,NULL,'NOT_REQUIRED',NULL,NULL,NULL,NULL,5,NULL,NULL,NULL,'2026-05-21 09:00:00','2026-05-21 09:35:00','2026-05-22 10:15:00','2026-05-23 16:00:00','2026-05-23 17:00:00',NULL,NULL,NULL,NULL,'FINISHED',100.00,'2026-05-22 10:15:00','2026-05-23 16:00:00',NULL,1420,1420,NULL,NULL,'RELEASED',1,1,NULL,0,NULL,NULL,0,NULL,'OMS_PUSH','已放行',NULL,1,'2026-05-21 08:00:00',1,'2026-05-23 17:00:00',0),(9200014,'000000','YT20260520001','DEVANNING',4001001,'CONTAINER_ORDER',NULL,'SO202605200001','MSCU1234001',NULL,NULL,'NOT_REQUIRED',NULL,NULL,NULL,NULL,5,NULL,NULL,NULL,'2026-05-19 14:00:00','2026-05-19 14:30:00','2026-05-20 09:00:00','2026-05-21 15:00:00','2026-05-21 16:00:00','2026-05-21 16:45:00',NULL,NULL,NULL,'FINISHED',100.00,'2026-05-20 09:00:00','2026-05-21 15:00:00',NULL,980,980,NULL,NULL,'LEFT_YARD',1,1,NULL,0,NULL,NULL,0,NULL,'OMS_PUSH','已离园（历史）',NULL,1,'2026-05-19 13:00:00',1,'2026-05-21 16:45:00',0);
/*!40000 ALTER TABLE `yms_yard_task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yms_yard_task_log`
--

DROP TABLE IF EXISTS `yms_yard_task_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `yms_yard_task_log` (
  `id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户',
  `yard_task_id` bigint NOT NULL COMMENT '园区任务ID',
  `action_type` varchar(50) NOT NULL COMMENT '操作类型',
  `before_status` varchar(30) DEFAULT NULL COMMENT '操作前状态',
  `after_status` varchar(30) DEFAULT NULL COMMENT '操作后状态',
  `action_content` text COMMENT '操作内容',
  `operator_id` bigint DEFAULT NULL,
  `operator_name` varchar(50) DEFAULT NULL,
  `action_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_yard_task_id` (`yard_task_id`),
  KEY `idx_action_time` (`action_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='园区任务操作日志';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yms_yard_task_log`
--

LOCK TABLES `yms_yard_task_log` WRITE;
/*!40000 ALTER TABLE `yms_yard_task_log` DISABLE KEYS */;
INSERT INTO `yms_yard_task_log` VALUES (9201001,'000000',9200001,'TASK_CREATED',NULL,'PRE_ARRIVAL','OMS推送创建任务',1,'系统','2026-05-24 09:00:00'),(9201002,'000000',9200002,'TASK_CREATED',NULL,'CREATED','OMS推送创建任务（Hold中）',1,'系统','2026-05-24 10:00:00'),(9201003,'000000',9200005,'TASK_CREATED',NULL,'PRE_ARRIVAL','OMS推送创建任务',1,'系统','2026-05-26 09:00:00'),(9201004,'000000',9200005,'CHECK_IN','PRE_ARRIVAL','ARRIVED','车辆签到到仓',1,'admin','2026-05-26 09:15:00'),(9201005,'000000',9200006,'TASK_CREATED',NULL,'PRE_ARRIVAL','OMS推送创建任务',1,'系统','2026-05-26 10:00:00'),(9201006,'000000',9200006,'CHECK_IN','PRE_ARRIVAL','ARRIVED','车辆签到',1,'admin','2026-05-27 08:45:00'),(9201007,'000000',9200006,'ASSIGN_DOCK','ARRIVED','DOCK_ASSIGNED','分配至 DOC-LA-A03',1,'admin','2026-05-27 08:50:00'),(9201008,'000000',9200007,'TASK_CREATED',NULL,'PRE_ARRIVAL','OMS推送创建任务',1,'系统','2026-05-27 08:00:00'),(9201009,'000000',9200007,'CHECK_IN','PRE_ARRIVAL','ARRIVED','车辆签到',1,'admin','2026-05-25 15:20:00'),(9201010,'000000',9200007,'ASSIGN_DOCK','ARRIVED','DOCK_ASSIGNED','分配至 DOC-LA-001',1,'admin','2026-05-27 09:00:00'),(9201011,'000000',9200007,'START_WORK','DOCK_ASSIGNED','DEVANNING','开始卸柜作业',1,'admin','2026-05-27 09:15:00'),(9201012,'000000',9200008,'TASK_CREATED',NULL,'PRE_ARRIVAL','OMS推送创建任务',1,'系统','2026-05-27 12:00:00'),(9201013,'000000',9200008,'CHECK_IN','PRE_ARRIVAL','ARRIVED','车辆签到',1,'admin','2026-05-24 11:35:00'),(9201014,'000000',9200008,'ASSIGN_DOCK','ARRIVED','DOCK_ASSIGNED','分配至 DOC-LA-002',1,'admin','2026-05-27 13:00:00'),(9201015,'000000',9200008,'START_WORK','DOCK_ASSIGNED','DOCK_WORKING','开始作业',1,'admin','2026-05-27 13:10:00'),(9201016,'000000',9200009,'TASK_CREATED',NULL,'PRE_ARRIVAL','OMS推送创建任务',1,'系统','2026-05-26 08:00:00'),(9201017,'000000',9200009,'CHECK_IN','PRE_ARRIVAL','ARRIVED','车辆签到',1,'admin','2026-05-22 09:00:00'),(9201018,'000000',9200009,'FINISH_WORK','DOCK_WORKING','OPERATION_FINISHED','作业完成100%',1,'admin','2026-05-26 17:30:00'),(9201019,'000000',9200011,'TASK_CREATED',NULL,'CREATED','手动创建装车任务',1,'admin','2026-05-28 06:00:00'),(9201020,'000000',9200011,'CHECK_IN','CREATED','ARRIVED','车辆签到',1,'admin','2026-05-28 07:30:00'),(9201021,'000000',9200011,'ASSIGN_DOCK','ARRIVED','DOCK_ASSIGNED','分配至 DOC-LA-B01',1,'admin','2026-05-28 07:35:00'),(9201022,'000000',9200013,'TASK_CREATED',NULL,'PRE_ARRIVAL','创建任务',1,'系统','2026-05-21 08:00:00'),(9201023,'000000',9200013,'FINISH_WORK','DOCK_WORKING','OPERATION_FINISHED','拆柜完成',1,'admin','2026-05-23 16:00:00'),(9201024,'000000',9200013,'RELEASE','OPERATION_FINISHED','RELEASED','放行',1,'admin','2026-05-23 17:00:00');
/*!40000 ALTER TABLE `yms_yard_task_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yms_yard_zone`
--

DROP TABLE IF EXISTS `yms_yard_zone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `yms_yard_zone` (
  `id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `warehouse_id` bigint NOT NULL COMMENT '仓库ID',
  `zone_code` varchar(30) NOT NULL COMMENT '分区编码',
  `zone_name` varchar(100) NOT NULL COMMENT '分区名称',
  `zone_type` varchar(30) NOT NULL DEFAULT 'CONTAINER' COMMENT '分区类型：CONTAINER/TRUCK/SELF_PICKUP/PARKING',
  `sort_order` int DEFAULT NULL COMMENT '排序',
  `remark` varchar(500) DEFAULT NULL,
  `create_dept` bigint DEFAULT NULL,
  `create_by` bigint DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_by` bigint DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_zone_code_tenant` (`zone_code`,`tenant_id`),
  KEY `idx_warehouse_id` (`warehouse_id`),
  KEY `idx_zone_type` (`zone_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='YMS堆场分区表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yms_yard_zone`
--

LOCK TABLES `yms_yard_zone` WRITE;
/*!40000 ALTER TABLE `yms_yard_zone` DISABLE KEYS */;
/*!40000 ALTER TABLE `yms_yard_zone` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yms_yardgo_task`
--

DROP TABLE IF EXISTS `yms_yardgo_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `yms_yardgo_task` (
  `id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `yard_task_id` bigint NOT NULL COMMENT '园区任务ID',
  `yard_task_no` varchar(64) DEFAULT NULL COMMENT '园区任务号（快照）',
  `warehouse_id` bigint DEFAULT NULL COMMENT '仓库ID',
  `dock_id` bigint DEFAULT NULL COMMENT 'Dock ID（快照）',
  `dock_code` varchar(30) DEFAULT NULL COMMENT 'Dock编码（快照）',
  `robot_task_id` varchar(100) DEFAULT NULL COMMENT '机器人系统任务ID（外部）',
  `robot_status` varchar(30) NOT NULL DEFAULT 'PENDING' COMMENT '机器人任务状态：PENDING/RUNNING/PAUSED/COMPLETED/FAILED/CANCELLED',
  `task_type` varchar(30) DEFAULT NULL COMMENT '任务类型（快照）',
  `progress` decimal(5,2) DEFAULT NULL COMMENT '完成进度（0~100）',
  `start_time` datetime DEFAULT NULL COMMENT '开始执行时间',
  `finish_time` datetime DEFAULT NULL COMMENT '完成时间',
  `callback_payload` text COMMENT '最后一次回调原始数据',
  `remark` varchar(500) DEFAULT NULL,
  `create_dept` bigint DEFAULT NULL,
  `create_by` bigint DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_by` bigint DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_yard_task_id` (`yard_task_id`),
  KEY `idx_robot_task_id` (`robot_task_id`),
  KEY `idx_robot_status` (`robot_status`),
  KEY `idx_warehouse_status` (`warehouse_id`,`robot_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='YMS YardGo机器人任务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yms_yardgo_task`
--

LOCK TABLES `yms_yardgo_task` WRITE;
/*!40000 ALTER TABLE `yms_yardgo_task` DISABLE KEYS */;
/*!40000 ALTER TABLE `yms_yardgo_task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `zip_code`
--

DROP TABLE IF EXISTS `zip_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `zip_code` (
  `id` bigint NOT NULL COMMENT '主键（雪花ID）',
  `tenant_id` varchar(20) NOT NULL COMMENT '租户ID',
  `country_code` varchar(10) NOT NULL COMMENT '国家代码',
  `state_code` varchar(20) DEFAULT NULL COMMENT '州/省代码',
  `city_name` varchar(100) DEFAULT NULL COMMENT '城市名称',
  `zip` varchar(20) NOT NULL COMMENT '邮政编码',
  `create_by` bigint DEFAULT NULL COMMENT '???',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '???',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` bigint DEFAULT '0' COMMENT '逻辑删除（0=存在，1=删除）',
  `create_dept` bigint DEFAULT NULL COMMENT '????',
  PRIMARY KEY (`id`),
  KEY `idx_country_state` (`tenant_id`,`country_code`,`state_code`),
  KEY `idx_zip` (`tenant_id`,`zip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='邮编库（LOG-001）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zip_code`
--

LOCK TABLES `zip_code` WRITE;
/*!40000 ALTER TABLE `zip_code` DISABLE KEYS */;
INSERT INTO `zip_code` VALUES (3008001,'000000','US','CA','Los Angeles','90001',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3008002,'000000','US','CA','Los Angeles','90011',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3008003,'000000','US','CA','Compton','90220',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3008004,'000000','US','CA','Ontario','91764',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3008005,'000000','US','CA','Moreno Valley','92551',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3008006,'000000','US','CA','San Francisco','94102',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3008007,'000000','US','NY','New York','10001',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3008008,'000000','US','NY','New York','10019',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3008009,'000000','US','TX','Houston','77001',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3008010,'000000','US','TX','Houston','77049',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3008011,'000000','US','TX','Dallas','75201',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3008012,'000000','US','FL','Miami','33101',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3008013,'000000','US','FL','Orlando','32801',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3008014,'000000','US','NJ','Newark','07102',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3008015,'000000','US','NJ','Avenel','07001',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3008016,'000000','US','NJ','Jersey City','07302',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3008017,'000000','US','NJ','Secaucus','07094',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3008018,'000000','US','IL','Chicago','60601',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3008019,'000000','US','IL','Joliet','60436',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL),(3008020,'000000','US','WA','Seattle','98101',1,'2026-05-22 00:41:18',NULL,NULL,0,NULL);
/*!40000 ALTER TABLE `zip_code` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-29 14:11:56
