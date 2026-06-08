package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsBlacklistAddReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsBlacklistEditReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsBlacklistQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsBlacklistRespVO;

import java.util.List;

public interface YmsBlacklistService {
    PageResult<YmsBlacklistRespVO> queryPageList(YmsBlacklistQueryReqVO bo, PageParam pageParam);
    YmsBlacklistRespVO queryById(Long id);
    Boolean insertByBo(YmsBlacklistAddReqVO bo);
    Boolean updateByBo(YmsBlacklistEditReqVO bo);
    Boolean removeByIds(List<Long> ids);
    /** 检查指定类型+值是否在有效黑名单中 */
    boolean isBlacklisted(String targetType, String targetValue);
    /** 快捷：检查车牌号 */
    boolean isPlateBlacklisted(String plateNo);
    /** 快捷：检查司机电话 */
    boolean isDriverPhoneBlacklisted(String phone);
}
