package cn.iocoder.yudao.module.org.dal.mysql.pilot;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.org.controller.admin.pilot.vo.OrgScopePilotRecordPageReqVO;
import cn.iocoder.yudao.module.org.dal.dataobject.pilot.OrgScopePilotRecordDO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface OrgScopePilotRecordMapper extends BaseMapperX<OrgScopePilotRecordDO> {

    default PageResult<OrgScopePilotRecordDO> selectPage(OrgScopePilotRecordPageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<OrgScopePilotRecordDO>()
                .likeIfPresent(OrgScopePilotRecordDO::getBizCode, reqVO.getBizCode())
                .orderByDesc(OrgScopePilotRecordDO::getId));
    }

}
