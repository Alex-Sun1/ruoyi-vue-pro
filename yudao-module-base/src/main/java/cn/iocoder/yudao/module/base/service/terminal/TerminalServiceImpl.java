package cn.iocoder.yudao.module.base.service.terminal;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.base.controller.admin.terminal.vo.*;
import cn.iocoder.yudao.module.base.dal.dataobject.port.PortDO;
import cn.iocoder.yudao.module.base.dal.dataobject.terminal.TerminalDO;
import cn.iocoder.yudao.module.base.dal.mysql.port.PortMapper;
import cn.iocoder.yudao.module.base.dal.mysql.terminal.TerminalMapper;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import java.util.List;
import java.util.Objects;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.base.enums.ErrorCodeConstants.*;

@Service
@Validated
public class TerminalServiceImpl implements TerminalService {

    @Resource
    private TerminalMapper terminalMapper;
    @Resource
    private PortMapper portMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createTerminal(TerminalSaveReqVO createReqVO) {
        normalize(createReqVO);
        validateUnique(null, createReqVO.getTerminalCode());
        if (createReqVO.getAppointmentSupported() == null) {
            createReqVO.setAppointmentSupported(0);
        }
        if (createReqVO.getStatus() == null) {
            createReqVO.setStatus(CommonStatusEnum.ENABLE.getStatus());
        }
        TerminalDO row = BeanUtils.toBean(createReqVO, TerminalDO.class);
        fillPortSnapshot(row);
        terminalMapper.insert(row);
        return row.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateTerminal(TerminalSaveReqVO updateReqVO) {
        TerminalDO existing = validateExists(updateReqVO.getId());
        normalize(updateReqVO);
        if (!Objects.equals(existing.getTerminalCode(), updateReqVO.getTerminalCode())) {
            throw exception(TERMINAL_CODE_NOT_MODIFIABLE);
        }
        updateReqVO.setTerminalCode(existing.getTerminalCode());
        TerminalDO update = BeanUtils.toBean(updateReqVO, TerminalDO.class);
        fillPortSnapshot(update);
        update.setStatus(existing.getStatus());
        terminalMapper.updateById(update);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteTerminal(Long id) {
        TerminalDO row = validateExists(id);
        if (CommonStatusEnum.ENABLE.getStatus().equals(row.getStatus())) {
            throw exception(TERMINAL_DELETE_ENABLED);
        }
        terminalMapper.deleteById(id);
    }

    @Override
    public TerminalRespVO getTerminal(Long id) {
        return BeanUtils.toBean(validateExists(id), TerminalRespVO.class);
    }

    @Override
    public PageResult<TerminalRespVO> getTerminalPage(TerminalPageReqVO pageReqVO) {
        return BeanUtils.toBean(terminalMapper.selectPage(pageReqVO), TerminalRespVO.class);
    }

    @Override
    public List<TerminalRespVO> getTerminalExportList(TerminalPageReqVO pageReqVO) {
        pageReqVO.setPageSize(-1);
        return getTerminalPage(pageReqVO).getList();
    }

    @Override
    public List<TerminalRespVO> getTerminalSimpleList(Integer status) {
        TerminalPageReqVO pageReqVO = new TerminalPageReqVO();
        pageReqVO.setPageNo(1);
        pageReqVO.setPageSize(500);
        pageReqVO.setStatus(status != null ? status : CommonStatusEnum.ENABLE.getStatus());
        return getTerminalPage(pageReqVO).getList();
    }

    private void fillPortSnapshot(TerminalDO terminal) {
        if (terminal == null || terminal.getPortId() == null) {
            return;
        }
        PortDO port = portMapper.selectById(terminal.getPortId());
        if (port == null) {
            throw exception(TERMINAL_PORT_NOT_EXISTS);
        }
        terminal.setPortCode(port.getPortCode());
        terminal.setPortName(port.getNameEn());
        if (StrUtil.isBlank(terminal.getCountryCode())) {
            terminal.setCountryCode(port.getCountryCode());
        }
        if (StrUtil.isBlank(terminal.getStateCode())) {
            terminal.setStateCode(port.getStateCode());
        }
        if (StrUtil.isBlank(terminal.getCity())) {
            terminal.setCity(port.getCity());
        }
        if (StrUtil.isBlank(terminal.getTimezone())) {
            terminal.setTimezone(port.getTimezone());
        }
    }

    private TerminalDO validateExists(Long id) {
        TerminalDO row = terminalMapper.selectById(id);
        if (row == null) {
            throw exception(TERMINAL_NOT_EXISTS);
        }
        return row;
    }

    private void validateUnique(Long id, String terminalCode) {
        TerminalDO exist = terminalMapper.selectByUnique(terminalCode);
        if (exist != null && (id == null || !exist.getId().equals(id))) {
            throw exception(TERMINAL_DUPLICATE);
        }
    }

    private void normalize(TerminalSaveReqVO reqVO) {
        if (reqVO.getTerminalCode() != null) {
            reqVO.setTerminalCode(reqVO.getTerminalCode().trim().toUpperCase());
        }
        if (reqVO.getTerminalName() != null) {
            reqVO.setTerminalName(reqVO.getTerminalName().trim());
        }
        if (reqVO.getTerminalNameEn() != null) {
            reqVO.setTerminalNameEn(reqVO.getTerminalNameEn().trim());
        }
    }

}
