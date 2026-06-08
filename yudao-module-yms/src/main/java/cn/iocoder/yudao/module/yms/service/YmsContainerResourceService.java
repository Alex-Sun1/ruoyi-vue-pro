package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.controller.admin.vo.*;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsContainerResourceRespVO;

import java.util.List;

public interface YmsContainerResourceService {

    PageResult<YmsContainerResourceRespVO> queryPageList(YmsContainerResourceQueryReqVO bo, PageParam pageParam);

    YmsContainerResourceRespVO queryById(Long id);

    List<YmsContainerResourceRespVO> queryList(YmsContainerResourceQueryReqVO bo);

    Boolean insertByBo(YmsContainerResourceAddReqVO bo);

    Boolean updateByBo(YmsContainerResourceEditReqVO bo);

    Boolean deleteWithValidByIds(List<Long> ids, Boolean isValid);

    /** 分配堆场位 */
    Boolean assignPosition(Long id, Long positionId);

    /** 标记已到仓（Check-in 后调用） */
    Boolean markArrived(Long id, String plateNo, String driverName, String driverPhone);

    /** 叫号（进入叫号队列，状态改为 CALLED） */
    Boolean callToDock(Long id, Long dockId);

    /** 上口完成（海柜已到 Dock，WMS 可以开始） */
    Boolean markOnDock(Long id, Long dockId, String dockCode);

    /** 拆柜完成（WMS 回调） */
    Boolean markDevanned(Long id);

    /** 标记空柜待还 */
    Boolean markEmptyWaitReturn(Long id);

    /** 离场 */
    Boolean markLeftYard(Long id);

    /** 标记异常 */
    Boolean markException(Long id, String reason);
}
