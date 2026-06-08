package cn.iocoder.yudao.module.base.service.timezone;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.controller.admin.timezone.vo.*;

import java.util.List;

public interface TimezoneService {

    Long createTimezone(TimezoneSaveReqVO createReqVO);

    void updateTimezone(TimezoneSaveReqVO updateReqVO);

    void updateTimezoneStatus(TimezoneUpdateStatusReqVO reqVO);

    TimezoneRespVO getTimezone(Long id);

    PageResult<TimezoneRespVO> getTimezonePage(TimezonePageReqVO pageReqVO);

    List<TimezoneRespVO> getTimezoneSimpleList(Integer status);

}
