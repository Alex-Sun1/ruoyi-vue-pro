package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.controller.admin.vo.*;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsTrailerResourceRespVO;

import java.util.List;

public interface YmsTrailerResourceService {

    PageResult<YmsTrailerResourceRespVO> queryPageList(YmsTrailerResourceQueryReqVO bo, PageParam pageParam);

    YmsTrailerResourceRespVO queryById(Long id);

    List<YmsTrailerResourceRespVO> queryList(YmsTrailerResourceQueryReqVO bo);

    Boolean insertByBo(YmsTrailerResourceAddReqVO bo);

    Boolean updateByBo(YmsTrailerResourceEditReqVO bo);

    Boolean deleteWithValidByIds(List<Long> ids, Boolean isValid);

    /** 分配堆场位 */
    Boolean assignPosition(Long id, Long positionId);

    /** 标记已到仓 */
    Boolean markArrived(Long id);

    /** WMS 备货完成回调 */
    Boolean markWmsReady(Long id);

    /** 叫号上 Dock */
    Boolean callToDock(Long id, Long dockId);

    /** 上口完成（车厢已到 Dock） */
    Boolean markOnDock(Long id, Long dockId, String dockCode);

    /** 装车完成（WMS 回调） */
    Boolean markLoaded(Long id);

    /** 离场 */
    Boolean markLeftYard(Long id);

    /** 标记异常 */
    Boolean markException(Long id, String reason);
}
