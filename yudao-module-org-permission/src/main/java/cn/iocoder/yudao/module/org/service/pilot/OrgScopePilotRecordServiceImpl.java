package cn.iocoder.yudao.module.org.service.pilot;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.org.controller.admin.pilot.vo.OrgScopePilotRecordPageReqVO;
import cn.iocoder.yudao.module.org.controller.admin.pilot.vo.OrgScopePilotRecordRespVO;
import cn.iocoder.yudao.module.org.dal.dataobject.pilot.OrgScopePilotRecordDO;
import cn.iocoder.yudao.module.org.dal.mysql.pilot.OrgScopePilotRecordMapper;
import cn.iocoder.yudao.module.org.framework.datapermission.annotation.OrgDataScope;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.validation.annotation.Validated;

@Service
@Validated
public class OrgScopePilotRecordServiceImpl implements OrgScopePilotRecordService {

    @Resource
    private OrgScopePilotRecordMapper pilotRecordMapper;

    @Override
    @OrgDataScope(tableClass = OrgScopePilotRecordDO.class, warehouseColumn = "warehouse_id")
    public PageResult<OrgScopePilotRecordRespVO> getPilotRecordPage(OrgScopePilotRecordPageReqVO pageReqVO) {
        PageResult<OrgScopePilotRecordDO> page = pilotRecordMapper.selectPage(pageReqVO);
        return BeanUtils.toBean(page, OrgScopePilotRecordRespVO.class);
    }

}
