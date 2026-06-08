package cn.iocoder.yudao.module.org.service.pilot;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.org.controller.admin.pilot.vo.OrgScopePilotRecordPageReqVO;
import cn.iocoder.yudao.module.org.controller.admin.pilot.vo.OrgScopePilotRecordRespVO;

public interface OrgScopePilotRecordService {

    PageResult<OrgScopePilotRecordRespVO> getPilotRecordPage(OrgScopePilotRecordPageReqVO pageReqVO);

}
