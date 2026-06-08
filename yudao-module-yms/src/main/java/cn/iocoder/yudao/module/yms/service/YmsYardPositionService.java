package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardPositionAddReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardPositionEditReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardPositionQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardPositionRespVO;

import java.util.List;

public interface YmsYardPositionService {

    PageResult<YmsYardPositionRespVO> queryPageList(YmsYardPositionQueryReqVO bo, PageParam pageParam);

    YmsYardPositionRespVO queryById(Long id);

    List<YmsYardPositionRespVO> queryListByZone(Long zoneId);

    List<YmsYardPositionRespVO> queryFreeList(Long warehouseId, String positionType);

    Boolean insertByBo(YmsYardPositionAddReqVO bo);

    Boolean updateByBo(YmsYardPositionEditReqVO bo);

    Boolean deleteByIds(List<Long> ids);

    /** 释放堆场位占用 */
    Boolean release(Long id);

    /** 锁定/禁用堆场位 */
    Boolean disable(Long id);

    /** 解锁堆场位 */
    Boolean enable(Long id);
}
