package cn.iocoder.yudao.module.base.enums;

import cn.iocoder.yudao.framework.common.exception.ErrorCode;

/**
 * Base 基础资料模块，使用 1-050-xxx-xxx 段
 */
public interface ErrorCodeConstants {

    // ========== 国家 Country ==========
    ErrorCode COUNTRY_NOT_EXISTS = new ErrorCode(1_050_001_000, "国家不存在");
    ErrorCode COUNTRY_DUPLICATE = new ErrorCode(1_050_001_001, "国家编码已存在");
    ErrorCode COUNTRY_CODE_INVALID = new ErrorCode(1_050_001_002, "国家编码须为 2 位大写字母");
    ErrorCode COUNTRY_DELETE_HAS_STATE = new ErrorCode(1_050_001_003, "存在州/省数据，无法删除");
    ErrorCode COUNTRY_CODE_NOT_MODIFIABLE = new ErrorCode(1_050_001_004, "国家代码创建后不可修改");
    ErrorCode COUNTRY_PHONE_CODE_INVALID = new ErrorCode(1_050_001_005, "电话区号格式不正确");
    ErrorCode COUNTRY_IMPORT_LIST_IS_EMPTY = new ErrorCode(1_050_001_006, "导入国家数据不能为空");
    ErrorCode COUNTRY_IMPORT_ROW_INVALID = new ErrorCode(1_050_001_007, "导入数据无效：{}");
    // ========== 州/省 StateProvince ==========
    ErrorCode STATE_PROVINCE_NOT_EXISTS = new ErrorCode(1_050_002_000, "州/省不存在");
    ErrorCode STATE_PROVINCE_DUPLICATE = new ErrorCode(1_050_002_001, "同国家下州/省编码已存在");
    ErrorCode STATE_PROVINCE_CODE_NOT_MODIFIABLE = new ErrorCode(1_050_002_002, "州/省代码创建后不可修改");
    ErrorCode STATE_PROVINCE_COUNTRY_NOT_ACTIVE = new ErrorCode(1_050_002_003, "所属国家不存在或未开通");
    ErrorCode STATE_PROVINCE_DELETE_HAS_CITY = new ErrorCode(1_050_002_004, "存在城市数据，无法删除");
    ErrorCode STATE_PROVINCE_DELETE_HAS_ZIP = new ErrorCode(1_050_002_005, "存在邮编数据，无法删除");
    ErrorCode STATE_PROVINCE_IMPORT_LIST_IS_EMPTY = new ErrorCode(1_050_002_006, "导入州/省数据不能为空");
    ErrorCode STATE_PROVINCE_IMPORT_ROW_INVALID = new ErrorCode(1_050_002_007, "导入数据无效：{}");
    // ========== 城市 City ==========
    ErrorCode CITY_NOT_EXISTS = new ErrorCode(1_050_003_000, "城市不存在");
    ErrorCode CITY_DUPLICATE = new ErrorCode(1_050_003_001, "同国家/州省下城市英文名称已存在");
    ErrorCode CITY_REGION_NOT_MODIFIABLE = new ErrorCode(1_050_003_002, "国家/州省创建后不可修改");
    ErrorCode CITY_STATE_INVALID = new ErrorCode(1_050_003_003, "州/省不存在、不属于所选国家或未启用");
    ErrorCode CITY_COUNTRY_NOT_ACTIVE = new ErrorCode(1_050_003_004, "所属国家不存在或未开通");
    ErrorCode CITY_DELETE_HAS_ZIP = new ErrorCode(1_050_003_005, "存在邮编数据，无法删除");
    ErrorCode CITY_DELETE_HAS_ADDRESS = new ErrorCode(1_050_003_006, "存在平台地址引用，无法删除");
    ErrorCode CITY_IMPORT_LIST_IS_EMPTY = new ErrorCode(1_050_003_007, "导入城市数据不能为空");
    ErrorCode CITY_IMPORT_ROW_INVALID = new ErrorCode(1_050_003_008, "导入数据无效：{}");
    // ========== 邮编 ZipCode ==========
    ErrorCode ZIP_CODE_NOT_EXISTS = new ErrorCode(1_050_004_000, "邮编不存在");
    ErrorCode ZIP_CODE_DUPLICATE = new ErrorCode(1_050_004_001, "同国家下邮编已存在");
    ErrorCode ZIP_CODE_KEY_NOT_MODIFIABLE = new ErrorCode(1_050_004_002, "国家/邮编创建后不可修改");
    ErrorCode ZIP_CODE_STATE_INVALID = new ErrorCode(1_050_004_003, "州/省不存在、不属于所选国家或未启用");
    ErrorCode ZIP_CODE_COUNTRY_NOT_ACTIVE = new ErrorCode(1_050_004_004, "所属国家不存在或未开通");
    ErrorCode ZIP_CODE_DELETE_HAS_ADDRESS = new ErrorCode(1_050_004_005, "存在平台地址引用，无法删除");
    ErrorCode ZIP_CODE_IMPORT_LIST_IS_EMPTY = new ErrorCode(1_050_004_006, "导入邮编数据不能为空");
    ErrorCode ZIP_CODE_IMPORT_ROW_INVALID = new ErrorCode(1_050_004_007, "导入数据无效：{}");
    // ========== 时区 Timezone ==========
    ErrorCode TIMEZONE_NOT_EXISTS = new ErrorCode(1_050_005_000, "时区不存在");
    ErrorCode TIMEZONE_DUPLICATE = new ErrorCode(1_050_005_001, "时区编码已存在");
    ErrorCode TIMEZONE_TZ_CODE_NOT_MODIFIABLE = new ErrorCode(1_050_005_002, "时区代码创建后不可修改");
    ErrorCode TIMEZONE_UTC_OFFSET_INVALID = new ErrorCode(1_050_005_003, "UTC 偏移格式不正确，示例：UTC-8、UTC+5:30");
    ErrorCode TIMEZONE_DISABLE_HAS_REFERENCE = new ErrorCode(1_050_005_004, "时区被国家、港口或仓库引用，无法停用");
    ErrorCode TIMEZONE_COUNTRY_NOT_ACTIVE = new ErrorCode(1_050_005_005, "所属国家不存在或未开通");
    // ========== 币种 Currency ==========
    ErrorCode CURRENCY_NOT_EXISTS = new ErrorCode(1_050_006_000, "币种不存在");
    ErrorCode CURRENCY_DUPLICATE = new ErrorCode(1_050_006_001, "币种编码已存在");
    ErrorCode CURRENCY_CODE_NOT_MODIFIABLE = new ErrorCode(1_050_006_002, "币种代码创建后不可修改");
    ErrorCode CURRENCY_CODE_INVALID = new ErrorCode(1_050_006_003, "币种代码须为 3 位大写字母");
    ErrorCode CURRENCY_DECIMAL_PLACES_INVALID = new ErrorCode(1_050_006_004, "小数位数须在 0-4 之间");
    ErrorCode CURRENCY_BASE_CANNOT_DISABLE = new ErrorCode(1_050_006_005, "基准货币不可停用，请先切换基准货币");
    ErrorCode CURRENCY_DISABLE_HAS_REFERENCE = new ErrorCode(1_050_006_006, "币种被国家或汇率引用，无法停用");
    // ========== 汇率 ExchangeRate ==========
    ErrorCode EXCHANGE_RATE_NOT_EXISTS = new ErrorCode(1_050_007_000, "汇率不存在");
    ErrorCode EXCHANGE_RATE_DUPLICATE = new ErrorCode(1_050_007_001, "该货币对在该生效日期的汇率已存在");
    ErrorCode EXCHANGE_RATE_NOT_CURRENT = new ErrorCode(1_050_007_002, "仅当前有效汇率可编辑或作废");
    ErrorCode EXCHANGE_RATE_CURRENCY_SAME = new ErrorCode(1_050_007_003, "源货币与目标货币不能相同");
    ErrorCode EXCHANGE_RATE_CURRENCY_INVALID = new ErrorCode(1_050_007_004, "货币代码不存在或未启用");
    ErrorCode EXCHANGE_RATE_RATE_INVALID = new ErrorCode(1_050_007_005, "汇率须大于 0");
    ErrorCode EXCHANGE_RATE_KEY_NOT_MODIFIABLE = new ErrorCode(1_050_007_006, "货币对或生效日期不可修改");
    // ========== 平台 Platform ==========
    ErrorCode PLATFORM_NOT_EXISTS = new ErrorCode(1_050_010_000, "平台不存在");
    ErrorCode PLATFORM_DUPLICATE = new ErrorCode(1_050_010_001, "平台编码已存在");
    ErrorCode PLATFORM_CODE_NOT_MODIFIABLE = new ErrorCode(1_050_010_002, "平台代码创建后不可修改");
    // ========== 平台地址 PlatformAddress ==========
    ErrorCode PLATFORM_ADDRESS_NOT_EXISTS = new ErrorCode(1_050_011_000, "平台地址不存在");
    ErrorCode PLATFORM_ADDRESS_DUPLICATE = new ErrorCode(1_050_011_001, "同平台下地址编码已存在");
    ErrorCode PLATFORM_ADDRESS_KEY_NOT_MODIFIABLE = new ErrorCode(1_050_011_002, "平台或地址编码创建后不可修改");
    ErrorCode PLATFORM_NOT_EXISTS_FOR_ADDRESS = new ErrorCode(1_050_011_003, "所属平台不存在");
    ErrorCode PLATFORM_ADDRESS_MAX_WEIGHT_REQUIRED = new ErrorCode(1_050_011_004, "过磅站须填写最高重量(吨)");
    ErrorCode PLATFORM_ADDRESS_IMPORT_LIST_IS_EMPTY = new ErrorCode(1_050_011_005, "导入平台地址数据不能为空");
    ErrorCode PLATFORM_ADDRESS_IMPORT_ROW_INVALID = new ErrorCode(1_050_011_006, "导入数据无效：{}");
    // ========== 港口 Port BASE-012 ==========
    ErrorCode PORT_NOT_EXISTS = new ErrorCode(1_050_012_000, "港口不存在");
    ErrorCode PORT_DUPLICATE = new ErrorCode(1_050_012_001, "港口代码已存在");
    ErrorCode PORT_KEY_NOT_MODIFIABLE = new ErrorCode(1_050_012_002, "港口代码或国家/州省创建后不可修改");
    ErrorCode PORT_COUNTRY_NOT_ACTIVE = new ErrorCode(1_050_012_003, "所属国家不存在或未启用");
    ErrorCode PORT_STATE_INVALID = new ErrorCode(1_050_012_004, "所属州/省不存在或未启用");
    ErrorCode PORT_TIMEZONE_INVALID = new ErrorCode(1_050_012_005, "时区不存在或未启用");
    ErrorCode PORT_CONTAINER_URL_INVALID = new ErrorCode(1_050_012_006, "海柜查询链接须包含占位符 {container_no}");
    ErrorCode PORT_PORT_TYPE_INVALID = new ErrorCode(1_050_012_007, "港口类型无效");
    ErrorCode PORT_IMPORT_LIST_IS_EMPTY = new ErrorCode(1_050_012_008, "导入港口数据不能为空");
    ErrorCode PORT_IMPORT_ROW_INVALID = new ErrorCode(1_050_012_009, "导入数据无效：{}");
    // ========== 船司 ShippingLine BASE-013 ==========
    ErrorCode SHIPPING_LINE_NOT_EXISTS = new ErrorCode(1_050_013_000, "船司不存在");
    ErrorCode SHIPPING_LINE_DUPLICATE = new ErrorCode(1_050_013_001, "船司代码已存在");
    ErrorCode SHIPPING_LINE_CODE_NOT_MODIFIABLE = new ErrorCode(1_050_013_002, "船司代码创建后不可修改");
    ErrorCode SHIPPING_LINE_COUNTRY_NOT_ACTIVE = new ErrorCode(1_050_013_003, "注册国家不存在或未启用");
    ErrorCode SHIPPING_LINE_TRACKING_URL_INVALID = new ErrorCode(1_050_013_004, "货物追踪链接须包含占位符 {container_no}");
    // ========== 费项 FeeItem BASE-019 ==========
    ErrorCode FEE_ITEM_NOT_EXISTS = new ErrorCode(1_050_019_000, "费项不存在");
    ErrorCode FEE_ITEM_DUPLICATE = new ErrorCode(1_050_019_001, "费项代码已存在");
    ErrorCode FEE_ITEM_CODE_NOT_MODIFIABLE = new ErrorCode(1_050_019_002, "费项代码创建后不可修改");
    ErrorCode FEE_ITEM_DELETE_SYSTEM = new ErrorCode(1_050_019_003, "系统内置费项不可删除");
    // ========== Channel BASE-030 ==========
    ErrorCode CHANNEL_NOT_EXISTS = new ErrorCode(1_050_030_000, "Channel does not exist");
    ErrorCode CHANNEL_DUPLICATE = new ErrorCode(1_050_030_001, "Channel code already exists");
    ErrorCode CHANNEL_CODE_NOT_MODIFIABLE = new ErrorCode(1_050_030_002, "Channel code cannot be modified after creation");
    ErrorCode CHANNEL_DELETE_ENABLED = new ErrorCode(1_050_030_003, "Enabled channel cannot be deleted");
    // ========== Business Type BASE-031 ==========
    ErrorCode BUSINESS_TYPE_NOT_EXISTS = new ErrorCode(1_050_031_000, "Business type does not exist");
    ErrorCode BUSINESS_TYPE_DUPLICATE = new ErrorCode(1_050_031_001, "Business type code already exists");
    ErrorCode BUSINESS_TYPE_CODE_NOT_MODIFIABLE = new ErrorCode(1_050_031_002, "Business type code cannot be modified after creation");
    ErrorCode BUSINESS_TYPE_DELETE_ENABLED = new ErrorCode(1_050_031_003, "Enabled business type cannot be deleted");
    ErrorCode BUSINESS_TYPE_SORTING_FIELD_REQUIRED = new ErrorCode(1_050_031_004, "Sorting field is required for field based sorting");
    // ========== Value Added Service BASE-032 ==========
    ErrorCode VAS_NOT_EXISTS = new ErrorCode(1_050_032_000, "Value added service does not exist");
    ErrorCode VAS_DUPLICATE = new ErrorCode(1_050_032_001, "Value added service code already exists");
    ErrorCode VAS_CODE_NOT_MODIFIABLE = new ErrorCode(1_050_032_002, "Value added service code cannot be modified after creation");
    ErrorCode VAS_DELETE_ENABLED = new ErrorCode(1_050_032_003, "Enabled value added service cannot be deleted");
    // ========== SKU BASE-022 ==========
    ErrorCode SKU_NOT_EXISTS = new ErrorCode(1_050_022_000, "SKU不存在");
    ErrorCode SKU_DUPLICATE = new ErrorCode(1_050_022_001, "同客户下 SKU 编码已存在");
    ErrorCode SKU_CLIENT_NOT_MODIFIABLE = new ErrorCode(1_050_022_002, "客户创建后不可修改");
    ErrorCode SKU_CODE_NOT_MODIFIABLE = new ErrorCode(1_050_022_003, "有库存或业务引用时 SKU 编码不可修改");
    ErrorCode SKU_DELETE_HAS_STOCK = new ErrorCode(1_050_022_004, "SKU 存在库存，无法删除");
    ErrorCode SKU_CLIENT_NOT_EXISTS = new ErrorCode(1_050_022_005, "客户不存在或未启用");
    ErrorCode SKU_HS_CODE_INVALID = new ErrorCode(1_050_022_006, "HS 编码须为 6-10 位数字");
    ErrorCode SKU_DEFAULT_FEE_INVALID = new ErrorCode(1_050_022_007, "默认费项代码无效：{}");
    ErrorCode SKU_IMPORT_LIST_IS_EMPTY = new ErrorCode(1_050_022_008, "导入 SKU 数据不能为空");
    ErrorCode SKU_IMPORT_ROW_INVALID = new ErrorCode(1_050_022_009, "导入数据无效：{}");
    // ========== 包装 Packaging BASE-018 ==========
    ErrorCode PACKAGING_NOT_EXISTS = new ErrorCode(1_050_018_000, "包装不存在");
    ErrorCode PACKAGING_DUPLICATE = new ErrorCode(1_050_018_001, "包装编码已存在");
    ErrorCode PACKAGING_CODE_NOT_MODIFIABLE = new ErrorCode(1_050_018_002, "包装编码创建后不可修改");
    ErrorCode PACKAGING_DELETE_HAS_REFERENCE = new ErrorCode(1_050_018_003, "包装已被 SKU 引用，无法删除");
    ErrorCode PACKAGING_PKG_TYPE_INVALID = new ErrorCode(1_050_018_004, "包装类型无效");
    ErrorCode PACKAGING_SOURCE_TYPE_INVALID = new ErrorCode(1_050_018_005, "包装来源类型无效");
    ErrorCode PACKAGING_DIMENSION_UNIT_INVALID = new ErrorCode(1_050_018_006, "尺寸单位须为 CM 或 IN");
    ErrorCode PACKAGING_WEIGHT_UNIT_INVALID = new ErrorCode(1_050_018_007, "重量单位须为 KG 或 LB");
    ErrorCode PACKAGING_CLIENT_REQUIRED = new ErrorCode(1_050_018_008, "客户提供或定制包装须选择客户");
    ErrorCode PACKAGING_CLIENT_NOT_EXISTS = new ErrorCode(1_050_018_009, "关联客户不存在或未启用");
    ErrorCode PACKAGING_WAREHOUSE_INVALID = new ErrorCode(1_050_018_010, "适用仓库无效：{}");
    ErrorCode PACKAGING_IMPORT_LIST_IS_EMPTY = new ErrorCode(1_050_018_011, "导入包装数据不能为空");
    ErrorCode PACKAGING_IMPORT_ROW_INVALID = new ErrorCode(1_050_018_012, "导入数据无效：{}");
    // ========== 主体 Company ==========
    ErrorCode COMPANY_NOT_EXISTS = new ErrorCode(1_050_020_000, "主体不存在");
    ErrorCode COMPANY_DUPLICATE = new ErrorCode(1_050_020_001, "主体编码已存在");
    ErrorCode COMPANY_CODE_NOT_MODIFIABLE = new ErrorCode(1_050_020_002, "主体编码创建后不可修改");
    ErrorCode COMPANY_DELETE_HAS_WAREHOUSE = new ErrorCode(1_050_020_003, "主体下存在仓库，无法删除");
    // ========== 仓库 Warehouse ==========
    ErrorCode WAREHOUSE_NOT_EXISTS = new ErrorCode(1_050_021_000, "仓库不存在");
    ErrorCode WAREHOUSE_DUPLICATE = new ErrorCode(1_050_021_001, "仓库编码已存在");
    ErrorCode WAREHOUSE_CODE_NOT_MODIFIABLE = new ErrorCode(1_050_021_002, "仓库编码创建后不可修改");
    ErrorCode WAREHOUSE_COMPANY_NOT_EXISTS = new ErrorCode(1_050_021_003, "归属主体不存在或未启用");
    ErrorCode WAREHOUSE_TIMEZONE_INVALID = new ErrorCode(1_050_021_004, "作业时区不存在或未启用");

