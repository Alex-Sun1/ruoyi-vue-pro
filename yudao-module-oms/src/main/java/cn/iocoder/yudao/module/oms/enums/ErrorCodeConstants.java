package cn.iocoder.yudao.module.oms.enums;

import cn.iocoder.yudao.framework.common.exception.ErrorCode;

public interface ErrorCodeConstants {

    ErrorCode OMS_BIZ_ERROR = new ErrorCode(1_020_001_400, "OMS 业务校验失败");
    ErrorCode OMS_NOT_EXISTS = new ErrorCode(1_020_002_404, "OMS 数据不存在");
    ErrorCode OMS_PARAM_INVALID = new ErrorCode(1_020_003_400, "OMS 参数不完整或无效");

}
