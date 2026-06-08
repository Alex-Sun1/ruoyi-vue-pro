package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardZoneAddReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardZoneEditReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardZoneQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardZoneRespVO;

import java.util.List;

public interface YmsYardZoneService {

    PageResult<YmsYardZoneRespVO> queryPageList(YmsYardZoneQueryReqVO bo);

    List<YmsYardZoneRespVO> queryListByWarehouse(Long warehouseId);

    YmsYardZoneRespVO queryById(Long id);

    Boolean insertByBo(YmsYardZoneAddReqVO bo);

    Boolean updateByBo(YmsYardZoneEditReqVO bo);

    Boolean deleteByIds(List<Long> ids);
}