    // ========== 航线 ShippingRoute BASE-014 ==========
    ErrorCode SHIPPING_ROUTE_NOT_EXISTS = new ErrorCode(1_050_014_000, "航线不存在");
    ErrorCode SHIPPING_ROUTE_DUPLICATE = new ErrorCode(1_050_014_001, "航线代码已存在");
    ErrorCode SHIPPING_ROUTE_CODE_NOT_MODIFIABLE = new ErrorCode(1_050_014_002, "航线代码创建后不可修改");
    ErrorCode SHIPPING_ROUTE_DELETE_ENABLED = new ErrorCode(1_050_014_003, "启用状态的航线不可删除");
    ErrorCode SHIPPING_ROUTE_SHIPPING_LINE_NOT_EXISTS = new ErrorCode(1_050_014_004, "船公司不存在");
    ErrorCode SHIPPING_ROUTE_ORIGIN_PORT_NOT_EXISTS = new ErrorCode(1_050_014_005, "起运港不存在");
    ErrorCode SHIPPING_ROUTE_DESTINATION_PORT_NOT_EXISTS = new ErrorCode(1_050_014_006, "目的港不存在");
    // ========== 码头 Terminal BASE-015 ==========
    ErrorCode TERMINAL_NOT_EXISTS = new ErrorCode(1_050_015_000, "码头不存在");
    ErrorCode TERMINAL_DUPLICATE = new ErrorCode(1_050_015_001, "码头代码已存在");
    ErrorCode TERMINAL_CODE_NOT_MODIFIABLE = new ErrorCode(1_050_015_002, "码头代码创建后不可修改");
    ErrorCode TERMINAL_DELETE_ENABLED = new ErrorCode(1_050_015_003, "启用状态的码头不可删除");
    ErrorCode TERMINAL_PORT_NOT_EXISTS = new ErrorCode(1_050_015_004, "所属港口不存在");
    // ========== 船舶 Vessel BASE-016 ==========
    ErrorCode VESSEL_NOT_EXISTS = new ErrorCode(1_050_016_000, "船舶不存在");
    ErrorCode VESSEL_DUPLICATE = new ErrorCode(1_050_016_001, "船舶代码已存在");
    ErrorCode VESSEL_CODE_NOT_MODIFIABLE = new ErrorCode(1_050_016_002, "船舶代码创建后不可修改");
    ErrorCode VESSEL_DELETE_ENABLED = new ErrorCode(1_050_016_003, "启用状态的船舶不可删除");
    ErrorCode VESSEL_SHIPPING_LINE_NOT_EXISTS = new ErrorCode(1_050_016_004, "所属船司不存在");
    ErrorCode VESSEL_STATUS_INVALID = new ErrorCode(1_050_016_005, "船舶状态不正确");
    // ========== 堆场分区 YardZone BASE-033 ==========
    ErrorCode YARD_ZONE_NOT_EXISTS = new ErrorCode(1_050_033_000, "堆场分区不存在");
    ErrorCode YARD_ZONE_DUPLICATE = new ErrorCode(1_050_033_001, "分区编码已存在");
    ErrorCode YARD_ZONE_CODE_NOT_MODIFIABLE = new ErrorCode(1_050_033_002, "分区编码创建后不可修改");
    // ========== 月台 YardDock BASE-034 ==========
    ErrorCode YARD_DOCK_NOT_EXISTS = new ErrorCode(1_050_034_000, "月台不存在");
    ErrorCode YARD_DOCK_DUPLICATE = new ErrorCode(1_050_034_001, "月台编码已存在");
    ErrorCode YARD_DOCK_CODE_NOT_MODIFIABLE = new ErrorCode(1_050_034_002, "月台编码创建后不可修改");
    ErrorCode YARD_DOCK_DELETE_ENABLED = new ErrorCode(1_050_034_003, "启用状态的月台不可删除");
    ErrorCode YARD_DOCK_WAREHOUSE_NOT_EXISTS = new ErrorCode(1_050_034_004, "所属仓库不存在");
    ErrorCode YARD_DOCK_BUSINESS_TYPE_NOT_EXISTS = new ErrorCode(1_050_034_005, "适合业务类型不存在");
    ErrorCode YARD_DOCK_ZONE_NOT_EXISTS = new ErrorCode(1_050_034_006, "堆场分区不存在");
    ErrorCode YARD_DOCK_ZONE_REQUIRED = new ErrorCode(1_050_034_007, "堆场堆位必须选择所属分区");

}
