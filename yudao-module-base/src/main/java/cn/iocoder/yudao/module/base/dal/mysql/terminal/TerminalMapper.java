package cn.iocoder.yudao.module.base.dal.mysql.terminal;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.controller.admin.terminal.vo.TerminalPageReqVO;
import cn.iocoder.yudao.module.base.dal.dataobject.terminal.TerminalDO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface TerminalMapper extends BaseMapperX<TerminalDO> {

    default PageResult<TerminalDO> selectPage(TerminalPageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<TerminalDO>()
                .likeIfPresent(TerminalDO::getTerminalCode, reqVO.getTerminalCode())
                .likeIfPresent(TerminalDO::getTerminalName, reqVO.getTerminalName())
                .eqIfPresent(TerminalDO::getPortId, reqVO.getPortId())
                .eqIfPresent(TerminalDO::getDefaultReleaseMethod, reqVO.getDefaultReleaseMethod())
                .eqIfPresent(TerminalDO::getAppointmentSupported, reqVO.getAppointmentSupported())
                .eqIfPresent(TerminalDO::getStatus, reqVO.getStatus())
                .orderByAsc(TerminalDO::getPortCode, TerminalDO::getTerminalCode));
    }

    default TerminalDO selectByUnique(String terminalCode) {
        return selectOne(TerminalDO::getTerminalCode, terminalCode);
    }

}
