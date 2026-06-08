package cn.iocoder.yudao.module.org.enums;

import cn.iocoder.yudao.framework.common.exception.ErrorCode;

/**
 * 组织数据权限错误码段 1-003-xxx
 */
public interface ErrorCodeConstants {

    ErrorCode ORG_PERMISSION_DENIED = new ErrorCode(1_003_001_403, "无权访问该仓库数据");
    ErrorCode ORG_ROLE_ORG_SCOPE_INVALID = new ErrorCode(1_003_002_400, "保存组织权限参数无效：{}");
    ErrorCode ORG_ROLE_NOT_EXISTS = new ErrorCode(1_003_003_404, "角色不存在");

}
