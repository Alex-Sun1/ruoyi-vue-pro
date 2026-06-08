package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardMapRespVO;

public interface YmsYardMapService {

    YmsYardMapRespVO queryMap(Long warehouseId);
}
