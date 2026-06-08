package cn.iocoder.yudao.module.wms.enums;

import cn.iocoder.yudao.framework.common.exception.ErrorCode;

/**
 * WMS 错误码段 1_030_xxx
 */
public interface ErrorCodeConstants {

    ErrorCode WMS_PARAM_INVALID = new ErrorCode(1_030_001_400, "WMS 参数不完整或无效");
    ErrorCode WMS_BIZ_ERROR = new ErrorCode(1_030_002_400, "WMS 业务校验失败");
    ErrorCode WMS_NOT_EXISTS = new ErrorCode(1_030_003_404, "WMS 数据不存在");
    ErrorCode WMS_ZONE_HAS_LOCATIONS = new ErrorCode(1_030_004_400, "库区下存在库位，请先处理库位或改为停用");
    ErrorCode WMS_ZONE_NAME_DUPLICATE = new ErrorCode(1_030_005_400, "区域名称在同一仓库内已存在");
    ErrorCode WMS_LOCATION_HAS_INVENTORY = new ErrorCode(1_030_006_400, "库位存在库存，不允许删除");
    ErrorCode WMS_LOCATION_CODE_DUPLICATE = new ErrorCode(1_030_007_400, "库位编码在同一仓库内已存在");
    ErrorCode WMS_LOCATION_STATUS_INVALID = new ErrorCode(1_030_008_400, "库位状态不合法");
    ErrorCode WMS_INVENTORY_NOT_EXISTS = new ErrorCode(1_030_009_404, "库存记录不存在");
    ErrorCode WMS_INVENTORY_INSUFFICIENT = new ErrorCode(1_030_010_400, "可用库存不足");
    ErrorCode WMS_PALLET_NOT_EXISTS = new ErrorCode(1_030_011_404, "卡板不存在");
    ErrorCode WMS_DEVANNING_NOT_EXISTS = new ErrorCode(1_030_012_404, "拆柜订单不存在");
    ErrorCode WMS_DEVANNING_STATUS_INVALID = new ErrorCode(1_030_013_400, "拆柜订单状态不允许此操作");

}
